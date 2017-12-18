data.raw["gui-style"].default["heli-listbox_button"] =
{
  type = "button_style",
  parent = "button",
  font = "default-bold",
  align = "left",
  scalable = true,

  height = 23,

  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 5,

  left_click_sound =
  {
    {
      filename = "__core__/sound/list-box-click.ogg",
      volume = 1
    }
  },

  default_font_color={r=1, g=1, b=1},
  default_graphical_set =
  {
    type = "composition",
    filename = "__Helicopters__/graphics/gui/black.png",
    priority = "extra-high-no-scale",
    corner_size = {0, 0},
    position = {0, 0}
  },

  hovered_font_color={r=1, g=1, b=1},
  hovered_graphical_set =
  {
    type = "composition",
    filename = "__Helicopters__/graphics/gui/grey.png",
    priority = "extra-high-no-scale",
    corner_size = {0, 0},
    position = {0, 0}
  },

  clicked_font_color = {r=0, g=0, b=0},
  clicked_graphical_set =
  {
    type = "composition",
    filename = "__Helicopters__/graphics/gui/orange.png",
    priority = "extra-high-no-scale",
    corner_size = {0, 0},
    position = {0, 0}
  },
}

data.raw["gui-style"].default["heli-clear_text_button"] =
{
  type = "button_style",
  parent = "button",
  scalable = true,

  width = 15,
  height = 15,

  top_padding = 4,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0,

  default_graphical_set =
  {
    type = "monolith",
    --monolith_border = 1,
    monolith_image =
    {
      filename = "__Helicopters__/graphics/icons/clear-text.png",
      priority = "extra-high-no-scale",
      width = 15,
      height = 15
    },
    stretch_monolith_image_to_size = false
  },

  hovered_graphical_set =
  {
    type = "monolith",
    --monolith_border = 1,
    monolith_image =
    {
      filename = "__Helicopters__/graphics/icons/clear-text.png",
      priority = "extra-high-no-scale",
      width = 15,
      height = 15,
      x = 15,
    },
    stretch_monolith_image_to_size = false
  },

  clicked_graphical_set =
  {
    type = "monolith",
    --monolith_border = 1,
    monolith_image =
    {
      filename = "__Helicopters__/graphics/icons/clear-text.png",
      priority = "extra-high-no-scale",
      width = 15,
      height = 15,
      x = 30,
    },
    stretch_monolith_image_to_size = false
  },
}