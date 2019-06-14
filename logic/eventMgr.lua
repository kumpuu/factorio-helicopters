eventMgr =
{
    events = {},
    gameEvents = {},

    subscribe = function(eventName, callback, id)
        if eventName == "on_tick" then
            script.on_event(defines.events.on_tick, callback) --performance

        elseif eventName == "on_load" then
            script.on_load(callback)

        elseif eventName == "on_configuration_changed" then
            script.on_configuration_changed(callback)

        else
            local subs = make(eventMgr.events, eventName)

            if id then
                subs[tostring(id)] = callback
    
            else
                table.insert(subs, callback)
            end
    
            if defines.events[eventName] and not eventMgr.gameEvents[eventName] then
                eventMgr.gameEvents.eventName = true
                script.on_event(defines.events[eventName], function(e) eventMgr.trigger(eventName, e) end)
            end
        end
    end,

    unsubscribe = function(eventName, id)
        if eventMgr[eventName] then
            eventMgr[eventName][id] = nil
        end
    end,

    trigger = function(eventName, e)
        if not e.name then e.name = eventName end

        if eventMgr.events[eventName] then
            for k, curCallback in pairs(eventMgr.events[eventName]) do
                curCallback(e)
            end
        end
    end,
}