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