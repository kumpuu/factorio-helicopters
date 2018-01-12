local math3d = require("math3d")

function by_pixel(t)
  return {t[1]/32,t[2]/32}
end

local fuel_slots = 4
local inventory_slots = 50
local namePre = "heli-scout-"

---------------------------
local dim =
{
	chassis = {304,244},
	chassisShadow = {332,228},

	gun = {104,80},
	gunShadow = {108,78},

	rotor = {202,140},
	rotorShadow = {198,140},
}

local dimHr = {}
for k,v in pairs(dim) do
	dimHr[k] = math3d.vector2.mul(v, 2)
end
dim.hr = dimHr

---------------------------

local off = {chassis = {0,0}}
off.chassisShadow = math3d.vector2.add(off.chassis, {35,50})

off.gun = math3d.vector2.add(off.chassis, {0,25})
off.gunShadow = math3d.vector2.add(off.gun, {5,8})

off.rotor = math3d.vector2.add(off.chassis, {0,-17})
off.rotorShadow = math3d.vector2.add(off.rotor, {50,73})

offHr = {}
for k,v in pairs(off) do
	offHr[k] = by_pixel(v)
	off[k] = by_pixel(v)
end
off.hr = offHr


off.chassis[2] = off.chassis[2] - 5
off.rotor[2] = off.rotor[2] - 5.1
off.rotorShadow[2] = off.rotorShadow[2] - 0.1

off.hr.chassis[2] = off.hr.chassis[2] - 5
off.hr.rotor[2] = off.hr.rotor[2] - 5.1
off.hr.rotorShadow[2] = off.hr.rotorShadow[2] - 0.1
---------------------------

data:extend({
	{
		type = "car",
		name = namePre .. "placement-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli-scout.png",
		icon_size = 32,
		flags = {"pushable", "placeable-off-grid", "player-creation"},
		has_belt_immunity = true,
		minable = {mining_time = 1, result = "heli-scout-item"},
		max_health = 2500,
		corpse = "medium-remnants",
		dying_explosion = "medium-explosion",
		selection_box = {{-1.5, -1.8}, {0.9, 3}},
		collision_box = {{-1.5, -1.8}, {0.9, 3}},
		collision_mask = {"object-layer", "water-tile", "player-layer"},
		energy_per_hit_point = 1,
		effectivity = 0.3,
		breaking_speed = 0.03,
		burner = {
			effectivity = 0.5,
			emissions = 0,
			fuel_inventory_size = 0,
			
		},
		consumption = "3MW",
		braking_power = "1MW",
		friction = 0.002,
		terrain_friction_modifier = 0,
		weight = 3000,

		rotation_speed = 0.005,
		inventory_size = 0,

		animation = {
			layers = {
				{
					priority = "high",
					width = dim.chassis[1],
					height = dim.chassis[2],
					frame_count = 1,
					direction_count = 1,
					shift = {off.chassis[1], off.chassis[2] + 5},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Chassis_Lo-0.png",
							width_in_frames = 1,
							height_in_frames = 1,
						},
					},

					hr_version = 
					{
						priority = "high",
						width = dim.hr.chassis[1],
						height = dim.hr.chassis[2],
						frame_count = 1,
						direction_count = 1,
						shift = {off.hr.chassis[1], off.hr.chassis[2] + 5},
						animation_speed = 8,
						max_advance = 0.2,
						stripes =
						{
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Chassis_Hi-0.png",
								width_in_frames = 1,
								height_in_frames = 1,
							},
						},
						scale = 0.5,
					},
				},

				{
					priority = "high",
					width = dim.rotor[1],
					height = dim.rotor[2],
					frame_count = 1,
					direction_count = 1,
					shift = {off.rotor[1], off.rotor[2] + 5.1},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Rotor_Lo-0.png",
							width_in_frames = 1,
							height_in_frames = 1,
						},
					},

					hr_version = 
					{
						priority = "high",
						width = dim.hr.rotor[1],
						height = dim.hr.rotor[2],
						frame_count = 1,
						direction_count = 1,
						shift = {off.hr.rotor[1], off.hr.rotor[2] + 5.1},
						animation_speed = 8,
						max_advance = 0.2,
						stripes =
						{
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Rotor_Hi-0.png",
								width_in_frames = 1,
								height_in_frames = 1,
							},
						},
						scale = 0.5,
					},
				},	
			}
		},
	},












	---------------------base entity---------------------
	{
		type = "car",
		name = namePre .. "entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		icon_size = 32,
		flags = {"pushable", "placeable-off-grid", "player-creation"},
		has_belt_immunity = true,
		minable = {mining_time = 1, result = "heli-scout-item"},
		max_health = 1500,
		corpse = "medium-remnants",
		dying_explosion = "medium-explosion",
		selection_box = {{-1.8, -1.8}, {1.2, 3}},
		collision_box = {{-1.8, -1.8}, {1.2, 3}},
		collision_mask = {},
		energy_per_hit_point = 1,
		effectivity = 0.3,
		breaking_speed = 0.05,
		burner = {
			effectivity = 0.66,
			emissions = 0.003,
			fuel_inventory_size = fuel_slots,
			
		},
		consumption = "2.2MW",
		braking_power = "1MW",
		friction = 0.002,
		terrain_friction_modifier = 0,
		weight = 1500,

		rotation_speed = 0.005,
		tank_driving = true,
		inventory_size = inventory_slots,

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
							filename = "__Helicopters__/graphics/void.png",
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
	    guns = {"tank-machine-gun"},
	    turret_rotation_speed = 1 / 60,
	},













