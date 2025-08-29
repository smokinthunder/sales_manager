#!/usr/bin/env python3
"""
Database initialization script.

This script creates all database tables from our SQLAlchemy models.
"""

import sys
import os

# Add the app directory to the Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'app'))

from app.core.config import settings
from app.domain.models.base import Base
from sqlalchemy import create_engine

def main():
    """Initialize the database."""
    print("Initializing database...")
    
    # Create engine
    engine = create_engine(settings.database_url)
    
    # Create all tables
    Base.metadata.create_all(bind=engine)
    
    print("Database tables created successfully!")
    print(f"Database URL: {settings.database_url}")

if __name__ == "__main__":
    main()
