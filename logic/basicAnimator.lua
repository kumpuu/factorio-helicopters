basicAnimator = 
{
	new = function(startValue, maxValue, durationInFrames, easingName)
		local obj = 
		{
			curFrame = 0,
			endFrame = durationInFrames - 1,

			curVal = nil,
			isDone = false,

			easingFunc = basicAnimator.easingFuncs[easingName],

			startValue = startValue,
			--maxValue = maxValue,
			delta = maxValue - startValue,

			direction = 1,
		}

		return setmetatable(obj, {__index = basicAnimator})
	end,

	nextFrame = function(self)
		local easedProgress = self.easingFunc(self.curFrame / self.endFrame)

		self.curVal = self.startValue + self.delta * easedProgress

		if self.directionChangeRate then
			local oldDir = self.direction
			self.direction = self.direction - self.directionChangeRate

			if self.bFadeOut then
				if self.direction == 0 or (oldDir > 0 and self.direction < 0) or (oldDir < 0 and self.direction > 0) then
					self.isDone = true
				end
			end

			if self.direction >= 1 then
				self.direction = 1
				self.directionChangeRate = nil

			elseif self.direction <= -1 then
				self.direction = -1
				self.directionChangeRate = nil
			end
		end

		self.curFrame = self.curFrame + self.direction
		if self.curFrame > self.endFrame or self.curFrame < 0 then
			self.isDone = true
		end

		return self.curVal, self.isDone
	end,

	reset = function(self)
		self.curVal = nil
		self.isDone = false
		self.curFrame = 0
	end,

	reverse = function(self)
		self.direction = -1
	end,

	reverseSmoothly = function(self, maxSmoothingFrames)
		if not maxSmoothingFrames then
			maxSmoothingFrames = 20
		end

		maxSmoothingFrames = math.min(maxSmoothingFrames, self:remainingFrames())

		self.directionChangeRate = (self.direction / maxSmoothingFrames) * 2
	end,

	fadeOut = function(self, maxSmoothingFrames)
		if maxSmoothingFrames then
			maxSmoothingFrames = maxSmoothingFrames / 2
		end

		self:reverseSmoothly(maxSmoothingFrames)
		self.bFadeOut = true
	end,

	remainingFrames = function(self)
		if direction == 1 then
			return self.endFrame - self.curFrame + 1
		else
			return self.curFrame + 1
		end
	end,

	easingFuncs = 
	{
		--source: https://gist.github.com/gre/1650294

		linear = function(x) return x end,

		-- accelerating from zero velocity
		easeInQuad = function(x) return x^2 end,

		-- decelerating to zero velocity
		easeOutQuad = function(x) return x*(2-x) end,

		-- acceleration until halfway, then deceleration
		easeInOutQuad = function(x) if x < 0.5 then return 2*x^2 else return -1+(4-2*x)*x end end,

		-- accelerating from zero velocity 
		easeInCubic = function(x) return x^3 end,

		-- decelerating to zero velocity 
		easeOutCubic = function(x) return (x-1)^3+1 end,

		-- acceleration until halfway, then deceleration 
		easeInOutCubic = function(x) if x < 0.5 then return 4*x^3 else return (x-1)*(2*x-2)*(2*x-2)+1 end end,

		-- accelerating from zero velocity 
		easeInQuart = function(x) return x^4 end,

		-- decelerating to zero velocity 
		easeOutQuart = function(x) return 1-(x-1)^4 end,

		-- acceleration until halfway, then deceleration
		easeInOutQuart = function(x) if x < 0.5 then return 8*x^4 else return 1-8*(x-1)^4 end end,

		-- accelerating from zero velocity
		easeInQuint = function(x) return x^5 end,

		-- decelerating to zero velocity
		easeOutQuint = function(x) return 1+(x-1)^5 end,
			
		-- acceleration until halfway, then deceleration 
		easeInOutQuint = function(x) if x < 0.5 then return 16*x^5 else return 1+16*(1-x)^5 end end,

		-- acceleration until halfway, then deceleration 
		easeInOutSine = function(x) return (math.cos(x * math.pi) - 1) * -0.5 end,

		cyclicSine = function(x) return math.sin(2 * math.pi * x) end,
	},
}