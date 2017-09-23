local math3d = require("math3d")
require("logic.basicAnimator")
require("logic.basicState")

function getHeliFromBaseEntity(ent)
	for k,v in pairs(global.helis) do
		if v.baseEnt == ent then
			return v
		end
	end

	return nil
end

local frameFixes = {
	0, 			--1	
	0.015625, 	--2	
	0.046875, 	--3	
	0.0625, 	--4	
	0.078125, 	--5	
	0.109375, 	--6	
	0.125, 		--7	
	0.140625, 	--8	
	0.15625, 	--9	
	0.171875, 	--10	
	0.1796875, 	--11	
	0.1875, 	--12	
	0.203125, 	--13	
	0.21875, 	--14	
	0.2265625, 	--15	
	0.234375, 	--16	
	0.25, 		--17	
	0.265625, 	--18	
	0.2734375, 	--19	
	0.28125, 	--20	
	0.296875, 	--21	
	0.3125, 	--22	
	0.3203125, 	--23	
	0.328125, 	--24	
	0.34375, 	--25	
	0.359375, 	--26	
	0.375, 		--27	
	0.390625, 	--28	
	0.40625, 	--29	
	0.4375, 	--30	
	0.453125, 	--31	
	0.46875, 	--32	
	0.5, 		--33	
	0.515625, 	--34	
	0.546875, 	--35	
	0.5625, 	--36	
	0.578125, 	--37	
	0.609375, 	--38	
	0.625, 		--39	
	0.640625, 	--40	
	0.65625, 	--41	
	0.671875, 	--42	
	0.6796875, 	--43	
	0.6875, 	--44	
	0.703125, 	--45	
	0.71875, 	--46	
	0.7265625, 	--47	
	0.734375, 	--48	
	0.75, 		--49	
	0.765625, 	--50	
	0.7734375, 	--51	
	0.78125, 	--52	
	0.796875, 	--53	
	0.8125, 	--54	
	0.8203125, 	--55	
	0.828125, 	--56	
	0.84375, 	--57	
	0.859375, 	--58	
	0.875, 		--59	
	0.890625, 	--60	
	0.90625, 	--61	
	0.9375, 	--62	
	0.953125, 	--63
	0.984375, 	--64
}

local versionStrToInt = function(s)
	v = 0
	for num in s:gmatch("%d+") do
		v = v * 100 + tonumber(num)
	end

	return v
end

--local modVersion = versionStrToInt(game.active_mods.Helicopters)

maxCollisionHeight = 2
local rotorMaxRPM = 200
local startupTime = 5*60 --5 seconds
local colliderMaxHealth = 999999
local baseEngineConsumption = 20000

local bodyOffset = 5
local rotorOffset = 5.1

local maxBobbing = 0.05
local bobbingPeriod = 8*60


local IsEntityBurnerOutOfFuel = function(ent)
	return ent.burner.remaining_burning_fuel <= 0 and ent.burner.inventory.is_empty()
end

local transferGridEquipment = function(srcEnt, destEnt)
	if srcEnt.grid and destEnt.grid then --assume they have the same size and destEnt.grid is empty.
		for i, equip in ipairs(srcEnt.grid.equipment) do
			local newEquip = destEnt.grid.put{name = equip.name, position = equip.position}

			if equip.type == "energy-shield-equipment" then newEquip.shield = equip.shield end
			newEquip.energy = equip.energy
		end
		srcEnt.grid.clear()
	end
end

