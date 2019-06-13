data:extend({
	{
	type = "gun",
	name = "heli-rocket-launcher-item",
	icon = "__Helicopters__/graphics/icons/rocket_pod.png",
	icon_size = 32,
	flags = {},
	subgroup = "gun",
	order = "d[rocket-launcher]",
	attack_parameters =
	{
		type = "projectile",
		ammo_category = "rocket",
		movement_slow_down_factor = 1.2,
		cooldown = 20,
		projectile_creation_distance = 0.6,
		range = 30,
		projectile_center = {-0.17, 0},
		sound =
		{
			{
				filename = "__base__/sound/fight/rocket-launcher.ogg",
				volume = 0.7
			}
		}
	},
	stack_size = 50
	},
})