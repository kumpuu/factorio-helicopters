playerSelectionGui =
{
	prefix = "heli_playerSelectionGui_",

	new = function(mgr, p)
		obj = 
		{
			valid = true,
			manager = mgr,
			player = p,

			guiElems = 
			{
				parent = p.gui.left,
			},
		}

		for k,v in pairs(playerSelectionGui) do
			obj[k] = v
		end

		obj:buildGui()

		return obj
	end,

	destroy = function(self)
		self.valid = false
	
		if self.guiElems.root and self.guiElems.root.valid then
			self.guiElems.root.destroy()
		end
	end,

	OnGuiClick = function(self, e)
		local name = e.element.name

		if name:match("^" .. self.prefix .. "btn_.+$") then
			self.manager:OnChildEvent(self, "selectedPosition", searchInTable(self.guiElems.btns, e.element, "btn").player.position)

		elseif name == self.prefix .. "rootFrame" and e.button == defines.mouse_button_type.right then
			self.manager:OnChildEvent(self, "cancel")
		end
	end,

	OnPlayerDied = function(self, player)
		self:removeBtnByPlayer(player)
	end,

	OnPlayerLeftGame = function(self, player)
		self:removeBtnByPlayer(player)
	end,

	OnPlayerRespawned = function(self, player)
		if player.force == self.player.force then
			table.insert(self.guiElems.btns, self:buildBtnFromPlayer(self.guiElems.flow, player))
		end
	end,

	OnPlayerChangedForce = function(self, player)
		if player == self.player then
			self.guiElems.root.destroy()
			self.guiElems = {parent = self.guiElems.parent}
			self:buildGui()
		else
			self:removeBtnByPlayer(player)
		end
	end,

	removeBtnByPlayer = function(self, player)
		local i = searchIndexInTable(self.guiElems.btns, player, "player")
		if i then
			self.guiElems.btns[i].btn.destroy()
			table.remove(self.guiElems.btns, i)
		end
	end,

	buildBtnFromPlayer = function(self, parent, player)
		local btn = parent.add
		{
			type = "button",
			name = self.prefix .. "btn_" .. player.name,
			style = "listbox_button_style",
			caption = player.name,
		}
		btn.style.minimal_width = 290

		return {
			btn = btn,
			player = player,
		}
	end,

	buildGui = function(self)
		local els = self.guiElems

		els.root = els.parent.add
		{
			type = "frame",
			name = self.prefix .. "rootFrame",
			caption = "Select player to fly to",
			style = "frame_style",
		}

		els.scroller = els.root.add
		{
			type = "scroll-pane",
			name = self.prefix .. "scroller",
		}

		els.scroller.style.maximal_width = 1000
		els.scroller.style.maximal_height = 600

		els.flow = els.scroller.add
		{
			type = "flow",
			name = self.prefix .. "flow",
			style = "achievements_flow_style",
			direction = "vertical",
		}

		els.btns = {}
		for i, curPlayer in pairs(game.connected_players) do
			if curPlayer.controller_type == defines.controllers.character and curPlayer.character then
				table.insert(els.btns, self:buildBtnFromPlayer(els.flow, curPlayer))
			end
		end
		
	end,
}