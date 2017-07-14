require ("logic.heli")
require ("logic.heliPad")
require ("logic.util")
require ("logic.heliController")
require ("logic.gui.remoteGui")

function setMetatables(name, mt)
	if global[name] then
		for k, v in pairs(global[name]) do
			setmetatable(v, {__index = mt})
		end
	end
end

function checkAndTick(name)
	if global[name] then
		for i, v in ipairs(global[name]) do
			if v.valid then
				v:OnTick()
			else
				table.remove(global[name], i)
			end
		end
	end
end



function OnLoad(e)
	setMetatables("helis", heli)
	setMetatables("remoteGuis", remoteGui)
	setMetatables("heliPads", heliPad)
end

function OnTick(e)
	checkAndTick("helis")
	checkAndTick("remoteGuis")
	checkAndTick("heliControllers")
end

function OnBuilt(e)
	local ent = e.created_entity

	if ent.name == "heli-placement-entity-_-" then
		if not global.helis then global.helis = {} end
		local newHeli = heli.new(ent)
		table.insert(global.helis, newHeli)

		if global.remoteGuis then
			for k, curRemote in pairs(global.remoteGuis) do
				curRemote:OnHeliBuilt(newHeli)
			end
		end

	elseif ent.name == "heli-pad-placement-entity" then
		if not global.heliPads then global.heliPads = {} end
		table.insert(global.heliPads, heliPad.new(ent))
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
					
					if global.remoteGuis then
						for k, curRemote in pairs(global.remoteGuis) do
							curRemote:OnHeliRemoved(val)
						end
					end
				end
			end
		end
	end

	if ent.name == "heli-pad-entity" then
		local i = getHeliPadIndexFromBaseEntity(ent)
		if i then
			global.heliPads[i]:destroy()
			table.remove(global.heliPads, i)
		end
	end
end

function OnHeliUp(e)
	local p = game.players[e.player_index]
	if p.driving and p.vehicle.name == "heli-entity-_-" then
		getHeliFromBaseEntity(p.vehicle):OnUp()
	end
	OnPlayerPlacedRemote(e)
end

function OnHeliDown(e)
	local p = game.players[e.player_index]
	if p.driving and p.vehicle.name == "heli-entity-_-" then
		getHeliFromBaseEntity(p.vehicle):OnDown()
	end
end

function OnPlacedEquipment(e)
	if e.equipment.name == "heli-remote-equipment" then
		OnPlayerPlacedRemote(e)
	end
end

function OnRemovedEquipment(e)
	if e.equipment == "heli-remote-equipment" then
		OnPlayerRemovedRemote(e)
	end
end

script.on_event(defines.events.on_built_entity, OnBuilt)
script.on_event(defines.events.on_robot_built_entity, OnBuilt)

script.on_load(OnLoad)
script.on_event(defines.events.on_tick, OnTick)

script.on_event(defines.events.on_player_mined_entity, OnRemoved)
script.on_event(defines.events.on_robot_mined_entity, OnRemoved)
script.on_event(defines.events.on_entity_died, OnRemoved)

script.on_event("heli-up", OnHeliUp)
script.on_event("heli-down", OnHeliDown)


script.on_event(defines.events.on_player_placed_equipment, OnPlacedEquipment)
script.on_event(defines.events.on_player_removed_equipment, OnRemovedEquipment)
script.on_event(defines.events.on_gui_click, OnGuiClick)
