from typing import Optional
from datetime import datetime, timezone
from sqlmodel import SQLModel, Field

def utcnow() -> datetime:
    return datetime.now(timezone.utc)

class listing_photo(SQLModel, table=True):
    photo_id: Optional[int] = Field(default=None, primary_key=True)
    
    # Relationship
    listing_id: int = Field(foreign_key="listing.listing_id", index=True)
    
    # image data
    url: str        # where image is stored
    position: Optional[int] = Field(default=None, index=True)
    is_primary: bool = Field(default=False)
    
    created_at: datetime = Field(default_factory=utcnow, index=True)