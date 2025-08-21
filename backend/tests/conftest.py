"""
Pytest configuration and fixtures for the test suite.

Provides common test fixtures and configuration
for all test modules.
"""

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.main import app
from app.core.database import Base, get_db
from app.core.config import settings


# Test database configuration
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def override_get_db():
    """
    Override database dependency for testing.
    
    Returns:
        Generator: Database session for testing
    """
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()


# Override database dependency
app.dependency_overrides[get_db] = override_get_db


@pytest.fixture(scope="session")
def db_engine():
    """
    Create test database engine.
    
    Returns:
        Engine: SQLAlchemy engine for testing
    """
    Base.metadata.create_all(bind=engine)
    yield engine
    Base.metadata.drop_all(bind=engine)


@pytest.fixture
def db_session(db_engine):
    """
    Create test database session.
    
    Args:
        db_engine: Test database engine
        
    Returns:
        Session: Database session for testing
    """
    connection = db_engine.connect()
    transaction = connection.begin()
    session = TestingSessionLocal(bind=connection)
    
    yield session
    
    session.close()
    transaction.rollback()
    connection.close()


@pytest.fixture
def client():
    """
    Create test client for FastAPI application.
    
    Returns:
        TestClient: FastAPI test client
    """
    return TestClient(app)


@pytest.fixture
def test_user_data():
    """
    Sample user data for testing.
    
    Returns:
        dict: Test user data
    """
    return {
        "phone": "+1234567890",
        "name": "Test User",
        "email": "test@example.com",
        "role": "sales_executive",
        "tenant_id": "TEST_TENANT"
    }


@pytest.fixture
def test_tenant_data():
    """
    Sample tenant data for testing.
    
    Returns:
        dict: Test tenant data
    """
    return {
        "name": "Test Company",
        "code": "TEST",
        "status": "active",
        "max_users": 50
    }
