local config = require("JosephMcKean.mobilePhone.config")
local log = require("JosephMcKean.lib.logging").createLogger(config, "main")
local ui = require("JosephMcKean.lib.ui")

---@class mobilePhone.uiids
local uiids = {
	menu = tes3ui.registerID("MenuMobilePhone"),
	device = tes3ui.registerID("MenuMobilePhone_device"),
	screen = tes3ui.registerID("MenuMobilePhone_screen"),
	homeScreen = tes3ui.registerID("MenuMobilePhone_homeScreen"),
	frontCamera = tes3ui.registerID("MenuMobilePhone_frontCamera"),
	earpieceSpeaker = tes3ui.registerID("MenuMobilePhone_earpieceSpeaker"),
	display = tes3ui.registerID("MenuMobilePhone_display"),
	homeButton = tes3ui.registerID("MenuMobilePhone_homeButton"),
	silentSwitch = tes3ui.registerID("MenuMobilePhone_silentSwitch"),
	volumeUpButton = tes3ui.registerID("MenuMobilePhone_volumeUpButton"),
	volumeDownButton = tes3ui.registerID("MenuMobilePhone_volumeDownButton"),
	sideButton = tes3ui.registerID("MenuMobilePhone_sideButton"),
	statusBar = tes3ui.registerID("MenuMobilePhone_statusBar"),
	clockLabel = tes3ui.registerID("MenuMobilePhone_clockLabel"),
}

---@class mobilePhone.app
---@field name string
---@field uiids table
---@field launch fun(menu:tes3uiElement)
---@field icon mobilePhone.app.icon

---@class mobilePhone.app.icon
---@field uiid integer
---@field path string

---@return table<string, mobilePhone.app> apps
local function loadApps()
	local dir = "Data Files\\MWSE\\mods\\JosephMcKean\\mobilePhone\\apps"
	local relative = "JosephMcKean.mobilePhone.apps."
	---@type table<string, mobilePhone.app>
	local apps = {}
	for file in lfs.dir(dir) do
		if not file:startswith(".") and file:endswith(".lua") then
			local app = file:sub(1, -5)
			apps[app] = require(relative .. app)
		end
	end
	return apps
end

---@param homeScreen tes3uiElement
local function createAppsIcon(homeScreen)
	local apps = loadApps()
	for name, app in pairs(apps) do
		local appIcon = homeScreen:createImage({ id = app.icon.uiid, path = app.icon.path })
		appIcon.borderAllSides = 10
		appIcon:register("mouseClick", function(e)
			homeScreen.visible = false
			app.launch(homeScreen.parent)
			homeScreen:destroy()
		end)
	end
end

---@param statusBar tes3uiElement
local function createClock(statusBar)
	local clock
    local clockLabel = statusBar:createLabel({ id = uiids.clockLabel })
    clockLabel.autoWidth, clocksBlock.autoHeight = true, true
    clockLabel.widthProportional = 1
	clockLabel.absolutePosAlignX = 0.5
    clockLabel.color = clock.color
	updateClockUI(clock)
end

---@param display tes3uiElement
local function createStatusBar(display)
	local statusBar = display:createBlock({ id = uiid.statusBar })
	createClock(statusBar)
end

local function createDisplay(screen)
	local display = screen:createThinBorder({ id = uiids.display })
	display.width, display.height = config.display.width, config.display.height
	display.absolutePosAlignX, display.absolutePosAlignY = 0.5, 0.55
	createStatusBar(display)
	createAppsIcon(display)
end

---@param menu tes3uiElement
local function createDevice(menu)
	local device = menu:createThinBorder({ id = uiids.device })
	device.parent.paddingAllSides = 5
	device.autoWidth, device.autoHeight = true, true
	--- screen
	local screen = device:createRect({ id = uiids.screen, color = tes3vector3.new(0, 0, 0) })
	screen.width, screen.height = config.screen.width, config.screen.height
	local frontCamera = screen:createThinBorder({ id = uiids.frontCamera })
	frontCamera.width, frontCamera.height = 8, 8
	frontCamera.absolutePosAlignX, frontCamera.absolutePosAlignY = 0.38, 0.05
	local earpieceSpeaker = screen:createThinBorder({ id = uiids.earpieceSpeaker })
	earpieceSpeaker.width, earpieceSpeaker.height = 50, 8
	earpieceSpeaker.absolutePosAlignX, earpieceSpeaker.absolutePosAlignY = 0.55, 0.05
	createDisplay(screen)
	local homeButton = screen:createButton({ id = uiids.homeButton })
	homeButton.absolutePosAlignX, homeButton.absolutePosAlignY = 0.5, 0.99
	homeButton.autoWidth, homeButton.autoHeight = false, false
	homeButton.width, homeButton.height = 36, 36
	--[[ device buttons
	local silentSwitch = device:createThinBorder({ id = uiids.silentSwitch })
	local volumeUpButton = device:createThinBorder({ id = uiids.volumeUpButton })
	local volumeDownButton = device:createThinBorder({ id = uiids.volumeDownButton })
	local sideButton = device:createButton({ id = uiids.sideButton })
	sideButton.autoWidth, sideButton.autoHeight = false, false
	sideButton.width, sideButton.height = 8, 40]]
end

---@return tes3uiElement menu
local function createMenu()
	local menu = tes3ui.createMenu({ id = uiids.menu, fixedFrame = true, modal = false })
	menu.autoWidth, menu.autoHeight = true, true
	menu.absolutePosAlignX, menu.absolutePosAlignY = 0.98, 1
	menu:loadMenuPosition()

	createDevice(menu)
	return menu
end

event.register("initialized", function()
	event.register("keyDown", function(e) ui.keyDownUIToggle(e, config.key, uiids.menu, createMenu) end)
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
	local template = mwse.mcm.createTemplate({ name = config.mod.name })
	template:register()
	template:saveOnClose(config.mod.name, config)
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
