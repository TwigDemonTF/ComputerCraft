local meBridge = peripheral.find("meBridge") -- Find ME Bridge automatically
local chatBox = peripheral.find("chatBox")   -- Find Chat Box for notifications

local itemName = "thermal:phytogro" -- Item to monitor
local threshold = 20000  -- Minimum acceptable amount
local craftAmount = 3000000 -- Amount to craft when below threshold
local checkInterval = 60 -- Seconds between checks
local playerName = "Twig_Demon" -- Player to receive notifications

-- Function to get item count in ME system
local function getItemCount(item)
    local itemDetail = meBridge.getItem({ name = item })
    if itemDetail then
        return itemDetail.amount
    end
    return 0
end

-- Function to send a toast notification
local function sendNotification()
    if chatBox then
        local title = { text = "Command", color = "green" }
        local message = { text = "Creating Phyto-Gro" }

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
    local success = meBridge.craftItem({ name = item, count = amount })
    if success then
        print("Requested " .. amount .. "x " .. item)
        sendNotification() -- Send a notification when crafting
    else
        print("Crafting request failed!")
    end
end

-- Main loop
while true do
    local currentAmount = getItemCount(itemName)

    print("Current Phyto-Gro: " .. currentAmount)

    if currentAmount < threshold then
        print("Low Phyto-Gro detected! Requesting crafting...")
        requestCraft(itemName, craftAmount)
    else
        print("Phyto-Gro level is sufficient!")
    end

    sleep(checkInterval)
end
