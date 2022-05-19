
rebreather.add_rebreather("rebreather", "rebreather_rebreather.png", 3000)
rebreather.add_rebreather("diamond_rebreather", "rebreather_rebreather.png^[colorize:#00ddff77", 1500)

local empty = ""
local iron = "default:steel_ingot"
local wool = "group:wool" -- Use groups!
local diamond = "default:diamond"

if minetest.get_modpath("mcl_core") then
    iron = "mcl_core:iron_ingot"
    --wool = "mcl_wool:white"
    diamond = "mcl_core:diamond"
end

minetest.register_craft({
    output = "rebreather:rebreather",
    recipe = {
        {wool, iron, wool},
        {iron, empty, iron},
        {empty, iron, empty},
    }
})

minetest.register_craft({
    output = "rebreather:diamond_rebreather",
    recipe = {
        {wool, diamond, wool},
        {diamond, "rebreather:rebreather", diamond},
        {empty, diamond, empty}
    }
})
