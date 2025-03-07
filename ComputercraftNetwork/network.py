from flask import Flask, request, jsonify
from db import database, app
from models import Item
from .BackgroundWorker import BackgroundWorker

import threading

@app.route('/item/update', methods=['POST'])
def update_item():
    data = request.json
    for item in data:
        existing = Item.query.filter_by(name=item['name']).first()
        if existing:
            existing.amount = item['amount']
        else:
            new_item = Item(name=item['name'], amount=item['amount'])
            database.session.add(new_item)
    database.session.commit()
    return jsonify({"message": "Items updated"})

@app.route('item/craft', methods=['POST'])
def craftItem():
    targetPc = request.args.get('targetPc')


if __name__ == '__main__':
    with app.app_context():
        database.create_all()
    threading.Thread(target=BackgroundWorker, daemon=True).start()
    app.run(host='0.0.0.0', port=9000, debug=True)
