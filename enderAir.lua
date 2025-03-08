-- Configuration
local ME_BRIDGE = "back"  -- Adjust if the ME Bridge is on another side
local CHAT_BOX = "right"  -- The side where the chatBox is located
local ITEM_NAME = "botania:ender_air_bottle"  -- The item to monitor
local THRESHOLD = 100  -- Minimum amount before refilling
local CHECK_INTERVAL = 60  -- Time (in seconds) between checks
local BOTTLE_SLOT = 1  -- Slot where Glass Bottles are stored
local BOTTLE_AMOUNT = 64  -- Number of Glass Bottles to insert
local PLAYER_NAME = "Twig_Demon"  -- Set this to your in-game name

-- Get ME bridge peripheral
local meBridge = peripheral.wrap(ME_BRIDGE)
if not meBridge then
    error("ME Bridge not found! Ensure it's connected at " .. ME_BRIDGE)
end

-- Get Chat Box peripheral
local chatBox = peripheral.wrap(CHAT_BOX)
if not chatBox then
    print("Warning: Chat Box not found on " .. CHAT_BOX .. ". Notifications will be skipped.")
end

-- Function to get the item count in the ME system
local function getItemCount(itemName)
    local item = meBridge.getItem({ name = itemName })
    return item and item.amount or 0
end

-- Function to send a toast notification
local function sendNotification(item)
    if chatBox then
        local title = { text = "Command", color = "green" }
        local message = { text = "Creating " .. item }

        local titleJson = textutils.serializeJSON(title)
        local messageJson = textutils.serializeJSON(message)

        local success, err = chatBox.sendFormattedToastToPlayer(
            messageJson, titleJson, PLAYER_NAME, "&7&o&lSystem", "()", "&c&l"
        )

        if not success then
            print("Failed to send notification: " .. tostring(err))
        else
            print("Sent notification to " .. PLAYER_NAME)
        end
    else
        print("No Chat Box found! Skipping notification.")
    end
end

-- Function to insert bottles into the front inventory
local function insertBottles()
    turtle.select(BOTTLE_SLOT)
    if turtle.getItemCount(BOTTLE_SLOT) >= BOTTLE_AMOUNT then
        if turtle.drop() then
            print("Inserted " .. BOTTLE_AMOUNT .. " Glass Bottles!")
            sendNotification("Ender Air Bottles")  -- Send chat notification
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
