heliPadSelectionGui = 
{
	prefix = "heli_heliPadSelectionGui_",

	new = function(mgr, p)
		obj = 
		{
			valid = true,
			manager = mgr,
			player = p,

			guiElems = 
			{
				parent = mod_gui.get_frame_flow(p),
			},
		}

		for k,v in pairs(heliPadSelectionGui) do
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

		if name:match("^" .. self.prefix .. "cam_%d+$") then
			self:OnCamClicked(e)

		elseif name == self.prefix .. "rootFrame" and e.button == defines.mouse_button_type.right then
			self.manager:OnChildEvent(self, "cancel")
		end
	end,

	OnCamClicked = function(self, e)

		if e.button == defines.mouse_button_type.left then
			local camID = tonumber(e.element.name:match("%d+"))
			local cam = searchInTable(self.guiElems.cams, camID, "ID")
			self.manager:OnChildEvent(self, "selectedPosition", cam.heliPad.baseEnt.position)

		elseif e.button == defines.mouse_button_type.right then
			local zoomMax = 1.0125
			local zoomMin = 0.025
			local zoomDelta = 0.5

			if e.shift then
				e.element.zoom = e.element.zoom * (1 + zoomDelta)
				if e.element.zoom > zoomMax then
					e.element.zoom = zoomMin
				end
			else
				e.element.zoom = e.element.zoom * (1 - zoomDelta)
				if e.element.zoom < zoomMin then
					e.element.zoom = zoomMax
				end
			end
		end
	end,

	OnHeliPadBuilt = function(self, heliPad)
		if heliPad.baseEnt.force == self.player.force then
			table.insert(self.guiElems.cams, 
			{
				cam = self:buildCam(self.guiElems.camTable, self.curCamID, heliPad.baseEnt.position, self:getDefaultZoom()),
				ID = self.curCamID,
				heliPad = heliPad,
			})
			self.curCamID = self.curCamID + 1
			self:setNothingAvailable(false)
		end
	end,

	OnHeliPadRemoved = function(self, heliPad)
		local i = searchIndexInTable(self.guiElems.cams, heliPad, "heliPad")
		if i then
			self.guiElems.cams[i].cam.destroy()
			table.remove(self.guiElems.cams, i)

			if #self.guiElems.cams == 0 then
				self:setNothingAvailable(true)
			end
		end
	end,

	OnPlayerChangedForce = function(self, player)
		if player == self.player then
			self.guiElems.root.destroy()
			self.guiElems = {parent = self.guiElems.parent}
			self:buildGui()
		end
	end,

	getDefaultZoom = function(self)
		return self.player.mod_settings["heli-gui-heliPadSelection-defaultZoom"].value
	end,

	buildCam = function(self, parent, ID, position, zoom)
		local padding = 8
		local size = 210
		local camSize = size - padding

		local cam = parent.add
		{
			type = "camera",
			name = self.prefix .. "cam_" .. tostring(ID),
			position = position,
			zoom = zoom,
			tooltip = {"heli-gui-cam-tt"},
		}
		cam.style.top_padding = padding
		cam.style.left_padding = padding

		cam.style.minimal_width = camSize
		cam.style.minimal_height = camSize

		--[[
		if hasController then
			local label = cam.add
			{
				type = "label",
				caption = "  CONTROLLED",
			}

			label.style.font = "pixelated"
			label.style.font_color = {r = 1, g = 0, b = 0}
		end
		]]

		return cam
	end,

	setNothingAvailable = function(self, val)
		local els = self.guiElems

		if val and not els.nothingAvailable then
			els.nothingAvailable = els.camTable.add
			{
				type = "label",
				name = self.prefix .. "nothingAvailable",
				caption = {"heli-gui-padSelection-noPadsAvailable"},
			}
			els.nothingAvailable.style.font = "default-bold"
			els.nothingAvailable.style.font_color = {r = 1, g = 0, b = 0}

		elseif not val and els.nothingAvailable then
			els.nothingAvailable.destroy()
			els.nothingAvailable = nil
		end
	end,

	buildGui = function(self)
		local els = self.guiElems

		els.root = els.parent.add
		{
			type = "frame",
			name = self.prefix .. "rootFrame",
			caption = {"heli-gui-padSelection-frame-caption"},
			style = "frame",
			direction = "vertical",
			tooltip = {"heli-gui-frame-tt"},
		}

		els.root.style.maximal_width = 1000
		els.root.style.maximal_height = 700


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
					column_count = 4,
				}
				els.camTable.style.horizontal_spacing = 10
				els.camTable.style.vertical_spacing = 10

					self.curCamID = 0
					els.cams = {}

					local hasCams = false
					if global.heliPads then
						for k, curPad in pairs(global.heliPads) do
							if curPad.baseEnt.force == self.player.force then
								hasCams = true
								table.insert(els.cams, 
								{
									cam = self:buildCam(els.camTable, self.curCamID, curPad.baseEnt.position, self:getDefaultZoom()),
									ID = self.curCamID,
									heliPad = curPad,
								})

								self.curCamID = self.curCamID + 1
							end
						end
					end

					if not hasCams then
						self:setNothingAvailable(true)
					end
	end,
}