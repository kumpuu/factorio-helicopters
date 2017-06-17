require ("logic.heli")

function getHeliFromBaseEntity(ent)
	for k,v in pairs(global.helis) do
		if v.baseEnt == ent then
			return v
		end
	end

	return nil
end

--[[function onDrivingStateChanged(e)
	local pInd = e.player_index
	local player = game.players[pInd]

	if player.driving then
		local char_name = player.vehicle.name
		local t = player.vehicle.type
		local d = player.driving

		player.print(tostring(pInd) .. " entered " .. t .. " with name " .. char_name .. " and driving= " .. tostring(d))
	else
		player.print(tostring(pInd) .. " left a vehicle ")
	end
end]]

function OnLoad(e)
	if global.helis then
		for k, v in pairs(global.helis) do
			setmetatable(v, {__index = heli})
		end
	end
end

function OnBuilt(e)
	local ent = e.created_entity

	if ent.name == "heli-placement-entity-_-" then
		if not global.helis then global.helis = {} end
		OnHeliBuilt(ent)
	end
end

function OnTick(e)
	if global.helis then
		for k, heli in pairs(global.helis) do
			heli:OnTick()
		end
	end
end

function OnRemoved(e)
	local ent = e.entity

	for k,v in pairs(heli.entityNames) do
		if ent.name == v then
			for i,val in ipairs(global.helis) do
				if val:isBaseOrChild(ent) then
					val:destroy()
					table.remove(global.helis, i)
				end
			end
		end
	end
end

function OnHeliUp(e)
	local p = game.players[e.player_index]
	if p.driving and p.vehicle.name == "heli-entity-_-" then
		getHeliFromBaseEntity(p.vehicle):OnUp()
	end
end

function OnHeliDown(e)
	local p = game.players[e.player_index]
	if p.driving and p.vehicle.name == "heli-entity-_-" then
		getHeliFromBaseEntity(p.vehicle):OnDown()
	end
end

--script.on_event(defines.events.on_player_driving_changed_state, onDrivingStateChanged)

script.on_event(defines.events.on_built_entity, OnBuilt)
script.on_event(defines.events.on_robot_built_entity, OnBuilt)

script.on_load(OnLoad)
script.on_event(defines.events.on_tick, OnTick)

script.on_event(defines.events.on_player_mined_entity, OnRemoved)
script.on_event(defines.events.on_robot_mined_entity, OnRemoved)
script.on_event(defines.events.on_entity_died, OnRemoved)

script.on_event("heli-up", OnHeliUp)
script.on_event("heli-down", OnHeliDown)