data:extend({
  {
    type = "technology",
    name = "heli-remote-technology",
    icon = "__Helicopters__/graphics/icons/heli-remote-technology.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "heli-remote-recipe"
      },
      {
        type = "unlock-recipe",
        recipe = "heli-pad-recipe"
      },
    },
    prerequisites = {"heli-technology", "concrete", "advanced-electronics-2", "battery", "modular-armor"},
    unit =
    {
      count = 450,
      ingredients =
      {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 2},
        {"utility-science-pack", 2},
      },
      time = 35
    },
    order = "e-d"
  },
})