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

-- ! game states
local kGameState = {getReady = 0, dumbbell = 1, musclePopped = 2}
local currentState = kGameState.getReady

-- ! constants
local kDumbbellMeterWidth = screenWidth - 20

-- crank position stuff
local lastCrankPosition = playdate.getCrankPosition()
local rotationCounter = 0  -- Counts complete rotations
local ignoreLastCrankPosition = false

-- ! setup sprites

local titleSprite = spritelib.new()
titleSprite:setImage(gfx.image.new('images/getReady'))
titleSprite:moveTo(screenWidth / 2, screenHeight / 2.5)
titleSprite:setZIndex(950)
titleSprite:addSprite()

local function init()
	print("init game")
	currentState = kGameState.getReady
	titleSprite:setImage(gfx.image.new('images/getReady'))
	titleSprite:setVisible(true)
end

local function startGame()
	print("play dumbbells")
	titleSprite:setVisible(false)
	currentState = kGameState.dumbbell
end

local function gameOver()
	ignoreLastCrankPosition = true -- this is a hack
	currentState = kGameState.musclePopped
	titleSprite:setImage(gfx.image.new('images/gameOver'))
	titleSprite:setVisible(true)
end

-- main update function
function playdate.update()
	print(rotationCounter)
	gfx.clear() -- Clear the screen each frame

	if currentState == kGameState.getReady then
		spritelib.update()
		
	elseif currentState == kGameState.dumbbell then
		local crankPosition = playdate.getCrankPosition()
		
		-- this is a hack because crank was probably moved between last plays of this minigame
		if ignoreLastCrankPosition then 
			lastCrankPosition = crankPosition
			ignoreLastCrankPosition = false
		end
		
		local delta = crankPosition - lastCrankPosition
	
		-- Adjust for wrapping
		if delta > 180 then  -- Crank turned counter-clockwise past 0
			delta = delta - 360
		elseif delta < -180 then  -- Crank turned clockwise past 359
			delta = delta + 360
		end
		
		rotationCounter = rotationCounter + delta
		-- Check for a full rotation
		if math.abs(rotationCounter) >= 360 then
			if rotationCounter < 0 then
				print("rotation counter is below zero")
			elseif rotationCounter > 0 then
				rotationCounter = 0
				lastCrankPosition = crankPosition;
				gameOver()
			end
			rotationCounter = 0  -- Reset the counter
		end
		
		lastCrankPosition = crankPosition;
		local fillWidth = (math.max(rotationCounter, 0) / 360) * kDumbbellMeterWidth
		print("rotation counter: " .. rotationCounter)
		gfx.setColor(gfx.kColorBlack) -- Set the color to black
		gfx.fillRect(10, 10, fillWidth, 20)
		
	elseif currentState == kGameState.musclePopped then
		spritelib.update();
	end
end

function playdate.AButtonUp()

	if currentState == kGameState.getReady then
		startGame()
	end
end

function playdate.BButtonUp()

	if currentState == kGameState.musclePopped then
		init()
	end
end

init()