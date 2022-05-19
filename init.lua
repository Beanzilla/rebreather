
-- We have an api for making your own rebreather items
rebreather = {}

rebreather.version = "1.0"
rebreather.debug = false
rebreather.modpath = minetest.get_modpath("rebreather")

if minetest.get_modpath("default") then
    rebreather.gamemode = "MTG"
elseif minetest.get_modpath("mcl_core") then
    rebreather.gamemode = "MCL"
else
    rebreather.gamemode = "???"
end

function rebreather.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function rebreather.Replace(str, find, replace)
    return str:gsub("%"..find, replace)
end

-- This tracks what item name counts as a rebreather item
rebreather.items = {}

dofile(rebreather.modpath..DIR_DELIM.."api.lua")
dofile(rebreather.modpath..DIR_DELIM.."base_item.lua") -- A generic basic rebreather

local interval = 0.0 -- fire off once every second
minetest.register_globalstep(function (delta)
    interval = interval + delta
    if interval >= 2.0 then
        for _, player in ipairs(minetest.get_connected_players()) do
            rebreather.air_player(player:get_player_name())
        end
        interval = 0.0
    end
end)

minetest.log("action", "[rebreather] Version: "..rebreather.version)
minetest.log("action", "[rebreather] Gamemode: "..rebreather.gamemode)
