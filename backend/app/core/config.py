"""
Application configuration management using Pydantic settings.

Handles environment variables, feature flags, and configuration
for different deployment environments.
"""

from typing import Optional, List
from pydantic import Field, validator
from pydantic_settings import BaseSettings
import os


class DatabaseSettings(BaseSettings):
    """Database connection settings."""
    
    host: str = Field(default="localhost", env="DB_HOST")
    port: int = Field(default=3306, env="DB_PORT")
    username: str = Field(default="root", env="DB_USERNAME")
    password: str = Field(default="", env="DB_PASSWORD")
    database: str = Field(default="sales_manager", env="DB_NAME")
    pool_size: int = Field(default=10, env="DB_POOL_SIZE")
    max_overflow: int = Field(default=20, env="DB_MAX_OVERFLOW")
    
    @property
    def connection_string(self) -> str:
        """Generate database connection string."""
        return f"mysql+pymysql://{self.username}:{self.password}@{self.host}:{self.port}/{self.database}"


class SecuritySettings(BaseSettings):
    """Security and authentication settings."""
    
    secret_key: str = Field(env="SECRET_KEY")
    algorithm: str = Field(default="HS256", env="ALGORITHM")
    access_token_expire_minutes: int = Field(default=30, env="ACCESS_TOKEN_EXPIRE_MINUTES")
    refresh_token_expire_days: int = Field(default=7, env="REFRESH_TOKEN_EXPIRE_DAYS")
    otp_expire_minutes: int = Field(default=10, env="OTP_EXPIRE_MINUTES")
    
    @validator("secret_key")
    def validate_secret_key(cls, v):
        if len(v) < 32:
            raise ValueError("Secret key must be at least 32 characters long")
        return v


class SMSSettings(BaseSettings):
    """SMS service configuration."""
    
    provider: str = Field(default="inhouse", env="SMS_PROVIDER")
    api_key: Optional[str] = Field(default=None, env="SMS_API_KEY")
    api_secret: Optional[str] = Field(default=None, env="SMS_API_SECRET")
    sender_id: str = Field(default="SALES", env="SMS_SENDER_ID")
    is_development: bool = Field(default=False, env="IS_DEVELOPMENT")


class RedisSettings(BaseSettings):
    """Redis configuration for caching and sessions."""
    
    host: str = Field(default="localhost", env="REDIS_HOST")
    port: int = Field(default=6379, env="REDIS_PORT")
    password: Optional[str] = Field(default=None, env="REDIS_PASSWORD")
    database: int = Field(default=0, env="REDIS_DB")
    
    @property
    def connection_string(self) -> str:
        """Generate Redis connection string."""
        if self.password:
            return f"redis://:{self.password}@{self.host}:{self.port}/{self.database}"
        return f"redis://{self.host}:{self.port}/{self.database}"


class Settings(BaseSettings):
    """Main application settings."""
    
    app_name: str = Field(default="Sales Manager API", env="APP_NAME")
    version: str = Field(default="1.0.0", env="APP_VERSION")
    debug: bool = Field(default=False, env="DEBUG")
    environment: str = Field(default="development", env="ENVIRONMENT")
    
    # API settings
    api_prefix: str = Field(default="/api/v1", env="API_PREFIX")
    cors_origins: List[str] = Field(default=["*"], env="CORS_ORIGINS")
    
    # Rate limiting
    rate_limit_per_minute: int = Field(default=100, env="RATE_LIMIT_PER_MINUTE")
    
    # Feature flags
    enable_analytics: bool = Field(default=True, env="ENABLE_ANALYTICS")
    enable_file_uploads: bool = Field(default=True, env="ENABLE_FILE_UPLOADS")
    enable_sync: bool = Field(default=True, env="ENABLE_SYNC")
    
    # Database
    database: DatabaseSettings = DatabaseSettings()
    
    # Security
    security: SecuritySettings = SecuritySettings()
    
    # SMS
    sms: SMSSettings = SMSSettings()
    
    # Redis
    redis: RedisSettings = RedisSettings()
    
    # Data Layer (Private Middleware)
    data_layer_url: str = Field(env="DATA_LAYER_URL")
    data_layer_cert_path: Optional[str] = Field(default=None, env="DATA_LAYER_CERT_PATH")
    data_layer_key_path: Optional[str] = Field(default=None, env="DATA_LAYER_KEY_PATH")
    
    class Config:
        env_file = ".env"
        case_sensitive = False


# Global settings instance
settings = Settings()
