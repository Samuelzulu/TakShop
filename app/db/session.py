import sqlite3
from typing import Generator, Annotated
from fastapi import Depends

DB_NAME = 'takshop.db'

def init_db():
    """Initializes the database engine and creates tables if they don't exist."""
    connection = sqlite3.connect(DB_NAME)
    cursor = connection.cursor()
    
    # Enable foreign key support (disabled by default in SQLite)
    cursor.execute("PRAGMA foreign_keys = ON;")
    
    #create students' table (central profile)
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS Students (
            student_id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            university TEXT NOT NULL,
            age INTEGER,
            email TEXT UNIQUE
        )
    ''')

    #create the products table (Links a seller to an Item)
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS products (
            product_id INTEGER PRIMARY KEY AUTOINCREMENT,
            seller_id INTEGER NOT NULL,
            item_name TEXT NOT NULL,
            price REAL NOT NULL,
            FOREIGN KEY (seller_id) REFERENCES students(student_id)
        )
    ''')

    # create the Transactions Table (Links Buyer, Seller, and Product)
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS Transactions (
            transaction_id INTEGER KEY AUTOINCREMENT,
            buyer_id INTEGER NOT NULL,
            seller_id INTEGER NOT NULL,
            product_id INTEGER NOT NULL,
            date TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (buyer_id) REFERENCES students(student_id),
            FOREIGN KEY (seller_id) REFERENCES students(student_id),
            FOREIGN KEY (product_id) REFERENCES products(product_id)
        )
    ''')

    # save and close
    connection.commit()
    connection.close()
    
# The session providor (request/response lifecycle)
def get_db() -> Generator:
    """Provides a database session to FastAPI routes."""
    # check_same_thread = False is required for SQLite + FastAPI
    connection = sqlite3.connect(DB_NAME, check_same_thread=False)
    connection.row_factory = sqlite3.Row # Allows accessing columns by name
    
    try:
        cursor = connection.cursor()
        cursor.execute("PRAGMA foreign_keys = ON;")
        yield cursor
        connection.commit()
    except Exception:
        connection.rollback()
        raise
    finally:
        connection.close()
        
# TYPE ALIAS (for cleaner routes)
# This allows us to just use 'db: DBSession' in the route parameters
DBSession = Annotated[sqlite3.Cursor, Depends(get_db)]