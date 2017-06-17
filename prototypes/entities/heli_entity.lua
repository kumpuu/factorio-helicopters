data:extend({
	{
		type = "car",
		name = "heli-placement-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		flags = {"pushable", "placeable-off-grid", "player-creation"},
		minable = {mining_time = 1, result = "heli-item"},
		max_health = 2500,
		corpse = "medium-remnants",
		dying_explosion = "medium-explosion",
		selection_box = {{-1.8, -1.8}, {1.2, 3}},
		collision_mask = {},
		--collision_box ={{0,0},{0,0}},
		energy_per_hit_point = 1,
		effectivity = 0.3,
		breaking_speed = 0.03,
		burner = {
			effectivity = 0.5,
			emissions = 0,
			fuel_inventory_size = 4,
			
		},
		consumption = "3MW",
		braking_power = "1MW",
		friction = 0.002,
		terrain_friction_modifier = 0,
		weight = 3000,

		rotation_speed = 0.005,
		inventory_size = 4,

		animation = {
			layers = {
				{
					priority = "high",
					width = 360,
					height = 300,
					frame_count = 1,
					direction_count = 1,
					shift = {0, 0},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/heli/body-0.png",
							width_in_frames = 1,
							height_in_frames = 1,
						},
					}
				},

				{
					priority = "high",
					width = 360,
					height = 300,
					frame_count = 1,
					direction_count = 1,
					shift = {0, 0},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/heli/rotor-0.png",
							width_in_frames = 1,
							height_in_frames = 1,
						},
					}
				},	
			}
		},
	},













	---------------------base entity---------------------
	{
		type = "car",
		name = "heli-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		flags = {"pushable", "placeable-off-grid", "player-creation"},
		minable = {mining_time = 1, result = "heli-item"},
		max_health = 2500,
		corpse = "medium-remnants",
		dying_explosion = "medium-explosion",
		selection_box = {{-1.8, -1.8}, {1.2, 3}},
		collision_box = {{0,0},{0,0}},
		collision_mask = {},
		energy_per_hit_point = 1,
		effectivity = 0.3,
		breaking_speed = 0.03,
		burner = {
			effectivity = 0.5,
			emissions = 0.005,
			fuel_inventory_size = 5,
			
		},
		consumption = "3MW",
		braking_power = "1MW",
		friction = 0.002,
		terrain_friction_modifier = 0,
		weight = 3000,

		rotation_speed = 0.005,
		tank_driving = true,
		inventory_size = 80,

		animation = {
			layers = {
				{
					priority = "high",
					width = 1,
					height = 1,
					frame_count = 1,
					direction_count = 64,
					shift = {0, 0},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/heli/void.png",
							width_in_frames = 8,
							height_in_frames = 8,
						},
					}
				},
			}
		},

		--[[turret_animation =
	    {
	      layers =
	      {
	        {
	          filename = "__base__/graphics/entity/car/car-turret.png",
	          priority = "low",
	          line_length = 8,
	          width = 36,
	          height = 29,
	          frame_count = 1,
	          direction_count = 64,
	          shift = {0.03125, -0.890625},
	          animation_speed = 8,
	          hr_version =
	          {
	            priority = "low",
	            width = 71,
	            height = 57,
	            frame_count = 1,
	            axially_symmetrical = false,
	            direction_count = 64,
	            shift = {0, -1.05},
	            animation_speed = 8,
	            scale = 0.5,
	            stripes =
	            {
	              {
	                filename = "__base__/graphics/entity/car/hr-car-turret-1.png",
	                width_in_frames = 1,
	                height_in_frames = 32
	              },
	              {
	                filename = "__base__/graphics/entity/car/hr-car-turret-2.png",
	                width_in_frames = 1,
	                height_in_frames = 32
	              }
	            }
	          }
	        },
	        {
	          filename = "__base__/graphics/entity/car/car-turret-shadow.png",
	          priority = "low",
	          line_length = 8,
	          width = 46,
	          height = 31,
	          frame_count = 1,
	          draw_as_shadow = true,
	          direction_count = 64,
	          shift = {0.875, 0.359375}
	        }
	      }
	    },]]
	    sound_no_fuel =
	    {
		{
			filename = "__base__/sound/fight/tank-no-fuel-1.ogg",
			volume = 0.6
		},
	    },
	    open_sound = { filename = "__base__/sound/car-door-open.ogg", volume=0.7 },
    	close_sound = { filename = "__base__/sound/car-door-close.ogg", volume = 0.7 },
	    guns = {"tank-machine-gun", "heli-rocket-launcher-item"},
	    turret_rotation_speed = 0.35 / 60,

		
	},













