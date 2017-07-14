require("mod-gui")
require("logic.gui.heliSelectionGui")

function getRemoteGuiIndexByPlayer(p)
	if global.remoteGuis then
		for i, curGui in ipairs(global.remoteGuis) do
			if curGui.player == p then return i end
		end
	end
end

function getRemoteGuiByPlayer(p)
	local i = getRemoteGuiIndexByPlayer(p)
	if i then return global.remoteGuis[i] end
end

function applyStyle(guiElem, style)
	for k,v in pairs(style) do
		guiElem.style[k] = v
	end
end

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

		local i = getRemoteGuiIndexByPlayer(p)
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

function OnGuiClick(e)
	local p = game.players[e.player_index]

	p.print(e.element.name)
	local name = e.element.name

	if name:match("^heli_") then
		local i = getRemoteGuiIndexByPlayer(p)
		
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



remoteGui = 
{
	new = function(p)
		local obj = {
			valid = true,

			player = p,

			curState = heliSelectionGui.new(p)
		}

		setmetatable(obj, {__index = remoteGui})
		return obj
	end,

	destroy = function(self)
		self.valid = false
		self.curState:destroy()
	end,

	safeStateCall = function(self, k, ...)
		if self.curState[k] then
			self.curState[k](self.curState, ...)
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

		if name:match("^" .. self.curState.prefix .. ".+") then
			self:safeStateCall("OnGuiClick", e)
		end
	end,

	OnHeliBuilt = function(self, heli)
		self:safeStateCall("OnHeliBuilt", heli)
	end,

	OnHeliRemoved = function(self, heli)
		self:safeStateCall("OnHeliRemoved", heli)
	end,

	OnHeliControllerCreated = function(self, controller)
		self:safeStateCall("OnHeliControllerCreated", controller)
	end,

	OnHeliControllerDestroyed = function(self, controller)
		self:safeStateCall("OnHeliControllerDestroyed", controller)
	end,
}