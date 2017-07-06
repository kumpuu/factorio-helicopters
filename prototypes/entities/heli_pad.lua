data:extend({
  {
    type = "simple-entity",
    name = "heli-pad-placement-entity",
    flags = {"placeable-neutral", "player-creation"},
    icon = "__base__/graphics/icons/stone-rock.png",
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
    type = "simple-entity",
    name = "heli-pad-entity",
    flags = {"placeable-neutral", "player-creation"},
    icon = "__base__/graphics/icons/stone-rock.png",
    subgroup = "grass",
    order = "b[decorative]-k[stone-rock]-a[big]",
    collision_box = {{-3.5, -3.5}, {3.5, 3.5}},
    collision_mask = {"object-layer"},
    selection_box = {{-3.5, -3.5}, {3.5, 3.5}},

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

 {
    type = "tile",
    name = "heli-pad-concrete",
    needs_correction = false,
    mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
    collision_mask = {"ground-tile"},
    walking_speed_modifier = 1.4,
    layer = 61,
    decorative_removal_probability = 0.25,
    variants =
    {
      main =
      {
        {
          picture = "__base__/graphics/terrain/concrete/concrete1.png",
          count = 16,
          size = 1
        },
        {
          picture = "__base__/graphics/terrain/concrete/concrete2.png",
          count = 4,
          size = 2,
          probability = 0.39,
        },
        {
          picture = "__base__/graphics/terrain/concrete/concrete4.png",
          count = 4,
          size = 4,
          probability = 1,
        },
      },
      inner_corner =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-inner-corner.png",
        count = 32
      },
      outer_corner =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-outer-corner.png",
        count = 16
      },
      side =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-side.png",
        count = 16
      },
      u_transition =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-u.png",
        count = 16
      },
      o_transition =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-o.png",
        count = 1
      }
    },
    walking_sound =
    {
      {
        filename = "__base__/sound/walking/concrete-01.ogg",
        volume = 1.2
      },
      {
        filename = "__base__/sound/walking/concrete-02.ogg",
        volume = 1.2
      },
      {
        filename = "__base__/sound/walking/concrete-03.ogg",
        volume = 1.2
      },
      {
        filename = "__base__/sound/walking/concrete-04.ogg",
        volume = 1.2
      }
    },
    map_color={r=100, g=100, b=100},
    ageing=0,
    vehicle_friction_modifier = concrete_vehicle_speed_modifier
  },
})