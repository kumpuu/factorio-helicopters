data:extend({
    {
        type = "bool-setting",
        name = "heli-deactivate-inserters",
        setting_type = "runtime-global",
        default_value = true,
    },

    {
        type = "double-setting",
        name = "heli-crash-dmg-mult",
        setting_type = "runtime-global",
        default_value = 1,
        minimum_value = 0,
    },

    ----------------------------------------------

    {
        type = "bool-setting",
        name = "heli-auto-focus-searchfields",
        setting_type = "runtime-per-user",
        default_value = false,
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

    {
        type = "bool-setting",
        name = "heli-gaugeGui-show",
        setting_type = "runtime-per-user",
        default_value = true,
    },

    {
        type = "bool-setting",
        name = "heli-gaugeGui-play-fuel-warning-sound",
        setting_type = "runtime-per-user",
        default_value = true,
    },

    {
        type = "bool-setting",
        name = "heli-fuel-alert",
        setting_type = "runtime-per-user",
        default_value = false,
    },
})