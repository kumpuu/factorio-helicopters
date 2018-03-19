local pointerFrames = 128

gaugeGui =
{
	prefix = "heli_gaugeGui_",

	pointerData =
	{
		fuel = 
		{
			min = 0,
			max = 1,
			fMin = 0.375 * pointerFrames,
			fMax = 0.625 * pointerFrames,
			clockwise = true,
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
		heli:addGaugeGui(obj)

		return obj
	end,

	destroy = function(self)
		self.valid = false
	
		if self.guiElems.root and self.guiElems.root.valid then
			self.guiElems.root.destroy()
		end

		self.heli:removeGaugeGui(self)

		removeInGlobal("gaugeGuis", self)
	end,

	setGauge = function(self, gaugeName, pointerName, val)
		local pD = self.pointerData[pointerName]
		local pointer = self.guiElems[gaugeName].pointers[pointerName]

		if pointer.noise then
			val = val + pointer.noise:advance()
		end

		if pointer.lastVal ~= val then
			pointer.lastVal = val

			local pc = math.min(math.max(val / (pD.max - pD.min), 0), 1)
			local frameDelta = math.abs(pD.fMax - pD.fMin)

			local frame
			if pD.clockwise then
				frame = pD.fMin + pc * frameDelta
			else
				frame = pD.fMin - pc * frameDelta
			end

			if frame < 0 then
				frame = pointerFrames + frame
			end
			frame = math.floor(frame % pointerFrames)

			if pointer.lastFrame ~= frame then
				pointer.lastFrame = frame

				if pointer.elem then
					pointer.elem.destroy() 
				end

				pointer.elem = pointer.root.add
				{
					type = "sprite",
					name = gaugeName .. "_pointer_" .. pointerName,
					sprite = "heli_gauge_pointer_" .. frame,
				}
			end
		end
	end,

	setLed = function(self, gaugeName, ledName, on)
		local led = self.guiElems[gaugeName].leds[ledName]

		if led.elem then
			led.elem.destroy()
		end

		if on then
			local fullName = gaugeName .. "_led_" .. ledName

			led.elem = self.guiElems[gaugeName].leds.root.add
			{
				type = "sprite",
				name = self.prefix .. fullName,
				sprite = "heli_" .. fullName,
			}
		end

		led.on = on
	end,

	setLedBlinking = function(self, gaugeName, ledName, on, interval, sound)
		local led = self.guiElems[gaugeName].leds[ledName]
		
		if not on then
			led.sound = nil

			if led.blinkInterval then
				led.blinkInterval.cancel()
				led.blinkInterval = nil
				self:setLed("gauge_fs", "fuel", false)
			end

		else
			led.sound = sound

			if not led.blinkInterval then
				led.blinkInterval = setInterval(function(timer)
					if not self.valid then
						timer.cancel()
					
					else
						self:setLed("gauge_fs", "fuel", not led.on)

						if led.sound and self.player.mod_settings["heli-gaugeGui-play-fuel-warning-sound"].value then
							self.player.play_sound{path = led.sound}
						end
					end
				end, interval)
			else
				led.blinkInterval.interval = interval
			end
		end
	end,

	setPointerNoise = function(self, gaugeName, pointerName, enable, magnitude, timeAdvance, minFrequency, maxFrequency)
		local pointer = self.guiElems[gaugeName].pointers[pointerName]

		if enable then
			pointer.noise = simpleNoise.new(magnitude, timeAdvance, minFrequency, maxFrequency)

		else
			pointer.noise = nil
		end
	end,

	buildGauge = function(self, parent, name, pointerNames, ledNames)
		local gauge = 
		{
			elem = parent.add
			{
				type = "sprite",
				name = self.prefix .. name,
				sprite = "heli_" .. name,
			},

			pointers = {},
		}

		gauge.leds =
		{
			root = gauge.elem.add
			{
				type = "sprite",
				name = self.prefix .. name .. "_ledRoot",
				sprite = "heli_void_128",
			},
		}

		for k,v in pairs(pointerNames or {}) do
			gauge.pointers[v] = 
			{
				root = gauge.elem.add
				{
					type = "sprite",
					name = self.prefix .. name .. "_pointer_" .. v .. "_root",
					sprite = "heli_void_128",
				}
			}
		end

		for k,v in pairs(ledNames or {}) do
			gauge.leds[v] = {}
		end

		return gauge
	end,

	buildGui = function(self)
		local els = self.guiElems

		els.root = els.parent.add
		{
			type = "frame",
			name = self.prefix .. "rootFrame",
			style = "frame",
			tooltip = {"heli-gui-gauges-tt"},
		}

		els.gauge_fs = self:buildGauge(els.root, "gauge_fs", {"fuel", "speed"}, {"fuel"})
		els.gauge_hr = self:buildGauge(els.root, "gauge_hr", {"height", "rpm"})

		self:setGauge("gauge_fs", "fuel", self.pointerData.fuel.min)
		self:setGauge("gauge_fs", "speed", self.pointerData.speed.min)
		self:setGauge("gauge_hr", "height", self.pointerData.height.min)
		self:setGauge("gauge_hr", "rpm", self.pointerData.rpm.min)
	end,
}