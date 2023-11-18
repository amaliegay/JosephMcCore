local name = "Calculator"

local uiids = { appIcon = tes3ui.registerID("MenuMobilePhone_Calculator_icon") }

---@param menu tes3uiElement
local function createMenu(menu)

end

local num1
local num2
local result = num1 + num2

---@param e tes3uiEventData
local function input(e)
  num1 = tes3ui.acquireTextInput(e.source)
end

local plus
plus:register("mouseClick", input)

return {
  name = name,
  uiids = uiids,
  launch = createMenu
}
