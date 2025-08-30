"""
Application configuration management using Pydantic settings.

Handles environment variables, feature flags, and configuration
for different deployment environments.
"""

import os
from typing import Optional, List


class Settings:
    """Main application settings."""
    
    def __init__(self):
        # App settings
        self.app_name = os.getenv("APP_NAME", "Sales Manager API")
        self.version = os.getenv("APP_VERSION", "1.0.0")
        self.debug = os.getenv("DEBUG", "false").lower() == "true"
        self.environment = os.getenv("ENVIRONMENT", "development")
        
        # API settings
        self.api_prefix = os.getenv("API_PREFIX", "/api/v1")
        self.cors_origins = os.getenv("CORS_ORIGINS", "*").split(",")
        
        # Rate limiting
        self.rate_limit_per_minute = int(os.getenv("RATE_LIMIT_PER_MINUTE", "100"))
        
        # Feature flags
        self.enable_analytics = os.getenv("ENABLE_ANALYTICS", "true").lower() == "true"
        self.enable_file_uploads = os.getenv("ENABLE_FILE_UPLOADS", "true").lower() == "true"
        self.enable_sync = os.getenv("ENABLE_SYNC", "true").lower() == "true"
        
        # Database settings
        self.db_host = os.getenv("DB_HOST", "localhost")
        self.db_port = int(os.getenv("DB_PORT", "3306"))
        self.db_username = os.getenv("DB_USERNAME", "root")
        self.db_password = os.getenv("DB_PASSWORD", "")
        self.db_name = os.getenv("DB_NAME", "sales_manager")
        self.db_pool_size = int(os.getenv("DB_POOL_SIZE", "10"))
        self.db_max_overflow = int(os.getenv("DB_MAX_OVERFLOW", "20"))
        self.db_echo = os.getenv("DB_ECHO", "false").lower() == "true"
        
        # Security settings
        self.secret_key = os.getenv("SECRET_KEY", "your-secret-key-must-be-at-least-32-characters-long")
        self.algorithm = os.getenv("ALGORITHM", "HS256")
        self.access_token_expire_minutes = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))
        self.refresh_token_expire_days = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", "7"))
        self.otp_expire_minutes = int(os.getenv("OTP_EXPIRE_MINUTES", "10"))
        
        # SMS settings
        self.sms_provider = os.getenv("SMS_PROVIDER", "inhouse")
        self.sms_api_key = os.getenv("SMS_API_KEY")
        self.sms_api_secret = os.getenv("SMS_API_SECRET")
        self.sms_sender_id = os.getenv("SMS_SENDER_ID", "SALES")
        self.is_development = os.getenv("IS_DEVELOPMENT", "false").lower() == "true"
        
        # Redis settings
        self.redis_host = os.getenv("REDIS_HOST", "localhost")
        self.redis_port = int(os.getenv("REDIS_PORT", "6379"))
        self.redis_password = os.getenv("REDIS_PASSWORD")
        self.redis_db = int(os.getenv("REDIS_DB", "0"))
        
        # Data Layer settings
        self.data_layer_url = os.getenv("DATA_LAYER_URL", "http://localhost:8001")
        self.data_layer_cert_path = os.getenv("DATA_LAYER_CERT_PATH")
        self.data_layer_key_path = os.getenv("DATA_LAYER_KEY_PATH")
        
        # Validate secret key
        if len(self.secret_key) < 32:
            raise ValueError("Secret key must be at least 32 characters long")
    
    @property
    def database_url(self) -> str:
        """Generate database connection string."""
        return f"mysql+pymysql://{self.db_username}:{self.db_password}@{self.db_host}:{self.db_port}/{self.db_name}"
    
    @property
    def redis_connection_string(self) -> str:
        """Generate Redis connection string."""
        if self.redis_password:
            return f"redis://:{self.redis_password}@{self.redis_host}:{self.redis_port}/{self.redis_db}"
        return f"redis://{self.redis_host}:{self.redis_port}/{self.redis_db}"


# Global settings instance
settings = Settings()
