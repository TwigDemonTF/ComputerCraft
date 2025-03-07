from db import app
from models import Item

import time
import requests

def BackgroundWorker():
    while True:
        with app.app_context():
            items = Item.query.all()
            for item in items:
                if item.amount < item.threshold and item.target_pc:
                    requests.post(f'http://{item.target_pc}/craft', json={"item": item.name, "amount": item.threshold - item.amount})
                    print(f"Requested {item.threshold - item.amount}x {item.name} from {item.target_pc}")
        time.sleep(60)