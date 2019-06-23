--Metatable manager v1.1 by kumpu
--Takes care of reassigning metatables during load.
--Use for tables stored in global.

-------Basic usage--------
-- mtMgr.assign on file level
-- mtMgr.set in your constructor
-- mtMgr.OnLoad in script.on_load

mtMgr =
{
	--It's worth noting that this table gets rebuilt everytime the mod is loaded,
	--which allows updating metatables.
	assignments = {},


	--Use this at the file level to assign a metatable to a type identifier.
	--The given metatable will be used on objects of this type in OnLoad and set.
	assign = function(strType, metatable)
		mtMgr.assignments[strType] = metatable
	end,


	--This will set the metatable assigned in assign() and save the type identifier to the object.
	set = function(obj, strType)
		obj.__mtMgr_type = strType
		return setmetatable(obj, mtMgr.assignments[strType])
	end,


	crawl = function(t, f, lookup)
		if not lookup then
			lookup = {}
		end

		lookup[t] = true

		--Reading nil fields on game tables will trigger an error.
		--This works for now.
		if not t.__self then
			f(t)

			for k,v in pairs(t) do
				if type(v) == "table" and not lookup[v] then
					mtMgr.crawl(v, f, lookup)
				end
			end
		end
	end,


	--Call this in script.on_load.
	--Walks the entire global table or the one you passed. If it encounters a table with a type identifier,
	--it sets the metatable assigned to the type on that table.
	--Circular references are safe.
	OnLoad = function(t)
		t = t or global

		mtMgr.crawl(global, function(t)
			local mt = mtMgr.assignments[t.__mtMgr_type]
			if mt then
				setmetatable(t, mt)
			end
		end)
	end,
}