----------------------flying collision--------------------
	{
		type = "car",
		name = "heli-flying-collision-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-item"},
		max_health = 999999,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
		collision_box = {{-1.8, -0.2}, {1.2, 0.2}},
		energy_per_hit_point = 1,
		effectivity = 0.3,
		breaking_speed = 0.03,
		burner = {
			effectivity = 0.5,
			emissions = 0,
			fuel_inventory_size = 1,
		},
		consumption = "1W",
		braking_power = "1W",
		friction = 0.002,
		terrain_friction_modifier = 0,
		weight = 3000,

		rotation_speed = 0.005,
		inventory_size = 0,

		animation = {
			layers = {
				{
					priority = "high",
					width = 1,
					height = 1,
					frame_count = 1,
					direction_count = 1,
					shift = {0, 0},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/heli/void.png",
							width_in_frames = 1,
							height_in_frames = 1,
						},
					}
				},
			}
		},

		crash_trigger = {
			type = "play-sound",
			sound =
			{
				{
				filename = "__base__/sound/car-crash.ogg",
				volume = 0.25
				},
			}
		},
		vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
	},











----------------------landed collision--------------------
	{
		type = "car",
		name = "heli-landed-collision-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-item"},
		max_health = 999999,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
		collision_box = {{-1.8, -1.8}, {1.2, 3}},
		energy_per_hit_point = 1,
		effectivity = 0.3,
		breaking_speed = 0.03,
		burner = {
			effectivity = 0.5,
			emissions = 0,
			fuel_inventory_size = 1,
		},
		consumption = "1W",
		braking_power = "1W",
		friction = 0.002,
		terrain_friction_modifier = 0,
		weight = 3000,

		rotation_speed = 0.005,
		inventory_size = 0,

		animation = {
			layers = {
				{
					priority = "high",
					width = 1,
					height = 1,
					frame_count = 1,
					direction_count = 1,
					shift = {0, 0},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/heli/void.png",
							width_in_frames = 1,
							height_in_frames = 1,
						},
					}
				},
			}
		},

		crash_trigger = {
			type = "play-sound",
			sound =
			{
				{
				filename = "__base__/sound/car-crash.ogg",
				volume = 0.25
				},
			}
		},
		vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
	},










	---------------body--------------
	{
		type = "car",
		name = "heli-body-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-item"},
		max_health = 1500,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
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
					shift = {0, -5},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/heli/body-0.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/heli/body-1.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/heli/body-2.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/heli/body-3.png",
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








	---------------shadow------------
	{
		type = "car",
		name = "heli-shadow-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-item"},
		max_health = 1500,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
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
					shift = {0, 0},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/heli/body_shadow-0.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/heli/body_shadow-1.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/heli/body_shadow-2.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/heli/body_shadow-3.png",
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








----------------------smoke and sound--------------------
	{
		type = "car",
		name = "heli-burner-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-item"},
		max_health = 999999,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
		energy_per_hit_point = 1,
		effectivity = 0.01,
		breaking_speed = 0.01,
		burner = {
			effectivity = 0.01,
			emissions = 0.002,
			fuel_inventory_size = 1,
			smoke =
			{
				{
					name = "heli-smoke",
					deviation = {0,0},
					frequency = 200,
					position = {-1, 0},
					starting_frame = 0,
					starting_frame_deviation = 60
				},
				{
					name = "heli-smoke",
					deviation = {0,0},
					frequency = 200,
					position = {0.45, 0},
					starting_frame = 0,
					starting_frame_deviation = 60
				}
			}
		},
		consumption = "1W",
		braking_power = "1W",
		friction = 1,
		terrain_friction_modifier = 0,
		weight = 9999,

		rotation_speed = 0.005,
		inventory_size = 0,

		animation = {
			layers = {
				{
					priority = "high",
					width = 1,
					height = 1,
					frame_count = 1,
					direction_count = 1,
					shift = {0, 0},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/heli/void.png",
							width_in_frames = 1,
							height_in_frames = 1,
						},
					}
				},
			}
		},

		working_sound = {
			sound = {
				filename = "__Helicopters__/sound/heli_loop.ogg",
				volume = 0.6
			},
			activate_sound = {
				filename = "__Helicopters__/sound/heli_startup.ogg",
				volume = 0.6
			},
			deactivate_sound = {
				filename = "__Helicopters__/sound/heli_shutdown.ogg",
				volume = 0.6
			},
			--match_speed_to_activity = true,
		},
	},
})