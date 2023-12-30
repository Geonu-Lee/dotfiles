from sqlalchemy import create_engine, Column, Integer, String, MetaData
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship

DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(DATABASE_URL)

Base = declarative_base()
metadata = MetaData()

class FileSystem(Base):
    __tablename__ = "filesystem"

    # create


class BoxInfo(Base):
    __tablename__ = "boxinfo"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    desc = Column(String, index=True)
    version = Column(String, index=True)
    models = relationship("Model", back_populates="boxinfo")

class Models(Base):
    __tablename__ = "models"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    

Base.metadata.create_all(bind=engine)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

