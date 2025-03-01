local meBridge = peripheral.find("meBridge") -- Find ME Bridge automatically
local turtleName = os.getComputerLabel() or "AdvancedTurtle" -- Optional naming
local itemName = "thermal:phytogro" -- The item to monitor
local threshold = 2200000  -- Minimum acceptable amount
local craftAmount = 1000000 -- Amount to craft when below threshold
local checkInterval = 60 -- Seconds between checks

-- Function to get item count in ME system
local function getItemCount(item)
    local itemDetail = meBridge.getItem({ name = item })
    if itemDetail then
        return itemDetail.amount
    end
    return 0
end

-- Function to request autocrafting
local function requestCraft(item, amount)
    local success = meBridge.craftItem({ name = item, count = amount })
    if success then
        print("🐾 Requested " .. amount .. "x " .. item)
    else
        print("⚠️ Crafting request failed!")
    end
end

-- Main loop
while true do
    local currentAmount = getItemCount(itemName)

    print("🌱 Current Phyto-Gro: " .. currentAmount)

    if currentAmount < threshold then
        print("⚠️ Low Phyto-Gro detected! Requesting crafting...")
        requestCraft(itemName, craftAmount)
    else
        print("✅ Phyto-Gro level is sufficient!")
    end

    sleep(checkInterval) -- Wait before checking again
end
