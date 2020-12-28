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

function mine_two_columns(skip_initial_advance)
    if not skip_initial_advance then
        -- enter first column
        while not turtle.forward() do
            turtle.dig()
        end
    end

    height = 0
    -- mine up one side
    while turtle.inspectUp() ~= false do
        turtle.digUp()
        if turtle.up() then
            height = height + 1
        end
    end

    -- cross to the second side
    while not turtle.forward() do
        turtle.dig()
    end

    -- mine up if necessary
    while turtle.inspectUp() ~= false do
        turtle.digUp()
        if turtle.up() then
            height = height + 1
        end
    end

    -- mine down the other side
    while height > 0 do
        while not turtle.down() do
            turtle.digDown()
        end
        height = height - 1
    end
end

function mine_trees(num_trees)
    trees_mined_pass_one = 0
    block_detected, block = turtle.inspect()
    while block_detected and block.name == "minecraft:log" do
        mine_two_columns()
        trees_mined_pass_one = trees_mined_pass_one + 1
        block_detected, block = turtle.inspect()
    end

    -- turn around
    -- note that we don't want to overshoot since we don't know what's beyond
    -- the last tree
    turtle.turnLeft()
    while not turtle.forward() do
        turtle.dig()
    end
    turtle.turnLeft()

    -- second path back
    mine_two_columns(true)
    trees_mined_pass_two = 1
    block_detected, block = turtle.inspect()
    while block_detected and block.name == "minecraft:log" do
        mine_two_columns()
        trees_mined_pass_two = trees_mined_pass_two + 1
        block_detected, block = turtle.inspect()
    end

    -- return to origin
    assert(trees_mined_pass_one == trees_mined_pass_two)
    while not turtle.forward() do
        turtle.dig()
    end
    turtle.turnLeft()
    while not turtle.forward() do
        turtle.dig()
    end
    turtle.turnLeft()
end

function unload_logs()
    print("Not implemented")
end

function plant_saplings()
    print("Not implemented")
end

function main(num_planted_trees)
    print("waiting for tree to spawn")
    block_detected, block = turtle.inspect()
    while not block_detected or block.name ~= "minecraft:log" do -- wait for tree to spawn
        block_detected, block = turtle.inspect()
    end

    print("tree spawned! mining trees")
    mine_trees()

    print("trying to refuel")
    -- try_refuel_if_needed()

    print("unloading logs")
    unload_logs()

    print("planting saplings")
    plant_saplings()

    print("done! starting over...")
end

main()
