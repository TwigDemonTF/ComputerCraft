from db import database

class item(database.Model):
    __tablename__ = 'items'
    id = database.Column(database.Integer, primary_key=True)
    itemNameId = database.Column(database.Integer, database.ForeignKey('itemNames.id'), nullable=False)
    itemName = database.relationship('itemName', backref=database.backref('items', lazy=True))
    amount = database.Column(database.Integer, nullable=False)
    threshold = database.Column(database.Integer, nullable=False)

class itemName(database.Model):
    __tablename__ = 'itemNames'
    id = database.Column(database.Integer, primary_key=True)
    name = database.Column(database.String(100), nullable=False)