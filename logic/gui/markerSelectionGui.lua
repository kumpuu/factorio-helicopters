markerSelectionGui =
{
	prefix = "heli_markerSelectionGui_",

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

		for k,v in pairs(markerSelectionGui) do
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
	end,

	buildGui = function(self)
		self.guiElems.root = self.guiElems.parent.add
		{
			type = "frame",
			name = self.prefix .. "rootFrame",
			caption = "Select marker to fly to",
			style = "frame_style",
		}

		self.guiElems.scroller = self.guiElems.root.add
		{
			type = "scroll-pane",
			name = self.prefix .. "scroller",
		}

		self.guiElems.scroller.style.maximal_width = 1000
		self.guiElems.scroller.style.maximal_height = 600

		self.guiElems.table = self.guiElems.scroller.add
		{
			type = "flow",
			name = self.prefix .. "flow",
			style = "achievements_flow_style",
			direction = "vertical",
		}

		for k, curTag in pairs(self.player.force.find_chart_tags(self.player.surface)) do
			local btn = self.guiElems.table.add
			{
				type = "button",
				name = self.prefix .. "btn_" .. tostring(curTag.tag_number),
				style = "listbox_button_style",
				caption = "                " .. curTag.text,
			}
			btn.style.minimal_height = 38
			btn.style.minimal_width = 290

			if curTag.icon then
				local sprite
				if curTag.icon.type == "virtual" then
					sprite = "virtual-signal" .. "/" .. curTag.icon.name
				else
					sprite = curTag.icon.type .. "/" .. curTag.icon.name
				end

				btn.add
				{
					type = "sprite",
					name = self.prefix .. "icon",
					sprite = sprite,
				}
			end
		end
		
	end,
}