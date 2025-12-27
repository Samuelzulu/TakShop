from typing import Optional
from datetime import datetime, timezone
from sqlmodel import SQLModel, Field

def utcnow() -> datetime:
    return datetime.now(timezone.utc)

class listing(SQLModel, table=True):
    # Identity/ownership
    listing_id: Optional[int] = Field(default=None, primary_key=True)
    
    seller_id: int = Field(index=True, foreign_key="user.user_id")
    university_id: int = Field(index=True, foreign_key="university.university_id")
    
    # Core product info
    title: str = Field(index=True, max_length=120)
    description: str = Field(max_length=2000)
    
    category: str = Field(index=True, max_length=60)
    condition: Optional[str] = Field(default=None, max_length=30)
    
    price: float = Field(ge=0)
    currency: str = Field(default="ZMW", max_length=3)
    
    # inventory
    quantity_on_hand: int = Field(default=0, ge=0)
    quantity_available: int = Field(default=0, ge=0)
    
    # Optional for later (cart holders / pending payment reservation)
    quantity_reserved: int = Field(default=0, ge=0)
    
    #low stock notifications
    low_stock_threshold: int = Field(default=0, ge=0)
    low_stock_notified: bool = Field(default=False)
    
    # visibility/lifecycle
    status: str = Field(default="PUBLISHED", index=True)
    
    created_at: datetime = Field(default_factory=utcnow, index=True)
    updated_at: datetime = Field(default_factory=utcnow, index=True)
    
    # (Optional) expire listings
    expires_at: Optional[datetime] = Field(default=None, index=True)