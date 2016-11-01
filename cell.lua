-- Cell
	c = require 'colors'
	
	Cell = 
	{
		cellSize = 16;
		mode = 'fill';
		alive = false;
		faction = 1;
		color = c.colors
	}
	
	function Cell:new( xCoord, yCoord, faction)
		if faction then
			assert(self.color[faction], "Not a proper faction.")
		end
		return setmetatable({x = xCoord, y = yCoord}, {__index=self})
	end
	
	function Cell:setAlive(alive)
		self.alive = alive; return self
	end
	
	function Cell:setFaction(color)
		self.faction = color; return self
	end
	
	function Cell:draw()
		if self.alive then
			local originalColor = {love.graphics.getColor( )}
			self.color[self.faction](c.set);
			love.graphics.rectangle( self.mode, self.x, self.y, self.cellSize, self.cellSize )
			love.graphics.setColor(unpack(originalColor))
		end
	end
	
	return Cell
