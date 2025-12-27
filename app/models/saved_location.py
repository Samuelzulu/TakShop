from typing import Optional
from sqlmodel import SQLModel, Field
from datetime import datetime, timezone

def utcnow() -> datetime:
    return datetime.now(timezone.utc)

class saved_location(SQLModel, table=True):
    saved_location_id: Optional[int] = Field(default=None, primary_key=True)
    
    user_id: int = Field(foreign_key="user.user_id", index=True)
    university_id: int = Field(foreign_key="university.university_id", index=True)
    
    label: str
    description: str
    
    # optional for future map support
    latitude: Optional[float] = Field(default=None)
    longitude: Optional[float] = Field(default=None)
    
    is_default: bool = Field(default=False)
    is_active: bool = Field(default=True)
    
    created_at: datetime = Field(default_factory=utcnow, index=True)
    updated_at: datetime = Field(default_factory=utcnow, index=True)
    