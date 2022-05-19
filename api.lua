
-- Adds a rebreather as an item then also adds it to the list of valud rebreather items
rebreather.add_rebreather = function (name, image, dmg)
    local clean_name = rebreather.firstToUpper(rebreather.Replace(name, "_", " "))
    minetest.register_tool("rebreather:"..name, {
        short_description = clean_name,
        description = clean_name.."\nKeep in your inventory to draw breath from.\nDurability is lost with use, regenerates when not in use.",
        inventory_image = image,
        groups = {damage_per_use = dmg}
    })
    table.insert(rebreather.items, "rebreather:"..name)
    minetest.log("action", "[rebreather] Added 'rebreather:"..name.."' to rebreathers")
end

-- Checks if a player's hand contains a rebreather item returns bool
rebreather.check_player = function (name)
    local player = minetest.get_player_by_name(name)
    if player ~= nil then
        local inv = player:get_inventory()
        local found = false
        local id = -1
        for idx, stack in pairs(inv:get_list("main")) do
            for _, i in ipairs(rebreather.items) do
                if i == stack:get_name() then
                    found = true
                    id = idx
                    break
                end
            end
        end
        if found then
            return {success=true, value=id}
        else
            return {success=false, value=nil}
        end
    else
        return {success=false, value=nil}
    end
end

rebreather.air_player = function (name)
    local player = minetest.get_player_by_name(name)
    if player ~= nil then
        local inv = player:get_inventory()
        local rebreather_in_hand = nil
        local at = nil
        local rc = rebreather.check_player(name)
        rebreather_in_hand = rc.success
        at = rc.value
        --minetest.log("action", "[rebreather] '"..name.."' "..tostring(rebreather_in_hand).." "..tostring(at).."")
        if rebreather_in_hand then
            -- Obtain current item in hand, Obtain current air levels, Obtain max air levels (via Object properites)
            local hand = inv:get_stack("main", at)
            local def = hand:get_definition()
            local air = player:get_breath()
            local props = player:get_properties()
            local max_air = props.breath_max
            -- Only trigger air refresh at 25 percent
            local perc = (air / max_air) * 100.0
            perc = math.floor(perc)
            if rebreather.debug then
                minetest.log("action", "[rebreather] '"..name.."' Has "..perc.."% Air ("..air.."/"..max_air..")")
            end
            if perc <= 25 then
                -- Update air, Damage item, Update item in hand
                player:set_breath(max_air-1) -- Don't update to max so we quit hiding the breath bubbles.
                hand:add_wear(def.groups.damage_per_use or 1000)
                if rebreather.debug then
                    minetest.log("action", "[rebreather] '"..name.."' Used '"..hand:get_name().."' durability at "..hand:get_wear())
                end
                inv:set_stack("main", at, hand)
            elseif perc == 100 then
                -- Regenerate if the air is full
                local meta = hand:get_meta()
                hand:add_wear(-(def.groups.damage_per_use/8) or -125)
                inv:set_stack("main", at, hand)
                if rebreather.debug then
                    minetest.log("action", "[rebreather] '"..name.."' Regenerates '"..hand:get_name().."' durability at "..hand:get_wear())
                end
            end
        end
    end
end
