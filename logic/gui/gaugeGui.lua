local pointerFrames = 128

gaugeGui =
{
	prefix = "heli_gaugeGui_",

	gaugeData = 
	{
		fuel = 
		{
			min = 0,
			max = 100,
			fMin = 0.625 * pointerFrames,
			fMax = 0.375 * pointerFrames,
			clockwise = false,
		},

		speed = 
		{
			min = 0,
			max = 400,
			fMin = 0.75 * pointerFrames,
			fMax = 1.25 * pointerFrames,
			clockwise = true,
		},

		height = 
		{
			min = 0,
			max = 25,
			fMin = 0.5390625 * pointerFrames,
			fMax = 0.965 * pointerFrames,
			clockwise = true,
		},

		rpm = 
		{
			min = 0,
			max = 3000,
			fMin = 0.4609375 * pointerFrames,
			fMax = 0.035 * pointerFrames,
			clockwise = false,
		},
	},

	new = function(player, heli)
		obj = 
		{
			valid = true,
			player = player,
			heli = heli,

			guiElems = 
			{
				parent = player.gui.left,
			},
		}

		for k,v in pairs(gaugeGui) do
			obj[k] = v
		end

		obj:buildGui()
		heli.gauge = obj

		return obj
	end,

	destroy = function(self)
		self.valid = false
	
		if self.guiElems.root and self.guiElems.root.valid then
			self.guiElems.root.destroy()
		end

		heli.gauge = nil
	end,

	setGauge = function(self, name, val)
		local gd = self.gaugeData[name]
		local pointer = self.guiElems.pointers[name]

		if pointer.lastVal ~= val then
			pointer.lastVal = val

			local pc = math.min(math.max(val / (gd.max - gd.min), gd.min), gd.max)
			local frameDelta = math.abs(gd.fMax - gd.fMin)

			local frame
			if gd.clockwise then
				frame = gd.fMin + pc * frameDelta
			else
				frame = gd.fMin - pc * frameDelta
			end

			if frame < 0 then
				frame = pointerFrames + frame
			end
			frame = math.floor(frame % pointerFrames)


			if pointer.elem then
				pointer.elem.destroy() 
			end

			pointer.elem = pointer.parent.add
			{
				type = "sprite",
				name = "gauge_pointer_" .. name,
				sprite = "heli_gauge_pointer_" .. frame,
			}
		end
	end,

	setLed = function(self, gaugeName, ledName, on)
		local els = self.guiElems

		local fullName = gaugeName .. "_" .. ledName

		if els[fullName] then
			els[fullName].destroy()
		
		end

		if on then
			els[fullName] = els[gaugeName].add
			{
				type = "sprite",
				name = self.prefix .. ledName,
				sprite = "heli_" .. fullName,
			}
		end
	end,

	buildGui = function(self)
		local els = self.guiElems

		els.root = els.parent.add
		{
			type = "frame",
			name = self.prefix .. "rootFrame",
			--caption = {"heli-gui-playerSelection-frame-caption"},
			style = "frame",
			--tooltip = {"heli-gui-frame-tt"},
		}

		els.gauge_fuel_speed = els.root.add
		{
			type = "sprite",
			name = self.prefix .. "gauge_fuel_speed",
			sprite = "heli_gauge_fuel_speed",
		}

		els.gauge_height_rpm = els.root.add
		{
			type = "sprite",
			name = self.prefix .. "gauge_height_rpm",
			sprite = "heli_gauge_height_rpm",
		}





		els.pointers =
		{
			fuel = 
			{
				elem = els.gauge_fuel_speed.add
				{
					type = "sprite",
					name ="gauge_pointer_fuel",
					sprite = "heli_gauge_pointer_0",
				},

				parent = els.gauge_fuel_speed,
			},

			speed = 
			{
				elem = els.gauge_fuel_speed.add
				{
					type = "sprite",
					name ="gauge_pointer_speed",
					sprite = "heli_gauge_pointer_0",
				},

				parent = els.gauge_fuel_speed,
			},

			height = 
			{
				elem = els.gauge_height_rpm.add
				{
					type = "sprite",
					name ="gauge_pointer_height",
					sprite = "heli_gauge_pointer_0",
				},

				parent = els.gauge_height_rpm,
			},

			rpm = 
			{
				elem = els.gauge_height_rpm.add
				{
					type = "sprite",
					name ="gauge_pointer_rpm",
					sprite = "heli_gauge_pointer_0",
				},

				parent = els.gauge_height_rpm,
			},
		}

		self:setGauge("fuel", self.gaugeData.fuel.min)
		self:setGauge("speed", self.gaugeData.speed.min)
		self:setGauge("height", self.gaugeData.height.min)
		self:setGauge("rpm", self.gaugeData.rpm.min)

		self:setLed("gauge_fuel_speed", "led_1", true)

		ledon = true
		setInterval(function()
			ledon = not ledon
			self:setLed("gauge_fuel_speed", "led_1", ledon)
		end, 60)
	end,
}