animationTransitor = 
{
	new = function(runningAnim, fadeOutFrames, newAnimMaxValue, newAnimDurationInFrames, newAnimEasingName)
		local obj = 
		{
			runningAnim = runningAnim,
			isFadeOutComplete = false,

			newAnimMaxValue = newAnimMaxValue,
			newAnimDurationInFrames = newAnimDurationInFrames,
			newAnimEasingName = newAnimEasingName,
		}

		obj.runningAnim:fadeOut(fadeOutFrames)

		return setmetatable(obj, {__index = animationTransitor})
	end,

	nextFrame = function(self)
		local curVal, isDone = self.runningAnim:nextFrame()

		if isDone and not self.isFadeOutComplete then
			self.isFadeOutComplete = true
			isDone = false
			self.runningAnim = basicAnimator.new(curVal, self.newAnimMaxValue, self.newAnimDurationInFrames, self.newAnimEasingName)
		end

		return curVal, isDone
	end,
}