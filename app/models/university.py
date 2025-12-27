from typing import Optional
from sqlmodel import SQLModel, Field

class university(SQLModel, table = True):
    university_id: Optional[int] = Field(default=None, primary_key=True)
    
    
    name: str = Field(index=True) 
    abbreviation: Optional[str] = Field(default=None, index=True)   # "UNILUS"
    country: Optional[str] = Field(default=None, index=True)    # "Zambia"
    
    # optional but usefal for when using email verification, routing, etc.
    domain: Optional[str] = Field(default=None, index=True)     # "unilus.ac.za" (if applicable)
    
    # Regex rule for manual control for now
    student_id_regex: str = Field(index=True)
    
    # flags to use later (csv/SSO rollout)
    verification_mode: str = Field(default="regex")
    is_active: bool = Field(default=True)