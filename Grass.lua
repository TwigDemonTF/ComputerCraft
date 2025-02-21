-- Configuration
local size = 128  -- Size of the square area
local seedSlot = 1 -- Slot where grass seeds are stored
local chestDirection = "back" -- Direction of chest (behind turtle)

-- Function to check and refill seeds
function refillSeeds()
    turtle.turnLeft()
    turtle.turnLeft() -- Face the chest
    for slot = 2, 16 do
        turtle.select(slot)
        if turtle.getItemCount(slot) > 0 then
            turtle.transferTo(seedSlot) -- Move seeds to main slot
            break
        end
    end
    turtle.suck(64) -- Pull more seeds if available
    turtle.turnLeft()
    turtle.turnLeft() -- Face back to work direction
end

-- Function to place seed
function placeSeed()
    if turtle.getItemCount(seedSlot) == 0 then
        print("Out of seeds! Returning to chest...")
        refillSeeds()
        if turtle.getItemCount(seedSlot) == 0 then
            print("No more seeds in chest! Stopping.")
            return false
        end
    end
    turtle.select(seedSlot)
    turtle.place()
    return true
end

-- Move and plant in a serpentine pattern
for y = 1, size do
    for x = 1, size - 1 do
        if not placeSeed() then return end
        turtle.forward()
    end
    placeSeed()

    -- Move to the next row
    if y < size then
        if y % 2 == 1 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
        else
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
        end
    end
end

print("Planting complete!")
