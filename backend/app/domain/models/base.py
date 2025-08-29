"""
Base model definitions for the Sales Manager application.

This module provides the base classes and common functionality
that all domain models inherit from.
"""

from datetime import datetime
from typing import Optional
from sqlalchemy import Column, Integer, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.ext.declarative import declarative_base
from pydantic import BaseModel, Field

# SQLAlchemy base class
Base = declarative_base()


class BaseEntity(Base):
    """Base entity with common fields for all models."""
    
    __abstract__ = True
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    created_by: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("users.id"), nullable=True)
    updated_by: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("users.id"), nullable=True)


class BasePydanticModel(BaseModel):
    """Base Pydantic model with common configuration."""
    
    model_config = {
        "from_attributes": True,
        "arbitrary_types_allowed": True
    }
