# TakShop Backend

Backend API for TakShop (campus marketplace + seller-controlled delivery slots).

## Tech
- FastAPI
- SQLModel
- PostgreSQL (prod) / SQLite (local ok)

## Setup (local)
1. Create a virtual environment
   - macOS/Linux:
     - python3 -m venv .venv
     - source .venv/bin/activate

2. Install dependencies
   - pip install -U pip
   - pip install fastapi uvicorn sqlmodel

3. Run the server
   - uvicorn app.main:app --reload

## Environment variables
Create a `.env` file (not committed). Example:
- DATABASE_URL=sqlite:///./takshop.db
- JWT_SECRET=change_me