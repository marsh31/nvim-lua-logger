--
-- NAME:   main.lua
-- AUTHOR: marsh
-- NOTE:
--

------------------------------------------------------------
-- config
------------------------------------------------------------
local utils = require("nvim_lua_logger.utils")

------------------------------------------------------------
-- nvim_lua_logger.main.NvimLuaLogger
------------------------------------------------------------

---@class nvim_lua_logger.main.NvimLuaLogger
---@field default_option
---@field opts
---@field augroup
local NvimLuaLogger = {}

---@return nvim_lua_logger.main.NvimLuaLogger
NvimLuaLogger.new = function()
	return setmetatable({
		augroup = vim.api.nvim_create_augroup("nvim_lua_logger", {}),
		default_options = {
			filename = vim.fn.expand("~/neovim.log"),
			hotreload = true,
		},
		opts = {},
		levels = {
			INFO = 1,
			WARN = 2,
			ERROR = 3,
			DEBUG = 4,
			TRACE = 5,
			MAX = 6,
		},
	}, { __index = NvimLuaLogger })
end

---@return nil
function NvimLuaLogger:setup(opts)
	self.opts = vim.tbl_extend("force", self.default_options, opts or {})

	self:enable()
end

---@return nil
function NvimLuaLogger:enable()
	self:disable()

	-- enable feature
end

---@return nil
function NvimLuaLogger:disable()
	vim.api.nvim_clear_autocmds({ group = self.augroup })
end

---@param  msg    string
---@param  level  string
---@param  target string|nil
---@return string
local function format_msg(msg, level, target)
	return string.format("%s %s %s [%s] %s\n", utils.day(), utils.time(), utils.level(level), target, msg)
end

---@return nil
function NvimLuaLogger:write(msg, target)
	local append_file = io.open(self.opts.filename, "a")
	if append_file ~= nil then
		io.output(append_file)

		for _, m in ipairs(utils.split(msg, "\n")) do
			io.write(format_msg(m, self.levels.INFO, target))
		end

		io.close(append_file)
	end
end

---@return nil
function NvimLuaLogger:open_logfile(filepath)
	vim.cmd("botright vsplit " .. filepath)
	local bufnr = vim.fn.bufnr("%")

	if self.opts.hotreload then
		local watcher = vim.loop.new_fs_poll()
		watcher:start(
			filepath,
			2000,
			vim.schedule_wrap(function()
				vim.cmd("checktime")
			end)
		)
	end
end

------------------------------------------------------------
-- vim.notify
------------------------------------------------------------

---@param msg string
---@return nil
function NvimLuaLogger:warn(msg)
	vim.notify("[nvim_lua_logger  WARN] " .. msg, vim.log.levels.WARN)
end

---@param msg string
---@return nil
function NvimLuaLogger:error(msg)
	vim.notify("[nvim_lua_logger ERROR] " .. msg, vim.log.levels.ERROR)
end

return NvimLuaLogger
-- vim: sw=4 sts=4 expandtab fenc=utf-8
