local logging = require("JosephMcKean.lib.logging")

---@return JosephMcCore.mod
local function Mod()
	local mod = {} ---@type JosephMcCore.mod
	mod.log = logging.log(mod)
	return mod
end

local lib = { Mod = Mod, logging = logging }
return lib
