versionNumber = baseClass.child("versionNumber", {
    new = function(strVersion)
        local obj = baseClass.new({
            version = versionNumber.versionStrToTable(strVersion)
        }, versionNumber, true)

        return obj
    end,

    versionStrToTable = function(v)
        local t = {}
    
        for num in v:gmatch("%d+") do
            table.insert(t, num)
        end
    
        return t
    end,

    compareVersions = function(t1, t2)
        if #t1 ~= #t2 then
            return nil
        end

        for i = 1, #t1 do
            if t1[i] > t2[i] then
                return 1
            end

            if t1[i] < t2[i] then
                return -1
            end
        end

        return 0
    end,

    __eq = function(v1, v2)
        return (versionNumber.compareVersions(v1.version, v2.version) == 0)
    end,

    __lt = function(v1, v2)
        return (versionNumber.compareVersions(v1.version, v2.version) < 0)
    end,

    __le = function(v1, v2)
        return (versionNumber.compareVersions(v1.version, v2.version) <= 0)
    end,
})