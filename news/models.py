from sqlalchemy import create_engine, Column, Integer, String, Text, Date, Time
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.engine.url import URL
import settings

DeclarativeBase = declarative_base()

def db_connect():
    return create_engine(URL(**settings.DATABASE))

def create_table(engine):
    DeclarativeBase.metadata.create_all(engine)

class News(DeclarativeBase):
    __tablename__ = "news"
    id = Column(Integer, primary_key=True)
    title = Column('title', String(200))
    author = Column('author', String(200))
    time = Column('time', Time)
    content = Column('content', Text)
    url = Column('url', String(200))
    type = Column('type',String(200))


