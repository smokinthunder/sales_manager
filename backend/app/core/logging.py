"""
Structured logging configuration for the application.

Configures structlog with proper formatting, log levels,
and correlation ID tracking for distributed tracing.
"""

import sys
import structlog
from typing import Any, Dict
from datetime import datetime


def setup_logging(debug: bool = False) -> None:
    """
    Setup structured logging configuration.
    
    Args:
        debug: Enable debug logging if True
        
    Note:
        Configures structlog with JSON formatting for production
        and console formatting for development.
    """
    # Configure structlog processors
    processors = [
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
    ]
    
    if debug:
        # Development: human-readable console output
        processors.append(structlog.dev.ConsoleRenderer())
    else:
        # Production: JSON output
        processors.append(structlog.processors.JSONRenderer())
    
    # Configure structlog
    structlog.configure(
        processors=processors,
        context_class=dict,
        logger_factory=structlog.stdlib.LoggerFactory(),
        wrapper_class=structlog.stdlib.BoundLogger,
        cache_logger_on_first_use=True,
    )
    
    # Configure standard library logging
    import logging
    logging.basicConfig(
        format="%(message)s",
        stream=sys.stdout,
        level=logging.DEBUG if debug else logging.INFO,
    )


def get_logger(name: str) -> structlog.BoundLogger:
    """
    Get a structured logger instance.
    
    Args:
        name: Logger name (usually __name__)
        
    Returns:
        structlog.BoundLogger: Configured logger instance
    """
    return structlog.get_logger(name)


def log_request_info(logger: structlog.BoundLogger, **kwargs) -> None:
    """
    Log request information with correlation ID.
    
    Args:
        logger: Logger instance to use
        **kwargs: Additional fields to log
        
    Note:
        Use this to log request details with consistent formatting.
    """
    logger.info("Request processed", **kwargs)


def log_security_event(logger: structlog.BoundLogger, event: str, **kwargs) -> None:
    """
    Log security-related events.
    
    Args:
        logger: Logger instance to use
        event: Security event description
        **kwargs: Additional security context
        
    Note:
        Security events are logged at WARNING level for monitoring.
    """
    logger.warning(f"Security event: {event}", event_type=event, **kwargs)


def log_performance(logger: structlog.BoundLogger, operation: str, duration_ms: float, **kwargs) -> None:
    """
    Log performance metrics.
    
    Args:
        logger: Logger instance to use
        operation: Operation name
        duration_ms: Duration in milliseconds
        **kwargs: Additional performance context
        
    Note:
        Performance logs help identify bottlenecks and monitor system health.
    """
    logger.info(
        "Performance metric",
        operation=operation,
        duration_ms=duration_ms,
        **kwargs
    )
