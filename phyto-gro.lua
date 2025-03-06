local meBridge = peripheral.find("meBridge") -- Find ME Bridge automatically
local chatBox = peripheral.find("chatBox")   -- Find Chat Box for notifications

local playerName = "Twig_Demon" -- Player to receive notifications
local checkInterval = 60 -- Seconds between checks

-- Table of items to monitor
local itemsToMonitor = {
    { name = "thermal:phytogro", threshold = 20000, craftAmount = 3000000 },
    { name = "mekanism:bio_fuel", threshold = 20000, craftAmount = 3000000 },
}

-- Function to get item count in ME system
local function getItemCount(item)
    local itemDetail = meBridge.getItem({ name = item })
    if itemDetail then
        return itemDetail.amount
    end
    return 0
end

-- Function to send a toast notification
local function sendNotification(item)
    if chatBox then
        local title = { text = "Command", color = "green" }
        local message = { text = "Creating " .. item }

        local titleJson = textutils.serialiseJSON(title)
        local messageJson = textutils.serialiseJSON(message)

        local success, err = chatBox.sendFormattedToastToPlayer(
            messageJson, titleJson, playerName, "&7&o&lSystem", "()", "&c&l"
        )

        if not success then
            print("Failed to send notification: " .. tostring(err))
        else
            print("Sent notification to " .. playerName)
        end
    else
        print("No Chat Box found! Skipping notification.")
    end
end

-- Function to request autocrafting
local function requestCraft(item, amount)
    local success, err = meBridge.craftItem({ name = item, count = amount })

    print("Requested: " .. amount .. "x " .. item)
    print("Success:", success, "Error:", err)

    if success then
        sendNotification(item) -- Send a notification when crafting
    else
        print("Crafting request failed for " .. item .. "! Error:", err or "Unknown error")
    end
end

-- Main loop
while true do
    for _, itemData in ipairs(itemsToMonitor) do
        local itemName = itemData.name
        local threshold = itemData.threshold
        local craftAmount = itemData.craftAmount

        local currentAmount = getItemCount(itemName)

        print("Current " .. itemName .. ": " .. currentAmount)

        if currentAmount < threshold then
            print("Low " .. itemName .. " detected! Requesting crafting...")
            requestCraft(itemName, craftAmount)
        else
            print(itemName .. " level is sufficient!")
        end
    end

    sleep(checkInterval)
end
