# main.py

from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy.orm import Session
from db import SessionLocal, FileSystem

app = FastAPI()

# Dependency to get the database session
def get_db():
    db = None
    try:
        db = SessionLocal()
        yield db
    except Exception as e:
        print(f"Error in get_db: {e}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")
    finally:
        if db is not None:
            db.close()

# API to create a file or directory
@app.post("/create_item/")
def create_item(name: str, db: Session = Depends(get_db)):
    db_file = FileSystem(name=name)
    db.add(db_file)
    db.commit()
    db.refresh(db_file)
    return {"id": db_file.id, "name": db_file.name}

# API to get all files and directories
@app.get("/get_items/")
def get_items(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    files = db.query(FileSystem).offset(skip).limit(limit).all()
    return files
