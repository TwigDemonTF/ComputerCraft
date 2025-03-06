local http = require("http")  -- Ensure HTTP API is enabled in ComputerCraft
local meBridge = peripheral.find("meBridge")
local chatBox = peripheral.find("chatBox")

local playerName = "Twig_Demon"
local checkInterval = 60
local apiURL = "http://192.168.193.96:9000"

-- Function to fetch thresholds from the API
local function fetchThresholds()
    local response = http.get(apiURL .. "/item/thresholds")
    if response then
        local data = response.readAll()
        response.close()
        return textutils.unserialiseJSON(data)
    else
        print("Failed to fetch thresholds!")
        return {}
    end
end

-- Function to get item count in ME system
local function getItemCount(item)
    local itemDetail = meBridge.getItem({ name = item })
    if itemDetail then return itemDetail.amount end
    return 0
end

-- Function to send data to the API
local function sendToAPI(item, amount)
    local jsonData = textutils.serialiseJSON({ name = item, amount = amount })
    local response = http.post(apiURL .. "/item/amounts", jsonData, { ["Content-Type"] = "application/json" })
    if response then
        print("Sent data to API for " .. item)
        response.close()
    else
        print("Failed to send data for " .. item)
    end
end

while true do
    local thresholds = fetchThresholds()  -- Get thresholds from API

    for itemName, threshold in pairs(thresholds) do
        local currentAmount = getItemCount(itemName)
        print("Current " .. itemName .. ": " .. currentAmount .. " | Threshold: " .. threshold)

        -- Send updated amounts to the API
        sendToAPI(itemName, currentAmount)
    end

    sleep(checkInterval)
end
