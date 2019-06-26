eventMgr =
{
    events = {},
    subscribedGameEvents = {},

    subscribe = function(eventName, callback, id)
        local subs = make(eventMgr.events, eventName)

        if id then
            subs[tostring(id)] = callback

        else
            table.insert(subs, callback)
        end

        if defines.events[eventName] and eventName ~= "on_tick" then
            eventMgr.hookGameEvent(eventName, defines.events[eventName])
        end
    end,

    unsubscribe = function(eventName, id)
        if eventMgr.events[eventName] then
            eventMgr.events[eventName][id] = nil
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

    subscribeInstanceEvents = function(inst, prototype)
        for k, method in pairs(prototype) do
            if type(method) == "function" and k:match("^__[oO]n.+") then
                eventMgr.subscribe(k:sub(3), function(e) method(inst, e) end, tostring(inst))
            end
        end
    end,

    unsubscribeInstanceEvents = function(inst, prototype)
        for k, method in pairs(prototype) do
            if type(method) == "function" and k:match("^__[oO]n.+") then
                eventMgr.unsubscribe(k:sub(3), tostring(inst))
            end
        end
    end,

    hookGameEvent = function(eventName, eventId)
        if not eventMgr.subscribedGameEvents[eventName] then
            eventMgr.subscribedGameEvents[eventName] = true

            local gameEventCallback = function(e) 
                eventMgr.raise(eventName, e) 
            end
                
            script.on_event(eventId, gameEventCallback)
        end
    end,

    on_init = function(e)
        eventMgr.raise("on_init", e)
    end,

    on_load = function(e)
        eventMgr.raise("on_load", e)
    end,

    on_configuration_changed = function(e)
        eventMgr.raise("on_configuration_changed", e)
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

script.on_init(eventMgr.on_init)
script.on_load(eventMgr.on_load)
script.on_configuration_changed(eventMgr.on_configuration_changed)


-- Dirty trick to hook all custom inputs. They don't exist in defines.events so subscribe wouldn't do it.
__oldData = data
data = 
{
    extend = function(self, t)
        for k,v in pairs(t) do
            if v.type == "custom-input" then
                eventMgr.hookGameEvent(v.name, v.name)
            end
        end
    end
}
require("input.input")
data = __oldData