function tableToString(table)
	local s = ""
	for k,v in pairs(table) do
		s = s .. type(v) .. " '" .. k .. "': " .. tostring(v) .. "\n"
	end
	return s
end

function printTable(t, prefix)
	if not prefix then
		prefix = ""
	end

	for k,v in pairs(t) do
		local typ = "[" .. type(v) .. "] "
		local name = "'" .. k .. "' ="
		local val = " " .. tostring(v)

		if type(v) == "table" then
			printA(prefix .. typ .. name)
			printTable(v, prefix .. "___")

		else
			printA(prefix .. typ .. name .. val)
		end
	end
end

function printA(...)
	local s = ""
	local n = select("#", ...)
	for i = 1, n do
		s = s .. tostring(select(i, ...))
		if i < n then 
			s = s .. ", "
		end
	end

	for k,v in pairs(game.players) do
		v.print(s)
	end

	return s
end

function printAF(...)
	local t = {...}
	table.insert(t, math.random())
	return printA(unpack(t))
end

function getDistance(pos1, pos2)
	return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2)
end

function equipmentGridHasItem(grid, itemName)
	local contents = grid.get_contents()
	return contents[itemName] and contents[itemName] > 0
end

function searchIndexInTable(table, obj, field)
	if table then
		for i, v in ipairs(table) do
			if field and v[field] == obj then
				return i
			elseif v == obj then
				return i
			end
		end
	end
end

function searchInTable(table, obj, field)
	if table then
		for k, v in pairs(table) do
			if field and v[field] == obj then
				return v
			elseif v == obj then
				return v
			end
		end
	end
end

function setMetatablesInGlobal(name, mt)
	if global[name] then
		for k, v in pairs(global[name]) do
			setmetatable(v, mt)
		end
	end
end

function checkAndTickInGlobal(name)
	if global[name] then
		for i = #global[name], 1, -1 do
			local v = global[name][i]

			if v.valid then
				v:OnTick()
			else
				table.remove(global[name], i)
			end
		end
	end
end

function callInGlobal(gName, kName, ...)
	if global[gName] then
		for k,v in pairs(global[gName]) do
			if v[kName] then v[kName](v, ...) end
		end
	end
end

function insertInGlobal(gName, val)
	if not global[gName] then global[gName] = {} end
	table.insert(global[gName], val)
	return val
end

function removeInGlobal(gName, val)
	if global[gName] then
		for i, v in ipairs(global[gName]) do
			if v == val then
				table.remove(global[gName], i)
				return v
			end
		end
	end
end

function fEqual(a, b, prec)
	if not prec then
		prec = 0.001
	end

	return math.abs(a - b) <= prec
end

function versionStrToInt(s)
	v = 0
	for num in s:gmatch("%d+") do
		v = v * 100 + tonumber(num)
	end

	return v
end

function concatStrTable(t, c)
	local s = ""
	for k,v in pairs(t) do
		s = s .. v .. c
	end

	return s
end

function getIndexedPos(pos)
	if pos[1] and pos[2] then
		return {pos[1], pos[2]}
	elseif pos.x and pos.y then
		return {pos.x, pos.y}
	end	
end

string.startswith = function(str, strSub)
  if str:len() < strSub:len() then
    return false
  end
  
  return str:sub(1, strSub:len()) == strSub
end

string.contains = function(str, strSub)
	return str:find(strSub, 1, true) ~= nil
end

function chopDecimal(val, place)
	local mult = 10^(place or 0)
	return math.floor(val * mult + 0.5) / mult
end

function getMaxStackFuelVal()
	if not _maxStackFuelVal then
		_maxStackFuelVal = 0
		local items = game.item_prototypes

		for k, curItem in pairs(items) do
			if curItem.fuel_category == "chemical" and curItem.fuel_value then
				_maxStackFuelVal = math.max(_maxStackFuelVal, curItem.stack_size * curItem.fuel_value)
			end
		end
	end

	return _maxStackFuelVal
end

function extractPlayer (obj)
	if obj and obj.valid then
		if obj.is_player() then
			return obj

		elseif obj.player and obj.player.valid and obj.player.is_player() then
			return obj.player
		end
	end

	return nil
end

function getCarPlayers(car)
	local d = extractPlayer(car.get_driver())
	local p = extractPlayer(car.get_passenger())

	local t = {}

	if d then
		table.insert(t, d)
	end

	if p then
		table.insert(t, p)
	end

	return t
end