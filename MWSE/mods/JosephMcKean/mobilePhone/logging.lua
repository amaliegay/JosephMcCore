local config = require("JosephMcKean.mobilePhone.config")
local logging = require("logging.logger")

local this = {}

---@type mwseLogger[]
this.loggers = {}

function this.createLogger(serviceName)
	local logger = logging.new({ name = string.format("%s - %s", config.mod.name, serviceName), logLevel = config.logLevel })
	table.insert(this.loggers, logger)
	return logger
end

return this
