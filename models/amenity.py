#!/usr/bin/python3
""" State Module for HBNB project """
from models.base_model import BaseModel
from sqlalchemy import Column, String
from sqlalchemy.orm import relationship
from models.place import place_amenity


class Amenity(BaseModel):
    """class to store amenity details"""
    __tablename__ = 'amenities'
    name = Column(String(128), nulllable=False)
    place_amenities = relationship(
        'Place',
        secondary=place_amenity)
