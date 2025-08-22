"""
Database connection and session management.

Handles SQLAlchemy engine creation, session management,
and database initialization for the FastAPI application.
"""

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.pool import QueuePool
from contextlib import contextmanager
from typing import Generator

from app.core.config import settings

# Create SQLAlchemy engine with connection pooling
engine = create_engine(
    settings.database.connection_string,
    poolclass=QueuePool,
    pool_size=settings.database.pool_size,
    max_overflow=settings.database.max_overflow,
    pool_pre_ping=True,
    echo=settings.debug
)

# Create session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for all models
Base = declarative_base()


def get_db() -> Generator[Session, None, None]:
    """
    Dependency to get database session.
    
    Yields:
        Session: Database session instance
        
    Note:
        This function is used as a FastAPI dependency to inject
        database sessions into route handlers.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@contextmanager
def get_db_context() -> Generator[Session, None, None]:
    """
    Context manager for database sessions.
    
    Yields:
        Session: Database session instance
        
    Note:
        Use this for manual session management outside of FastAPI routes.
    """
    db = SessionLocal()
    try:
        yield db
        db.commit()
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()


def init_db() -> None:
    """
    Initialize database tables.
    
    Creates all tables defined in the models.
    Should be called during application startup.
    """
    Base.metadata.create_all(bind=engine)


def close_db() -> None:
    """
    Close database connections.
    
    Should be called during application shutdown.
    """
    engine.dispose()
