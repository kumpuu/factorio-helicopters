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
    prerequisites = {"heli-technology", "concrete", "advanced-electronics-2", "battery", "rocket-silo"},
    unit =
    {
      count = 450,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 2},
        {"high-tech-science-pack", 2},
      },
      time = 35
    },
    order = "e-d"
  },
})