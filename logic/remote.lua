require("mod-gui")

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

function equipmentGridHasItem(grid, itemName)
	local contents = grid.get_contents()
	return contents[itemName] and contents[itemName] > 0
end


remoteGui = 
{
	new = function(p)
		local obj = {
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
			local flow = self.player.gui.center.heli_remote_frame.scroller.cam_table["heli_cam_flow_" .. tostring(camNo)]
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
			self.player.gui.center.heli_remote_frame.scroller.cam_table["heli_cam_flow_" .. tostring(i)]["heli_cam_box_" .. tostring(i)]["heli_cam_" .. tostring(i)].position = curHeli.baseEnt.position
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
				name = "btn_flow",
			}
			buttonFlow.style.left_padding = 7

				local btnToPlayer = buttonFlow.add
				{
					type = "sprite-button",
					name = "btn_to_player",
					sprite = "heli_to_player",
					style = mod_gui.button_style,
				}

				local btnToMap = buttonFlow.add
				{
					type = "sprite-button",
					name = "btn_to_map",
					sprite = "heli_to_map",
					style = mod_gui.button_style,
				}

				local btnToPad = buttonFlow.add
				{
					type = "sprite-button",
					name = "btn_to_pad",
					sprite = "heli_to_pad",
					style = mod_gui.button_style,
				}

				local btnStop = buttonFlow.add
				{
					type = "sprite-button",
					name = "btn_stop",
					sprite = "heli_stop",
					style = mod_gui.button_style,
				}

			local scrollPane = frame.add
			{
				type = "scroll-pane",
				name = "scroller",
			}

			scrollPane.style.maximal_width = 1000
			scrollPane.style.maximal_height = 600

				local camTable = scrollPane.add
				{
					type = "table",
					name = "cam_table",
					colspan = 1,
				}
				applyStyle(camTable, tableStyle)


					self.trackedHelis = {}
					local i = 1
					for k,v in pairs(global.helis) do
						if v.baseEnt.force == self.force then
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
	end
end



heli_pad = 
{
	new = function(placementEnt)
		local obj = 
		{
			replacedTiles = {},
			baseEnt = game.surfaces[1].create_entity
			{
				name = "heli-pad-entity",
				force = placementEnt.force,
				position = placementEnt.position,
			}
		}

		--game.players[1].print("calc: ".. tostring(placementEnt.position.y - heli_pad_sprite_y_shift).. " real pos: "..tostring(obj.baseEnt.position.y))

		game.players[1].print(tostring(placementEnt.position.x) .. "|" .. tostring(placementEnt.position.y))

		local boundingBox = 
		{
			left_top = {placementEnt.position.x - 3.5, placementEnt.position.y - 3.5},
			right_bottom = {placementEnt.position.x + 3.5, placementEnt.position.y + 3.5}
		}

		game.surfaces[1].destroy_decoratives(boundingBox)

		local scorches = game.surfaces[1].find_entities_filtered
		{
			area = boundingBox,
			type = "corpse",
			name = "small-scorchmark",
		}

		for k,v in pairs(scorches) do
			v.destroy()
		end

		local tiles = {}
		for i = -3, 3 do
			for j = -3, 3 do
				table.insert(tiles, 
				{
					name = "heli-pad-concrete", 
					position = {x = placementEnt.position.x + i, y = placementEnt.position.y + j} 
				})

				local oldTile = game.surfaces[1].get_tile(placementEnt.position.x + i, placementEnt.position.y + j)
				table.insert(obj.replacedTiles, 
				{
					name = oldTile.name,
					position = oldTile.position
				})
			end
		end

		game.surfaces[1].set_tiles(tiles, true)

		placementEnt.destroy()
		return setmetatable(obj, {__index = heli_pad})
	end,

	destroy = function(self)
		game.surfaces[1].set_tiles(self.replacedTiles, true)
	end
}

