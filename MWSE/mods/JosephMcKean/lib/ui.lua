---@param e keyDownEventData

local function keyDownUIToggle(e, createMenu)
	if not tes3.isKeyEqual({ actual = e, expected = config.key }) then return end
	local menu = tes3ui.findMenu(uiids.menu)
	if menu then
		menu.visible = not menu.visible
	else
		menu = createMenu()
	end
end
