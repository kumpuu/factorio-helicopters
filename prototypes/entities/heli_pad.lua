data:extend({
  {
    type = "simple-entity-with-force",
    name = "heli-pad-placement-entity",
    flags = {"placeable-neutral", "player-creation"},
    icon = "__Helicopters__/graphics/icons/heli_pad.png",
    icon_size = 32,
    subgroup = "grass",
    order = "b[decorative]-k[stone-rock]-a[big]",
    collision_box = {{-3.5, -3.5}, {3.5, 3.5}},
    collision_mask = {"object-layer", "water-tile"},
    selection_box = {{-3.5, -3.5}, {3.5, 3.5}},

    minable =
    {
      mining_time = 2,
      result = "heli-pad-item",
      count = 1
    },

    count_as_rock_for_filtered_deconstruction = false,
    mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
    render_layer = "object",
    max_health = 200,
    resistances =
    {
      {
        type = "fire",
        percent = 100
      }
    },

    pictures =
    {
      {
        filename = "__Helicopters__/graphics/entities/heli_pad.png",
        width = 260,
        height = 260,
      },
    }
  },

  {
    type = "simple-entity-with-force",
    name = "heli-pad-entity",
    flags = {"placeable-neutral", "player-creation"},
    icon = "__Helicopters__/graphics/icons/heli_pad.png",
    icon_size = 32,
    subgroup = "grass",
    order = "b[decorative]-k[stone-rock]-a[big]",
    collision_box = {{-3.5, -3.5}, {3.5, 3.5}},
    collision_mask = {},--{"object-layer"},
    selection_box = {{-2, -2}, {2, 2}},
    
    minable =
    {
      mining_time = 2,
      result = "heli-pad-item",
      count = 1
    },

    count_as_rock_for_filtered_deconstruction = false,
    mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
    render_layer = "decorative",
    max_health = 200,
    resistances =
    {
      {
        type = "fire",
        percent = 100
      },
            {
        type = "physical",
        percent = 100
      },
      {
        type = "impact",
        percent = 100
      },
      {
        type = "explosion",
        percent = 90
      },
      {
        type = "acid",
        percent = 100
      }
    },

    pictures =
    {
      {
        filename = "__Helicopters__/graphics/entities/heli_pad_inner.png",
        width = 173,
        height = 172,
      },
    }
  },
})