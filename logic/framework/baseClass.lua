--[[
    Base Class to provide some standard object behaviour

    Usage:
        Create a prototype that will inherit from baseClass with baseClass.child
        In prototype.new you create an instance with baseClass.new

        The instance will have all its event listeners (__On<EventName>) subscribed to eventMgr
        It will get assigned the right metatable, any metamethods (__<metamethod>) will be assigned to the metatable
        During on_load, event listeners and the metatable will be reassigned to all instances stored in global (as they exist in the prototype)
]]

baseClass =
{
    valid = true,
    modVersion = nil,

    new = function(newInstance, prototype, noVersioning)
        mtMgr.set(newInstance, prototype.__classId)

        newInstance.__prototype = prototype
        eventMgr.subscribeInstanceEvents(newInstance)

        if not noVersioning then
            newInstance.__modVersion = getThisModVersion()
        end

        return newInstance
    end,

    child = function(classId, prototype)
        prototype.__classId = classId

        local mt = {__index = prototype}

        local metaFields = {"__eq", "__lt", "__le",
            "__tostring", "__index", "__newindex"}

        for k,v in pairs(metaFields) do
            if prototype[v] then
                mt[v] = prototype[v]
            end
        end

        mtMgr.assign(classId, mt)
        
        return setmetatable(prototype, {__index = baseClass})
    end,

    destroy = function(inst)
        eventMgr.unsubscribeInstanceEvents(inst)
        
        inst.valid = false
    end,
}

baseClass.super = baseClass
