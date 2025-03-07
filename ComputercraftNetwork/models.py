from db import database

class Item(database.Model):
    __tablename__ = 'items'
    id = database.Column(database.Integer, primary_key=True)
    name = database.Column(database.String(100), unique=True, nullable=False)
    amount = database.Column(database.Integer, nullable=False, default=0)
    threshold = database.Column(database.Integer, nullable=False, default=1000)
    target_pc = database.Column(database.String(100), nullable=True)  # The PC or turtle to send crafting requests