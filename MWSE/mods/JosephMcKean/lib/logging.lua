local logging = require("logging.logger")

local loggers = {} ---@type table<string,mwseLogger[]>

local function createLogger(config, serviceName)
	local logger = logging.new({ name = string.format("%s - %s", config.mod.name, serviceName), logLevel = config.logLevel })
	if not loggers[config.mod.name] then loggers[config.mod.name] = {} end
	table.insert(loggers[config.mod.name], logger)
	return logger
end

return { createLogger = createLogger }
