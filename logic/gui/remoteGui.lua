require("mod-gui")
require("logic.gui.heliSelectionGui")
require("logic.gui.playerSelectionGui")
require("logic.gui.markerSelectionGui")
require("logic.gui.heliPadSelectionGui")

function OnPlayerPlacedRemote(e)
	local p = game.players[e.player_index]

	if not mod_gui.get_button_flow(p).heli_remote_btn then
		mod_gui.get_button_flow(p).add
		{
			type = "sprite-button",
			name = "heli_remote_btn",
			sprite = "item/heli-remote-equipment",
			style = mod_gui.button_style,
		}
	end
end

function OnPlayerRemovedRemote(e)
	if not equipmentGridHasItem(e.grid, "heli-remote-equipment") then
		local p = game.players[e.player_index]
		local flow = mod_gui.get_button_flow(p)

		if flow.heli_remote_btn then
			flow.heli_remote_btn.destroy()
		end

		local i = searchIndexInTable(global.remoteGuis, p, "player")
		if i then
			global.remoteGuis[i]:destroy()
			table.remove(global.remoteGuis, i)
		end
	end
end

function OnHeliControllerCreated(controller)
	callInGlobal("remoteGuis", "OnHeliControllerCreated", controller)
end

function OnHeliControllerDestroyed(controller)
	callInGlobal("remoteGuis", "OnHeliControllerDestroyed", controller)
end


remoteGui = 
{
	new = function(p)
		local obj = {
			valid = true,

			player = p,

			guis = {}
		}

		setmetatable(obj, {__index = remoteGui})
	
		obj.guis.heliSelection = heliSelectionGui.new(obj, p)
		return obj
	end,

	destroy = function(self)
		self.valid = false
		for k, curGui in pairs(self.guis) do
			curGui:destroy()
		end
	end,

	safeStateCall = function(self, kName, ...)
		for k, curGui in pairs(self.guis) do
			if curGui[kName] then
				curGui[kName](curGui, ...)
			end
		end
	end,

	OnTick = function(self)
		if not self.player.valid then
			self:destroy()
		else
			self:safeStateCall("OnTick")
		end
	end,

	OnGuiClick = function(self, e)
		local name = e.element.name

		for k, curGui in pairs(self.guis) do
			if name:match("^" .. curGui.prefix .. ".+") and curGui.OnGuiClick then
				curGui:OnGuiClick(e)
			end
		end
	end,

	OnPlayerChangedForce = function(self, e)
		self:safeStateCall("OnPlayerChangedForce", e)
	end,

	OnChildEvent = function(self, child, evtName, ...)
		if evtName == "showTargetSelectionGui" then
			local prot = ...
			self.guis.heliSelection:setVisible(false)
			self.guis.targetSelection = prot.new(self, self.player)

		elseif evtName == "selectedPosition" then
			local pos = ...
			local heli = self.guis.heliSelection.selectedCam.heli

			local oldControllerIndex = searchIndexInTable(global.heliControllers, heli, "heli")
			if oldControllerIndex then
				global.heliControllers[oldControllerIndex]:destroy()
				table.remove(global.heliControllers, oldControllerIndex)
			end

			insertInGlobal("heliControllers", heliController.new(self.player, self.guis.heliSelection.selectedCam.heli, pos))

			if child ~= self.guis.heliSelection then
				child:destroy()
				self.guis.targetSelection = nil
			end
			self.guis.heliSelection:setVisible(true)
		
		elseif evtName == "OnSelectedHeliIsInvalid" then
			if self.guis.targetSelection then
				self.guis.targetSelection:destroy()
				self.guis.heliSelection:setVisible(true)
			end
		end
	end,

	OnHeliBuilt = function(self, heli)
		self:safeStateCall("OnHeliBuilt", heli)
	end,

	OnHeliRemoved = function(self, heli)
		self:safeStateCall("OnHeliRemoved", heli)
	end,

	OnHeliPadBuilt = function(self, heli)
		self:safeStateCall("OnHeliPadBuilt", heli)
	end,

	OnHeliPadRemoved = function(self, heli)
		self:safeStateCall("OnHeliPadRemoved", heli)
	end,

	OnHeliControllerCreated = function(self, controller)
		self:safeStateCall("OnHeliControllerCreated", controller)
	end,

	OnHeliControllerDestroyed = function(self, controller)
		self:safeStateCall("OnHeliControllerDestroyed", controller)
	end,
}