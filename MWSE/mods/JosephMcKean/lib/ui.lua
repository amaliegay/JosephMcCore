local ui = {}

---@param actualKey JosephMcKean.lib.keybind
---@param expectedKey JoseohMcKean.lib.keybind
---@param uiid integer
---@param createMenu function
function ui.keyDownUIToggle(actualKey, expectedKey, uiid, createMenu)
	if not tes3.isKeyEqual({ actual = actualKey, expected = expectedKey }) then return end
	local menu = tes3ui.findMenu(uiid)
	if menu then
		menu.visible = not menu.visible
	else
		menu = createMenu()
	end
end
