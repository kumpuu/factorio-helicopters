--- Tools for working with entities.
-- @module Entity
-- @usage local Entity = require('stdlib/entity/entity')

local Entity = {_module_name = 'Entity'}
setmetatable(Entity, {__index = require('stdlib/core')})

local Is = require('stdlib/utils/is')

--- Tests whether an entity has access to a given field.
-- @tparam LuaEntity entity the entity to test the access to a field
-- @tparam string field_name the field name
-- @treturn boolean true if the entity has access to the field, false if the entity threw an exception when trying to access the field
function Entity.has(entity, field_name)
    Is.Assert(entity, 'missing entity argument')
    Is.Assert(field_name, 'missing field name argument')

    local status =
        pcall(
        function()
            return entity[field_name]
        end
    )
    return status
end

--- Gets the user data that is associated with an entity.
-- The user data is stored in the global object and it persists between loads.
--> The user data will be removed from an entity when the entity becomes invalid.
-- @tparam LuaEntity entity the entity to look up
-- @param Optional field to access data like a table
-- @treturn ?|nil|Mixed the user data, or nil if no data exists for the entity
function Entity.get_data(entity, field)
    Is.Assert(entity, 'missing entity argument')

    if not global._entity_data then
        return nil
    end

    local dest

    local code, unit_number = pcall(function() return entity.unit_number end)
    if code then
        dest = global._entity_data[unit_number]
    else
        local prototype_name = entity.name
        if not global._entity_data[prototype_name] then
            return nil
        end

        local prototype_category = global._entity_data[prototype_name]

        for i = #prototype_category, 1, -1 do
            local cur_entity_data = prototype_category[i]

            if not cur_entity_data.entity.valid then
                table.remove(prototype_category, i)
            
            elseif Entity._are_equal(cur_entity_data.entity, entity) then
                dest = cur_entity_data.data
                break
            end
        end
    end

    if dest and field then
        if type(dest) == "table" then
            return dest[field]
        else
            return nil
        end
    end

    return dest
end

