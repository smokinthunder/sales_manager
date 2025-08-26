"""
Redis client for caching and session management.

Provides Redis connection management, caching utilities,
and session storage for the application.
"""

import json
import pickle
from typing import Any, Optional, Union
from datetime import timedelta
import redis.asyncio as redis
import structlog
from app.core.config import settings

logger = structlog.get_logger(__name__)


class RedisClient:
    """Redis client wrapper with caching utilities."""
    
    def __init__(self):
        """Initialize Redis client."""
        self.client: Optional[redis.Redis] = None
        self._connect()
    
    def _connect(self) -> None:
        """Establish Redis connection."""
        try:
            self.client = redis.Redis.from_url(
                settings.redis_connection_string,
                decode_responses=False,  # Keep binary for pickle
                socket_connect_timeout=5,
                socket_timeout=5,
                retry_on_timeout=True,
                health_check_interval=30
            )
            logger.info("Redis client initialized", url=settings.redis_connection_string)
        except Exception as e:
            logger.error("Failed to initialize Redis client", error=str(e))
            self.client = None
    
    async def is_connected(self) -> bool:
        """Check if Redis is connected."""
        if not self.client:
            return False
        
        try:
            await self.client.ping()
            return True
        except Exception:
            return False
    
    async def get(self, key: str, default: Any = None) -> Any:
        """
        Get value from Redis.
        
        Args:
            key: Redis key
            default: Default value if key not found
            
        Returns:
            Value from Redis or default
        """
        if not self.client or not await self.is_connected():
            return default
        
        try:
            value = await self.client.get(key)
            if value is None:
                return default
            
            # Try to deserialize as JSON first, then pickle
            try:
                return json.loads(value.decode('utf-8'))
            except (json.JSONDecodeError, UnicodeDecodeError):
                try:
                    return pickle.loads(value)
                except pickle.UnpicklingError:
                    return value.decode('utf-8')
                    
        except Exception as e:
            logger.error("Redis get error", key=key, error=str(e))
            return default
    
    async def set(
        self,
        key: str,
        value: Any,
        expire: Optional[Union[int, timedelta]] = None,
        nx: bool = False,
        xx: bool = False
    ) -> bool:
        """
        Set value in Redis.
        
        Args:
            key: Redis key
            value: Value to store
            expire: Expiration time in seconds or timedelta
            nx: Only set if key doesn't exist
            xx: Only set if key exists
            
        Returns:
            True if successful, False otherwise
        """
        if not self.client or not await self.is_connected():
            return False
        
        try:
            # Serialize value
            if isinstance(value, (str, int, float, bool)) or value is None:
                serialized_value = json.dumps(value).encode('utf-8')
            else:
                serialized_value = pickle.dumps(value)
            
            # Set expiration
            if isinstance(expire, timedelta):
                expire_seconds = int(expire.total_seconds())
            else:
                expire_seconds = expire
            
            # Set value
            if expire_seconds:
                result = await self.client.setex(key, expire_seconds, serialized_value)
            else:
                result = await self.client.set(key, serialized_value, nx=nx, xx=xx)
            
            return bool(result)
            
        except Exception as e:
            logger.error("Redis set error", key=key, error=str(e))
            return False
    
    async def delete(self, key: str) -> bool:
        """
        Delete key from Redis.
        
        Args:
            key: Redis key to delete
            
        Returns:
            True if successful, False otherwise
        """
        if not self.client or not await self.is_connected():
            return False
        
        try:
            result = await self.client.delete(key)
            return bool(result)
        except Exception as e:
            logger.error("Redis delete error", key=key, error=str(e))
            return False
    
    async def exists(self, key: str) -> bool:
        """
        Check if key exists in Redis.
        
        Args:
            key: Redis key to check
            
        Returns:
            True if key exists, False otherwise
        """
        if not self.client or not await self.is_connected():
            return False
        
        try:
            result = await self.client.exists(key)
            return bool(result)
        except Exception as e:
            logger.error("Redis exists error", key=key, error=str(e))
            return False
    
    async def expire(self, key: str, seconds: int) -> bool:
        """
        Set expiration for key.
        
        Args:
            key: Redis key
            seconds: Expiration time in seconds
            
        Returns:
            True if successful, False otherwise
        """
        if not self.client or not await self.is_connected():
            return False
        
        try:
            result = await self.client.expire(key, seconds)
            return bool(result)
        except Exception as e:
            logger.error("Redis expire error", key=key, error=str(e))
            return False
    
    async def ttl(self, key: str) -> int:
        """
        Get time to live for key.
        
        Args:
            key: Redis key
            
        Returns:
            TTL in seconds, -1 if no expiration, -2 if key doesn't exist
        """
        if not self.client or not await self.is_connected():
            return -2
        
        try:
            return await self.client.ttl(key)
        except Exception as e:
            logger.error("Redis TTL error", key=key, error=str(e))
            return -2
    
    async def increment(self, key: str, amount: int = 1) -> Optional[int]:
        """
        Increment counter value.
        
        Args:
            key: Redis key
            amount: Amount to increment
            
        Returns:
            New value or None if failed
        """
        if not self.client or not await self.is_connected():
            return None
        
        try:
            return await self.client.incrby(key, amount)
        except Exception as e:
            logger.error("Redis increment error", key=key, error=str(e))
            return None
    
    async def set_hash(self, key: str, field: str, value: Any) -> bool:
        """
        Set hash field value.
        
        Args:
            key: Redis key
            field: Hash field
            value: Field value
            
        Returns:
            True if successful, False otherwise
        """
        if not self.client or not await self.is_connected():
            return False
        
        try:
            # Serialize value
            if isinstance(value, (str, int, float, bool)) or value is None:
                serialized_value = json.dumps(value).encode('utf-8')
            else:
                serialized_value = pickle.dumps(value)
            
            result = await self.client.hset(key, field, serialized_value)
            return True
        except Exception as e:
            logger.error("Redis hash set error", key=key, field=field, error=str(e))
            return False
    
    async def get_hash(self, key: str, field: str, default: Any = None) -> Any:
        """
        Get hash field value.
        
        Args:
            key: Redis key
            field: Hash field
            default: Default value if field not found
            
        Returns:
            Field value or default
        """
        if not self.client or not await self.is_connected():
            return default
        
        try:
            value = await self.client.hget(key, field)
            if value is None:
                return default
            
            # Try to deserialize
            try:
                return json.loads(value.decode('utf-8'))
            except (json.JSONDecodeError, UnicodeDecodeError):
                try:
                    return pickle.loads(value)
                except pickle.UnpicklingError:
                    return value.decode('utf-8')
                    
        except Exception as e:
            logger.error("Redis hash get error", key=key, field=field, error=str(e))
            return default
    
    async def delete_hash(self, key: str, field: str) -> bool:
        """
        Delete hash field.
        
        Args:
            key: Redis key
            field: Hash field to delete
            
        Returns:
            True if successful, False otherwise
        """
        if not self.client or not await self.is_connected():
            return False
        
        try:
            result = await self.client.hdel(key, field)
            return bool(result)
        except Exception as e:
            logger.error("Redis hash delete error", key=key, field=field, error=str(e))
            return False
    
    async def close(self) -> None:
        """Close Redis connection."""
        if self.client:
            await self.client.close()
            self.client = None
            logger.info("Redis client closed")


# Global Redis client instance
redis_client = RedisClient()


async def get_redis_client() -> RedisClient:
    """
    Get Redis client instance.
    
    Returns:
        RedisClient instance
    """
    return redis_client


async def close_redis_client() -> None:
    """Close Redis client."""
    await redis_client.close()
