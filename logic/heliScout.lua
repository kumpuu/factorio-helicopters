heliScout =
{
	type = "heliScout",
	bodyOffset = 5,
	rotorOffset = 5.1,
			
	new = function(placementEnt)
		local baseEnt = placementEnt.surface.create_entity{name = "heli-scout-entity-_-", force = placementEnt.force, position = placementEnt.position}

		local childs =
		{
			bodyEnt = placementEnt.surface.create_entity{name = "heli-scout-body-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + heliAttack.bodyOffset}},
			rotorEnt = placementEnt.surface.create_entity{name = "heli-scout-rotor-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + heliAttack.rotorOffset}},

			bodyEntShadow = placementEnt.surface.create_entity{name = "heli-scout-shadow-entity-_-", force = game.forces.neutral, position = baseEnt.position},
			rotorEntShadow = placementEnt.surface.create_entity{name = "heli-scout-rotor-shadow-entity-_-", force = game.forces.neutral, position = baseEnt.position},

			burnerEnt = placementEnt.surface.create_entity{name = "heli-scout-burner-entity-_-", force = game.forces.neutral, position = {x = baseEnt.position.x, y = baseEnt.position.y + 1.3}},
		
			floodlightEnt = placementEnt.surface.create_entity{name = "heli-scout-floodlight-entity-_-", force = game.forces.neutral, position = baseEnt.position},
		}

		return heliBase.new(placementEnt, baseEnt, childs, {__index = heliScout})
	end,
}

setmetatable(heliScout, {__index = heliBase})

heliEntityNames = heliEntityNames .. concatStrTable({
	"heli-scout-entity-_-",
	"heli-scout-body-entity-_-",
	"heli-scout-landed-collision-end-entity-_-",
	"heli-scout-landed-collision-side-entity-_-",
	"heli-scout-shadow-entity-_-",
	"heli-scout-flying-collision-entity-_-",
	"heli-scout-burner-entity-_-",
	"heli-scout-floodlight-entity-_-",
	"heli-scout-rotor-entity-_-",
	"heli-scout-rotor-shadow-entity-_-",
}, ",")

heliBaseEntityNames = heliBaseEntityNames .. "heli-scout-entity-_-" .. ","