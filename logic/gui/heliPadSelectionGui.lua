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
				parent = p.gui.left,
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
	
		if self.guiElems.root then
			self.guiElems.root.destroy()
		end
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

	buildGui = function(self)
		local els = self.guiElems

		els.root = els.parent.add
		{
			type = "frame",
			name = self.prefix .. "rootFrame",
			caption = "Select helicopter pad to fly to",
			style = "frame_style",
			direction = "vertical",
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
					colspan = 4,
				}
				els.camTable.style.horizontal_spacing = 10
				els.camTable.style.vertical_spacing = 10

					for k, curPad in pairs(global.heliPads) do
							printA(curPad.baseEnt.force, self.player.force, curPad.baseEnt.force == self.player.force)
						if curPad.baseEnt.force == self.player.force then
							self:buildCam(els.camTable, k, curPad.baseEnt.position, 0.3)
						end
					end
	end,
}