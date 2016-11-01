-- LifeLayers


-- 											globals
local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()
local ActiveLayer = 1;
local Speed = 20


-- 											Data Structs

Board = require 'board'
LS = require 'life_sprite'     
c = require 'colors'

-- 											Call backs
function love.load()
	main = Board:new(40,40,'Main')
	main:init()
	
	--main:anchorSprite(LS.glider, 1,1, 1)
	--main:anchorSprite(LS.block, 1,1, 2)
	main:anchorSprite(LS.gliderGun,1,1, 1)
	print(LS.gliderGun:displayPattern())
	--main:anchorSprite(LS.beacon, 15,10, 3)
	--main:anchorSprite(LS.blinker, 20,10, 4)
	--main:anchorSprite(LS.gunHandle, 23,23, 5)
	--
	
end

local cycles = 0;
local totalDt = 0;
function love.update(dt)
	totalDt = totalDt + dt;
	-- current board
	local board = Board.layers[ActiveLayer]
	-- window resized
	if Width ~= love.graphics.getWidth() or Height ~= love.graphics.getHeight() then
		board:orient()
	end
	if totalDt >= Speed then
		-- logic for life
		board:update()
		cycles = cycles + 1
		print(cycles)
		totalDt = totalDt-Speed
	end
end

function love.draw()
	Board.layers[ActiveLayer]:draw()
end