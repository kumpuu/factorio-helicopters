data:extend({
    {
        type = "bool-setting",
        name = "heli-auto-focus-searchfields",
        setting_type = "runtime-per-user",
        default_value = false,
    },

    {
        type = "bool-setting",
        name = "heli-deactivate-inserters",
        setting_type = "runtime-global",
        default_value = true,
    },

    {
        type = "double-setting",
        name = "heli-gui-heliSelection-defaultZoom",
        setting_type = "runtime-per-user",
        default_value = 0.3,
        minimum_value = 0.2,
        maximum_value = 1.26,
    },

    {
        type = "double-setting",
        name = "heli-gui-heliPadSelection-defaultZoom",
        setting_type = "runtime-per-user",
        default_value = 0.2,
        minimum_value = 0.025,
        maximum_value = 1.0125,
    },
})