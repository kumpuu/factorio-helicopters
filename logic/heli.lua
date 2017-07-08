local math3d = require("math3d")

function getHeliFromBaseEntity(ent)
	for k,v in pairs(global.helis) do
		if v.baseEnt == ent then
			return v
		end
	end

	return nil
end

local frameFixes = {
	0, --1	
	0.015625, --2	
	0.046875, --3	
	0.0625, --4	
	0.078125, --5	
	0.109375, --6	
	0.125, --7	
	0.140625, --8	
	0.15625, --9	
	0.171875, --10	
	0.1796875, --11	
	0.1875, --12	
	0.203125, --13	
	0.21875, --14	
	0.2265625, --15	
	0.234375, --16	
	0.25, --17	
	0.265625, --18	
	0.2734375, --19	
	0.28125, --20	
	0.296875, --21	
	0.3125, --22	
	0.3203125, --23	
	0.328125, --24	
	0.34375, --25	
	0.359375, --26	
	0.375, --27	
	0.390625, --28	
	0.40625, --29	
	0.4375, --30	
	0.453125, --31	
	0.46875, --32	
	0.5, --33	
	0.515625, --34	
	0.546875, --35	
	0.5625, --36	
	0.578125, --37	
	0.609375, --38	
	0.625, --39	
	0.640625, --40	
	0.65625, --41	
	0.671875, --42	
	0.6796875, --43	
	0.6875, --44	
	0.703125, --45	
	0.71875, --46	
	0.7265625, --47	
	0.734375, --48	
	0.75, --49	
	0.765625, --50	
	0.7734375, --51	
	0.78125, --52	
	0.796875, --53	
	0.8125, --54	
	0.8203125, --55	
	0.828125, --56	
	0.84375, --57	
	0.859375, --58	
	0.875, --59	
	0.890625, --60	
	0.90625, --61	
	0.9375, --62	
	0.953125, --63
	0.984375, --64
}

local versionStrToInt = function(s)
	v = 0
	for num in s:gmatch("%d+") do
		v = v * 100 + tonumber(num)
	end

	return v
end

--local modVersion = versionStrToInt(game.active_mods.Helicopters)

local rotorMaxRPM = 200
local startupTime = 5*60 --5 seconds
local heightPF = 2/60 --2 tiles per second
local maxHeight = 5
local maxCollisionHeight = 2
local colliderMaxHealth = 999999
local baseEngineConsumption = 20000

