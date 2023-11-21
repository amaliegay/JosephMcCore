local defaults = {
	mod = { id = "mobilePhone", name = "Mobile Phone" },
	logLevel = "INFO",
	key = { keyCode = tes3.scanCode.p, isShiftDown = false, isControlDown = false, isAltDown = false },
	screen = { width = 284, height = 572 },
	display = { width = 250, height = 452 },
}

---@class mobilePhone.config
---@field mod JosephMcKean.lib.mod
---@field logLevel mwseLoggerLogLevel
---@field key JosephMcKean.lib.keybind
---@field display JosephMcKean.lib.size
---@field screen JosephMcKean.lib.size
local config = mwse.loadConfig(defaults.mod.name, defaults)

return config
