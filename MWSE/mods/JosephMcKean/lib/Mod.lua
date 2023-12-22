local Mod = {}

---@return JosephMcCore.mod
function Mod:new()
	local mod = {} ---@type JosephMcCore.mod
	setmetatable(mod, self)
	self.__index = self
	return mod
end

function Mod:log(serviceName)
end

return Mod
