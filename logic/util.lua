function tableToString(table)
	local s = ""
	for k,v in pairs(table) do
		s = s .. "'" .. k .. "': " .. tostring(v) .. "\n"
	end
	return s
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
end

function getDistance(pos1, pos2)
	return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2)
end

function equipmentGridHasItem(grid, itemName)
	local contents = grid.get_contents()
	return contents[itemName] and contents[itemName] > 0
end

function callInGlobal(gName, kName, ...)
	if global[gName] then
		for k,v in pairs(global[gName]) do
			if v[kName] then v[kName](v, ...) end
		end
	end
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