----------------------flying collision--------------------
	{
		type = "car",
		name = namePre .. "flying-collision-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-scout-item"},
		has_belt_immunity = true,
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
							filename = "__Helicopters__/graphics/void.png",
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
		name = namePre .. "landed-collision-side-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-scout-item"},
		has_belt_immunity = true,
		max_health = 999999,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
		collision_box = {{-0.1, -2.4}, {0.1, 2.4}}, --{{-0.1, -1.8}, {0.1, 3}},
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
							filename = "__Helicopters__/graphics/void.png",
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

	{
		type = "car",
		name = namePre .. "landed-collision-end-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		icon_size = 32,
		flags = {"not-on-map"},
		has_belt_immunity = true,
		minable = {mining_time = 1, result = "heli-scout-item"},
		max_health = 999999,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
		collision_box = {{-1.5, -0.1}, {1.5, 0.1}}, --{{-1.8, -0.1}, {1.2, 0.1}} --{{-1.8, -1.8}, {1.2, 3}}
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
							filename = "__Helicopters__/graphics/void.png",
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
		name = namePre .. "body-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-scout-item"},
		has_belt_immunity = true,
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
					width = dim.chassis[1],
					height = dim.chassis[2],
					frame_count = 1,
					direction_count = 64,
					shift = off.chassis,
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Chassis_Lo-0.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Chassis_Lo-1.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Chassis_Lo-2.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Chassis_Lo-3.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
					},

					hr_version = 
					{
						priority = "high",
						width = dim.hr.chassis[1],
						height = dim.hr.chassis[2],
						frame_count = 1,
						direction_count = 64,
						shift = off.hr.chassis,
						animation_speed = 8,
						max_advance = 0.2,
						stripes =
						{
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Chassis_Hi-0.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Chassis_Hi-1.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Chassis_Hi-2.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Chassis_Hi-3.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
						},
						scale = 0.5,
					},
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
		name = namePre .. "shadow-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-scout-item"},
		has_belt_immunity = true,
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
					width = dim.chassisShadow[1],
					height = dim.chassisShadow[2],
					frame_count = 1,
					draw_as_shadow = true,
					direction_count = 64,
					shift = off.chassisShadow,
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/ChassisShadow_Lo-0.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/ChassisShadow_Lo-1.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/ChassisShadow_Lo-2.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/ChassisShadow_Lo-3.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
					},

					hr_version = 
					{
						priority = "very-low",
						width = dim.hr.chassisShadow[1],
						height = dim.hr.chassisShadow[2],
						frame_count = 1,
						draw_as_shadow = true,
						direction_count = 64,
						shift = off.hr.chassisShadow,
						animation_speed = 8,
						max_advance = 0.2,
						stripes =
						{
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/ChassisShadow_Hi-0.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/ChassisShadow_Hi-1.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/ChassisShadow_Hi-2.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/ChassisShadow_Hi-3.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
						},
						scale = 0.5,
					},
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
		name = namePre .. "burner-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-scout-item"},
		has_belt_immunity = true,
		max_health = 999999,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
		collision_box = {{0,0},{0,0}},
		collision_mask = {},
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
					frequency = 120,
					position = {0, 0.1},
					starting_frame = 0,
					starting_frame_deviation = 60
				},
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
							filename = "__Helicopters__/graphics/void.png",
							width_in_frames = 1,
							height_in_frames = 1,
						},
					}
				},
			}
		},

		working_sound = {
			sound = {
				filename = "__Helicopters__/sound/scout_loop.ogg",
				volume = 0.6
			},
			activate_sound = {
				filename = "__Helicopters__/sound/scout_startup.ogg",
				volume = 0.6
			},
			deactivate_sound = {
				filename = "__Helicopters__/sound/scout_shutdown.ogg",
				volume = 0.6
			},
			--match_speed_to_activity = true,
		},
	},






