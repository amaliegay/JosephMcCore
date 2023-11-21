local calculator = { name = "Calculator" }

local config = require("JosephMcKean.mobilePhone.config")
local log = require("JosephMcKean.lib.logging").createLogger(config, "calculator")

local uiids = {
	appIcon = tes3ui.registerID("MenuMobilePhone_Calculator_icon"),
	mainRect = tes3ui.registerID("MenuMobilePhone_Calculator_mainRect"),
	mainBlock = tes3ui.registerID("MenuMobilePhone_Calculator_mainBlock"),
	display = tes3ui.registerID("MenuMobilePhone_Calculator_display"),
	numpad = tes3ui.registerID("MenuMobilePhone_Calculator_numpad"),
	numpadLeft = tes3ui.registerID("MenuMobilePhone_Calculator_numpadLeft"),
	numpadRight = tes3ui.registerID("MenuMobilePhone_Calculator_numpadRight"),
}

calculator.icon = { uiid = uiids.appIcon, path = "Textures\\jsmk\\mb\\c\\icon.dds" }

calculator.previous = ""
calculator.current = ""
calculator.operator = nil ---@type nil|fun(a: number, b: number):number
calculator.operatorClicked = false

local function updateDisplay() calculator.display.text = calculator.current == "" and 0 or calculator.current end

local function clear()
	calculator.current = "0"
	calculator.operator = nil
	calculator.operatorClicked = false
end
local function sign()
	log:trace("sign(%s)", calculator.current)
	if calculator.current ~= "0" then calculator.current = tostring(-tonumber(calculator.current)) end
end
local function percent() calculator.current = tostring(tonumber(calculator.current) / 100) end
---@param number string
local function append(number)
	log:trace("append(%s)", number)
	if calculator.operatorClicked then calculator.current = "" end
	calculator.current = calculator.current .. number
end
local function zero() if calculator.current ~= "0" then append("0") end end
local function dot() if not calculator.current:match("%.") then append(".") end end
local function setOperator()
	calculator.previous = calculator.current
	calculator.operatorClicked = true
end
local function divide()
	calculator.operator = function(a, b) return a / b end
	log:trace("divide")
	setOperator()
end
local function times()
	calculator.operator = function(a, b) return a * b end
	log:trace("times")
	setOperator()
end
local function minus()
	calculator.operator = function(a, b) return a - b end
	log:trace("minus")
	setOperator()
end
local function add()
	calculator.operator = function(a, b) return a + b end
	log:trace("add")
	setOperator()
end
local function equal()
	calculator.current = tostring(calculator.operator(tonumber(calculator.previous), tonumber(calculator.current)))
	calculator.previous = ""
	log:trace("equal")
end

---@class mobilePhone.numpadButton.data
---@field id string
---@field widthProportional number?
---@field click fun(key:string?)?

local numpadButtons = {
	---@type mobilePhone.numpadButton.data[][]
	["left"] = {
		[1] = { [1] = { id = "C", click = clear }, [2] = { id = "+/-", click = sign }, [3] = { id = "%", click = percent } },
		[2] = { [1] = { id = "7", click = append }, [2] = { id = "8", click = append }, [3] = { id = "9", click = append } },
		[3] = { [1] = { id = "4", click = append }, [2] = { id = "5", click = append }, [3] = { id = "6", click = append } },
		[4] = { [1] = { id = "1", click = append }, [2] = { id = "2", click = append }, [3] = { id = "3", click = append } },
		[5] = { [1] = { id = "0", click = zero, widthProportional = 1.37 }, [2] = { id = ".", widthProportional = 0.64, click = dot } },
	},
	---@type mobilePhone.numpadButton.data[]
	["right"] = { [1] = { id = "/", click = divide }, [2] = { id = "x", click = times }, [3] = { id = "-", click = minus }, [4] = { id = "+", click = add }, [5] = { id = "=", click = equal } },
}

---@param numpad tes3uiElement
---@param data mobilePhone.numpadButton.data
local function createButton(numpad, data)
	local button = numpad:createButton({ id = tes3ui.registerID("MenuMobilePhone_Calculator_numpad" .. data.id), text = data.id })
	button.height = 72
	button.widthProportional = data.widthProportional or 1
	button.autoHeight = false
	button:register("mouseClick", function(e)
		if data.click then data.click(data.id) end
		updateDisplay()
	end)
end

---@param mainBlock tes3uiElement
local function createNumpad(mainBlock)
	local numpad = mainBlock:createBlock({ id = uiids.numpad })
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
		for j, data in ipairs(row) do createButton(rowBlock, data) end
	end
	local numpadRight = numpad:createBlock({ id = uiids.numpadRight })
	numpadRight.widthProportional = 0.5
	numpadRight.autoHeight = true
	numpadRight.flowDirection = tes3.flowDirection.topToBottom
	for i, data in ipairs(numpadButtons["right"]) do createButton(numpadRight, data) end
end

---@param mainBlock tes3uiElement
local function createDisplay(mainBlock)
	local display = mainBlock:createLabel({ id = uiids.display, text = "0" })
	display.borderTop, display.borderRight = 20, 10
	display.widthProportional = 1
	display.wrapText = true
	display.justifyText = "right"
	display.font = 1
	calculator.display = display
end

event.register("keyDown", function() updateDisplay() end)

---@param menu tes3uiElement
local function createMenu(menu)
	local mainRect = menu:createRect({ id = uiids.mainRect })
	mainRect.width, mainRect.height = config.homeScreen.width, config.homeScreen.height
	local mainBlock = mainRect:createBlock({ id = uiids.mainBlock })
	mainBlock.absolutePosAlignY = 1
	mainBlock.width = mainRect.width
	mainBlock.autoHeight = true
	mainBlock.flowDirection = tes3.flowDirection.topToBottom
	createDisplay(mainBlock)
	createNumpad(mainBlock)
end

calculator.uiids = uiids
calculator.launch = createMenu

return calculator
