emptyBoxCollider =
{
	new = function(options)
		local obj =
		{
			_orientation = options.orientation or 0,
			surface = options.surface,
			position = getIndexedPos(options.position),
			force = options.force,

			boxHalfs = 
			{
				ends = options.boxLengths.ends / 2,
				sides = options.boxLengths.sides / 2
			},
			childColliders = {},
			childColliderOffsets = {},
		}

		if not obj.force then
			obj.force = game.forces.enemy
		end

		obj.childColliders.top = obj.surface.create_entity{
			name = options.nameEnds,
			force = obj.force,
			position = obj.position,
		}

		obj.childColliders.bottom = obj.surface.create_entity{
			name = options.nameEnds,
			force = obj.force,
			position = obj.position,
		}

		obj.childColliders.left = obj.surface.create_entity{
			name = options.nameSides,
			force = obj.force,
			position = obj.position,
		}

		obj.childColliders.right = obj.surface.create_entity{
			name = options.nameSides,
			force = obj.force,
			position = obj.position,
		}

		setmetatable(obj, emptyBoxCollider.mt)
		obj.setOrientation(obj._orientation)

		return obj
	end,

	destroy = function(self)
		for k,v in pairs(self.childColliders) do
			if v.valid then
				v.destroy()
			end
		end
	end,

	valid = function(self)
		local val = true

		for k,v in pairs(self.childColliders) do
			if not v.valid then
				val = false
				break
			end
		end

		if not val then
			self.destroy()
		end

		return val
	end,

	moveChildColliders = function(self)
		self.childColliders.top.teleport(math3d.vector2.add(self.position, self.childColliderOffsets.up))
		self.childColliders.bottom.teleport(math3d.vector2.sub(self.position, self.childColliderOffsets.up))

		self.childColliders.right.teleport(math3d.vector2.add(self.position, self.childColliderOffsets.right))
		self.childColliders.left.teleport(math3d.vector2.sub(self.position, self.childColliderOffsets.right))
	end,

	setOrientation = function(self, orient)
		self._orientation = orient

		self.childColliderOffsets.up = math3d.vector2.rotate({0,self.boxHalfs.sides}, math.pi * 2 * orient)
		self.childColliderOffsets.right = math3d.vector2.rotate({self.boxHalfs.ends,0}, math.pi * 2 * orient)

		for k,v in pairs(self.childColliders) do
			v.orientation = orient
		end

		self.moveChildColliders()
	end,

	teleport = function(self, pos)
		self.position = getIndexedPos(pos)

		self.moveChildColliders()
	end,

	getHealth = function(self)
		local lowest = self.childColliders.top.health

		for k,v in pairs(self.childColliders) do
			if v.health < lowest then
				lowest = v.health
			end
		end

		return lowest
	end,

	setHealth = function(self, health)
		for k,v in pairs(self.childColliders) do
			v.health = health
		end
	end,

	getSpeed = function(self)
		local highest = self.childColliders.top.speed

		for k,v in pairs(self.childColliders) do
			if v.speed > highest then
				speed = v.speed
			end
		end

		return highest
	end,

	setSpeed = function(self, speed)
		for k,v in pairs(self.childColliders) do
			v.speed = speed
		end
	end,

	setOperable = function(self, operable)
		for k,v in pairs(self.childColliders) do
			v.operable = operable
		end
	end,

	get_driver = function(self)
		for k,v in pairs(self.childColliders) do
			local driver = v.get_driver()
			if driver then
				return driver
			end
		end

		return nil
	end,

	set_driver = function(self, driver)
		if driver == nil then
			for k,v in pairs(self.childColliders) do
				v.set_driver(nil)
			end
		end
	end,

	get_passenger = function(self)
		for k,v in pairs(self.childColliders) do
			local passenger = v.get_passenger()
			if passenger then
				return passenger
			end
		end

		return nil
	end,

	set_passenger = function(self, passenger)
		if passenger == nil then
			for k,v in pairs(self.childColliders) do
				v.set_passenger(nil)
			end
		end
	end,

	isPosInside = function(self, pos)
		local delta = math3d.vector2.sub(getIndexedPos(pos), self.position)

		local tX = delta[1]
		local tY = delta[2]

		local up = math3d.vector2.mul(self.childColliderOffsets.up, 1.1)
		local right = math3d.vector2.mul(self.childColliderOffsets.right, 1.1)

		local b1X = up[1]
		local b1Y = up[2]

		local b2X = right[1]
		local b2Y = right[2]

		--https://i.imgur.com/zQrgq0B.png
		local a = (tY * b2X - tX * b2Y) / (b1Y * b2X - b1X * b2Y)
		local b = (tY * b1X - tX * b1Y) / (b2Y * b1X - b2X * b1Y)

		return math.abs(a) < 1 and math.abs(b) < 1, a, b
	end,

	ejectPlayers = function(self)
		local rad = math.ceil(math.sqrt(self.boxHalfs.ends^2 + self.boxHalfs.sides^2))
		local x = self.position[1]
		local y = self.position[2]

		local players = self.surface.find_entities_filtered{
			area = {{x - rad, y - rad}, {x + rad, y + rad}},
			name = "player",
		}

		for k, curPlayer in pairs(players) do
			local pos = getIndexedPos(curPlayer.position)
			local inside, a, b = self.isPosInside(pos)

			if inside then
				local deltaVec
				if math.abs(a) > math.abs(b) then
					local delta
					if a > 0 then
						delta = 1.2 - a
					else
						delta = -1.2 - a
					end

					deltaVec = math3d.vector2.mul(self.childColliderOffsets.up, delta)
				else
					local delta
					if b > 0 then
						delta = 1.2 - b
					else
						delta = -1.2 - b
					end
					
					deltaVec = math3d.vector2.mul(self.childColliderOffsets.right, delta)
				end

				curPlayer.teleport(math3d.vector2.add(pos, deltaVec))
			end
		end
	end,

	isChildEntity = function(self, ent)
		for k,v in pairs(self.childColliders) do
			printA(v.name)
			if v == ent then
				printA("yaa!!")
				return true
			end
		end

		return false
	end,
}

emptyBoxCollider.mt =
{
	__index = function(t, k)
		if k == "valid" then
			return emptyBoxCollider.valid(t)

		elseif k == "orientation" then
			return t._orientation

		elseif k == "health" then
			return emptyBoxCollider.getHealth(t)

		elseif k == "speed" then
			return emptyBoxCollider.getSpeed(t)

		elseif k == "get_inventory" then
			return function(...)
				local params = {...}
				return setmetatable({}, 
					{__index = function(_t, _k)
						return function(...)
							for key, curCol in pairs(t.childColliders) do
								curCol[k](unpack(params))[_k](...)
							end
						end
					end})
			end

		elseif type(emptyBoxCollider[k]) == "function" then
			return function(...)
				return emptyBoxCollider[k](t, ...)
			end

		else
			return emptyBoxCollider[k]
		end
	end,

	__newindex = function(t, k, v)
		if k == "orientation" then
			emptyBoxCollider.setOrientation(t, v)

		elseif k == "health" then
			emptyBoxCollider.setHealth(t, v)

		elseif k == "speed" then
			emptyBoxCollider.setSpeed(t, v)

		elseif k == "operable" then
			emptyBoxCollider.setOperable(t, v)
		end
	end,
}