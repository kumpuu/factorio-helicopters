require ("logic.heli")
require ("logic.heliPad")
require ("logic.util")
require ("logic.heliController")
require ("logic.gui.remoteGui")

function OnLoad(e)
	setMetatablesInGlobal("helis", heli)
	setMetatablesInGlobal("remoteGuis", remoteGui)
	setMetatablesInGlobal("heliPads", heliPad)
end

function OnTick(e)
	checkAndTickInGlobal("helis")
	checkAndTickInGlobal("remoteGuis")
	checkAndTickInGlobal("heliControllers")
end

function OnBuilt(e)
	local ent = e.created_entity

	if ent.name == "heli-placement-entity-_-" then
		local newHeli = insertInGlobal("helis", heli.new(ent))
		callInGlobal("helis", "OnHeliBuilt", newHeli)

	elseif ent.name == "heli-pad-placement-entity" then
		local newPad = insertInGlobal("heliPads", heliPad.new(ent)) 
		callInGlobal("remoteGuis", "OnHeliPadBuilt", newPad)
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
					
					callInGlobal("remoteGuis", "OnHeliRemoved", val)
				end
			end
		end
	end

	if ent.name == "heli-pad-entity" then
		local i = getHeliPadIndexFromBaseEntity(ent)
		if i then
			global.heliPads[i]:destroy()

			callInGlobal("remoteGuis", "OnHeliPadRemoved", global.heliPads[i])
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

function OnGuiClick(e)
	printA(e.element.name)
	local name = e.element.name

	if name:match("^heli_") then
		local p = game.players[e.player_index]
		local i = searchIndexInTable(global.remoteGuis, p, "player")
		
		if name == "heli_remote_btn" then
			if not global.remoteGuis then global.remoteGuis = {} end

			if not i then
				table.insert(global.remoteGuis, remoteGui.new(p))
			else
				global.remoteGuis[i]:destroy()
				table.remove(global.remoteGuis, i)
			end
		
		else
			global.remoteGuis[i]:OnGuiClick(e)
		end
	end
end

function OnPlayerChangedForce(e)
	local gui = searchInTable(global.remoteGuis, game.players[e.player_index], "player")
	if gui then 
		gui:OnPlayerChangedForce(e)
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

script.on_event(defines.events.on_player_changed_force, OnPlayerChangedForce)