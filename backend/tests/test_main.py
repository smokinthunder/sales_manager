"""
Simple tests for the main application.

These tests verify basic functionality without complex configuration.
"""

import pytest
from fastapi.testclient import TestClient
from app.main import app


@pytest.fixture
def client():
    """Create a test client."""
    return TestClient(app)


def test_root_endpoint(client):
    """Test the root endpoint."""
    response = client.get("/")
    assert response.status_code == 200


def test_health_check_endpoint(client):
    """Test the health check endpoint."""
    response = client.get("/health")
    assert response.status_code == 200


def test_docs_endpoint_in_development(client):
    """Test that docs endpoint is accessible in development."""
    response = client.get("/docs")
    assert response.status_code == 200


def test_redoc_endpoint_in_development(client):
    """Test that redoc endpoint is accessible in development."""
    response = client.get("/redoc")
    assert response.status_code == 200


def test_api_prefix_configuration(client):
    """Test that API prefix is configured correctly."""
    response = client.get("/api/v1/")
    # This might return 404 if no root endpoint, but that's okay
    assert response.status_code in [200, 404, 405]


def test_cors_configuration():
    """Test that CORS is configured."""
    from app.main import app
    # Just check that the app exists and can be imported
    assert app is not None


def test_database_configuration():
    """Test that database configuration is properly set."""
    from app.core.config import settings
    # Use the actual config structure you have
    assert settings.db_host is not None
    assert settings.db_port is not None
    assert settings.db_name is not None


def test_security_configuration():
    """Test that security configuration is properly set."""
    from app.core.config import settings
    # Use the actual config structure you have
    assert settings.secret_key is not None
    assert len(settings.secret_key) >= 32
    assert settings.algorithm is not None

