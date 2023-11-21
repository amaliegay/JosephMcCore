local tic-tac-toc = { name = "Tic-tac-toc" }

local config = require("JosephMcKean.mobilePhone.config")
local log = require("JosephMcKean.lib.logging").createLogger(config, "tic-tac-toc")

local uiids = {
	appIcon = tes3ui.registerID("MenuMobilePhone_TicTacToc_icon"),
	mainRect = tes3ui.registerID("MenuMobilePhone_TicTacToc_mainRect"),
	mainBlock = tes3ui.registerID("MenuMobilePhone_TicTacToc_mainBlock")
}

tic-tac-toc.icon = { uiid = uiids.appIcon, path = "Textures\\jsmk\\mb\\ttt\\icon.dds" }

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

tic-tac-toc.uiids = uiids
tic-tac-toc.launch = createMenu

return tic-tac-toc
