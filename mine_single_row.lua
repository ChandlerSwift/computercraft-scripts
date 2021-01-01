-- an old version of mine.lua, which doesn't do row after row. It doesn't refuel
-- or empty inventory, either.

local function get_free_inventory_slots()
    free_slots = 0
    for slot=1, 16, 1 do
        if turtle.getItemCount(slot) == 0 then
            free_slots = free_slots + 1
        end
    end
    return free_slots
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

how_far_forward = 0
repeat
    turtle.dig()
    turtle.forward()
    how_far_forward = how_far_forward + 1
until not mine_column()
for i=1, how_far_forward, 1 do
    turtle.back()
end
