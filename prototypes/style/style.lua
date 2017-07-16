data.raw["gui-style"].default["listbox_button_style"] =
{
  type = "button_style",
  parent = "button_style",
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
      filename = "__core__/sound/listbox-click.ogg",
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