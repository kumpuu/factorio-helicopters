data:extend({
    {
        type = "gun",
        name = "heli-gun",
        icon = "__base__/graphics/icons/submachine-gun.png",
        icon_size = 32,
        flags = {"hidden"},
        subgroup = "gun",
        order = "a[basic-clips]-b[tank-machine-gun]",
        attack_parameters =
        {
          type = "projectile",
          ammo_category = "bullet",
          cooldown = 4,
          damage_modifier = 1,
          movement_slow_down_factor = 0.7,
          shell_particle =
          {
            name = "shell-particle",
            direction_deviation = 0.1,
            speed = 0.1,
            speed_deviation = 0.03,
            center = {0, 0},
            creation_distance = -0.6875,
            starting_frame_speed = 0.4,
            starting_frame_speed_deviation = 0.1
          },
          projectile_center = {-0.15625, -0.07812},
          projectile_creation_distance = 1,
          range = 20,
          sound = make_heavy_gunshot_sounds()
        },
        stack_size = 1
    }
})