heli = {
	entityNames = {
		"heli-entity-_-",
		"heli-body-entity-_-",
		"heli-landed-collision-entity-_-",
		"heli-shadow-entity-_-",
		"heli-flying-collision-entity-_-",
		"heli-burner-entity-_-",
		"rotor-entity-_-",
		"rotor-shadow-entity-_-",
	},

	---------- default vals -----------
	valid = true,

	goUp = false,

	startupProgress = 0,
	height = 0,
	targetHeight = 0,
	maxHeight = 5,
	curBobbing = 0,

	heightSpeed = 0, 
	heightAcceleration = 0.001,

	maxHeightUperLimit = 20,
	maxHeightLowerLimit = 3,


	rotorOrient = 0,
	rotorRPF = 0,
	rotorTargetRPF = 0,
	rotorRPFacceleration = 0.0002,
	rotorMaxRPF = rotorMaxRPM/60/60, --revolutions per frame

	hasLandedCollider = false,
	landedColliderCreationDelay = 1, --frames. workaround for inserters trying to access collider inventory when created at the same time.
	------------------------------------------------------------

	new = function(ent)
		baseEnt = game.surfaces[1].create_entity{name = "heli-entity-_-", force = ent.force, position = ent.position}
		
		transferGridEquipment(ent, baseEnt)
		baseEnt.health = ent.health

		ent.destroy()

		local obj = {
			version = versionStrToInt(game.active_mods.Helicopters),

			oldBasePosition = {x = baseEnt.position.x + 1, y = 0}, --no idea why, but child entities are messed up if not teleported once after spawning

			lockedBaseOrientation = baseEnt.orientation,

			baseEnt = baseEnt,

			childs = {
				bodyEnt = game.surfaces[1].create_entity{name = "heli-body-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + bodyOffset}},
				rotorEnt = game.surfaces[1].create_entity{name = "rotor-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + rotorOffset}},

				bodyEntShadow = game.surfaces[1].create_entity{name = "heli-shadow-entity-_-", force = game.forces.neutral, position = baseEnt.position},
				rotorEntShadow = game.surfaces[1].create_entity{name = "rotor-shadow-entity-_-", force = game.forces.neutral, position = baseEnt.position},

				burnerEnt = game.surfaces[1].create_entity{name = "heli-burner-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + 1.3}},
			},
		}

		obj.baseEnt.effectivity_modifier = 0

		for k,v in pairs(obj.childs) do
			v.get_inventory(defines.inventory.fuel).insert({name = "coal", count = 50})
			v.destructible = false
		end

		setmetatable(obj, {__index = heli})

		obj:changeState(heli.landed)

		return obj
	end,

	destroy = function(self)
		self.valid = false
		
		if self.baseEnt and self.baseEnt.valid then
			--self.baseEnt.destroy()
		end

		for k,v in pairs(self.childs) do
			if v and v.valid then
				v.destroy()
			end
		end

		if self.burnerDriver and self.burnerDriver.valid then
			self.burnerDriver.destroy()
		end
	end,


	---------------- events ----------------

	OnTick = function(self)
		self:redirectPassengers()
		self:updateRotor()
		self:updateHeight()
		self:updateEntityPositions()
		self.curState.OnTick(self)
		self:handleColliderDamage()
	end,

	OnUp = function(self)
		self.curState.OnUp(self)
	end,

	OnDown = function(self)
		self:changeState(self.descend)
	end,

	OnIncreaseMaxHeight = function(self)
		self.maxHeight = math.min(self.maxHeightUperLimit, self.maxHeight + 1)
		self.curState.OnMaxHeightChanged(self)
	end,

	OnDecreaseMaxHeight = function(self)
		self.maxHeight = math.max(self.maxHeightLowerLimit, self.maxHeight - 1)
		self.curState.OnMaxHeightChanged(self)
	end, 


	---------------- states ----------------

	landed = basicState.new({
		init = function(heli)
			heli.baseEnt.effectivity_modifier = 0
			heli.baseEnt.friction_modifier = 50

			heli.lockedBaseOrientation = heli.baseEnt.orientation

			heli.landedColliderCreationDelay = 2
		end,

		OnTick = function(heli)
			if heli.landedColliderCreationDelay > 0 then
				if heli.landedColliderCreationDelay == 1 then
					heli:setCollider("landed")
					heli:updateEntityRotations()
				end

				heli.landedColliderCreationDelay = heli.landedColliderCreationDelay - 1
			end

			if heli.baseEnt.orientation ~= heli.lockedBaseOrientation then
				heli.baseEnt.orientation = heli.lockedBaseOrientation
			end

			if heli.baseEnt.speed > 0.25 then --54 km/h
				heli.baseEnt.damage(heli.baseEnt.speed*210, game.forces.neutral)

				if not heli.baseEnt.valid then
					return
				end
			end

			if heli.rotorAnimator and not heli.rotorAnimator.isDone then
				local isDone
				heli.rotorRPF, isDone = heli.rotorAnimator:nextFrame()

				if isDone then
					heli.rotorAnimator = nil
				end
			end
		end,

		OnUp = function(heli)
			heli:changeState(heli.engineStarting)
		end,
	}),

	engineStarting = basicState.new({
		init = function(heli)
			heli.lockedBaseOrientation = heli.baseEnt.orientation

			heli:setRotorTargetRPF(heli.rotorMaxRPF)

			if not (heli.burnerDriver and heli.burnerDriver.valid) then
				heli.burnerDriver = game.surfaces[1].create_entity{name="player", force = game.forces.neutral, position = heli.baseEnt.position}
				heli.childs.burnerEnt.passenger = heli.burnerDriver
			end
		end,

		OnTick = function(heli)
			if heli.baseEnt.orientation ~= heli.lockedBaseOrientation then
				heli.baseEnt.orientation = heli.lockedBaseOrientation
			end

			heli:consumeBaseFuel()
			heli:landIfEmpty()

			if heli.rotorRPF == heli.rotorMaxRPF then
				heli:changeState(heli.ascend)
			end
		end,
	}),

	ascend = basicState.new({
		init = function(heli)
			heli.baseEnt.effectivity_modifier = 1
			heli.baseEnt.friction_modifier = 1

			local time = heli:setTargetHeight(heli.maxHeight)
			heli.bobbingAnimator = basicAnimator.new(heli.curBobbing, 0, time*60, "linear")

			heli:setCollider("flying")
		end,

		OnTick = function(heli)
			heli:updateEntityRotations()
			heli:consumeBaseFuel()
			heli:landIfEmpty()

			if heli.bobbingAnimator and not heli.bobbingAnimator.isDone then
				heli.curBobbing = heli.bobbingAnimator:nextFrame()
			end
			
			if heli.height > maxCollisionHeight then
				heli:setCollider("none")
			end

			if heli.height == heli.maxHeight then
				heli:changeState(heli.hovering)
			end
		end,

		OnMaxHeightChanged = function(heli)
			heli:setTargetHeight(heli.maxHeight)
		end,
	}),

	hovering = basicState.new({
		init = function(heli)
			heli.bobbingAnimator = basicAnimator.new(0, maxBobbing, bobbingPeriod, "cyclicSine")
		end,

		OnTick = function(heli)
			heli:updateEntityRotations()
			heli:consumeBaseFuel()
			heli:landIfEmpty()

			local isDone
			heli.curBobbing, isDone = heli.bobbingAnimator:nextFrame()

			if isDone then
				heli.bobbingAnimator:reset()
			end
		end,

		OnMaxHeightChanged = function(heli)
			heli:setTargetHeight(heli.maxHeight)
		end,
	}),

	descend = basicState.new({
		init = function(heli)
			local time = heli:setTargetHeight(0)
			heli.bobbingAnimator = basicAnimator.new(heli.curBobbing, 0, time*60, "linear")
		end,

		OnTick = function(heli)
			heli:updateEntityRotations()
			heli:consumeBaseFuel()
			
			if heli.bobbingAnimator and not heli.bobbingAnimator.isDone then
				heli.curBobbing = heli.bobbingAnimator:nextFrame()
			end
			
			if heli.height <= maxCollisionHeight and not (heli.childs.collisionEnt and heli.childs.collisionEnt.valid) then
				heli:setCollider("flying")
			end

			if heli.height == 0 then
				heli:changeState(heli.engineStopping)
			end
		end,

		OnUp = function(heli)
			heli:changeState(heli.ascend)
		end,
	}),

	engineStopping = basicState.new({
		init = function(heli)
			heli.childs.burnerEnt.passenger = nil

			if heli.burnerDriver and heli.burnerDriver.valid then
				heli.burnerDriver.destroy()
				heli.burnerDriver = nil
			end

			heli:setRotorTargetRPF(0)

			heli:changeState(heli.landed)
		end,
	}),


	---------------- utility ---------------

	setTargetHeight = function(self, targetHeight)
		self.targetHeight = targetHeight
		return 60
	end,

	setRotorTargetRPF = function(self, targetRPF)
		self.rotorTargetRPF = targetRPF
	end,

	getAscendTime = function(height)
		return 4.5 - 4.5 / (height * 0.27 + 1)
	end,

	changeHeight = function(self, newHeight)
		local delta = newHeight - self.height
		local oldY = self.baseEnt.position.y

		self.baseEnt.teleport({x = self.baseEnt.position.x, y = self.baseEnt.position.y - delta})

		
		if newHeight == self.targetHeight then
			self.height = self.targetHeight

		else
			--cant just apply the delta, the height would not reflect the sum of teleports,
			--causing the shadow to move down.
			--probably because of precision loss from lua->c++ / double->float
			self.height = self.height + oldY - self.baseEnt.position.y
		end
	end,

	landIfEmpty = function(self)
		if not self.baseEnt.passenger or not self.baseEnt.passenger.valid or IsEntityBurnerOutOfFuel(self.baseEnt) then
			self:OnDown()
		end
	end,

	changeState = function(self, newState)
		--[[
		for k,v in pairs(heli) do
			if v == newState then
				printA("change state: " .. k)
				break
			end
		end
		]]

		self.previousState = self.curState

		if self.curState then
			self.curState.deinit(self)
		end

		self.curState = newState
		self.curState.init(self)
	end,

	redirectPassengers = function(self)
		for k,v in pairs(self.childs) do
			if v and v.passenger then
				if k == "burnerEnt" and self.burnerDriver then
					if v.passenger ~= self.burnerDriver then
						self.baseEnt.passenger = v.passenger
						v.passenger = self.burnerDriver
					end
				else
					local p = v.passenger
					v.passenger = nil
					self.baseEnt.passenger = p
				end
			end
		end
	end,

	setCollider = function(self, name)
		if self.childs.collisionEnt and self.childs.collisionEnt.valid then
			self.childs.collisionEnt.destroy()
			self.childs.collisionEnt = nil
			self.hasLandedCollider = false
		end

		if name == "landed" then
			self.childs.collisionEnt = game.surfaces[1].create_entity{
				name = "heli-landed-collision-entity-_-",
				force = game.forces.neutral,
				position = self.baseEnt.position,
			}
			self.hasLandedCollider = true

		elseif name == "flying" then
			self.childs.collisionEnt = game.surfaces[1].create_entity{
				name = "heli-flying-collision-entity-_-",
				force = game.forces.neutral,
				position = self.baseEnt.position,
			}
		end

		if self.childs.collisionEnt then
			self.childs.collisionEnt.get_inventory(defines.inventory.fuel).insert({name = "coal", count = 50})
			self.childs.collisionEnt.operable = false
		end
	end,

	handleColliderDamage = function(self)
		if self.childs.collisionEnt then
			if self.childs.collisionEnt.health ~= colliderMaxHealth then
				self.baseEnt.speed = self.childs.collisionEnt.speed
				self.baseEnt.damage(colliderMaxHealth - self.childs.collisionEnt.health, game.forces.neutral)

				if not self.baseEnt.valid then --destroy event might already be executed
					return false 
				end 
				self.childs.collisionEnt.health = colliderMaxHealth
			end
		end
		return true
	end,

	consumeBaseFuel = function(self)
		self.baseEnt.burner.remaining_burning_fuel = self.baseEnt.burner.remaining_burning_fuel - baseEngineConsumption

		if self.baseEnt.burner.remaining_burning_fuel <= 0 then
			if self.baseEnt.burner.inventory.is_empty() then
				local mod = self.baseEnt.effectivity_modifier
				self.baseEnt.effectivity_modifier = 0

				if self.baseEnt.passenger and self.baseEnt.passenger.valid then
					self.baseEnt.passenger.riding_state = {acceleration = defines.riding.acceleration.accelerating, direction = defines.riding.direction.straight}
				
				else	
					self.baseEnt.passenger = game.surfaces[1].create_entity{name = "player", force = self.baseEnt.force, position = self.baseEnt.position}
					self.baseEnt.passenger.riding_state = {acceleration = defines.riding.acceleration.accelerating, direction = defines.riding.direction.straight}
					self.baseEnt.passenger.destroy()
					self.baseEnt.passenger = nil
				end

				self.baseEnt.effectivity_modifier = mod
			else
				local fuelItemStack = nil
				for i = 1, #self.baseEnt.burner.inventory do
					if self.baseEnt.burner.inventory[i] and self.baseEnt.burner.inventory[i].valid_for_read then
						fuelItemStack = self.baseEnt.burner.inventory[i]
						break
					end
				end

				if fuelItemStack then
					self.baseEnt.burner.currently_burning = fuelItemStack.name
					self.baseEnt.burner.remaining_burning_fuel = fuelItemStack.prototype.fuel_value

					self.baseEnt.burner.inventory.remove({name = fuelItemStack.name})
				end
			end
		end

		if self.burnerDriver and self.burnerDriver.valid then
			self.burnerDriver.riding_state = {acceleration = defines.riding.acceleration.accelerating, direction = defines.riding.direction.straight}
			if self.childs.burnerEnt.burner.remaining_burning_fuel < 1000 then
				self.childs.burnerEnt.get_inventory(defines.inventory.fuel).insert({name = "coal", count = 1})
			end
		end
	end,

	updateRotor = function(self)
		if self.rotorRPF ~= self.rotorTargetRPF then
			if self.rotorRPF < self.rotorTargetRPF then
				self.rotorRPF = math.min(self.rotorRPF + self.rotorRPFacceleration, self.rotorTargetRPF)

			else
				self.rotorRPF = math.max(self.rotorRPF - self.rotorRPFacceleration, self.rotorTargetRPF)
			end
		end

		if self.rotorRPF > 0 then
			self.rotorOrient = self.rotorOrient + self.rotorRPF
			if self.rotorOrient > 1 then self.rotorOrient = self.rotorOrient - 1 end

			local frameFix = frameFixes[math.floor(self.rotorOrient * 64) + 1]
			self.childs.rotorEnt.orientation = frameFix
			self.childs.rotorEntShadow.orientation = frameFix
		end
	end,

	updateHeight = function(self)
		if self.height ~= self.targetHeight then
			local dir = 1
			if self.targetHeight < self.height then
				dir = -1
			end

			local desiredSpeed = (self.targetHeight - self.height) / 90 + dir * 0.005

			if self.heightSpeed < desiredSpeed then
				self.heightSpeed = math.min(self.heightSpeed + self.heightAcceleration, desiredSpeed)
			else
				self.heightSpeed = math.max(self.heightSpeed - self.heightAcceleration, desiredSpeed)
			end

			local newHeight = self.height + self.heightSpeed

			if fEqual(newHeight, self.targetHeight, 0.01) then
				self:changeHeight(self.targetHeight)
				self.heightSpeed = 0
			else
				self:changeHeight(newHeight)
			end
		end
	end,


	updateEntityPositions = function(self)
		local vec = math3d.vector2.mul(math3d.vector2.rotate({0,1}, math.pi * 2 * self.baseEnt.orientation), self.baseEnt.speed)

		self.childs.bodyEnt.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2] + bodyOffset - self.curBobbing})
		self.childs.rotorEnt.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2] + rotorOffset - self.curBobbing})
		
		self.childs.rotorEntShadow.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2] + self.height})
		self.childs.bodyEntShadow.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2] + self.height})


		if self.childs.collisionEnt then
			if not self.hasLandedCollider then
				local initVec = {0,1}
				local mul = 2
				if self.baseEnt.speed < 0 then
					initVec = {0,-1}
					local x = self.baseEnt.orientation
					mul = math.abs(math.sin(math.pi*2*x))*1.2 + math.sin(math.pi*x) + 3 --dont ask
				end

				vec = math3d.vector2.mul(math3d.vector2.rotate(initVec, math.pi * 2 * self.baseEnt.orientation), mul)
				self.childs.collisionEnt.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2]})
				self.childs.collisionEnt.speed = self.baseEnt.speed

			else
				self.childs.collisionEnt.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2]})
				self.childs.collisionEnt.speed = self.baseEnt.speed
			end
		end


		local off = (1 - math.sin(math.pi*self.baseEnt.orientation)) * 0.7
		local center = {x = self.baseEnt.position.x, y = self.baseEnt.position.y - off}
		local radius = 2
		snap = self.baseEnt.orientation
		snap = snap * (1 - math.sin(math.pi * snap)*0.05) 
		snap = math.abs(snap * 64) / 64
		local vec = math3d.vector2.mul(math3d.vector2.rotate({0,1}, math.pi * 2 * snap), radius)

		self.childs.burnerEnt.teleport({x = center.x + vec[1], y = center.y + vec[2] - self.curBobbing})
	end,

	updateEntityRotations = function(self)
		self.childs.bodyEnt.orientation = self.baseEnt.orientation
		self.childs.bodyEntShadow.orientation = self.baseEnt.orientation
		self.childs.burnerEnt.orientation = self.baseEnt.orientation

		if self.childs.collisionEnt then
			self.childs.collisionEnt.orientation = self.baseEnt.orientation
		end
	end,

	isBaseOrChild = function(self, ent)
		if self.baseEnt == ent then
			return true
		end

		for k,v in pairs(self.childs) do
			if v == ent then
				return true
			end
		end

		return false
	end,
}