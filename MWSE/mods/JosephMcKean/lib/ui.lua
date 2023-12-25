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
local function keyDownUIToggle(actualKey, expectedKey, uiid, createMenu)
	if isTextInputIsActive() then return end
	if not tes3.isKeyEqual({ actual = actualKey, expected = expectedKey }) then return end
	local menu = tes3ui.findMenu(uiid)
	if menu then
		menu.visible = not menu.visible
	else
		menu = createMenu()
	end
end

---@param menu tes3uiElement
---@return tes3uiElement main
local function getMainElement(menu)
	local main = menu:findChild("PartNonDragMenu_main")
	if not main then main = menu:findChild("PartDragMenu_main") end
	return main
end

---@class JosephMcCore.ui.createMenu.params
---@field id string
---@field size JosephMcCore.size? Default: viewport size
---@field resizable boolean? Default: false
---@field borderless boolean? Default: false. Only available if resizable is false
---@field visible boolean? Default: true

---@param params JosephMcCore.ui.createMenu.params
---@return tes3uiElement menu
---@return tes3uiElement root
local function createMenu(params)
	local menu = tes3ui.createMenu({ id = params.id, dragFrame = params.resizable, fixedFrame = not params.resizable, modal = false })
	local root = menu:createBlock({ id = params.id .. "_root" })
	if params.size then
		root.width, root.height = params.size.width, params.size.height
	else
		root.width, root.height = tes3ui.getViewportSize()
	end
	local main = getMainElement(menu)
	if not params.resizable and params.borderless then
		main.paddingAllSides = 0
	else
		main.paddingAllSides = 4
	end
	menu:updateLayout()
	if params.visible == false then menu.visible = false end
	return menu, root
end

---@param width integer
---@param height integer
---@return niSourceTexture texture
local function createTexture(width, height)
	local pixelData = niPixelData.new(width, height)
	local texture = pixelData:createSourceTexture()
	texture.isStatic = false
	return texture
end

local ui = { createMenu = createMenu, createTexture = createTexture, keyDownUIToggle = keyDownUIToggle }

return ui
