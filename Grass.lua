-- Configuration
local size = 128  -- Size of the square area
local seedSlot = 1 -- Slot where grass seeds are stored

-- Check if there are seeds
if turtle.getItemCount(seedSlot) == 0 then
    print("No grass seeds in slot " .. seedSlot)
    return
end

-- Function to place seed
function placeSeed()
    if turtle.getItemCount(seedSlot) == 0 then
        print("Out of seeds!")
        return false
    end
    turtle.select(seedSlot)
    turtle.place()
    return true
end

-- Move and plant in a serpentine pattern
for y = 1, size do
    for x = 1, size - 1 do
        placeSeed()
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
