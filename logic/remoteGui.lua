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
		if name == "heli_remote_btn" then
			if not global.remoteGuis then global.remoteGuis = {} end

			local i = getRemoteGuiIndexByPlayer(p)
			if not i then
				table.insert(global.remoteGuis, remoteGui.new(p))
			else
				global.remoteGuis[i]:destroy()
				table.remove(global.remoteGuis, i)
			end
		
		elseif name:match("^heli_cam_%d+$") then
			getRemoteGuiByPlayer(p):OnHeliCamClicked(e)
		
		elseif name == "heli_btn_to_player" then
			local gui = getRemoteGuiByPlayer(p)
			local heli = gui.selectedHeli

			if heli then
				if not global.heliControllers then global.heliControllers = {} end
				table.insert(global.heliControllers, heliController.new(p, heli, p.position))
			end
		end
	end
end



remoteGui = 
{
	new = function(p)
		local obj = {
			valid = true,

			player = p,
			force = p.force,
			selectedHeli = nil,
			trackedHelis = {},
		}

		setmetatable(obj, {__index = remoteGui})
		obj:rebuildGui()
		return obj
	end,

	destroy = function(self)
		self.valid = false
		self:destroyGui()
	end,

	OnTick = function(self)
		if not self.player.valid then
			self:destroy()
		elseif self.player.force ~= self.force then
			self.force = self.player.force
			self.selectedHeli = nil
			self:rebuildGui()
		else
			self:updateCamPositions()
		end
	end,

	OnHeliCamClicked = function(self, e)
		local p = game.players[e.player_index]
		local camNo = tonumber(e.element.name:match("%d+"))

		if e.button == defines.mouse_button_type.left then
			--self:rebuildGui(camNo)
			local flow = self.player.gui.center.heli_remote_frame.heli_scroller.heli_cam_table["heli_cam_flow_" .. tostring(camNo)]
			local cam = flow["heli_cam_box_" .. tostring(camNo)]["heli_cam_" .. tostring(camNo)]

			local pos = cam.position
			local zoom = cam.zoom

			flow.clear()

			local selectionBox = flow.add
			{
				type = "sprite",
				name = "heli_cam_box_" .. tostring(camNo),
				sprite = "heli_gui_selected",
			}
			selectionBox.style.minimal_width = 214
			selectionBox.style.minimal_height = 214
			selectionBox.style.maximal_width = 214
			selectionBox.style.maximal_height = 214


				local cam = selectionBox.add
				{
					type = "camera",
					name = "heli_cam_" .. tostring(camNo),
					position = pos,
					zoom = zoom,
				}
				cam.style.top_padding = 7
				cam.style.left_padding = 7

				applyStyle(cam, camStyle)

			self.selectedHeli = self.trackedHelis[camNo]

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

	OnHeliBuilt = function(self, heli)
		self:rebuildGui()
	end,

	OnHeliRemoved = function(self, heli)
		if heli == self.selectedHeli then
			self.selectedHeli = nil
		end
		self:rebuildGui()
	end,

	updateCamPositions = function(self)
		for i, curHeli in ipairs(self.trackedHelis) do
			self.player.gui.center.heli_remote_frame.heli_scroller.heli_cam_table["heli_cam_flow_" .. tostring(i)]["heli_cam_box_" .. tostring(i)]["heli_cam_" .. tostring(i)].position = curHeli.baseEnt.position
		end
	end,

	rebuildGui = function(self, selectedIndex)
		local p = self.player

		if p.gui.center.heli_remote_frame then
			self:destroyGui()
		end

		local frame = p.gui.center.add
		{
			type = "frame",
			name = "heli_remote_frame",
			caption = "Helicopter remote control",
			style = "frame_style",
			direction = "vertical",
		}

		frame.style.maximal_width = 1000
		frame.style.maximal_height = 700

			local buttonFlow = frame.add
			{
				type = "flow",
				name = "heli_btn_flow",
			}
			buttonFlow.style.left_padding = 7

				local btnToPlayer = buttonFlow.add
				{
					type = "sprite-button",
					name = "heli_btn_to_player",
					sprite = "heli_to_player",
					style = mod_gui.button_style,
				}

				local btnToMap = buttonFlow.add
				{
					type = "sprite-button",
					name = "heli_btn_to_map",
					sprite = "heli_to_map",
					style = mod_gui.button_style,
				}

				local btnToPad = buttonFlow.add
				{
					type = "sprite-button",
					name = "heli_btn_to_pad",
					sprite = "heli_to_pad",
					style = mod_gui.button_style,
				}

				local btnStop = buttonFlow.add
				{
					type = "sprite-button",
					name = "heli_btn_stop",
					sprite = "heli_stop",
					style = mod_gui.button_style,
				}

			local scrollPane = frame.add
			{
				type = "scroll-pane",
				name = "heli_scroller",
			}

			scrollPane.style.maximal_width = 1000
			scrollPane.style.maximal_height = 600

				local camTable = scrollPane.add
				{
					type = "table",
					name = "heli_cam_table",
					colspan = 4,
				}
				applyStyle(camTable, tableStyle)


					self.trackedHelis = {}
					local i = 1
					for k,v in pairs(global.helis) do
						if v.baseEnt.force == self.force and (v.baseEnt.passenger == nil or v.baseEnt.passenger == self.player) then
							sprite = ""
							if selectedIndex and i == selectedIndex then
								self.selectedHeli = v
								sprite = "heli_gui_selected"
							end
							table.insert(self.trackedHelis, v)

							local flow = camTable.add
							{
								type = "flow",
								name = "heli_cam_flow_" .. tostring(i),
							}

							flow.style.minimal_width = 214
							flow.style.minimal_height = 214
							flow.style.maximal_width = 214
							flow.style.maximal_height = 214

								local selectionBox = flow.add
								{
									type = "sprite",
									name = "heli_cam_box_" .. tostring(i),
									sprite = sprite,
									--style = mod_gui.button_style,
								}
								selectionBox.style.minimal_width = 214
								selectionBox.style.minimal_height = 214
								selectionBox.style.maximal_width = 214
								selectionBox.style.maximal_height = 214


									local cam = selectionBox.add
									{
										type = "camera",
										name = "heli_cam_" .. tostring(i),
										position = v.baseEnt.position,
										zoom = 0.3,
									}
									cam.style.top_padding = 7
									cam.style.left_padding = 7

									applyStyle(cam, camStyle)

							i = i + 1
						end
					end
	end,

	destroyGui = function(self)
		if self.player.gui.center.heli_remote_frame then
			self.player.gui.center.heli_remote_frame.destroy()
		end
	end,
}