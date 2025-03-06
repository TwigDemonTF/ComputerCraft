from flask import Flask, request, jsonify
from db import database, app
from models import item, itemName

@app.route('/item/amounts', methods=["POST"])
def itemAmounts():
    data = request.json
    if not data or "name" not in data or "amount" not in data:
        return jsonify({"error": "Invalid data"}), 400

    item_name = data["name"]
    amount = data["amount"]

    # Find or create the itemName entry
    item_name_entry = itemName.query.filter_by(name=item_name).first()
    if not item_name_entry:
        item_name_entry = itemName(name=item_name)
        database.session.add(item_name_entry)
        database.session.commit()

    # Find or create the item entry
    item_entry = item.query.filter_by(itemNameId=item_name_entry.id).first()
    if item_entry:
        item_entry.amount = amount
    else:
        # Default threshold (change if needed)
        item_entry = item(itemNameId=item_name_entry.id, amount=amount, threshold=20000)
        database.session.add(item_entry)

    database.session.commit()

    return jsonify({
        "message": "Item amount updated",
        "threshold": item_entry.threshold  # Send threshold back
    }), 200

@app.route('/item/thresholds', methods=["GET"])
def getItemThresholds():
    items = item.query.all()
    item_data = {entry.itemName.name: entry.threshold for entry in items}
    return jsonify(item_data), 200
