---@class JosephMcCore.Mod
local Mod = {}

local logging = require("logging.logger")

local loggers = {} ---@type table<string,mwseLogger[]>
local coreName = "JosephMcCore"
local coreConfigDefaults = { mod = { id = coreName, name = coreName }, logLevel = "INFO" }
local coreConfig = mwse.loadConfig(coreName, coreConfigDefaults)
local log = logging.new({ name = coreName, logLevel = coreConfig.logLevel })
if not loggers[coreName] then loggers[coreName] = { log } end

---@class JosephMcCore.Config.defaults
---@field mod JosephMcCore.Config.mod

---@class JosephMcCore.Config.mod
---@field id string
---@field name string

---@param config JosephMcCore.Config.defaults
---@return JosephMcCore.Mod mod
function Mod:new(config)
	local mod = {} ---@type JosephMcCore.Mod
	setmetatable(mod, self)
	self.__index = self
	self.config = mwse.loadConfig(config.mod.name, config)
	log:info("Mod %s created", config.mod.name)
	return mod
end

---@param serviceName string?
---@return mwseLogger
function Mod:log(serviceName)
	local config = self.config
	local name = config.mod.name
	if serviceName then serviceName = name .. " - " .. serviceName end
	local logger = logging.new({ name = serviceName or name, logLevel = config.logLevel })
	if not loggers[name] then loggers[name] = {} end
	table.insert(loggers[name], logger)
	log:info("New logger %s created", serviceName or name)
	return logger
end

return Mod