--- Associates the user data to an entity.
-- The user data will be stored in the global object and it will persist between loads.
--> The user data will be removed from an entity when the entity becomes invalid.
-- @tparam LuaEntity entity the entity with which to associate the user data
-- @tparam ?|nil|Mixed data the data to set, or nil to delete the data associated with the entity
-- @param Optional field to set data to, treats the entity data like a table
-- @treturn ?|nil|Mixed the previous data associated with the entity, or nil if the entity had no previous data
function Entity.set_data(entity, data, field)
    Is.Assert(entity, 'missing entity argument')

    if not global._entity_data then
        global._entity_data = {}
    end

    local dest_table, dest_key

    local code, unit_number = pcall(function() return entity.unit_number end)
    if code then
        dest_table = global._entity_data
        dest_key = unit_number
    else
        local prototype_name = entity.name
        dest_key = "data"

        if not global._entity_data[prototype_name] then
            global._entity_data[prototype_name] = {}
        end

        local prototype_category = global._entity_data[prototype_name]

        for i = #prototype_category, 1, -1 do
            local cur_entity_data = prototype_category[i]

            if not cur_entity_data.entity.valid then
                table.remove(prototype_category, i)

            elseif Entity._are_equal(cur_entity_data.entity, entity) then
                if not field and data == nil then
                    local prev = cur_entity_data.data
                    table.remove(prototype_category, i)
                    return prev
                end

                dest_table = cur_entity_data
                break
            end
        end

        if not dest_table then
            table.insert(prototype_category, {entity = entity})
            dest_table = prototype_category[#prototype_category]
        end
    end

    local prev

    if field then
        if type(dest_table[dest_key]) ~= "table" then
            dest_table[dest_key] = {}
        end

        prev = dest_table[dest_key][field]
        dest_table[dest_key][field] = data
    else
        prev = dest_table[dest_key]
        dest_table[dest_key] = data
    end

    return prev
end

--- Freezes an entity, by making it inactive, inoperable, and non-rotatable, or unfreezes by doing the reverse.
-- @tparam LuaEntity entity the entity to freeze or unfreeze
-- @tparam[opt=true] boolean mode if true, freezes the entity, if false, unfreezes the entity. If not specified, it is set to true
-- @treturn LuaEntity the entity that has been frozen or unfrozen
function Entity.set_frozen(entity, mode)
    Is.Assert(entity, 'missing entity argument')
    mode = mode == false and true or false
    entity.active = mode
    entity.operable = mode
    entity.rotatable = mode
    return entity
end

--- Makes an entity indestructible so that it cannot be damaged or mined neither by the player nor by their enemy factions.
-- @tparam LuaEntity entity the entity to make indestructable
-- @tparam[opt=true] boolean mode if true, makes the entity indestructible, if false, makes the entity destructable
-- @treturn LuaEntity the entity that has been made indestructable or destructable
function Entity.set_indestructible(entity, mode)
    Is.Assert(entity, 'missing entity argument')
    mode = mode == false and true or false
    entity.minable = mode
    entity.destructible = mode
    return entity
end

--- Tests if two entities are equal.
-- If they don't have a reference equality and ***entity\_a*** has ***equals*** function, it will be called with ***entity\_b*** as its first argument.
-- @tparam LuaEntity entity_a
-- @tparam LuaEntity entity_b
-- @treturn boolean
function Entity._are_equal(entity_a, entity_b)
    if entity_a == nil then
        return entity_a == entity_b
    elseif entity_a == entity_b then
        return true
    elseif Entity.has(entity_a, 'equals') and entity_a.equals ~= nil then
        return entity_a.equals(entity_b)
    else
        return false
    end
end

--- Functions that raise events
-- @section Raise-Events
-- from @{https://github.com/aubergine10/lifecycle-events lifecycle-events}
-- <br>Used for raising `on_built and on_died` events for other mods

--- Destroy an entity by first raising the event.
--> Some entities can't be destroyed, such as the rails with trains on them.
-- @tparam LuaEntity entity the entity to be destroyed
-- @tparam[opt=false] boolean died raise on_entity_died event
-- @tparam[opt] LuaEntity cause the entity if available that did the killing for on_entity_died
-- @tparam[opt] LuaForce force the force if any that did the killing
-- @treturn boolean was the entity destroyed?
function Entity.destroy_entity(entity, died, cause, force)
    if entity and entity.valid and entity.can_be_destroyed then
        local event = {
            name = died and defines.events.on_entity_died or defines.events.script_raised_destroy,
            entity = entity,
            cause = cause,
            force = force,
            script = true
        }
        -- If no event name is passed, assume script_raised_destroy, otherwise raise the event
        -- with the passed event name. ie. defines.events.on_preplayer_mined_item
        event.script = true
        event.mod_name = 'stdlib'
        script.raise_event(event.name, event)
        return entity.destroy()
    end
end

--- Create an entity and raise a build event.
-- @tparam LuaSurface surface the surface to create the entity on
-- @tparam table settings settings to pass to create_entity see @{LuaSurface.create_entity}
-- @tparam[opt] uint player_index the index of the player, when not present and not raise_script_event pass a fake robot
-- @tparam[opt] boolean raise_script_event raise script_raised_built
-- @treturn LuaEntity the created entity
function Entity.create_entity(surface, settings, player_index, raise_script_event)
    surface = game.surfaces[surface]
    local entity = surface.create_entity(settings)
    if entity then
        local event = {
            created_entity = entity,
            script = true
        }

        if raise_script_event then
            event.name = defines.events.script_raised_built
            event.player_index = player_index
        elseif player_index then
            event.name = defines.events.on_built_entity
            event.player_index = player_index
        else
            event.name = defines.events.on_robot_built_entity
            event.robot = {}
        end

        script.raise_event(event.name, event)
        return entity
    end
end

--- Revivie an entity ghost and raise the `on_built` or `on_robot_built` event.
-- @tparam LuaEntity ghost the ghost entity to revivie
-- @tparam[opt] uint player_index if present, raise `on_built_entity` with player_index, if not present raise `on_robot_built_entity`
-- @tparam[opt] boolean raise_script_event, if true raise script_raised_built as the event
-- @treturn table the item stacks this entity collided with
-- @treturn LuaEntity the new revived entity
-- @treturn LuaEntity the item request proxy if present
function Entity.revive(ghost, player_index, raise_script_event)
    if ghost and ghost.valid then
        local collided, revived, proxy = ghost.revive(true)
        if revived then
            local event = {
                created_entity = revived,
                revived = true,
                script = true,
                modname = 'stdlib'
            }

            if raise_script_event then
                event.name = defines.events.script_raised_built
                event.player_index = player_index
            elseif player_index then
                event.name = defines.events.on_built_entity
                event.player_index = player_index
            else
                event.name = defines.events.on_robot_built_entity
                event.robot = {}
            end

            script.raise_event(event.name, event)
            return collided, revived, proxy
        end
    end
end

return Entity
