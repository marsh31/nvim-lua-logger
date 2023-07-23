local NvimLuaLogger = require("nvim_lua_logger.main")
local nll = NvimLuaLogger.new()

return setmetatable({
    nll = nll,
}, {
    __index = function(_, method)
        return function(...)
            local args = { ... }
            local f = nll[method]
            if f then
                f(nll, unpack(args))
            else
                nll:error("Unknown method: " .. method)
            end
        end
    end,
})

-- vim: sw=4 sts=4 expandtab fenc=utf-8
