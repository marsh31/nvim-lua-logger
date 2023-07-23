-- NAME:   utils.lua
-- AUTHOR: marsh
-- NOTE:
--
-- output message to logfile
--

local levels = {
    " INFO",
    " WARN",
    "ERROR",
    "DEBUG",
    "TRACE",
}

M = {}
M.day = function()
    return os.date("%Y-%m-%d")
end

M.time = function()
    return os.date("%H:%M:%S")
end

M.level = function(level)
    if level <= #levels then
        return levels[level]
    else
        return ""
    end
end

M.split = function(str, ts)
    if ts == nil then
        return {}
    end

    local t = {}
    local i = 1
    for s in string.gmatch(str, "([^" .. ts .. "]+)") do
        t[i] = s
        i = i + 1
    end

    return t
end

return M

-- vim: sw=4 sts=4 expandtab fenc=utf-8
