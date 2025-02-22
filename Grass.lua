-- Configuration
local size = 128  -- Size of the area
local seedSlot = 1 -- Slot where grass seeds are stored
local fuelThreshold = 5000 -- Refuel when fuel is below this value
local targetFuelValue = 90000 -- Target value for refilling fuel
local seedAmount = 64 -- How many seeds to request each time
local fuelAmount = 64 -- How much fuel to request each time
local homePoint = "home" -- Warp point for the start location
local automata = peripheral.wrap("right")
local seedChest = peripheral.wrap("top")
local coalChest = peripheral.wrap("bottom")

local function removeAllPoints()
    local points = automata.points()
    if points then
        for _, name in pairs(points) do
            automata.deletePoint(name)
        end
    end
end

local function homeExists()
    local points = automata.points()
    if points then
        for _, name in pairs(points) do
            if name == "home" then
                return true
            end
        end
    end
    return false
end

-- Function to request items from AE2
function requestItem(itemName, amount)
    me.exportItem({name="Grass Seeds", count=1}, "left")
    return false
end

-- Function to check and refill seeds
function refillSeeds()
    print("Refilling seeds...")
    local tempPoint = automata.savePoint("return_point")

    -- Warp to home
    automata.warpToPoint(homePoint)

    -- Request seeds
    for slot = 1, 16 do
        turtle.suckUp(seedAmount)
    end

    -- Warp back to the saved position
    automata.warpToPoint("return_point")
end

-- Function to refuel
function refuelIfNeeded()
    if  turtle.getFuelLevel() <= fuelThreshold then
        print("Refueling. . .")
        local tempPoint = automata.savePoint("return_point")
        automata.warpToPoint("home")
        print("warped home")
        turtle.select(1)
        while turtle.getFuelLevel() < targetFuelValue do

            turtle.suckDown(64)
            turtle.refuel()

            -- Warp back to the saved position
            automata.warpToPoint("return_point")
        end
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

if not homeExists() then
    print("Saving home warp point...")
    if automata.savePoint("home") then
        print("Home point set!")
    else
        error("Failed to save home warp point!")
    end
else
    print("Home warp point already exists.")
end

-- Main Execution
print("Starting Automated Planting System")
plantGrass()
print("Planting complete!")

removeAllPoints()