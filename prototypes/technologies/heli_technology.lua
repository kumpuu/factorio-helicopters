data:extend({
  {
    type = "technology",
    name = "heli-technology",
    icon = "__Helicopters__/graphics/icons/heli-technology.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "heli-recipe"
      },
    },
    prerequisites = {"automobilism", "advanced-electronics-2", "turrets", "rocketry"},
    unit =
    {
      count = 400,
      ingredients =
      {
						{"automation-science-pack", 1},
						{"logistic-science-pack", 1},
						{"chemical-science-pack", 2},
      },
      time = 30
    },
    order = "e-d"
  },
})