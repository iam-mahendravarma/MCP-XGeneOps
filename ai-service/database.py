import os
from pymongo import MongoClient
from dotenv import load_dotenv

load_dotenv()

# MongoDB connection
MONGODB_URI = os.getenv('MONGODB_URI', 'mongodb://localhost:27017')

def get_database():
    """Get MongoDB database connection"""
    try:
        client = MongoClient(MONGODB_URI)
        # Get database name from URI or use default
        db_name = MONGODB_URI.split('/')[-1] if '/' in MONGODB_URI else 'contentdb'
        return client[db_name]
    except Exception as e:
        print(f"Error connecting to MongoDB: {e}")
        return None

def get_content_collection():
    """Get content collection from MongoDB"""
    db = get_database()
    if db:
        return db.content
    return None 