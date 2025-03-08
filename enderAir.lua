-- Configuration
local ME_BRIDGE = "back"  -- Adjust if the ME Bridge is on another side
local ITEM_NAME = "botania:ender_air_bottle"  -- The item to monitor
local THRESHOLD = 64  -- Minimum amount before refilling
local CHECK_INTERVAL = 60  -- Time (in seconds) between checks
local BOTTLE_SLOT = 1  -- Slot where Glass Bottles are stored
local BOTTLE_AMOUNT = 64  -- Number of Glass Bottles to insert

-- Get ME bridge peripheral
local meBridge = peripheral.wrap(ME_BRIDGE)
if not meBridge then
    error("ME Bridge not found! Ensure it's connected at " .. ME_BRIDGE)
end

-- Function to get the item count in the ME system
local function getItemCount(itemName)
    local item = meBridge.getItem({ name = itemName })
    return item and item.amount or 0
end

-- Function to insert bottles into the front inventory
local function insertBottles()
    turtle.select(BOTTLE_SLOT)
    if turtle.getItemCount(BOTTLE_SLOT) >= BOTTLE_AMOUNT then
        if turtle.drop() then
            print("Inserted " .. BOTTLE_AMOUNT .. " Glass Bottles!")
        else
            print("Failed to insert bottles! Is the inventory full?")
        end
    else
        print("Not enough Glass Bottles in slot " .. BOTTLE_SLOT .. "!")
    end
end

-- Main monitoring loop
while true do
    local count = getItemCount(ITEM_NAME)
    print("Current " .. ITEM_NAME .. " count: " .. count)

    if count < THRESHOLD then
        print("Low on Ender Air Bottles! Refilling...")
        insertBottles()
    else
        print("Sufficient stock, no action needed.")
    end

    sleep(CHECK_INTERVAL)
end
