require("mod-gui")
require("logic.gui.heliSelectionGui")
require("logic.gui.playerSelectionGui")
require("logic.gui.markerSelectionGui")
require("logic.gui.heliPadSelectionGui")

function setRemoteBtn(p, show)
	local flow = mod_gui.get_button_flow(p)

	if show and not flow.heli_remote_btn then
		flow.add
		{
			type = "sprite-button",
			name = "heli_remote_btn",
			sprite = "item/heli-remote-equipment",
			style = mod_gui.button_style,
			tooltip = {"heli-gui-remote-btn-tt"},
		}

	elseif (not show) and flow.heli_remote_btn and flow.heli_remote_btn.valid then
		flow.heli_remote_btn.destroy()

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
	mt = 
	{
		__index = function(t, k)
			if remoteGui[k] then
				return remoteGui[k]

			elseif type(k) == "string" and k:match("^On.+") then
				return function(self, ...)
					remoteGui.safeStateCall(self, k, ...)
				end
			end
		end,
	},

	new = function(p)
		local obj = {
			valid = true,

			player = p,

			guis = {}
		}

		setmetatable(obj, remoteGui.mt)
	
		obj.guis.heliSelection = heliSelectionGui.new(obj, p)
		return obj
	end,

	destroy = function(self)
		self.valid = false
		for k, curGui in pairs(self.guis) do
			if curGui.valid then
				curGui:destroy()
			end
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

	OnGuiTextChanged = function(self, e)
		local name = e.element.name

		for k, curGui in pairs(self.guis) do
			if name:match("^" .. curGui.prefix .. ".+") and curGui.OnGuiTextChanged then
				curGui:OnGuiTextChanged(e)
			end
		end
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
		
		elseif evtName == "selectedPlayer" then
			local p = ...
			local heli = self.guis.heliSelection.selectedCam.heli

			local oldControllerIndex = searchIndexInTable(global.heliControllers, heli, "heli")
			if oldControllerIndex then
				global.heliControllers[oldControllerIndex]:destroy()
				table.remove(global.heliControllers, oldControllerIndex)
			end

			insertInGlobal("heliControllers", heliController.new(self.player, self.guis.heliSelection.selectedCam.heli, p, true))

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

		elseif evtName == "cancel" then
			if child == self.guis.heliSelection then
				self:destroy()
				removeInGlobal("remoteGuis", self)
			else
				child:destroy()
				self.guis.targetSelection = nil
				self.guis.heliSelection:setVisible(true)
			end
		end
	end,
}