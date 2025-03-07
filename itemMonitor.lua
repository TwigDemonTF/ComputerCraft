local meBridge = peripheral.find("meBridge")
local checkInterval = 60 -- Seconds between checks
local apiUrl = "http://192.168.193.96:9000/item/update"

-- Table of items to monitor with their target PCs
local itemsToMonitor = {
    { name = "thermal:phytogro", target_pc = "autoCrafter", craftAmount = 3000000, "threshold" = 20000 },
    { name = "mekanism:bio_fuel", target_pc = "autoCrafter" craftAmount = 3000000, "threshold" = 20000 },
    { name = "botania:ender_air_bottle", target_pc = "enderAirTurtle" craftAmount = 100, "threshold" = 20 },
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
        local craftAmount = itemData.craftAmount
        local threshold = itemData.threshold

        table.insert(data, { name = itemName, amount = amount, target_pc = targetPc, craftAmount = craftAmount, itemThreshold = threshold })
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
