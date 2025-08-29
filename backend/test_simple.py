"""
Simple test to isolate SQLModel issues.
"""

from datetime import datetime
from typing import Optional
from enum import Enum
from sqlmodel import SQLModel, Field

class TestRole(str, Enum):
    ADMIN = "admin"
    USER = "user"

class TestUser(SQLModel, table=True):
    __tablename__ = "test_users"
    
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(..., description="User name")
    role: TestRole = Field(..., description="User role")
    created_at: datetime = Field(default_factory=datetime.utcnow)

if __name__ == "__main__":
    print("Test model created successfully")
    user = TestUser(name="Test User", role=TestRole.ADMIN)
    print(f"User: {user.name}, Role: {user.role}")
