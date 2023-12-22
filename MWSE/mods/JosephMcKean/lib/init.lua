local logging = require("JosephMcKean.lib.logging")

local Mod = {}

---@return JosephMcCore.mod
function Mod:new()
	local mod = {} ---@type JosephMcCore.mod
	setmetatable(mod, self)
	self.__index = self
	return mod
end

local lib = { Mod = Mod, logging = logging }
return lib
