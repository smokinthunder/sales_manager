"""
Main FastAPI application entry point - Server C (Backend API Gateway).

Configures the application with middleware, CORS, and route registration.
Implements the three-layer architecture where this service communicates
with the Data Layer (Server B) and never directly with the database (Server A).
"""

from contextlib import asynccontextmanager
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from starlette.exceptions import HTTPException as StarletteHTTPException
import time
import structlog
import httpx
import os

from app.core.config import settings
from app.core.logging import setup_logging, get_logger
from app.core.redis_client import get_redis_client, close_redis_client
from app.core.scheduler import start_scheduler, stop_scheduler, get_scheduler
from app.core.errors import (
    BaseError,
    AuthenticationError,
    AuthorizationError,
    ValidationError,
    NotFoundError,
    ConflictError,
    RateLimitError,
    DatabaseError,
    ExternalServiceError
)
from app.api.deps import get_current_user


# Setup logging
setup_logging(debug=settings.debug)
logger = get_logger(__name__)

# Data Layer service configuration
DATA_LAYER_URL = os.getenv("DATA_LAYER_URL", "http://data-layer:8000")


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Application lifespan manager.
    
    Handles startup and shutdown events for the backend service.
    Note: No direct database initialization - that's handled by the Data Layer.
    """
    # Startup
    logger.info("Starting Sales Manager Backend API", version=settings.version, environment=settings.environment)
    
    try:
        # Initialize Redis client
        redis_client = await get_redis_client()
        if await redis_client.is_connected():
            logger.info("Redis client initialized successfully")
            app.state.redis = redis_client.client
        else:
            logger.warning("Redis client not available")
            app.state.redis = None
    except Exception as e:
        logger.warning("Could not initialize Redis client", error=str(e))
        app.state.redis = None
    
    try:
        # Verify Data Layer service is accessible
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{DATA_LAYER_URL}/health")
            if response.status_code == 200:
                logger.info("Data Layer service is accessible")
            else:
                logger.warning("Data Layer service health check failed", status_code=response.status_code)
    except Exception as e:
        logger.warning("Could not verify Data Layer service", error=str(e))
    
    try:
        # Initialize task scheduler
        if settings.sync_enabled or settings.analytics_enabled:
            await start_scheduler()
            logger.info("Task scheduler started successfully")
        else:
            logger.info("Task scheduler disabled in configuration")
    except Exception as e:
        logger.warning("Could not start task scheduler", error=str(e))
    
    yield
    
    # Shutdown
    logger.info("Shutting down Sales Manager Backend API")
    try:
        # Close Data Layer client
        from app.services import close_data_layer_client
        await close_data_layer_client()
        logger.info("Data Layer client closed")
    except Exception as e:
        logger.error("Error closing Data Layer client", error=str(e))
    
    try:
        # Stop task scheduler
        await stop_scheduler()
        logger.info("Task scheduler stopped")
    except Exception as e:
        logger.error("Error stopping task scheduler", error=str(e))
    
    try:
        # Close Redis client
        await close_redis_client()
        logger.info("Redis client closed")
    except Exception as e:
        logger.error("Error closing Redis client", error=str(e))


# Create FastAPI application
app = FastAPI(
    title=settings.app_name,
    version=settings.version,
    description="Sales Executive Management Platform API - Backend Gateway (Server C)",
    docs_url="/docs" if settings.debug else None,
    redoc_url="/redoc" if settings.debug else None,
    lifespan=lifespan
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add trusted host middleware for production
if not settings.debug:
    app.add_middleware(
        TrustedHostMiddleware,
        allowed_hosts=["*"]  # Configure based on deployment
    )


@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    """
    Add processing time header to responses.
    
    Args:
        request: Incoming request
        call_next: Next middleware/route handler
        
    Returns:
        Response with X-Process-Time header
    """
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)
    return response


@app.middleware("http")
async def log_requests(request: Request, call_next):
    """
    Log all incoming requests and responses.
    
    Args:
        request: Incoming request
        call_next: Next middleware/route handler
        
    Returns:
        Response from route handler
    """
    start_time = time.time()
    
    # Log request
    logger.info(
        "Request started",
        method=request.method,
        url=str(request.url),
        client_ip=request.client.host if request.client else None,
        user_agent=request.headers.get("user-agent")
    )
    
    try:
        response = await call_next(request)
        process_time = time.time() - start_time
        
        # Log response
        logger.info(
            "Request completed",
            method=request.method,
            url=str(request.url),
            status_code=response.status_code,
            process_time=process_time
        )
        
        return response
        
    except Exception as e:
        process_time = time.time() - start_time
        logger.error(
            "Request failed",
            method=request.method,
            url=str(request.url),
            error=str(e),
            process_time=process_time
        )
        raise


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    """
    Handle request validation errors.
    
    Args:
        request: Request that caused the error
        exc: Validation exception
        
    Returns:
        JSON response with validation error details
    """
    logger.warning(
        "Request validation failed",
        url=str(request.url),
        errors=exc.errors()
    )
    
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={
            "detail": "Validation error",
            "errors": exc.errors()
        }
    )


@app.exception_handler(StarletteHTTPException)
async def http_exception_handler(request: Request, exc: StarletteHTTPException):
    """
    Handle HTTP exceptions.
    
    Args:
        request: Request that caused the error
        exc: HTTP exception
        
    Returns:
        JSON response with error details
    """
    logger.warning(
        "HTTP exception",
        url=str(request.url),
        status_code=exc.status_code,
        detail=exc.detail
    )
    
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.detail}
    )


@app.exception_handler(BaseError)
async def base_error_handler(request: Request, exc: BaseError):
    """
    Handle Sales Manager custom exceptions.
    
    Args:
        request: Request that caused the error
        exc: SalesManagerException instance
        
    Returns:
        JSON response with error details
    """
    logger.error(
        "Sales Manager exception",
        url=str(request.url),
        error_type=exc.__class__.__name__,
        message=exc.message,
        details=exc.details,
        status_code=exc.status_code
    )
    
    return JSONResponse(
        status_code=exc.status_code,
        content=exc.to_response()
    )


@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    """
    Handle general exceptions.
    
    Args:
        request: Request that caused the error
        exc: General exception
        
    Returns:
        JSON response with generic error message
    """
    logger.error(
        "Unhandled exception",
        url=str(request.url),
        error=str(exc),
        exc_info=True
    )
    
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": "Internal server error"}
    )


@app.get("/")
async def root():
    """
    Root endpoint for health check.
    
    Returns:
        dict: Application information
    """
    return {
        "app": settings.app_name,
        "version": settings.version,
        "environment": settings.environment,
        "status": "healthy",
        "architecture": "three-layer",
        "service": "backend-gateway",
        "data_layer_url": DATA_LAYER_URL
    }


@app.get("/health")
async def health_check():
    """
    Health check endpoint.
    
    Returns:
        dict: Health status information
    """
    # Check Data Layer service health
    data_layer_healthy = False
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{DATA_LAYER_URL}/health", timeout=5.0)
            data_layer_healthy = response.status_code == 200
    except Exception as e:
        logger.warning("Data Layer health check failed", error=str(e))
    
    # Check scheduler status
    scheduler_healthy = False
    scheduler_status = {}
    try:
        scheduler = await get_scheduler()
        scheduler_status = scheduler.get_job_status()
        scheduler_healthy = scheduler_status.get("scheduler_running", False)
    except Exception as e:
        logger.warning("Scheduler health check failed", error=str(e))
    
    return {
        "status": "healthy" if data_layer_healthy and scheduler_healthy else "degraded",
        "timestamp": time.time(),
        "version": settings.version,
        "service": "backend-gateway",
        "data_layer": {
            "status": "healthy" if data_layer_healthy else "unhealthy",
            "url": DATA_LAYER_URL
        },
        "scheduler": {
            "status": "healthy" if scheduler_healthy else "unhealthy",
            "running": scheduler_healthy,
            "jobs": scheduler_status.get("total_jobs", 0)
        }
    }


@app.get("/scheduler/status")
async def scheduler_status():
    """
    Scheduler status endpoint.
    
    Returns:
        dict: Scheduler status and job information
    """
    try:
        scheduler = await get_scheduler()
        return scheduler.get_job_status()
    except Exception as e:
        logger.error("Failed to get scheduler status", error=str(e))
        return {
            "error": "Failed to get scheduler status",
            "details": str(e)
        }


# Import and include API routers
from app.api.v1 import users_router, auth_router, territories_router, routes_router, shops_router, sync_router, analytics_router

app.include_router(auth_router, prefix="/api/v1/auth", tags=["authentication"])
app.include_router(users_router, prefix="/api/v1/users", tags=["users"])
app.include_router(territories_router, prefix="/api/v1/territories", tags=["territories"])
app.include_router(routes_router, prefix="/api/v1/routes", tags=["routes"])
app.include_router(shops_router, prefix="/api/v1/shops", tags=["shops"])
app.include_router(sync_router, prefix="/api/v1", tags=["sync"])
app.include_router(analytics_router, prefix="/api/v1", tags=["analytics"])


if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.debug,
        log_level="debug" if settings.debug else "info"
    )
