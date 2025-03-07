local meBridge = peripheral.find("meBridge")
local checkInterval = 60 -- Seconds between checks
local apiUrl = "http://your-flask-api-address/item/update"

-- Table of items to monitor with their target PCs
local itemsToMonitor = {
    { name = "thermal:phytogro", target_pc = "autoCrafter" },
    { name = "mekanism:bio_fuel", target_pc = "autoCrafter" },
    { name = "botania:ender_air_bottle", target_pc = "enderAirTurtle" },
}

-- Function to get item count in ME system
local function getItemCount(item)
    local itemDetail = meBridge.getItem({ name = item })
    if itemDetail then
        return itemDetail.amount
    end
    return 0
end

-- Function to send item amounts to the API
local function sendData()
    local data = {}
    for _, itemData in ipairs(itemsToMonitor) do
        local itemName = itemData.name
        local targetPc = itemData.target_pc
        local amount = getItemCount(itemName)

        table.insert(data, { name = itemName, amount = amount, target_pc = targetPc })
    end

    -- Convert data to JSON and send to API
    local jsonData = textutils.serializeJSON(data)
    local response = http.post(apiUrl, jsonData, { ["Content-Type"] = "application/json" })

    if response then
        print("Sent data to API: " .. jsonData)
    else
        print("Failed to send data to API")
    end
end

-- Main loop
while true do
    sendData()
    sleep(checkInterval)
end
