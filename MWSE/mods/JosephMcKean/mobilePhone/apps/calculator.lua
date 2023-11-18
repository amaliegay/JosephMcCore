local app = {
  name = "Calculator"
}

app.uiids = { appIcon = tes3ui.registerID("MenuMobilePhone_Calculator_icon") }

local num1
local num2
local result = num1 + num2

---@param e tes3uiEventData
local function input(e)
  num1 = tes3ui.acquireTextInput(e.source)
end

local plus
plus:register("mouseClick", input)

return app
