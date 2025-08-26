"""
Rate limiting middleware for API endpoints.

Implements token bucket algorithm using Redis to limit
API requests per user/IP address.
"""

import time
from typing import Optional, Callable
from fastapi import Request, HTTPException, status
from fastapi.responses import JSONResponse
import redis.asyncio as redis
import structlog
from app.core.config import settings
from app.core.errors import RateLimitError

logger = structlog.get_logger(__name__)


class RateLimiter:
    """Rate limiter using Redis for distributed rate limiting."""
    
    def __init__(self, redis_client: redis.Redis):
        """
        Initialize rate limiter.
        
        Args:
            redis_client: Redis client instance
        """
        self.redis = redis_client
        self.default_limit = settings.rate_limit_per_minute
        self.window_size = 60  # 1 minute window
    
    async def _get_client_identifier(self, request: Request) -> str:
        """
        Get unique identifier for the client.
        
        Args:
            request: FastAPI request object
            
        Returns:
            Client identifier string
        """
        # Try to get user ID from JWT token first
        auth_header = request.headers.get("authorization")
        if auth_header and auth_header.startswith("Bearer "):
            # In a real implementation, decode JWT to get user ID
            # For now, use IP address as fallback
            pass
        
        # Fallback to IP address
        client_ip = request.client.host if request.client else "unknown"
        return f"rate_limit:{client_ip}"
    
    async def is_allowed(self, request: Request, limit: Optional[int] = None) -> bool:
        """
        Check if request is allowed based on rate limit.
        
        Args:
            request: FastAPI request object
            limit: Custom rate limit (requests per minute)
            
        Returns:
            True if request is allowed, False otherwise
        """
        if limit is None:
            limit = self.default_limit
        
        client_id = await self._get_client_identifier(request)
        current_time = int(time.time())
        window_start = current_time - (current_time % self.window_size)
        
        # Use Redis sorted set to track requests in current window
        key = f"{client_id}:{window_start}"
        
        try:
            # Add current request timestamp to sorted set
            await self.redis.zadd(key, {str(current_time): current_time})
            
            # Set expiry for the key (clean up after window)
            await self.redis.expire(key, self.window_size)
            
            # Count requests in current window
            request_count = await self.redis.zcount(key, window_start, current_time)
            
            # Remove old requests outside current window
            await self.redis.zremrangebyscore(key, 0, window_start - 1)
            
            return request_count <= limit
            
        except redis.RedisError as e:
            logger.error("Redis error in rate limiting", error=str(e))
            # Allow request if Redis is unavailable
            return True
    
    async def get_remaining_requests(self, request: Request, limit: Optional[int] = None) -> int:
        """
        Get remaining requests for the client in current window.
        
        Args:
            request: FastAPI request object
            limit: Custom rate limit (requests per minute)
            
        Returns:
            Number of remaining requests
        """
        if limit is None:
            limit = self.default_limit
        
        client_id = await self._get_client_identifier(request)
        current_time = int(time.time())
        window_start = current_time - (current_time % self.window_size)
        
        key = f"{client_id}:{window_start}"
        
        try:
            request_count = await self.redis.zcount(key, window_start, current_time)
            return max(0, limit - request_count)
        except redis.RedisError as e:
            logger.error("Redis error getting remaining requests", error=str(e))
            return limit
    
    async def get_reset_time(self, request: Request) -> int:
        """
        Get time until rate limit resets.
        
        Args:
            request: FastAPI request object
            
        Returns:
            Seconds until reset
        """
        current_time = int(time.time())
        window_start = current_time - (current_time % self.window_size)
        return window_start + self.window_size - current_time


async def rate_limit_middleware(
    request: Request,
    call_next: Callable,
    limit: Optional[int] = None
):
    """
    Rate limiting middleware.
    
    Args:
        request: FastAPI request object
        call_next: Next middleware/route handler
        limit: Custom rate limit (requests per minute)
        
    Returns:
        Response from route handler or rate limit error
    """
    # Skip rate limiting for health checks and documentation
    if request.url.path in ["/health", "/docs", "/redoc", "/openapi.json"]:
        return await call_next(request)
    
    # Get Redis client from request state
    redis_client = getattr(request.app.state, "redis", None)
    if not redis_client:
        logger.warning("Redis client not available, skipping rate limiting")
        return await call_next(request)
    
    rate_limiter = RateLimiter(redis_client)
    
    try:
        # Check if request is allowed
        if await rate_limiter.is_allowed(request, limit):
            # Add rate limit headers to response
            response = await call_next(request)
            
            remaining = await rate_limiter.get_remaining_requests(request, limit)
            reset_time = await rate_limiter.get_reset_time(request)
            
            response.headers["X-RateLimit-Limit"] = str(limit or settings.rate_limit_per_minute)
            response.headers["X-RateLimit-Remaining"] = str(remaining)
            response.headers["X-RateLimit-Reset"] = str(reset_time)
            
            return response
        else:
            # Rate limit exceeded
            reset_time = await rate_limiter.get_reset_time(request)
            
            error_response = {
                "error": {
                    "message": "Rate limit exceeded",
                    "code": "RATE_LIMIT",
                    "type": "RateLimitError",
                    "details": {
                        "limit": limit or settings.rate_limit_per_minute,
                        "reset_in_seconds": reset_time
                    }
                }
            }
            
            return JSONResponse(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                content=error_response,
                headers={
                    "X-RateLimit-Limit": str(limit or settings.rate_limit_per_minute),
                    "X-RateLimit-Remaining": "0",
                    "X-RateLimit-Reset": str(reset_time),
                    "Retry-After": str(reset_time)
                }
            )
            
    except Exception as e:
        logger.error("Error in rate limiting middleware", error=str(e))
        # Allow request if rate limiting fails
        return await call_next(request)


def create_rate_limit_dependency(limit: Optional[int] = None):
    """
    Create rate limit dependency for specific endpoints.
    
    Args:
        limit: Custom rate limit (requests per minute)
        
    Returns:
        Rate limit dependency function
    """
    async def rate_limit_dependency(request: Request):
        """Rate limit dependency."""
        redis_client = getattr(request.app.state, "redis", None)
        if not redis_client:
            return
        
        rate_limiter = RateLimiter(redis_client)
        
        if not await rate_limiter.is_allowed(request, limit):
            raise RateLimitError(
                message="Rate limit exceeded",
                details={
                    "limit": limit or settings.rate_limit_per_minute,
                    "reset_in_seconds": await rate_limiter.get_reset_time(request)
                }
            )
    
    return rate_limit_dependency
