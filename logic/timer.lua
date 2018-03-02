function createTimer(func, frames, isInterval)
	local timers = global.timers

	local timer = 
	{
		callback = func,
		runTick = game.tick + frames,
		interval = isInterval and frames,
		paused = false,
	}

	timer.cancel = function()
		for i,v in ipairs(global.timers) do
			if v == timer then
				table.remove(global.timers, i)
				return
			end
		end
	end

	timer.pause = function()
		timer.paused = true
		timer.remaining = timer.runTick - game.tick
	end

	timer.resume = function()
		timer.paused = false
		timer.runTick = game.tick + timer.remaining
	end

	insertInGlobal("timers", timer)
	return timer
end

function setTimeout(func, frames)
	return createTimer(func, frames, false)
end

function setInterval(func, frames)
	return createTimer(func, frames, true)
end

function OnTimerTick()
	local timers = global.timers

	if timers then
		for i = #timers, 1, -1 do
			local curTimer = timers[i]

			if (not curTimer.paused) and curTimer.runTick <= game.tick then
				curTimer.callback(curTimer)

				if curTimer.interval then
					curTimer.runTick = game.tick + curTimer.interval

				else
					if timers[i] == curTimer then --might have cancelled itself
						table.remove(timers, i)
					end
				end
			end
		end 
	end
end