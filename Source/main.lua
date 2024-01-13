import "CoreLibs/sprites"
import "CoreLibs/graphics"

playdate.display.setRefreshRate(20)

local gfx = playdate.graphics
local spritelib = gfx.sprite
local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()

-- reset the screen to white
gfx.setBackgroundColor(gfx.kColorWhite)
gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, screenWidth, screenHeight)

-- ! setup states
local stateModule = import "states"

-- ! setup sprites
local titleSprite = spritelib.new()
titleSprite:setImage(gfx.image.new('images/getReady'))
titleSprite:moveTo(screenWidth / 2, screenHeight / 2.5)
titleSprite:setZIndex(950)
titleSprite:addSprite()

-- ! main update
function playdate.update()
	gfx.clear()
	local currentState = stateModule.getCurrentState()
	if currentState and currentState.update then
		currentState:update()
	end
end

function playdate.AButtonUp()
	if stateModule.getCurrentState() == stateModule.getReady then
		stateModule.changeState(stateModule.dumbbell)
	end
end

function playdate.BButtonUp()
	if stateModule.getCurrentState() == stateModule.musclePulled then
		stateModule.changeState(stateModule.getReady)
	end
end

-- stateModule.changeState(stateModule.getReady)
print("Imported states from states.lua")
for k, v in pairs(stateModule) do
	print("Key:", k, "Value:", v)
end