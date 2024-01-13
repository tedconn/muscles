local gfx = playdate.graphics
local spritelib = gfx.sprite

local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()

local kDumbbellMeterWidth = screenWidth - 20

-- ! setup sprites
local titleSprite = spritelib.new()
titleSprite:setImage(gfx.image.new('images/getReady'))
titleSprite:moveTo(screenWidth / 2, screenHeight / 2.5)
titleSprite:setZIndex(950)
titleSprite:addSprite()

local states = {}
states.getReady = {
	enter = function(self) 
		print("starting getReady state")
		titleSprite:setImage(gfx.image.new('images/getReady'))
		titleSprite:setVisible(true)
	end,
	update = function(self)
		gfx.clear()
		spritelib.update()
	end,
	exit = function(self) 
		print("exiting getReady state")
	end
}

states.musclePulled = {
	enter = function(self) 
		print("starting musclePuled state")
		titleSprite:setImage(gfx.image.new('images/gameOver'))
		titleSprite:setVisible(true)
	end,
	update = function(self)
		spritelib.update()
	end,
	exit = function(self) 
		print("exiting musclePulled state")
	end
}

states.dumbbell = {
	rotationCounter = 0,
	lastCrankPosition = nil,
	enter = function(self) 
		self.lastCrankPosition = playdate.getCrankPosition()
	end,
	update = function(self)
		gfx.clear()
		local crankPosition = playdate.getCrankPosition()
		local delta = crankPosition - self.lastCrankPosition
		
		-- Adjust for wrapping
		if delta > 180 then  -- Crank turned counter-clockwise past 0
			delta = delta - 360
		elseif delta < -180 then  -- Crank turned clockwise past 359
			delta = delta + 360
		end
		
		self.rotationCounter = self.rotationCounter + delta
		
		-- Check for a full rotation
		if math.abs(self.rotationCounter) >= 360 then
			if self.rotationCounter < 0 then
				print("rotation counter is below zero")
			elseif self.rotationCounter > 0 then
				self.rotationCounter = 0
				-- pulled a muscle
				changeState(states.musclePulled)
			end
			self.rotationCounter = 0  -- Reset the counter
		end
		
		self.lastCrankPosition = crankPosition;
		local fillWidth = (math.max(self.rotationCounter, 0) / 360) * kDumbbellMeterWidth
		print("rotation counter: " .. self.rotationCounter)
		print("fill width: " .. fillWidth)
		gfx.setColor(gfx.kColorBlack) -- Set the color to black
		gfx.fillRect(10, 10, fillWidth, 20)
	end,
	exit = function(self) 
		print("exiting dumbbell state")
	end
}

local currentState

function changeState(newState, ...)
	
	print("requesting new state")
	if currentState and currentState.exit then
		currentState:exit()
	end

	currentState = newState
	if currentState and currentState.enter then
		currentState:enter(...)
	end
end

function getCurrentState()
	return currentState
end

return { getReady = states.getReady, dumbbell = states.dumbbell, musclePulled = states.musclePulled, changeState = changeState, getCurrentState = getCurrentState }