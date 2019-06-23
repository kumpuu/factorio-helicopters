eventMgr.subscribe("on_load_done", function(e)
    local v1 = versionNumber.new("1.0.0")
    local v2 = versionNumber.new("1.0.1")
    local v3 = versionNumber.new("0.1.9")

    assert(v1 == v1, "versionNumber eq fail")
    assert(v1 < v2, "versionNumber lt fail")
    assert(v1 > v3, "versionNumber gt fail")
    assert(v1 <= v1, "versionNumber le fail")
    assert(v3 <= v1, "versionNumber le fail")

    printA("[tests.lua]: All tests passed")
end)