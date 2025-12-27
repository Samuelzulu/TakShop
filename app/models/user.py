from typing import Optional
from datetime import datetime, timezone
from sqlmodel import SQLModel, Field

def utcnow():
    return datetime.now(timezone.utc)

class user(SQLModel, table=True):
    user_id: Optional[int] = Field(default=None, primary_key=True)
    
    # core identity fields
    full_name: str
    email: Optional[str] = Field(default=None, index=True)
    
    # student identity
    student_id: str = Field(index=True)
    university_id: int = Field(foreign_key="university.university_id", index=True)
    
    # regex match only for now. we will later implement/upgrade this for csv/SSO
    verification_status: str = Field(default="regex_matched", index=True)
    
    
    created_at: datetime = Field(default_factory=utcnow)
    updated_at: datetime = Field(default_factory=utcnow)
    
    is_active: bool = Field(default=True)