from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Database Configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///reactor.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False