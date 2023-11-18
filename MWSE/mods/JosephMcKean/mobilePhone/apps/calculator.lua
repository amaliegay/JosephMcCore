local name = "Calculator"

local config = require("JosephMcKean.mobilePhone.config")
local log = require("JosephMcKean.mobilePhone.logging").createLogger("calculator") -- move logging to lib

local uiids = {
	appIcon = tes3ui.registerID("MenuMobilePhone_Calculator_icon"),
	mainRect = tes3ui.registerID("MenuMobilePhone_Calculator_mainRect"),
	textInput = tes3ui.registerID("MenuMobilePhone_Calculator_textInput"),
	numpad = tes3ui.registerID("MenuMobilePhone_Calculator_numpad"),
	numpadLeft = tes3ui.registerID("MenuMobilePhone_Calculator_numpadLeft"),
	numpadRight = tes3ui.registerID("MenuMobilePhone_Calculator_numpadRight"),
}

local numpadButtons = {
	["left"] = {
		[1] = { [1] = { id = "C" }, [2] = { id = "+/-" }, [3] = { id = "%" } },
		[2] = { [1] = { id = "7" }, [2] = { id = "8" }, [3] = { id = "9" } },
		[3] = { [1] = { id = "4" }, [2] = { id = "5" }, [3] = { id = "6" } },
		[4] = { [1] = { id = "1" }, [2] = { id = "2" }, [3] = { id = "3" } },
		[5] = { [1] = { id = "0", widthProportional = 1.37 }, [2] = { id = ".", widthProportional = 0.64 } },
	},
	["right"] = { [1] = { id = "/" }, [2] = { id = "*" }, [3] = { id = "-" }, [4] = { id = "+" }, [5] = { id = "=" } },
}

---@param numpad tes3uiElement
---@param id string
local function createButton(numpad, id, widthProportional)
	local button = numpad:createButton({ id = tes3ui.registerID("MenuMobilePhone_Calculator_numpad" .. id), text = id })
	button.widthProportional = widthProportional or 1
	button.autoHeight = false
end

---@param numpad tes3uiElement
local function updateButtonHeight(numpad)
	local height
	for uiElement in table.traverse(numpad.children) do
		if uiElement.type == tes3.uiElementType.button then
			if not height and (uiElement.widthProportional == 1) then height = uiElement.width end
			uiElement.height = height
			log:trace("updating %s button height: %d", uiElement.text, uiElement.height)
		end
	end
end

---@param mainRect tes3uiElement
local function createNumpad(mainRect)
	local numpad = mainRect:createBlock({ id = uiids.numpad })
	numpad.autoHeight = true
	numpad.widthProportional = 1
	numpad.borderTop = 10
	numpad.flowDirection = tes3.flowDirection.leftToRight
	local numpadLeft = numpad:createBlock({ id = uiids.numpadLeft })
	numpadLeft.widthProportional = 1.5
	numpadLeft.autoHeight = true
	numpadLeft.flowDirection = tes3.flowDirection.topToBottom
	for i, row in ipairs(numpadButtons["left"]) do
		local rowBlock = numpadLeft:createBlock({ id = tes3ui.registerID("MenuMobilePhone_Calculator_numpadLeftRow" .. i) })
		rowBlock.widthProportional = 1
		rowBlock.autoHeight = true
		rowBlock.flowDirection = tes3.flowDirection.leftToRight
		for j, data in ipairs(row) do createButton(rowBlock, data.id, data.widthProportional) end
	end
	local numpadRight = numpad:createBlock({ id = uiids.numpadRight })
	numpadRight.widthProportional = 0.5
	numpadRight.autoHeight = true
	numpadRight.flowDirection = tes3.flowDirection.topToBottom
	for i, data in ipairs(numpadButtons["right"]) do createButton(numpadRight, data.id) end
	updateButtonHeight(numpad)
end

---@param mainRect tes3uiElement
local function createTextInput(mainRect)
	local textInput = mainRect:createTextInput({ id = uiids.textInput, text = "0", placeholderText = "0", numeric = true, autoFocus = true })
	textInput.borderTop, textInput.borderRight = 20, 10
	textInput.widthProportional = 1
	textInput.wrapText = true
	textInput.justifyText = "right"
	textInput.font = 1
end

---@param menu tes3uiElement
local function createMenu(menu)
	local mainRect = menu:createRect({ id = uiids.mainRect })
	mainRect.width, mainRect.height = config.homeScreen.width, config.homeScreen.height
	mainRect.flowDirection = tes3.flowDirection.topToBottom
	createTextInput(mainRect)
	createNumpad(mainRect)
end

local num1 = 0
local num2 = 0
local result = num1 + num2

---@param e tes3uiEventData
local function input(e) num1 = tonumber(tes3ui.acquireTextInput(e.source)) or 0 end

local plus
-- plus:register("mouseClick", input)

return { name = name, uiids = uiids, launch = createMenu }
