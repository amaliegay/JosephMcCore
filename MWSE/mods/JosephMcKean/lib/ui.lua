local ui = {}

--- written by @tewlwolow
---@return tes3uiElement textInputFocus
local function getTextInputFocus() return tes3.worldController.menuController.inputController.textInputFocus end

---@return boolean
local function isTextInputIsActive()
	local inputFocus = getTextInputFocus()

	-- Patch for UI Expansion not releasing text input after leaving menu mode
	if not tes3ui.menuMode() and inputFocus and inputFocus.widget and inputFocus.widget.element.name == "UIEXP:FiltersearchBlock" then
		tes3ui.acquireTextInput(nil)
		inputFocus = getTextInputFocus()
	end

	if inputFocus and inputFocus.visible and not inputFocus.disabled then return true end
	return false
end

---@param actualKey JosephMcCore.keybind
---@param expectedKey JosephMcCore.keybind
---@param uiid integer
---@param createMenu function
function ui.keyDownUIToggle(actualKey, expectedKey, uiid, createMenu)
	if isTextInputIsActive() then return end
	if not tes3.isKeyEqual({ actual = actualKey, expected = expectedKey }) then return end
	local menu = tes3ui.findMenu(uiid)
	if menu then
		menu.visible = not menu.visible
	else
		menu = createMenu()
	end
end

return ui
