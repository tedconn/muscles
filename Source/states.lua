local states = {}
states.getReady = {
	enter = function(self) 
		print("starting getReady state")
		titleSprite:setImage(gfx.image.new('images/getReady'))
		titleSprite:setVisible(true)
	end,
	update = function(self)
		spritelib.update()
	end,
	exit = function(self) 
		print("exiting getReady state")
	end
}

states.musclePulled = {
	enter = function(self) 
		print("starting muscle pulled state")
		ignoreLastCrankPosition = true
		titleSprite:setImage(gfx.image.new('images/gameOver'))
		titleSprite:setVisible(true)
	end,
	update = function(self)
		spritelib.update()
	end,
	exit = function(self) 
		print("exiting muscle pulled state")
	end
}

local currentState

function changeState(newState, ...)
	print("requesting new state")
	if currentState and currentState.exit then
		currentState:exit()
	end

	currentState = states[newState]
	print(currentState)
	if currentState and currentState.enter then
		currentState:enter(...)
	end
end

function getCurrentState()
	return currentState
end

print("defined states in states.lua")
for k, v in pairs(states) do
	print("Key:", k, "Value:", v)
end

return { getReady = states.getReady, dumbbell = states.dumbbell, musclePulled = states.musclePulled, changeState = changeState, getCurrentState = getCurrentState }