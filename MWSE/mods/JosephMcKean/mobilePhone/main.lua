local fileName = "Mobile Phone"
local defaults = { logLevel = "INFO", key = { keyCode = tes3.scanCode.p, isShiftDown = false, isControlDown = false, isAltDown = false } }

---@class JosephMcKean.mobilePhone.config
---@field logLevel mwseLoggerLogLevel
---@field key JosephMcKean.lib.keybind
local config = mwse.loadConfig(fileName, defaults)

local logging = require("logging.logger")
local log = logging.new({ name = fileName, logLevel = config.logLevel })

---@class JosephMcKean.mobilePhone.uiids
local uiids = { menu = tes3ui.registerID("MenuMobilePhone"), rect = tes3ui.registerID("MenuMobilePhone_rect") }

---@return table<string, JosephMcKean.mobilePhone.app> apps
local function loadApps()
	local dir = "Data Files\\MWSE\\mods\\JosephMcKean\\mobilePhone\\apps"
    local relative = "JosephMcKean.mobilePhone.apps."
    ---@type table<string, JosephMcKean.mobilePhone.app>
    local apps = {}
    for file in lfs.dir(dir) do
        if not file:startswith(".") and file:endswith(".lua") then
            local app = file:sub(1, -4)
            apps[app] = require(relative .. app)
        end
    end
	return apps
end

---@param mainScreen tes3uiElement
local function createAppsIcon(homeScreen)
	local apps = loadApps()
	for name, app in pairs(apps) do
		local appIcon = homeScreen:createButton({ id = app.uiids.appIcon, text = app.name })
	end
end

---@param menu tes3uiElement
local function createMainScreen(menu)
	local homeScreen = menu:createRect({ id = uiids.homeScreen })
	homeScreen.width, homeScreen.height = 322, 502

	createAppsIcon(homeScreen)
end

---@return tes3uiElement menu
local function createMenu()
	local menu = tes3ui.createMenu({ id = uiids.menu, fixedFrame = true })
	menu.width, menu.height = 322, 502
	menu.absolutePosAlignX, menu.absolutePosAlignY = 0.98, 1
	menu:loadMenuPosition()

	createMainScreen(menu)
	return menu
end

---@param e keyDownEventData
local function keyDown(e)
	if not tes3.isKeyEqual({ actual = e, expected = config.key }) then return end
	local menu = tes3ui.findMenu(uiids.menu)
	if menu then
		menu.visible = not menu.visible
	else
		menu = createMenu()
	end
end

event.register("initialized", function()
	event.register("keyDown", keyDown)
	log:info("Initialized!")
end)

local function centerInfo(self)
	local info = self.elements.info
	info.absolutePosAlignX = 0.5
	info.widthProportional = nil
end

local function borderAllSides(self)
	local outerContainer = self.elements.outerContainer
	outerContainer.borderAllSides = 10
end

local function leftToRightSliderStyle(self)
	local outerContainer = self.elements.outerContainer
	outerContainer.flowDirection = tes3.flowDirection.leftToRight
end

local function leftToRightDropDownStyle(self)
	local outerContainer = self.elements.outerContainer
	outerContainer.flowDirection = tes3.flowDirection.leftToRight
	local labelBlock = self.elements.labelBlock
	labelBlock.wrapText = true
	local innerContainer = self.elements.innerContainer
	innerContainer.widthProportional = nil
	innerContainer.minWidth = 100
end

local function registerModConfig()
	local template = mwse.mcm.createTemplate({ name = fileName })
	template:register()
	template:saveOnClose(fileName, config)
	local preferences = template:createPage({ label = "Mod Preferences", noScroll = true })
	preferences:createInfo({
		text = "\nCalculator App\n",
		postCreate = function(self)
			centerInfo(self)
			borderAllSides(self)
		end,
	})
	preferences:createInfo({
		text = "Created by JosephMcKean\n",
		postCreate = function(self)
			centerInfo(self)
			borderAllSides(self)
		end,
	})
	preferences:createDropdown({
		label = "Set the log level to",
		options = {
			{ label = "TRACE", value = "TRACE" },
			{ label = "DEBUG", value = "DEBUG" },
			{ label = "INFO", value = "INFO" },
			{ label = "ERROR", value = "ERROR" },
			{ label = "NONE", value = "NONE" },
		},
		variable = mwse.mcm.createTableVariable({ id = "logLevel", table = config }),
		callback = function(self) log:setLogLevel(self.variable.value) end,
		postCreate = function(self)
			leftToRightDropDownStyle(self)
			borderAllSides(self)
		end,
	})
end
event.register("modConfigReady", registerModConfig)