local bodyOffset = 5
local rotorOffset = 5.1


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

	---------- fallback vals for old version objects -----------
	landedColliderCreationDelay = 0,
	valid = true,
	------------------------------------------------------------

	new = function(ent)
		baseEnt = game.surfaces[1].create_entity{name = "heli-entity-_-", force = ent.force, position = ent.position}
		
		transferGridEquipment(ent, baseEnt)
		baseEnt.health = ent.health

		ent.destroy()

		local obj = {
			valid = true,
			version = versionStrToInt(game.active_mods.Helicopters),

			oldBasePosition = baseEnt.position,

			lockedBaseOrientation = baseEnt.orientation,

			goUp = false,

			startupProgress = 0,
			height = 0,

			rotorOrient = 0,
			rotorRPF = 0,
			rotorMaxRPF = rotorMaxRPM/60/60, --revolutions per frame

			hasLandedCollider = false,
			landedColliderCreationDelay = 1, --frames. workaround for inserters trying to access collider inventory when created at the same time.

			baseEnt = baseEnt,

			childs = {
				bodyEnt = game.surfaces[1].create_entity{name = "heli-body-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + bodyOffset}},
				rotorEnt = game.surfaces[1].create_entity{name = "rotor-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + rotorOffset}},

				bodyEntShadow = game.surfaces[1].create_entity{name = "heli-shadow-entity-_-", force = game.forces.neutral, position = baseEnt.position},
				rotorEntShadow = game.surfaces[1].create_entity{name = "rotor-shadow-entity-_-", force = game.forces.neutral, position = baseEnt.position},

				--collisionEnt = game.surfaces[1].create_entity{name = "heli-landed-collision-entity-_-", force = game.forces.neutral, position = baseEnt.position},

				burnerEnt = game.surfaces[1].create_entity{name = "heli-burner-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + 1.3}},
			},
		}

		obj.baseEnt.effectivity_modifier = 0

		for k,v in pairs(obj.childs) do
			v.get_inventory(defines.inventory.fuel).insert({name = "coal", count = 50})
			v.destructible = false
		end

		--obj.childs.collisionEnt.destructible = true

		return setmetatable(obj, {__index = heli})
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

	handleFuel = function(self)
		if IsEntityBurnerOutOfFuel(self.baseEnt) then
			self.goUp = false
		end
	end,

	handleCollider = function(self)
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

	updateFlightState = function(self)
		if self.height == 0 then
			if self.baseEnt.orientation ~= self.lockedBaseOrientation then
				self.baseEnt.orientation = self.lockedBaseOrientation
			end
		else
			self.childs.bodyEnt.orientation = self.baseEnt.orientation
			self.childs.bodyEntShadow.orientation = self.baseEnt.orientation
			self.childs.burnerEnt.orientation = self.baseEnt.orientation

			if self.childs.collisionEnt then
				self.childs.collisionEnt.orientation = self.baseEnt.orientation
			end
		end

		if self.height == 0 and self.baseEnt.speed > 0.25 then
			self.baseEnt.damage(self.baseEnt.speed * 150, game.forces.neutral)

			if not self.baseEnt.valid then --destroy event might already be executed
				return false 
			end
		end

		if self.height ~= 0 or self.baseEnt.speed ~= 0 then
			local off = (1 - math.sin(math.pi*self.baseEnt.orientation)) * 0.7
			local center = {x = self.baseEnt.position.x, y = self.baseEnt.position.y - off}
			local radius = 2
			snap = self.baseEnt.orientation
			snap = snap * (1 - math.sin(math.pi * snap)*0.05) 
			snap = math.abs(snap * 64) / 64
			local vec = math3d.vector2.mul(math3d.vector2.rotate({0,1}, math.pi * 2 * snap), radius)

			self.childs.burnerEnt.teleport({x = center.x + vec[1], y = center.y + vec[2]})
		end

		if self.oldBasePosition ~= self.baseEnt.position then --baseEnt moved
			local vec = math3d.vector2.mul(math3d.vector2.rotate({0,1}, math.pi * 2 * self.baseEnt.orientation), self.baseEnt.speed)

			self.childs.bodyEnt.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2] + bodyOffset})
			self.childs.rotorEnt.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2] + rotorOffset})
			
			self.childs.rotorEntShadow.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2] + self.height})
			self.childs.bodyEntShadow.teleport({x = self.baseEnt.position.x - vec[1], y = self.baseEnt.position.y - vec[2] + self.height})


			if self.childs.collisionEnt and not self.hasLandedCollider then
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
			end

			self.oldBasePosition = self.baseEnt.position
		end

		if self.goUp and (not self.baseEnt.passenger or not self.baseEnt.passenger.valid) then
			self.goUp = false
		end

		if self.goUp then
			if not self.burnerDriver then
				self.burnerDriver = game.surfaces[1].create_entity{name="player", force = game.forces.neutral, position = self.baseEnt.position}
				self.childs.burnerEnt.passenger = self.burnerDriver
			end


			self.baseEnt.burner.remaining_burning_fuel = self.baseEnt.burner.remaining_burning_fuel - baseEngineConsumption

			if self.baseEnt.burner.remaining_burning_fuel <= 0 then
				if self.baseEnt.burner.inventory.is_empty() then
					local mod = self.baseEnt.effectivity_modifier
					self.baseEnt.effectivity_modifier = 0
					self.baseEnt.passenger.riding_state = {acceleration = defines.riding.acceleration.accelerating, direction = defines.riding.direction.straight}
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

			self.burnerDriver.riding_state = {acceleration = defines.riding.acceleration.accelerating, direction = defines.riding.direction.straight}
			if self.childs.burnerEnt.burner.remaining_burning_fuel < 1000 then
				self.childs.burnerEnt.get_inventory(defines.inventory.fuel).insert({name = "coal", count = 1})
			end


			if self.rotorRPF < self.rotorMaxRPF then
				self.rotorRPF = math.min(self.rotorRPF + 0.0002, self.rotorMaxRPF)
			end

			if self.startupProgress < startupTime then
				self.startupProgress = math.min(self.startupProgress + 1, startupTime)
			end

			if self.startupProgress == startupTime and self.height < maxHeight then
				self.baseEnt.effectivity_modifier = 1
				self.baseEnt.friction_modifier = 1

				local delta = heightPF
				if self.height + delta > maxHeight then
					delta = maxHeight - self.height
				end

				local oldY = self.baseEnt.position.y

				self.baseEnt.teleport({x = self.baseEnt.position.x, y = self.baseEnt.position.y - delta})

				self.height = self.height + oldY - self.baseEnt.position.y --cant apply delta directly to height or it diverges for some reason

				if self.hasLandedCollider then
					self.hasLandedCollider = false
					self.childs.collisionEnt.destroy()
					self.childs.collisionEnt = game.surfaces[1].create_entity{
						name = "heli-flying-collision-entity-_-",
						force = game.forces.neutral,
						position = self.baseEnt.position,
						orientation = self.baseEnt.orientation
					}
					self.childs.collisionEnt.get_inventory(defines.inventory.fuel).insert({name = "coal", count = 50})
				end

				if self.height > maxCollisionHeight and self.childs.collisionEnt then
					self.childs.collisionEnt.destroy()
					self.childs.collisionEnt = nil
				end
			end
		else
			if self.burnerDriver then
				self.childs.burnerEnt.passenger = nil
				self.burnerDriver.destroy()
				self.burnerDriver = nil
			end

			if self.rotorRPF > 0 then
				self.rotorRPF = math.max(self.rotorRPF - 0.0002, 0)
			end

			if self.height > 0 then
				local delta = heightPF
				if self.height < delta then
					delta = self.height
				end

				local oldY = self.baseEnt.position.y

				self.baseEnt.teleport({x = self.baseEnt.position.x, y = self.baseEnt.position.y + delta})
				
				self.height = self.height + oldY - self.baseEnt.position.y --cant apply delta directly to height or it diverges for some reason

				if self.height <= maxCollisionHeight and not self.childs.collisionEnt then
					self.childs.collisionEnt = game.surfaces[1].create_entity{name = "heli-flying-collision-entity-_-", force = game.forces.neutral, position = self.baseEnt.position}
					self.childs.collisionEnt.get_inventory(defines.inventory.fuel).insert({name = "coal", count = 50})
				end

				if self.height == 0 then
					self.lockedBaseOrientation = self.baseEnt.orientation
					self.baseEnt.effectivity_modifier = 0
					self.baseEnt.friction_modifier = 50
				end
			end

			if self.height == 0 then
				if self.startupProgress > 0 then
					self.startupProgress = math.max(self.startupProgress - 1, 0)
				end
				if self.baseEnt.speed == 0 and not self.hasLandedCollider then
					if self.landedColliderCreationDelay > 0 then 
						self.landedColliderCreationDelay = self.landedColliderCreationDelay - 1
					else
						self.hasLandedCollider = true
						if self.childs.collisionEnt and self.childs.collisionEnt.valid then
							self.childs.collisionEnt.destroy()
						end

						self.childs.collisionEnt = game.surfaces[1].create_entity{
							name = "heli-landed-collision-entity-_-",
							force = game.forces.neutral,
							position = self.baseEnt.position,
							orientation = self.baseEnt.orientation
						}
						self.childs.collisionEnt.get_inventory(defines.inventory.fuel).insert({name = "coal", count = 50})
						self.childs.collisionEnt.operable = false
					end
				end
			end
		end

		return true
	end,

	updateRotor = function(self)
		if self.rotorRPF > 0 then
			self.rotorOrient = self.rotorOrient + self.rotorRPF
			if self.rotorOrient > 1 then self.rotorOrient = self.rotorOrient - 1 end

			local frameFix = frameFixes[math.floor(self.rotorOrient * 64) + 1]
			self.childs.rotorEnt.orientation = frameFix
			self.childs.rotorEntShadow.orientation = frameFix
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

	OnTick = function(self)
		if not self:handleCollider() then
			return
		end

		self:handleFuel()
		self:redirectPassengers()

		if not self:updateFlightState() then
			return
		end

		self:updateRotor()
	end,

	 
	OnUp = function(self)
		if not IsEntityBurnerOutOfFuel(self.baseEnt) then
			self.goUp = true
		end
	end,

	OnDown = function(self)
		self.goUp = false
	end,
}
