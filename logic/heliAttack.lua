heliAttack =
{
	type = "heliAttack",
	bodyOffset = 5,
	rotorOffset = 5.1,

	rotorRPFacceleration = 0.0002,
	rotorMaxRPF = 240/60/60, --revolutions per frame

	engineReduction = 7.5,

	fuelSlots = 5,
			
	new = function(placementEnt)
		local baseEnt = placementEnt.surface.create_entity{name = "heli-entity-_-", force = placementEnt.force, position = placementEnt.position}

		local childs =
		{
			bodyEnt = placementEnt.surface.create_entity{name = "heli-body-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + heliAttack.bodyOffset}},
			rotorEnt = placementEnt.surface.create_entity{name = "rotor-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + heliAttack.rotorOffset}},

			bodyEntShadow = placementEnt.surface.create_entity{name = "heli-shadow-entity-_-", force = game.forces.neutral, position = baseEnt.position},
			rotorEntShadow = placementEnt.surface.create_entity{name = "rotor-shadow-entity-_-", force = game.forces.neutral, position = baseEnt.position},

			burnerEnt = placementEnt.surface.create_entity{name = "heli-burner-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + 1.3}},
		
			floodlightEnt = placementEnt.surface.create_entity{name = "heli-floodlight-entity-_-", force = game.forces.neutral, position = baseEnt.position},
		}

		return heliBase.new(placementEnt, baseEnt, childs, {__index = heliAttack})
	end,
}

setmetatable(heliAttack, {__index = heliBase})

heliEntityNames = heliEntityNames .. concatStrTable({
	"heli-entity-_-",
	"heli-body-entity-_-",
	"heli-landed-collision-end-entity-_-",
	"heli-landed-collision-side-entity-_-",
	"heli-shadow-entity-_-",
	"heli-flying-collision-entity-_-",
	"heli-burner-entity-_-",
	"heli-floodlight-entity-_-",
	"rotor-entity-_-",
	"rotor-shadow-entity-_-",
}, ",")

heliBaseEntityNames = heliBaseEntityNames .. "heli-entity-_-" .. ","