----------------------flashlight--------------------
	{
		type = "car",
		name = namePre .. "floodlight-entity-_-",
		icon = "__Helicopters__/graphics/icons/heli.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-scout-item"},
		has_belt_immunity = true,
		max_health = 999999,
		corpse = "medium-remnants",
		selection_box = {{0,0},{0,0}},
		collision_box = {{0,0},{0,0}},
		collision_mask = {},
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
							filename = "__Helicopters__/graphics/void.png",
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

		light =
	    {
	      {
	        type = "oriented",
	        minimum_darkness = 0.3,
	        picture =
	        {
	          filename = "__core__/graphics/light-cone.png",
	          priority = "extra-high",
	          flags = { "light" },
	          scale = 2.5,
	          width = 200,
	          height = 200
	        },
	        shift = {-0.3, -20},
	        size = 2.5,
	        intensity = 0.6,
	        color = {r = 0.92, g = 0.77, b = 0.3}
	      },
	    },
	},



	----------------------ROTOR---------------
	{
		type = "car",
		name = namePre .. "rotor-entity-_-",
		icon = "__base__/graphics/icons/car.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-scout-item"},
		has_belt_immunity = true,
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
					width = dim.rotor[1],
					height = dim.rotor[2],
					frame_count = 1,
					direction_count = 64,
					shift = off.rotor,
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Rotor_Lo-0.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Rotor_Lo-1.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Rotor_Lo-2.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/Rotor_Lo-3.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
					},

					hr_version = 
					{
						priority = "high",
						width = dim.hr.rotor[1],
						height = dim.hr.rotor[2],
						frame_count = 1,
						direction_count = 64,
						shift = off.hr.rotor,
						animation_speed = 8,
						max_advance = 0.2,
						stripes =
						{
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Rotor_Hi-0.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Rotor_Hi-1.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Rotor_Hi-2.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/Rotor_Hi-3.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
						},
						scale = 0.5,
					},
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
		name = namePre .. "rotor-shadow-entity-_-",
		icon = "__base__/graphics/icons/car.png",
		icon_size = 32,
		flags = {"not-on-map"},
		minable = {mining_time = 1, result = "heli-scout-item"},
		has_belt_immunity = true,
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
					width = dim.rotorShadow[1],
					height = dim.rotorShadow[2],
					frame_count = 1,
					draw_as_shadow = true,
					direction_count = 64,
					shift = off.rotorShadow,
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/RotorShadow_Lo-0.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/RotorShadow_Lo-1.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/RotorShadow_Lo-2.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
						{
							filename = "__Helicopters__/graphics/entities/heli_scout/RotorShadow_Lo-3.png",
							width_in_frames = 4,
							height_in_frames = 4,
						},
					},

					hr_version = 
					{
						priority = "very-low",
						width = dim.hr.rotorShadow[1],
						height = dim.hr.rotorShadow[2],
						frame_count = 1,
						draw_as_shadow = true,
						direction_count = 64,
						shift = off.hr.rotorShadow,
						animation_speed = 8,
						max_advance = 0.2,
						stripes =
						{
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/RotorShadow_Hi-0.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/RotorShadow_Hi-1.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/RotorShadow_Hi-2.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
							{
								filename = "__Helicopters__/graphics/entities/heli_scout/hr/RotorShadow_Hi-3.png",
								width_in_frames = 4,
								height_in_frames = 4,
							},
						},
						scale = 0.5,
					},
				},
			}
		},
		inventory_size = 0,
		rotation_speed = 0.005,
		weight = 50,
	},
})
