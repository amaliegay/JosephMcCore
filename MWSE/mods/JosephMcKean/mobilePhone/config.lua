local defaults = {
	mod = { id = "mobilePhone", name = "Mobile Phone" },
	logLevel = "INFO",
	key = { keyCode = tes3.scanCode.p, isShiftDown = false, isControlDown = false, isAltDown = false },
	homeScreen = { width = 322, height = 502 },
}

---@class mobilePhone.config.homeScreen
---@field width integer
---@field height integer

---@class mobilePhone.config
---@field mod JosephMcKean.lib.mod
---@field logLevel mwseLoggerLogLevel
---@field key JosephMcKean.lib.keybind
---@field homeScreen mobilePhone.config.homeScreen
local config = mwse.loadConfig(defaults.mod.name, defaults)

return config
