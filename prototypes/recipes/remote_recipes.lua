data:extend({
	{
		type = "recipe",
		name = "heli-remote-recipe",
		enabled = false,
		ingredients = {
			{"processing-unit", 35},
			{"battery", 20},
			{"plastic-bar", 20},
			{"rocket-control-unit", 2},
			{"iron-stick", 2},
		},
		result = "heli-remote-equipment",
	},
	{
		type = "recipe",
		name = "heli-pad-recipe",
		enabled = false,
		ingredients = {
			{"concrete", 50},
		},
		result = "heli-pad-item",
	},
})