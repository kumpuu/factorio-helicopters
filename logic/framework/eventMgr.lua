eventMgr =
{
    events = {},
    eventIds = {},
    subscribedGameEvents = {},

    subscribe = function(eventName, callback, id)
        local subs = make(eventMgr.events, eventName)

        if id then
            subs[tostring(id)] = callback

        else
            table.insert(subs, callback)
        end

        if eventName ~= "on_tick" and 
            defines.events[eventName] and 
            not eventMgr.subscribedGameEvents[eventName] then

            eventMgr.subscribedGameEvents[eventName] = true

            local gameEventCallback = function(e) eventMgr.raise(eventName, e) end

            if eventName == "on_init" then
                script.on_init(gameEventCallback)

            elseif eventName == "on_load" then
                script.on_load(gameEventCallback)

            elseif eventName == "on_configuration_changed" then
                script.on_configuration_changed(gameEventCallback)
                
            else
                script.on_event(defines.events[eventName], gameEventCallback)
            end
        end
    end,

    unsubscribe = function(eventName, id)
        if eventMgr[eventName] then
            eventMgr[eventName][id] = nil
        end
    end,

    raise = function(eventName, e)
        if type(e) == "table" and not e.name then 
            e.name = eventName 
        end

        if eventMgr.events[eventName] then
            for k, curCallback in pairs(eventMgr.events[eventName]) do
                curCallback(e)
            end
        end
    end,

    getEventId = function(eventName)
        local evts = eventMgr.eventIds
    
        if type(eventName) == "string" then
            if eventName:match("^(__)?[oO]n.+") then
                if evts[eventName] then
                    return evts[eventName]
                else
                    return make(evts, eventName, script.generate_event_name())
                end
            else
                return nil
            end
        end
    
        return eventName
    end,

    registerInstanceEvents = function(inst, prototype)
        for k, method in pairs(prototype) do
            if type(method) == "function" and k:match("^__[oO]n.+") then
                printA("register " .. k)
                eventMgr.subscribe(k:sub(3), function(e) method(inst, e) end)
            end
        end
    end,

    on_tick = function(e)
        if __firstTick then
            eventMgr.raise("on_load_done", e)
            __firstTick = false
        end

        eventMgr.raise("on_tick", e)
    end,
}

__firstTick = true
script.on_event(defines.events.on_tick, eventMgr.on_tick)

--[[event ids are not valid after game load anymore so we have to regenerate them
eventMgr.subscribe("OnLoadDone", function(e)
    if globals.eventIds then
        for k, v in pairs(global.eventIds) do
            global.eventIds[k] = script.generate_event_name()
        end
    end
end)
]]