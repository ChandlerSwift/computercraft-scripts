local function get_free_inventory_slots()
    free_slots = 0
    for slot=1, 16, 1 do
        if turtle.getItemCount(slot) == 0 then
            free_slots = free_slots + 1
        end
    end
    return free_slots
end

function try_refuel_if_needed()
    for i = 1, 16 do
        turtle.select(i)
        if turtle.refuel(0) then -- it's valid fuel
            while turtle.getFuelLevel() < turtle.getFuelLimit() and turtle.getItemCount(i) > 0 do
                turtle.refuel(1)
            end
        end 
    end
end

local function mine_column()
    local hit_bedrock = false
    local depth = 0
    local max_depth = 1000
    block_detected, block = turtle.inspectDown()
    while block.name ~= "minecraft:bedrock" and get_free_inventory_slots() > 0 and turtle.getFuelLevel() > 1000 and depth < max_depth do
        turtle.digDown()
        if turtle.down() then
            depth = depth + 1
        end
        block_detected, block = turtle.inspectDown()
    end
    if block.name == "minecraft:bedrock" or depth == max_depth then
        hit_bedrock = true
    end
    while depth > 0 do
        turtle.up()
        depth = depth - 1
    end
    return hit_bedrock
end

local function deposit_inventory_into_chest()
    for slot=1, 16, 1 do
        turtle.select(slot)
        turtle.drop()
    end
end

while true do
    -- mine column and return
    how_far_forward = 0
    repeat
        turtle.dig()
        turtle.forward()
        how_far_forward = how_far_forward + 1
    until not mine_column()
    for i=1, how_far_forward, 1 do
        turtle.back()
    end

    try_refuel_if_needed()

    -- deposit items into chest
    turtle.turnLeft()
    turtle.turnLeft()
    assert(turtle.advance())

    -- in minecraft 1.12, chests can't be placed directly next to each other.
    -- (I believe this got added in a later update.) However, we don't mine a
    -- full chest each pass, so I just populate at least one of every two chests
    -- and check if we need to move to access one.
    moved_for_chest = false
    block_detected, block = turtle.inspect()
    if block.name ~= "minecraft:chest" then
        moved_for_chest = true
        turtle.turnLeft()
        assert(turtle.advance())
        turtle.turnRight()
        block_detected, block = turtle.inspect()
        assert(block.name == "minecraft:chest")
    end
    deposit_inventory_into_chest()

    -- return to mining position in next slot
    turtle.turnLeft()
    if not moved_for_chest then
        turtle.advance()
    end
    turtle.turnLeft()
    turtle.advance()
end
