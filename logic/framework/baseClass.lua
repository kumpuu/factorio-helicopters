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

    childs = {},

    new = function(newInstance, prototype, noVersioning)
        newInstance.__classId = prototype.__classId

        setmetatable(newInstance, baseClass.childs[prototype.__classId].metatable)
        eventMgr.subscribeInstanceEvents(newInstance, prototype)

        if not noVersioning then
            newInstance.__modVersion = getThisModVersion()
        end

        return newInstance
    end,

    extend = function(prototype)
        local mt = {__index = prototype}

        local metaFields = {"__eq", "__lt", "__le",
            "__tostring", "__index", "__newindex"}

        for k,v in pairs(metaFields) do
            if prototype[v] then
                mt[v] = prototype[v]
            end
        end

        assert(prototype.__classId, "baseClass.lua: prototype must have field __classId")
        assert(not baseClass.childs[prototype.__classId], "baseClass.lua: " .. prototype.__classId .. " does already exist")

        baseClass.childs[prototype.__classId] = {prototype = prototype, metatable = mt}
        
        return setmetatable(prototype, {__index = baseClass})
    end,

    destroy = function(inst)
        eventMgr.unsubscribeInstanceEvents(inst, baseClass.childs[inst.__classId].prototype)
        
        inst.valid = false
    end,

    getPrototype = function(classId)
        return baseClass.childs[classId].prototype
    end,
}

baseClass.super = baseClass

eventMgr.subscribe("on_load", function(e)
    tableCrawler.crawl(global, function(t)
        local classId = t.__classId or t.__mtMgr_type

        if classId then
            local classMeta = baseClass.childs[classId]

            if classMeta then
                setmetatable(t, classMeta.metatable)
                eventMgr.subscribeInstanceEvents(t, classMeta.prototype)
            end
        end
    end)
end)
