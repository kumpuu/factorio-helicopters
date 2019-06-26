timer = baseClass.extend({
	__classId = "timer",

	new = function(func, frames, isInterval, timerData)
		local timer = baseClass.new({
			valid = true,
			callback = func,
			runTick = game.tick + frames,
			interval = isInterval and frames,
			paused = false,
			data = timerData,
		}, timer)

		return insertInGlobal("timers", timer)
	end,

	cancel = function(self)
		self.valid = false
	end,

	pause = function(self)
		self.paused = true
		self.remaining = self.runTick - game.tick
	end,

	resume = function(self)
		self.paused = false
		self.runTick = game.tick + self.remaining
	end,
})

function setTimeout(func, frames, timerData)
	return timer.new(func, frames, false, timerData)
end

function setInterval(func, frames, timerData)
	return timer.new(func, frames, true, timerData)
end

function OnTimerTick()
	local timers = global.timers

	if timers then
		for i = #timers, 1, -1 do
			local curTimer = timers[i]

			if not curTimer.valid then
				table.remove(timers, i)
			
			else
				if (not curTimer.paused) and curTimer.runTick <= game.tick then
					curTimer:callback()

					if curTimer.interval then
						curTimer.runTick = game.tick + curTimer.interval

					else
						curTimer.valid = false
						table.remove(timers, i)
					end
				end
			end
		end 
	end
end