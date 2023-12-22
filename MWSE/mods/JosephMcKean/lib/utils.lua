--- This is a generic iterator function that is used
--- to loop over all the items in an inventory
---@param reference tes3reference
---@return fun(): tes3item, integer, tes3itemData|nil
local function iterateInventory(reference)
	local function iterator()
		for _, itemStack in pairs(reference.object.inventory) do
			---@cast itemStack tes3itemStack
			local object = itemStack.object

			-- Account for restocking items,
			-- since their count is negative
			local count = math.abs(itemStack.count)

			-- first yield stacks with custom data
			if itemStack.variables then
				for _, itemData in pairs(itemStack.variables) do
					if itemData then
						-- Note that itemData.count is always 1 for items in inventories.
						-- That field is only relevant for items in the game world, which
						-- are stored as references. In that case tes3itemData.count field
						-- contains the amount of items in the in-game-world stack of items.
						coroutine.yield(object, itemData.count, itemData)
						count = count - itemData.count
					end
				end
			end
			-- then yield all the remaining copies
			if count > 0 then coroutine.yield(object, count) end
		end
	end
	return coroutine.wrap(iterator)
end

local function isLuaFile(file) return file:sub(-4, -1) == ".lua" end

---@param path string
local function executeAllLuaFilesIn(path) for filename in lfs.dir(path) do if isLuaFile(filename) then dofile(path .. filename) end end end

local utils = { iterateInventory = iterateInventory, executeAllLuaFilesIn = executeAllLuaFilesIn }

return utils
