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
    prerequisites = {"automobilism", "flying"},
    unit =
    {
      count = 400,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 2},
      },
      time = 30
    },
    order = "e-d"
  },
})