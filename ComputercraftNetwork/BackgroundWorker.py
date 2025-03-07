from flask import request # type: ignore
from db import app
from models import Item

import time
import requests

def BackgroundWorker():
    while True:
        with app.app_context():
            items = Item.query.all()
            for item in items:
                if item.amount < item.threshold and item.targetPc:
                    craftItemDirect(item.name, item.craftAmount, item.targetPc)
        time.sleep(60)

def craftItemDirect(itemName, craftAmount, targetPc):
    print(f"Requested {craftAmount}x {itemName} from {targetPc}")
    
    # Prepare the request data to be sent to the ComputerCraft computer
    data = {
        "item": itemName,
        "amount": craftAmount,
        "targetPc": targetPc  # This could map to a redstone channel or computer name
    }

    # POST request to ComputerCraft API (a custom server or direct address)
    try:
        response = requests.post("http://computerCraftAddress:port/craft", json=data)
        print(f"Flask sent POST request: {response.status_code}")
    except Exception as e:
        print(f"Error sending POST request: {str(e)}")