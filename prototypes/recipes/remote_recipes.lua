data:extend({
	{
		type = "recipe",
		name = "heli-remote-recipe",
		enabled = false,
		energy_required = 15,
		ingredients = {
			{"processing-unit", 125},
			{"battery", 50},
			{"plastic-bar", 40},
			{"iron-stick", 2},
		},
		result = "heli-remote-equipment",
	},
	{
		type = "recipe",
		name = "heli-pad-recipe",
		enabled = false,
		energy_required = 5,
		ingredients = {
			{"refined-concrete", 50},
		},
		result = "heli-pad-item",
	},
})