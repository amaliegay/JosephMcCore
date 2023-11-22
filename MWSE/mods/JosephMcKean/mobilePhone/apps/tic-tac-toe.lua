local tictactoe = { name = "Tic-tac-toe" }

local config = require("JosephMcKean.mobilePhone.config")
local log = require("JosephMcKean.lib.logging").createLogger(config, "tictactoe")

local uiids = {
	appIcon = tes3ui.registerID("MenuMobilePhone_TicTacToe_icon"),
	mainRect = tes3ui.registerID("MenuMobilePhone_TicTacToe_mainRect"),
	gameBoard = tes3ui.registerID("MenuMobilePhone_TicTacToe_gameBoard"),
}

tictactoe.icon = { uiid = uiids.appIcon, path = "Textures\\jsmk\\mb\\ttt\\icon.dds" }

local function createButton() end

---@param menu tes3uiElement
local function createMenu(menu)
	local mainRect = menu:createRect({ id = uiids.mainRect })
	mainRect.width, mainRect.height = config.display.width, config.display.height
	local title = mainRect:createLabel({ id = uiids.title, text = "Tic Tac Toe" })
	local statusDisplay = mainRect:createLabel({ id = uiids.statusDisplay, text = "It's X's turn." })
	local gameBoard = mainRect:createBlock({ id = uiids.gameBoard })
end

tictactoe.uiids = uiids
tictactoe.launch = createMenu

return tictactoe
