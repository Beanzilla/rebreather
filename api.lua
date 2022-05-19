
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
                    local stack_def = stack:get_definition()
                    -- Don't destroy rebreathers (this will find what the durability/wear is left, if we can take another use)
                    if stack:get_wear()+(stack_def.groups.damage_per_use) < 65535 then
                        found = true
                        id = idx
                        break
                    end
                end
                if found then
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
        local rebreather_in_inv = nil
        local at = nil
        local rc = rebreather.check_player(name)
        rebreather_in_inv = rc.success
        at = rc.value
        --minetest.log("action", "[rebreather] '"..name.."' "..tostring(rebreather_in_inv).." "..tostring(at).."")
        if rebreather_in_inv then
            -- Obtain item in inv, Obtain current air levels, Obtain max air levels (via Object properites)
            local rebr = inv:get_stack("main", at)
            local def = rebr:get_definition()
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
                -- Update air, Damage item, Update item in inventory
                player:set_breath(max_air-1) -- Don't update to max so we quit hiding the breath bubbles. (Which also triggered a regenerate)
                rebr:add_wear(def.groups.damage_per_use or 5000)
                if rebreather.debug then
                    minetest.log("action", "[rebreather] '"..name.."' Used '"..rebr:get_name().."' durability at "..rebr:get_wear())
                else
                    minetest.log("action", "[rebreather] '"..name.."' Used '"..rebr:get_name().."'")
                end
                inv:set_stack("main", at, rebr)
            elseif perc == 100 then
                -- Regenerate if the air is full (Regenerate all of them not just the one we were using)
                local num_repaired = 0
                for i, _ in pairs(inv:get_lists()) do
                    if rebreather.debug_regeneration then
                        minetest.log("action", "[rebreather] i="..tostring(i))
                    end
                    for id, stack in pairs(inv:get_list(i)) do
                        if rebreather.debug_regeneration then
                            minetest.log("action", "[rebreather] i="..tostring(i).." id="..tostring(id).." stack="..minetest.serialize(stack:to_table()))
                        end
                        for _, r in ipairs(rebreather.items) do
                            if stack:get_name() == r and stack:get_wear() ~= 0 then
                                if rebreather.debug_regeneration then
                                    minetest.log("action", "[rebreather] Repaired! i="..tostring(i).." id="..tostring(id).." stack="..minetest.serialize(stack:to_table()).." Repaired!")
                                end
                                local stack_def = stack:get_definition()
                                stack:add_wear(-(stack_def.groups.damage_per_use/8) or -625)
                                inv:set_stack(i, id, stack)
                                num_repaired = num_repaired + 1
                            end
                        end
                    end
                end
                if num_repaired ~= 0 then
                    minetest.log("action", "[rebreather] '"..name.."' Regenerates "..tostring(num_repaired).." rebreathers")
                end
            end
        end
    end
end
