"""
Services package for the Sales Manager Backend.

This package contains service layer implementations that handle
business logic and external service communication.
"""

from .data_layer_client import DataLayerClient, get_data_layer_client, close_data_layer_client
from .auth_service import get_auth_service, AuthService

__all__ = [
    "DataLayerClient",
    "get_auth_service",
    "get_data_layer_client", 
    "close_data_layer_client"
]
