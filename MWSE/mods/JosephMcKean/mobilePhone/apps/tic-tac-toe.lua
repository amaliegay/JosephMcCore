local tictactoe = { name = "Tic Tac Toe" }

local config = require("JosephMcKean.mobilePhone.config")
local log = require("JosephMcKean.lib.logging").createLogger(config, "tictactoe")

local uiids = {
	appIcon = tes3ui.registerID("MenuMobilePhone_TicTacToe_icon"),
	mainRect = tes3ui.registerID("MenuMobilePhone_TicTacToe_mainRect"),
	title = tes3ui.registerID("MenuMobilePhone_TicTacToe_title"),
	statusDisplay = tes3ui.registerID("MenuMobilePhone_TicTacToe_statusDisplay"),
	gameBoard = tes3ui.registerID("MenuMobilePhone_TicTacToe_gameBoard"),
	resetButton = tes3ui.registerID("MenuMobilePhone_TicTacToe_resetButton"),
}

tictactoe.icon = { uiid = uiids.appIcon, path = "Textures\\jsmk\\mb\\ttt\\icon.dds" }

---@alias mobilePhone.tictactoe.currentUser
---|'"X"'
---|'"O"'
tictactoe.currentUser = "X"

local function createGameBoard(mainRect)
	local gameBoard = mainRect:createBlock({ id = uiids.gameBoard })
	gameBoard.flowDirection = tes3.flowDirection.topToBottom
	for i = 1, 3 do
		local row = gameBoard:createBlock({ id = tes3ui.registerID("MenuMobilePhone_TicTacToe_gameBoard"..i)})
		row.flowDirection = tes3.flowDirection.leftToRight
		for j = 1, 3 do
			local gameBoardTile = row:createButton({ id = tes3ui.registerID("MenuMobilePhone_TicTacToe_gameBoard"..i..j )}
			gameBoardTile.borderAllSides = 10
		end
	end
end

---@param menu tes3uiElement
local function createMenu(menu)
	local mainRect = menu:createRect({ id = uiids.mainRect })
	mainRect.width, mainRect.height = config.display.width, config.display.height
	local title = mainRect:createLabel({ id = uiids.title, text = "Tic Tac Toe" })
	title.justifyText = "center"
	local statusDisplay = mainRect:createLabel({ id = uiids.statusDisplay, text = "It's X's turn." })
	statusDisplay.justifyText = "center"
	createGameBoard(mainRect)
	local resetButton = mainRect:createButton({ id = uiids.resetButton, text = "Restart?" })
end

local function setup()
	createMenu()

end

tictactoe.uiids = uiids
tictactoe.launch = setup

return tictactoe
