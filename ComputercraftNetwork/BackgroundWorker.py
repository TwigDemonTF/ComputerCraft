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
                    requests.post(f'http://127.0.0.1:9000/item/craft/?targetPc={item.targetPc}', json={"item": item.name, "amount": item.threshold - item.amount})
                    print(f"Requested {item.threshold - item.amount}x {item.name} from {item.targetPc}")
        time.sleep(60)