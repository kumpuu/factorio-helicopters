data:extend({
    {
        type = "item",
        name = "heli-remote-equipment",
        icon = "__Helicopters__/graphics/icons/heli-remote-icon.png",
        icon_size = 32,
        placed_as_equipment_result = "heli-remote-equipment",
        flags = {"goes-to-main-inventory"},
        subgroup = "equipment",
        order = "g[heli-remote]-a[heli-remote-item]",
        stack_size = 1,
        default_request_amount = 1,
    },
    {
        type = "item",
        name = "heli-pad-item",
        icon = "__Helicopters__/graphics/icons/heli_pad.png",
        icon_size = 32,
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "b[personal-transport]-d[heli-pad-item]",
        place_result = "heli-pad-placement-entity",
        stack_size = 10
    },
})

