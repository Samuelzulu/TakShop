from pydantic import BaseModel
from typing import Optional

class UniversityBase(BaseModel):
    name: str
    abbreviation: Optional[str] = None
    location: str
    domain: str     # Useful for verifying school eamils (or ids in the case of Zambian universities)
    
class UniveersityCreate(UniversityBase):
    pass    # used for incoming data when creating a school 

class UniversityResponse(UniversityBase):
    university_id: int  # used when sending data back to the user
    
    class Config:
        from_attributes = True