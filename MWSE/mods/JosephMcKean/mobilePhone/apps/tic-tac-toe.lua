local tic-tac-toe = { name = "Tic-tac-toe" }

local config = require("JosephMcKean.mobilePhone.config")
local log = require("JosephMcKean.lib.logging").createLogger(config, "tic-tac-toe")

local uiids = {
	appIcon = tes3ui.registerID("MenuMobilePhone_TicTacToe_icon"),
	mainRect = tes3ui.registerID("MenuMobilePhone_TicTacToe_mainRect"),
	mainBlock = tes3ui.registerID("MenuMobilePhone_TicTacToe_mainBlock")
}

tic-tac-toe.icon = { uiid = uiids.appIcon, path = "Textures\\jsmk\\mb\\ttt\\icon.dds" }

local function createButton()
	
end

---@param menu tes3uiElement
local function createMenu(menu)
	local mainRect = menu:createRect({ id = uiids.mainRect })
	mainRect.width, mainRect.height = config.homeScreen.width, config.homeScreen.height
	local mainBlock = mainRect:createBlock({ id = uiids.mainBlock })
	mainBlock.absolutePosAlignY = 1
	mainBlock.width = mainRect.width
	mainBlock.autoHeight = true
	mainBlock.flowDirection = tes3.flowDirection.topToBottom
end

tic-tac-toe.uiids = uiids
tic-tac-toe.launch = createMenu

return tic-tac-toe
