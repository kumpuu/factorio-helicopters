require("mod-gui")

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



local camStyle = 
{
	minimal_width = 207,
	minimal_height = 207,
}

local tableStyle =
{
	horizontal_spacing = 10,
	vertical_spacing = 10,
}

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
}



heliSelectionGui =
{
	prefix = "heli_heliSelectionGui_",

	new = function(p)
		obj = 
		{
			valid = true,
			player = p,

			guiElems = 
			{
				parent = p.gui.left,
			},

			curCamID = 0,
		}

		for k,v in pairs(heliSelectionGui) do
			obj[k] = v
		end

		obj:buildGui()

		return obj
	end,

	destroy = function(self)
		self.valid = false
	
		if self.guiElems.root then
			self.guiElems.root.destroy()
		end
	end,

	OnTick = function(self)
		self:updateCamPositions()
	end,

	OnGuiClick = function(self, e)
		local name = e.element.name

		if name:match("^" .. self.prefix .. "cam_%d+$") then
			self:OnCamClicked(e)
		
		elseif name == self.prefix .. "btn_toPlayer" then
			if self.selectedCam then
				if not global.heliControllers then global.heliControllers = {} end
				table.insert(global.heliControllers, heliController.new(self.player, self.selectedCam.heli, self.player.position))
			end
		end
	end,

	OnHeliBuilt = function(self, heli)
		local flow, selectionBox, cam = self:buildCam(self.guiElems.camTable, self.curCamID, false, heli.baseEnt.position, 0.3)

		table.insert(self.guiElems.cams,
		{
			flow = flow,
			selectionBox = selectionBox,
			cam = cam,
			heli = heli,
			ID = self.curCamID,
		})

		self.curCamID = self.curCamID + 1
	end,

	OnHeliRemoved = function(self, heli)
		for i, curCam in ipairs(self.guiElems.cams) do
			if curCam.heli == heli then
				if curCam == self.selectedCam then
					self.selectedCam = nil
				end

				curCam.flow.destroy()
				table.remove(self.guiElems.cams, i)
				break
			end
		end
	end,

	OnCamClicked = function(self, e)
		local p = game.players[e.player_index]
		local camID = tonumber(e.element.name:match("%d+"))

		if e.button == defines.mouse_button_type.left then
			self:setCamSelected(self.guiElems.cams[self:getCamIndexById(camID)], true)

		elseif e.button == defines.mouse_button_type.right then
			local zoomMax = 1.26
			local zoomMin = 0.2
			local zoomDelta = 0.333

			if e.shift then
				e.element.zoom = e.element.zoom * (1 - zoomDelta)
				if e.element.zoom < zoomMin then
					e.element.zoom = zoomMax
				end
			else
				e.element.zoom = e.element.zoom * (1 + zoomDelta)
				if e.element.zoom > zoomMax then
					e.element.zoom = zoomMin
				end
			end
		end
	end,

	getCamIndexById = function(self, ID)
		for i, curCam in ipairs(self.guiElems.cams) do
			if curCam.ID == ID then return i end
		end
	end,

	updateCamPositions = function(self)
		for k, curCam in pairs(self.guiElems.cams) do
			curCam.cam.position = curCam.heli.baseEnt.position
		end
	end,

	setCamSelected = function(self, cam, isSelected)
		local flow = cam.flow

		local pos = cam.cam.position
		local zoom = cam.cam.zoom

		flow.clear()

		cam.selectionBox, cam.cam = self:buildCamInner(flow, cam.ID, isSelected, pos, zoom)

		if isSelected then
			if self.selectedCam and self.selectedCam ~= cam then
				self:setCamSelected(self.selectedCam, false)
			end
			self.selectedCam = cam
		else
			if self.selectedCam and self.selectedCam == cam then
				self.selectedCam = nil
			end
		end
	end,

	buildCamInner = function(self, parent, ID, isSelected, position, zoom)
		local sprite = ""
		if isSelected then
			sprite = "heli_gui_selected"
		end

		local selectionBox = parent.add
		{
			type = "sprite",
			name = self.prefix .. "camBox_" .. tostring(ID),
			sprite = sprite,
		}
		selectionBox.style.minimal_width = 214
		selectionBox.style.minimal_height = 214
		selectionBox.style.maximal_width = 214
		selectionBox.style.maximal_height = 214


			local cam = selectionBox.add
			{
				type = "camera",
				name = self.prefix .. "cam_" .. tostring(ID),
				position = position,
				zoom = zoom,
			}
			cam.style.top_padding = 7
			cam.style.left_padding = 7

			applyStyle(cam, camStyle)

		return selectionBox, cam
	end,

	buildCam = function(self, parent, ID, isSelected, position, zoom)
		local flow = parent.add
		{
			type = "flow",
			name = self.prefix .. "camFlow_" .. tostring(ID),
		}

		flow.style.minimal_width = 214
		flow.style.minimal_height = 214
		flow.style.maximal_width = 214
		flow.style.maximal_height = 214

		return flow, self:buildCamInner(flow, ID, isSelected, position, zoom)
	end,

	buildGui = function(self, selectedIndex)
		local p = self.player
		local els = self.guiElems

		--if els.parent.heli_remote_frame then
		--	self:destroyGui()
		--end

		els.root = els.parent.add
		{
			type = "frame",
			name = self.prefix .. "rootFrame",
			caption = "Helicopter remote control",
			style = "frame_style",
			direction = "vertical",
		}

		els.root.style.maximal_width = 1000
		els.root.style.maximal_height = 700

			els.buttonFlow = els.root.add
			{
				type = "flow",
				name = self.prefix .. "btnFlow",
			}
			els.buttonFlow.style.left_padding = 7

				els.btnToPlayer = els.buttonFlow.add
				{
					type = "sprite-button",
					name = self.prefix .. "btn_toPlayer",
					sprite = "heli_to_player",
					style = mod_gui.button_style,
				}

				els.btnToMap = els.buttonFlow.add
				{
					type = "sprite-button",
					name = self.prefix .. "btn_toMap",
					sprite = "heli_to_map",
					style = mod_gui.button_style,
				}

				els.btnToPad = els.buttonFlow.add
				{
					type = "sprite-button",
					name = self.prefix .. "btn_toPad",
					sprite = "heli_to_pad",
					style = mod_gui.button_style,
				}

				els.btnStop = els.buttonFlow.add
				{
					type = "sprite-button",
					name = self.prefix .. "btn_Stop",
					sprite = "heli_stop",
					style = mod_gui.button_style,
				}

			els.scrollPane = els.root.add
			{
				type = "scroll-pane",
				name = self.prefix .. "scroller",
			}

			els.scrollPane.style.maximal_width = 1000
			els.scrollPane.style.maximal_height = 600

				els.camTable = els.scrollPane.add
				{
					type = "table",
					name = self.prefix .. "camTable",
					colspan = 4,
				}
				applyStyle(els.camTable, tableStyle)

					els.cams ={}
					self.curCamID = 0
					for k,v in pairs(global.helis) do
						if v.baseEnt.force == self.player.force and (v.baseEnt.passenger == nil or v.baseEnt.passenger == self.player) then

							local flow, selectionBox, cam = self:buildCam(els.camTable, self.curCamID, false, v.baseEnt.position, 0.3)

							table.insert(els.cams,
							{
								flow = flow,
								selectionBox = selectionBox,
								cam = cam,
								heli = v,
								ID = self.curCamID,
							})

							self.curCamID = self.curCamID + 1
						end
					end
	end,
}