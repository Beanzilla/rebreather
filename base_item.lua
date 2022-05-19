
rebreather.add_rebreather("steel_rebreather", "rebreather_rebreather.png", 5000)
rebreather.add_rebreather("gold_rebreather", "rebreather_rebreather.png^[colorize:#dddd0088", 3000)
rebreather.add_rebreather("diamond_rebreather", "rebreather_rebreather.png^[colorize:#00ddff99", 2000)

local empty = ""
local iron = "default:steel_ingot"
local wool = "group:wool" -- Use groups!
local diamond = "default:diamond"
local gold = "default:gold_ingot"

if minetest.get_modpath("mcl_core") then
    iron = "mcl_core:iron_ingot"
    --wool = "mcl_wool:white"
    diamond = "mcl_core:diamond"
    gold = "mcl_core:gold_ingot"
end

minetest.register_craft({
    output = "rebreather:steel_rebreather",
    recipe = {
        {wool, iron, wool},
        {iron, empty, iron},
        {empty, iron, empty},
    }
})

minetest.register_craft({
    output = "rebreather:gold_rebreather",
    recipe = {
        {wool, gold, wool},
        {gold, "rebreather:steel_rebreather", gold},
        {empty, gold, empty},
    }
})

minetest.register_craft({
    output = "rebreather:diamond_rebreather",
    recipe = {
        {wool, diamond, wool},
        {diamond, "rebreather:gold_rebreather", diamond},
        {empty, diamond, empty}
    }
})
