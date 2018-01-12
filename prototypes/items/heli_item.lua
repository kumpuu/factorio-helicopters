data:extend({
	{
		type = "item-with-entity-data",
		name = "heli-item",
		icon = "__Helicopters__/graphics/icons/heli.png",
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "transport",
		order = "b[personal-transport]-c[heli]",
		place_result = "heli-placement-entity-_-",
		stack_size = 1
	},

	{
		type = "item-with-entity-data",
		name = "heli-scout-item",
		icon = "__Helicopters__/graphics/icons/heli-scout.png",
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "transport",
		order = "b[personal-transport]-c[heli]",
		place_result = "heli-scout-placement-entity-_-",
		stack_size = 1
	},
})