local meBridge = peripheral.find("meBridge")
local chatBox = peripheral.find("chatBox")
local playerName = "Twig_Demon" -- Change this to your actual username
local redstoneChannel = 1 -- The redstone channel where the requests will be received
local checkInterval = 10 -- Seconds between each check

-- Function to send a toast notification
local function sendNotification(item)
    if chatBox then
        local title = { text = "Command", color = "green" }
        local message = { text = "Creating " .. item }

        local titleJson = textutils.serializeJSON(title)
        local messageJson = textutils.serializeJSON(message)

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
    if not meBridge then
        print("No ME Bridge found! Cannot craft items.")
        return
    end

    local success, err = meBridge.craftItem({ name = item, count = amount })

    print("Requested: " .. amount .. "x " .. item)
    print("Success:", success, "Error:", err)

    if success then
        sendNotification(item) -- Send a notification when crafting
    else
        print("Crafting request failed for " .. item .. "! Error:", err or "Unknown error")
    end
end

-- Function to listen for redstone signals and handle craft requests
local function listenForCraftRequests()
    while true do
        print("Waiting for redstone signal on channel " .. redstoneChannel)

        -- Check for the redstone signal
        if redstone.getInput(redstoneChannel) then
            print("Signal received!")

            -- Simulating the receipt of item data (this can be sent from Flask API)
            local item = "stone" 
            local amount = 5 

            -- Request the crafting action
            requestCraft(item, amount)
        end

        sleep(checkInterval) -- Delay between checks
    end
end

-- Start listening for redstone signals (craft requests)
listenForCraftRequests()
