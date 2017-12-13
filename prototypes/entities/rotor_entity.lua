data:extend({
	{
		type = "car",
		name = "rotor-entity-_-",
		icon = "__base__/graphics/icons/car.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-item"},
		max_health = 1500,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
		collision_box = {{0,0},{0,0}},
		collision_mask = {},
		energy_per_hit_point = 1,
		effectivity = 0.5,
		braking_power = "100kW",
		breaking_speed = 0.03,
		burner = {
			effectivity = 1,
			emissions = 0,
			fuel_inventory_size = 1,
		},
		consumption = "100kW",
		friction = 0.01,

		animation = {
			layers = {
				{
					priority = "high",
					width = 360,
					height = 300,
					frame_count = 1,
					direction_count = 64,
					shift = {0, -5.1},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/entities/heli/rotor-0.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli/rotor-1.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli/rotor-2.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli/rotor-3.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
					}
				},		
			}
		},
		inventory_size = 0,
		rotation_speed = 0.005,
		weight = 50,
	},
	------------shadow------------------
	{
		type = "car",
		name = "rotor-shadow-entity-_-",
		icon = "__base__/graphics/icons/car.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-item"},
		max_health = 1500,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
		collision_box = {{0,0},{0,0}},
		collision_mask = {},
		energy_per_hit_point = 1,
		effectivity = 0.5,
		braking_power = "100kW",
		breaking_speed = 0.03,
		burner = {
			effectivity = 1,
			emissions = 0,
			fuel_inventory_size = 1,
		},
		consumption = "100kW",
		friction = 0.01,

		animation = {
			layers = {
				{
					priority = "very-low",
					width = 360,
					height = 300,
					frame_count = 1,
					draw_as_shadow = true,
					direction_count = 64,
					shift = {0, -0.1},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/entities/heli/rotor_shadow-0.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli/rotor_shadow-1.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli/rotor_shadow-2.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli/rotor_shadow-3.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
					}
				},
			}
		},
		inventory_size = 0,
		rotation_speed = 0.005,
		weight = 50,
	}
})