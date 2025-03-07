local http = require("http")
local meBridge = peripheral.find("meBridge") -- Find ME Bridge automatically

local apiUrl = "http://your-api-ip:9000/item/update" -- Replace with your Flask API endpoint
local checkInterval = 60 -- Seconds between updates

-- Function to get all items in ME system
local function getAllItems()
    return meBridge.listItems()
end

-- Function to send item data to the API
local function updateDatabase(items)
    local payload = textutils.serializeJSON(items)
    local response = http.post(apiUrl, payload, { ["Content-Type"] = "application/json" })
    if response then
        local resBody = response.readAll()
        response.close()
        print("Database updated successfully: " .. resBody)
    else
        print("Failed to update database!")
    end
end

-- Main loop
while true do
    local items = getAllItems()
    local itemData = {}
    
    for _, item in ipairs(items) do
        table.insert(itemData, { name = item.name, amount = item.amount })
    end
    
    updateDatabase(itemData)
    sleep(checkInterval)
end