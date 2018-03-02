data:extend({
  {
    type = "sprite",
    name = "heli_to_player",
    filename = "__Helicopters__/graphics/icons/to_player.png",
    priority = "medium",
    width = 64,
    height = 64,
    flags = {"icon"},
  },

  {
    type = "sprite",
    name = "heli_to_map",
    filename = "__Helicopters__/graphics/icons/map.png",
    priority = "medium",
    width = 64,
    height = 64,
    flags = {"icon"},
  },

  {
    type = "sprite",
    name = "heli_to_pad",
    filename = "__Helicopters__/graphics/icons/to_pad.png",
    priority = "medium",
    width = 64,
    height = 64,
    flags = {"icon"},
  },

  {
    type = "sprite",
    name = "heli_stop",
    filename = "__Helicopters__/graphics/icons/stop.png",
    priority = "medium",
    width = 64,
    height = 64,
    flags = {"icon"},
  },

  {
    type = "sprite",
    name = "heli_gui_selected",
    filename = "__Helicopters__/graphics/gui/selected.png",
    priority = "medium",
    width = 400,
    height = 400,
    flags = {"icon"},
  },

  {
    type = "sprite",
    name = "heli_search_icon",
    filename = "__Helicopters__/graphics/icons/search-icon.png",
    priority = "medium",
    width = 15,
    height = 15,
    shift = {-17, 1},
    --scale = 0.5,
    flags = {"icon"},
  },

  {
    type = "sprite",
    name = "heli_void_128",
    filename = "__Helicopters__/graphics/gui/gauges/void_128.png",
    priority = "medium",
    width = 128,
    height = 128,
    --flags = {"icon"},
  },

  {
    type = "sprite",
    name = "heli_gauge_fs",
    filename = "__Helicopters__/graphics/gui/gauges/gauge_fs.png",
    priority = "medium",
    width = 128,
    height = 128,
    --flags = {"icon"},
  },

  {
    type = "sprite",
    name = "heli_gauge_fs_led_fuel",
    filename = "__Helicopters__/graphics/gui/gauges/gauge_fs_led_fuel.png",
    priority = "medium",
    width = 128,
    height = 128,
    --flags = {"icon"},
  },

  {
    type = "sprite",
    name = "heli_gauge_hr",
    filename = "__Helicopters__/graphics/gui/gauges/gauge_hr.png",
    priority = "medium",
    width = 128,
    height = 128,
    --flags = {"icon"},
  },
})

gauge_pointers = {}

for i = 0, 127 do
	table.insert(gauge_pointers, {
		type = "sprite",
	    name = "heli_gauge_pointer_" .. tostring(i),
	    filename = "__Helicopters__/graphics/gui/gauges/pointers/pointer-" .. tostring(i) .. ".png",
	    priority = "medium",
	    width = 128,
	    height = 128,
	})
end

data:extend(gauge_pointers)