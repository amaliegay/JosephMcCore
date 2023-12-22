local logging = require("logging.logger")

local loggers = {} ---@type table<string,mwseLogger[]>

---@param mod JosephMcCore.mod
---@param serviceName string?
local function createLogger(mod, serviceName)
	local config = mod.config
	local name = config.mod.name
	if serviceName then serviceName = name .. " - " .. serviceName end
	local logger = logging.new({ name = serviceName, logLevel = config.logLevel })
	if not loggers[name] then loggers[name] = {} end
	table.insert(loggers[name], logger)
	return logger
end

---@param serviceName string?
local function log(serviceName)
	return createLogger(mod, serviceName)
end

return { log = log }
