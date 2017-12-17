math3d = require("math3d")

require("logic.util")

require("logic.heliBase")
require("logic.heliAttack")

require("logic.heliPad")
require("logic.heliController")
require("logic.gui.remoteGui")

function playerIsInHeli(p)
	return p.driving and string.find(heliBaseEntityNames, p.vehicle.name .. ",", 1, true)
end

function OnLoad(e)
	if global.helis then
		for k, curHeli in pairs(global.helis) do
			if not curHeli.type or curHeli.type == "heliAttack" then
				setmetatable(curHeli, {__index = heliAttack})
			end
		end
	end

	setMetatablesInGlobal("remoteGuis", remoteGui.mt)
	setMetatablesInGlobal("heliPads", {__index = heliPad})
	setMetatablesInGlobal("heliControllers", {__index = heliController})

	callInGlobal("helis", "OnLoad")
end

function OnConfigChanged(e)
	if global.helis then
		for k, curHeli in pairs(global.helis) do
			if not curHeli.curState then
				if curHeli.goUp then
					curHeli:changeState(curHeli.engineStarting)
				else
					curHeli:changeState(curHeli.descend)
				end
			end

			if not curHeli.surface then
				curHeli.surface = curHeli.baseEnt.surface
			end

			if not curHeli.type then
				curHeli.type = "heliAttack"
			end

			if curHeli.hasLandedCollider and not curHeli.childs.collisionEnt.valid then
				curHeli:setCollider("landed")
			end
		end
	end

	if global.heliPads then
		for k, curPad in pairs(global.heliPads) do
			if not curPad.surface then
				curPad.surface = curPad.baseEnt.surface
			end
		end
	end

	for k, p in pairs(game.players) do
		OnArmorInventoryChanged({player_index = p.index})
	end
end

function OnTick(e)
	checkAndTickInGlobal("helis")
	checkAndTickInGlobal("remoteGuis")
	checkAndTickInGlobal("heliControllers")
end

function OnBuilt(e)
	local ent = e.created_entity

	if ent.name == "heli-placement-entity-_-" then
		local newHeli = insertInGlobal("helis", heliAttack.new(ent))
		callInGlobal("remoteGuis", "OnHeliBuilt", newHeli)

	elseif ent.name == "heli-pad-placement-entity" then
		local newPad = insertInGlobal("heliPads", heliPad.new(ent)) 
		callInGlobal("remoteGuis", "OnHeliPadBuilt", newPad)
	end
end

function OnRemoved(e)
	local ent = e.entity

	if ent.valid then
		local entName = ent.name

		if string.find(heliEntityNames, entName .. ",", 1, true) then
			for i,val in ipairs(global.helis) do
				if val:isBaseOrChild(ent) then
					val:destroy()
					table.remove(global.helis, i)
					
					callInGlobal("remoteGuis", "OnHeliRemoved", val)
				end
			end
		end

		if entName == "heli-pad-entity" then
			local i = getHeliPadIndexFromBaseEntity(ent)
			if i then
				global.heliPads[i]:destroy()

				callInGlobal("remoteGuis", "OnHeliPadRemoved", global.heliPads[i])
				table.remove(global.heliPads, i)
			end
		end
	end
end

function OnHeliUp(e)
	local p = game.players[e.player_index]
	if playerIsInHeli(p) then
		getHeliFromBaseEntity(p.vehicle):OnUp()
	end
end

function OnHeliDown(e)
	local p = game.players[e.player_index]
	if playerIsInHeli(p) then
		getHeliFromBaseEntity(p.vehicle):OnDown()
	end
end

function OnHeliIncreaseMaxHeight(e)
	local p = game.players[e.player_index]
	if playerIsInHeli(p) then
		getHeliFromBaseEntity(p.vehicle):OnIncreaseMaxHeight()
	end
end

function OnHeliDecreaseMaxHeight(e)
	local p = game.players[e.player_index]
	if playerIsInHeli(p) then
		getHeliFromBaseEntity(p.vehicle):OnDecreaseMaxHeight()
	end
end

function OnHeliToggleFloodlight(e)
	local p = game.players[e.player_index]
	if playerIsInHeli(p) then
		getHeliFromBaseEntity(p.vehicle):OnToggleFloodlight()
	end
