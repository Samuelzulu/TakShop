from typing import Optional
from sqlmodel import SQLModel, Field
from datetime import datetime, timezone

def utcnow() -> datetime:
    return datetime.now(timezone.utc)
class order(SQLModel, table=True):
    order_id: Optional[int] = Field(default=None, primary_key=True)
    
    # parties
    buyer_id: int = Field(foreign_key="user.user_id", index=True)
    seller_id: int = Field(foreign_key="user.user_id", index=True)
    
    # product/scope
    listing_id: int = Field(foreign_key="listing.listing_id", index=True)
    university_id: int = Field(foreign_key="university.university_id", index=True)
    
    # amount and quantity
    quantity: int = Field(ge=1)
    unit_price: float = Field(ge=0)
    currency: str = Field(default="ZMW", max_length=3)
    
    # What the buyer is actually charged (subtotal + fees + taxes - discounts)
    total_amount: float = Field(ge=0)
    
    # payment
    payment_status: str = Field(default="PENDING_PAYMENT", index=True)
    # PENDING_PAYMENT | PAID | PAYMENT_FAILED | CANCELED | REFUNDED
    
    payment_provider: Optional[str] = Field(default=None, max_length=40)
    payment_reference: Optional[str] = Field(default=None, index=True, max_length=120)
    
    paid_at: Optional[datetime] = Field(default=None, index=True)
    
    # fulfilment
    fulfilment_type: str = Field(default="PICKUP", index=True)
    # PICKUP | DELIVERY
    
    saved_location_id: Optional[int] = Field(default=None, foreign_key="saved_location.saved_location_id", index=True)
    seller_slot_id: Optional[int] = Field(default=None, foreign_key="seller_slot.slot_id", index=True)
    scheduled_at: Optional[datetime] = Field(default=None, index=True)
    
    # order fulfilment satus
    fulfilment_status: str = Field(default="NEW", index=True)
    # NEW | CONFIRMED | READY_FOR_PICKUP | OUT_FOR_DELIVERY | COMPLETED | CANCELED
    
    completed_at: Optional[datetime] = Field(default=None, index=True)
    
    # time stamps
    created_at: datetime = Field(default_factory=utcnow, index=True)
    updated_at: datetime = Field(default_factory=utcnow, index=True)