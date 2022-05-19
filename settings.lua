
rebreather.debug = minetest.settings:get_bool("rebreather.debug")
if rebreather.debug == nil then
    rebreather.debug = false
    minetest.settings:set_bool("rebreather.debug", false)
end

rebreather.debug_regeneration = minetest.settings:get_bool("rebreather.debug_regeneration")
if rebreather.debug_regeneration == nil then
    rebreather.debug_regeneration = false
    minetest.settings:set_bool("rebreather.debug_regeneration", false)
end

rebreather.enable_builtin = minetest.settings:get_bool("rebreather.enable_builtin")
if rebreather.enable_builtin == nil then
    rebreather.enable_builtin = true
    minetest.settings:set_bool("rebreather.enable_builtin", true)
end

rebreather.enable_builtin_crafting = minetest.settings:get_bool("rebreather.enable_builtin_crafting")
if rebreather.enable_builtin_crafting == nil then
    rebreather.enable_builtin_crafting = true
    minetest.settings:set_bool("rebreather.enable_builtin_crafting", true)
end