end

function OnPlacedEquipment(e)
	if e.equipment.name == "heli-remote-equipment" then
		local p = game.players[e.player_index]

		setRemoteBtn(p, true)
	end
end

function OnRemovedEquipment(e)
	if e.equipment == "heli-remote-equipment" then
		local p = game.players[e.player_index]

		if not equipmentGridHasItem(e.grid, "heli-remote-equipment") then
			setRemoteBtn(p, false)
		end
	end
end

function OnArmorInventoryChanged(e)
	local p = game.players[e.player_index]

	if p.character and p.character.valid and
		p.character.grid and p.character.grid.valid and
			equipmentGridHasItem(p.character.grid, "heli-remote-equipment") then

		setRemoteBtn(p, true)
	else
		setRemoteBtn(p, false)
	end
end

function OnGuiClick(e)
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
			if i then
				global.remoteGuis[i]:OnGuiClick(e)
			end
		end
	end
end

function OnPlayerChangedForce(e)
	local p = game.players[e.player_index]
	
	callInGlobal("remoteGuis", "OnPlayerChangedForce", p)
end

function OnPlayerDied(e)
	local p = game.players[e.player_index]
	
	setRemoteBtn(p, false)

	callInGlobal("remoteGuis", "OnPlayerDied", p)
end

function OnPlayerLeft(e)
	local p = game.players[e.player_index]
	local i = searchIndexInTable(global.remoteGuis, p, "player")

	if i then
		global.remoteGuis[i]:destroy()
		table.remove(global.remoteGuis, i)
	end

	callInGlobal("remoteGuis", "OnPlayerLeft", p)
end

function OnPlayerRespawned(e)
	callInGlobal("remoteGuis", "OnPlayerRespawned", game.players[e.player_index])
end

function OnDrivingStateChanged(e)
	local p = game.players[e.player_index]
	local ent = e.entity
	local entName = ent.name

	if not p.driving and string.find(heliEntityNames, entName .. ",", 1, true) then
		for i,val in ipairs(global.helis) do
			if val:isBaseOrChild(ent) then
				val:OnPlayerEjected(p)
			end
		end
	end
end

function OnPlayerJoined(e)
	OnArmorInventoryChanged(e)
end

function OnPlayerCreated(e)
	OnArmorInventoryChanged(e)
end

script.on_event(defines.events.on_built_entity, OnBuilt)
script.on_event(defines.events.on_robot_built_entity, OnBuilt)

script.on_load(OnLoad)
script.on_configuration_changed(OnConfigChanged)
script.on_event(defines.events.on_tick, OnTick)

script.on_event(defines.events.on_player_mined_entity, OnRemoved)
script.on_event(defines.events.on_robot_mined_entity, OnRemoved)
script.on_event(defines.events.on_entity_died, OnRemoved)

script.on_event("heli-up", OnHeliUp)
script.on_event("heli-down", OnHeliDown)
script.on_event("heli-zaa-height-increase", OnHeliIncreaseMaxHeight)
script.on_event("heli-zab-height-decrease", OnHeliDecreaseMaxHeight)
script.on_event("heli-zba-toogle-floodlight", OnHeliToggleFloodlight)


script.on_event(defines.events.on_player_placed_equipment, OnPlacedEquipment)
script.on_event(defines.events.on_player_removed_equipment, OnRemovedEquipment)
script.on_event(defines.events.on_gui_click, OnGuiClick)

script.on_event(defines.events.on_player_changed_force, OnPlayerChangedForce)
script.on_event(defines.events.on_player_died, OnPlayerDied)
script.on_event(defines.events.on_player_left_game, OnPlayerLeft)
script.on_event(defines.events.on_player_respawned, OnPlayerRespawned)
script.on_event(defines.events.on_player_joined_game, OnPlayerJoined)
script.on_event(defines.events.on_player_created, OnPlayerCreated)

script.on_event(defines.events.on_player_armor_inventory_changed, OnArmorInventoryChanged)
script.on_event(defines.events.on_player_driving_changed_state, OnDrivingStateChanged)