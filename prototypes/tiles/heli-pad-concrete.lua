require("util")

local heliConcrete = table.deepcopy(data.raw.tile["refined-concrete"])
heliConcrete.name = "heli-pad-concrete"
heliConcrete.minable = {hardness = 0.2, mining_time = 0.5}
heliConcrete.decorative_removal_probability = 1

data:extend({heliConcrete})