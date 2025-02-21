-- Configuration
local size = 128  -- Size of the area
local seedSlot = 1 -- Slot where grass seeds are stored
local fuelThreshold = 500 -- Refuel when fuel is below this value
local seedAmount = 64 -- How many seeds to request each time
local homePoint = "home" -- Warp point for the start location
local me = peripheral.find("meBridge")

-- Ensure ME System is available
if not me then
    error("ME System not found! Ensure the Peripheral Proxy is connected.")
end

-- Save home location once at the start
if not turtle.savePoint(homePoint) then
    error("Failed to save home warp point!")
end

-- Function to request items from AE2
function requestItem(itemName, amount)
    local craftable = me.getCraftables()
    for _, recipe in pairs(craftable) do
        if recipe.name == itemName then
            print("Requesting " .. amount .. " of " .. itemName)
            recipe.request(amount)
            return true
        end
    end
    return false
end

-- Function to warp to a saved point
function warpTo(point)
    local cooldown = turtle.getWarpCooldown()
    if cooldown > 0 then
        print("Warp on cooldown! Waiting " .. cooldown .. " seconds...")
        sleep(cooldown)
    end
    if turtle.warpToPoint(point) then
        print("Warped to " .. point)
        return true
    else
        print("Failed to warp to " .. point)
        return false
    end
end

-- Function to check and refill seeds
function refillSeeds()
    print("Refilling seeds...")
    local tempPoint = "return_point"
    
    -- Save current position as a return point
    if not turtle.savePoint(tempPoint) then
        error("Failed to save return warp point!")
    end

    -- Warp to home
    warpTo(homePoint)

    -- Request seeds
    requestItem("botania:grass_seeds", seedAmount)
    sleep(5) -- Wait for AE2 crafting to complete
    turtle.suck(64) -- Take from ME Interface

    -- Warp back to the saved position
    warpTo(tempPoint)
end

-- Function to refuel
function refuelIfNeeded()
    if turtle.getFuelLevel() < fuelThreshold then
        print("Refueling...")
        local tempPoint = "return_point"

        -- Save current position as a return point
        if not turtle.savePoint(tempPoint) then
            error("Failed to save return warp point!")
        end

        -- Warp to home
        warpTo(homePoint)

        -- Request fuel
        requestItem("minecraft:charcoal", 16)
        sleep(5)
        turtle.suck(16)
        turtle.refuel()

        -- Warp back to the saved position
        warpTo(tempPoint)
    end
end

-- Function to place seed
function placeSeed()
    if turtle.getItemCount(seedSlot) == 0 then
        refillSeeds()
        if turtle.getItemCount(seedSlot) == 0 then
            print("No seeds available! Stopping.")
            return false
        end
    end
    turtle.select(seedSlot)
    turtle.place()
    return true
end

-- Move and plant in a serpentine pattern
function plantGrass()
    for y = 1, size do
        for x = 1, size - 1 do
            refuelIfNeeded()
            if not placeSeed() then return end
            turtle.forward()
        end
        placeSeed()

        -- Move to the next row
        if y < size then
            if y % 2 == 1 then
                turtle.turnRight()
                placeSeed()
                turtle.forward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                placeSeed()
                turtle.forward()
                turtle.turnLeft()
            end
        end
    end
end

-- Main Execution
print("Starting Automated Planting System")
plantGrass()
print("Planting complete!")
