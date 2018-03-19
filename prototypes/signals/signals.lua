data:extend(
{
	{
		type = "virtual-signal",
		name = "signal-heli-fuel-warning",
		icon = "__Helicopters__/graphics/icons/fuel_warning.png",
		icon_size = 32,
		subgroup = "virtual-signal-number",
		order = "e[warnings]-[1]"
	},

	{
		type = "virtual-signal",
		name = "signal-heli-fuel-warning-critical",
		icon = "__Helicopters__/graphics/icons/fuel_warning_critical.png",
		icon_size = 32,
		subgroup = "virtual-signal-number",
		order = "e[warnings]-[2]"
	},
})