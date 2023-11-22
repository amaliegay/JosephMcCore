local draw = { name = "Draw" }

local config = require("JosephMcKean.mobilePhone.config")
local log = require("JosephMcKean.lib.logging").createLogger(config, "draw")

local uiids = {
	appIcon = tes3ui.registerID("MenuMobilePhone_Draw_icon"),
	mainRect = tes3ui.registerID("MenuMobilePhone_Draw_mainRect"),
	mainBlock = tes3ui.registerID("MenuMobilePhone_Draw_mainBlock"),
}

draw.icon = { uiid = uiids.appIcon, path = "Textures\\jsmk\\mb\\d\\icon.dds" }

local function createButton() end

---@param menu tes3uiElement
local function createMenu(menu)
	local mainRect = menu:createRect({ id = uiids.mainRect })
	mainRect.width, mainRect.height = config.display.width, config.display.height
	local mainBlock = mainRect:createBlock({ id = uiids.mainBlock })
	mainBlock.absolutePosAlignY = 1
	mainBlock.width = mainRect.width
	mainBlock.autoHeight = true
	mainBlock.flowDirection = tes3.flowDirection.topToBottom
end

draw.uiids = uiids
draw.launch = createMenu

return tictactoe
