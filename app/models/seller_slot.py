from typing import Optional
from sqlmodel import SQLModel, Field
from datetime import datetime, timezone

def utcnow() -> datetime:
    return datetime.now(timezone.utc)

class seller_slot(SQLModel, table = True):
    # primary key: DB assigns it, so it's Optional[int] with default None
    slot_id: Optional[int] = Field(default=None, primary_key=True)
    
    # foreign keys: MUST exist (a slot cannot exist without a seller/university)
    seller_id: int = Field(foreign_key="user.user_id", index=True)
    university_id: int = Field(foreign_key="university.university_id", index=True)
    
    # Availability window: must be provided my the seller (no default "now")
    start_at: datetime = Field(index=True)
    end_at: datetime = Field(index=True)
    
    #status: usually active immediatly; change to false if your product wants draft step
    is_active: bool = Field(default=True)
    
    # Audit timestamps: safe defaults
    created_at: datetime = Field(default_factory=utcnow, index=True)
    updated_at: datetime = Field(default_factory=utcnow, index=True)
    
    