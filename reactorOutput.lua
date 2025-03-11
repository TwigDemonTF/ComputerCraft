-- Configuration: Add items you want to filter
local filter = {
    ["draconicevolution:small_chaos_frag"] = true,
    ["draconicevolution:medium_chaos_frag"] = true,
    ["draconicevolution:large_chaos_frag"] = true
}

-- Function to check if an item is allowed
local function isAllowed(itemName)
    return filter[itemName] or false
end

-- Function to take items from inventory in front
local function takeFilteredItems()
    if not turtle.suck then
        print("This turtle doesn't support sucking items~ nya!")
        return
    end

    for slot = 1, 16 do
        local item = turtle.getItemDetail(slot)
        if not item then
            for i = 1, 64 do -- Try to take up to 64 items
                if turtle.suck(1) then
                    local newItem = turtle.getItemDetail(slot)
                    if newItem and not isAllowed(newItem.name) then
                        -- Drop unwanted item back
                        turtle.drop()
                    end
                else
                    break -- No more items to take
                end
            end
        end
    end
end

-- Main loop (runs once)
print("Meow~ Checking inventory in front!")
takeFilteredItems()
print("All done, nya~!")
