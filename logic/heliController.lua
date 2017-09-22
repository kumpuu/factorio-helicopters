function getHeliControllerIndexByOwner(p)
	if global.heliControllers then
		for i, curController in ipairs(global.heliControllers) do
			if curController.owner == p then
				return i
			end
		end
	end
end

function getHeliControllerByOwner(p)
	local i = getHeliControllerIndexByowner(p)
	if i then return global.heliControllers[i] end
end

function getHeliControllerIndexByHeli(heli)
	if global.heliControllers then
		for i, curController in ipairs(global.heliControllers) do
			if curController.heli == heli then
				return i
			end
		end
	end
end

function getHeliControllerByHeli(heli)
	local i = getHeliControllerIndexByHeli(heli)
	if i then return global.heliControllers[i] end
end


heliController = 
{
	new = function(player, heli, target, targetIsPlayer)
		local obj = 
		{
			valid = true,

			owner = player,
			heli = heli,
			targetIsPlayer = targetIsPlayer,

			curState = heliController.getUp,
			stateChanged = true,
		}

		if targetIsPlayer then
			obj.targetPlayer = target
			obj.targetPos = target.position
		else
			obj.targetPos = target
		end

		if not heli.baseEnt.passenger then
			obj.driverIsBot = true
			obj.driver = game.surfaces[1].create_entity{name = "player", force = player.force, position = player.position}
			heli.baseEnt.passenger = obj.driver
		else
			obj.driverIsBot = false
			obj.driver = heli.baseEnt.passenger
		end

		heli.hasRemoteController = true

		setmetatable(obj, {__index = heliController})

		OnHeliControllerCreated(obj)
		return obj
	end,

	destroy = function(self)
		self.valid = false
		self.heli.hasRemoteController = nil

		if self.driverIsBot and self.driver and self.driver.valid then
			self.driver.destroy()
		end

		OnHeliControllerDestroyed(self)
	end,

	stopAndDestroy = function(self)
		if self.driverIsBot then
			self:changeState(self.stop)
		else
			self:destroy()
		end
	end,

	OnTick = function(self)
		if not (self.heli.valid and self.heli.baseEnt.valid) then
			self:destroy()

		elseif not (self.heli.baseEnt.passenger and self.heli.baseEnt.passenger.valid) then
			if self.driverIsBot then
				self:destroy()
			else
				self.driverIsBot = true
				self.driver = game.surfaces[1].create_entity{name = "player", force = self.owner.force, position = self.owner.position}
				self.heli.baseEnt.passenger = self.driver
				self.heli:OnUp()
			end

		elseif self.driverIsBot and self.heli.baseEnt.passenger ~= self.driver then
			if self.driver and self.driver.valid then
				self.driver.destroy()
				self.driver = self.heli.baseEnt.passenger
				self.driverIsBot = false
			end

		else
			if self.targetIsPlayer then
				if self.targetPlayer.valid then
					self.targetPos = {x = self.targetPlayer.position.x, y = self.targetPlayer.position.y - 1}
				else
					self:stopAndDestroy()
					return
				end
			end

			local old = self.curState
			self:curState()

			if old == self.curState then
				self.stateChanged = false
			else
				self.stateChanged = true
			end
		end
	end,

	changeState = function(self, newState)
		self.curState = newState
	end,

	setRidingState = function(self, acc, dir)
		if not acc then
			acc = self.driver.riding_state.acceleration
		end

		if not dir then
			dir = self.driver.riding_state.direction
		end

		self.driver.riding_state = {acceleration = acc, direction = dir}
	end,

	holdSpeed = function(self, speed)
		local dir = self.driver.riding_state.direction

		if math.abs(1 - (self.heli.baseEnt.speed / speed)) < 0.05 then
			self.heli.baseEnt.speed = speed
		else

			if self.heli.baseEnt.speed > speed then
				self:setRidingState(defines.riding.acceleration.braking)
			else
				self:setRidingState(defines.riding.acceleration.accelerating)
			end
		end
	end,

	getTargetOrientation = function(self)
		local curPos = self.heli.childs.bodyEntShadow.position

		local vec = {x = self.targetPos.x - curPos.x, y = curPos.y - self.targetPos.y}
		local len = math.sqrt(vec.x ^ 2 + vec.y ^ 2)

		vec.x = vec.x / len
		vec.y = vec.y / len


		local angle = math.atan2(vec.y, vec.x)
		self.targetOrient = 1.25 - (angle / (2 * math.pi))
		if self.targetOrient > 1 then self.targetOrient = self.targetOrient - 1 end
	end,

	getSteeringToTargetOrientation = function(self)
		local curOrient = self.heli.baseEnt.orientation

		if math.abs(self.targetOrient - curOrient) < 0.02 then
			return defines.riding.direction.straight
		else
			local deltaLeft = 0
			local deltaRight = 0

			if self.targetOrient < curOrient then
				deltaLeft = curOrient - self.targetOrient
				deltaRight = 1 - curOrient + self.targetOrient
			else
				deltaLeft = curOrient + 1 - self.targetOrient
				deltaRight = self.targetOrient - curOrient
			end

			if deltaLeft < deltaRight then
				return defines.riding.direction.left
			else
				return defines.riding.direction.right
			end
		end
	end,

	------------- states ---------------
	getUp = function(self)
		if self.stateChanged then
			self.heli:OnUp()
		elseif self.heli.height >= maxCollisionHeight then
			self:changeState(self.orientToTarget)
		end
	end,

	orientToTarget = function(self)
		if self.stateChanged then
			self.targetOrientation = self:getTargetOrientation()
		else
			local dir = self:getSteeringToTargetOrientation()

			self:setRidingState(defines.riding.acceleration.nothing, dir)

			if dir == defines.riding.direction.straight then
				self:changeState(self.moveToTarget)
			end
		end
	end,

	moveToTarget = function(self)
		local dist = getDistance(self.heli.childs.bodyEntShadow.position, self.targetPos)

		if self.stateChanged then
			self.updateOrientationCooldown = 30
			self.oldDist = -1
		end

		self.updateOrientationCooldown = self.updateOrientationCooldown - 1
		if self.updateOrientationCooldown <  3 or dist < 10 then
			if self.updateOrientationCooldown == 0 then
				self.updateOrientationCooldown = 30
				if dist >= 10 then
					self:setRidingState(nil, defines.riding.direction.straight)
				end
			end

			self.targetOrientation = self:getTargetOrientation()
			self:setRidingState(nil, self:getSteeringToTargetOrientation())
		else
			--self:setRidingState(nil, defines.riding.direction.straight)
		end

		if dist < 150 then
			local creepZone = 0.5
			local landingZone = 1
			local desiredSpeed = 1.5 - (1.2247448 - (dist - creepZone) / 150)^2

			self:holdSpeed(desiredSpeed)

			if dist <= landingZone and (dist <= creepZone or dist == self.oldDist) then
				self:setRidingState(defines.riding.acceleration.braking)
				self:changeState(self.creepToPosition)
			end

			self.oldDist = dist
		else
			self:setRidingState(defines.riding.acceleration.accelerating)
		end
	end,

	creepToPosition = function(self)
		local curPos = self.heli.childs.bodyEntShadow.position
		
		if self.stateChanged then
			self:setRidingState(defines.riding.acceleration.braking, defines.riding.direction.straight)
			self.heli.baseEnt.speed = 0
			self.targetIsPlayer = false

			local curDist = getDistance(curPos, self.targetPos)
			local alignVec = {x = (self.targetPos.x - curPos.x) / curDist * 1,  y = (self.targetPos.y - curPos.y) / curDist * 1}
			self.targetPos = {x = self.targetPos.x + alignVec.x, y = self.targetPos.y + alignVec.y}

			local creepFrames = 60
			self.creepVec = {x = (self.targetPos.x - curPos.x) / creepFrames, y = (self.targetPos.y - curPos.y) / creepFrames}

			self.oldDist = 100
		end

		self.heli.baseEnt.teleport({x = self.heli.baseEnt.position.x + self.creepVec.x, y = self.heli.baseEnt.position.y + self.creepVec.y})
		self.heli:updateEntityPositions()

		local dist = getDistance(self.heli.childs.bodyEntShadow.position, self.targetPos)
		if dist < 0.2 or dist > self.oldDist then
			self:changeState(self.land)
		end

		self.oldDist = dist
	end,

	land = function(self)
		self.heli:OnDown()
		self:destroy()
	end,

	stop = function(self)
		self:setRidingState(defines.riding.acceleration.braking, defines.riding.direction.straight)
		
		if self.heli.baseEnt.speed == 0 then
			self:changeState(self.land)
		end
	end,
	------------------------------------
}