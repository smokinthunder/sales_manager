"""
Tests for main application endpoints.

Tests the root endpoints, health checks, and basic
application functionality.
"""

import pytest
from fastapi.testclient import TestClient


def test_root_endpoint(client: TestClient):
    """
    Test the root endpoint returns application information.
    
    Args:
        client: FastAPI test client
    """
    response = client.get("/")
    assert response.status_code == 200
    
    data = response.json()
    assert "app" in data
    assert "version" in data
    assert "environment" in data
    assert "status" in data
    assert data["status"] == "healthy"


def test_health_check_endpoint(client: TestClient):
    """
    Test the health check endpoint.
    
    Args:
        client: FastAPI test client
    """
    response = client.get("/health")
    assert response.status_code == 200
    
    data = response.json()
    assert "status" in data
    assert "timestamp" in data
    assert "version" in data
    assert data["status"] == "healthy"


def test_docs_endpoint_in_development(client: TestClient):
    """
    Test that API documentation is available in development.
    
    Args:
        client: FastAPI test client
    """
    response = client.get("/docs")
    assert response.status_code == 200


def test_redoc_endpoint_in_development(client: TestClient):
    """
    Test that ReDoc documentation is available in development.
    
    Args:
        client: FastAPI test client
    """
    response = client.get("/redoc")
    assert response.status_code == 200


def test_api_prefix_configuration():
    """
    Test that API prefix is properly configured.
    
    This test ensures the API prefix is set correctly
    for versioning and routing.
    """
    from app.core.config import settings
    assert settings.api_prefix == "/api/v1"


def test_cors_configuration():
    """
    Test that CORS is properly configured.
    
    This test ensures CORS middleware is enabled
    for cross-origin requests.
    """
    from app.core.config import settings
    assert "*" in settings.cors_origins or len(settings.cors_origins) > 0


def test_database_configuration():
    """
    Test that database configuration is properly set.
    
    This test ensures database connection parameters
    are configured correctly.
    """
    from app.core.config import settings
    assert settings.database.host is not None
    assert settings.database.port > 0
    assert settings.database.database is not None


def test_security_configuration():
    """
    Test that security configuration is properly set.
    
    This test ensures JWT and security parameters
    are configured correctly.
    """
    from app.core.config import settings
    assert settings.security.secret_key is not None
    assert len(settings.security.secret_key) >= 32
    assert settings.security.algorithm is not None
    assert settings.security.access_token_expire_minutes > 0
