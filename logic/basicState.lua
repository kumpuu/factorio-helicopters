basicState = 
{
	new = function(obj)
		return setmetatable(obj, basicState.mt)
	end,

	--placeholders to avoid errors when a state does not need them
	init = function() --becoming the active state
	end,

	deinit = function() --no longer the active state
	end,
	----
}

basicState.mt =
{
	__index = function(t, k)
		if basicState[k] then
			return basicState[k]

		elseif type(k) == "string" and k:match("^On.+") then
			return function()
			end
		end
	end,
}