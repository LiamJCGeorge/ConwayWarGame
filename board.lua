-- Board
Cell = require 'cell'
Color = require 'colors'

Board = {
	layers = {};
	xAnchor = 1;
	yAnchor = 1;
	-- divider
	showDivider = false;
	dividerSize = 4;
	dividerColor = Color.colors.divider; 
}
function Board:new(columnAmount, rowAmount, name )
	assert(columnAmount and rowAmount, 'Board must have a column amount and row amount.')
	self.name = name
	local o = {rowAmount = rowAmount, columnAmount = columnAmount}
	table.insert(Board.layers, o)
	return setmetatable(o, {__index = self})
end


-- centers board
function Board:getOffset()
	Width = love.graphics.getWidth()
	Height = love.graphics.getHeight()
	local boardWidth = self.columnAmount*Cell.cellSize + (self.columnAmount+1)*self.dividerSize
	local boardHeight = self.rowAmount*Cell.cellSize + (self.rowAmount+1)*self.dividerSize
	
	local xOffset = math.floor(Width/2)- math.floor(boardWidth/2);
	local yOffset = math.floor(Height/2)- math.floor(boardHeight/2);
	return xOffset, yOffset, boardWidth, boardHeight
end

function Board:orient()
	self.xAnchor , self.yAnchor = self:getOffset()
	for k=1, self.columnAmount do
		for j=1, self.rowAmount do
			local xCoord = (Board.dividerSize*k)+(Cell.cellSize*(k-1))+self.xAnchor;
			local yCoord = (Board.dividerSize*j)+(Cell.cellSize*(j-1))+self.yAnchor;
			local cell = self.grid[k][j]
			cell.x = xCoord;
			cell.y = yCoord;
		end
	end
end

function Board:init()
	self.xAnchor, self.yAnchor, boardWidth, boardHeight = self:getOffset()
	self.grid = {}
	for k=1, self.columnAmount do
		self.grid[k] = {}
		for j=1, self.rowAmount do
			local xCoord = (Board.dividerSize*k)+(Cell.cellSize*(k-1))+self.xAnchor;
			local yCoord = (Board.dividerSize*j)+(Cell.cellSize*(j-1))+self.yAnchor;
			self.grid[k][j] = Cell:new(xCoord,yCoord)
		end
	end
	self.boardWidth = boardWidth;
	self.boardHeight = boardHeight;
	if self.showDivider then print('Dividers on.') end
end

function Board:draw()
	local boardTop = self.grid[1][1].y
	local boardLeft = self.grid[1][1].x
	for cDex,column in ipairs(self.grid) do
		for rDex, cell in ipairs(column) do
			cell:draw()
			if self.showDivider and cDex == rDex then
				local dividerWidth = self.boardWidth-self.dividerSize
				local dividerHeight = self.boardHeight-self.dividerSize
				local originalColor = {love.graphics.getColor()}
				self.dividerColor(Color.set)
				-- vertical
				love.graphics.rectangle('fill', cell.x-self.dividerSize, boardTop, self.dividerSize, dividerHeight);
				-- horizontal
				love.graphics.rectangle('fill', boardLeft, cell.y-self.dividerSize, dividerWidth, self.dividerSize);
				if cDex == #self.grid then
					-- vertical
					love.graphics.rectangle('fill', cell.x+cell.cellSize, boardTop, self.dividerSize, dividerHeight);
					-- horizontal
					love.graphics.rectangle('fill', boardLeft, cell.y+cell.cellSize, dividerWidth, self.dividerSize);
				end
				love.graphics.setColor(unpack(originalColor))
			end
		end
	end
end

function Board:getCellNeighbors(cellX,cellY)
	local neighbors = {}
	for x=-1,1 do
		for y=-1,1 do
			if not(x==0 and y==0) then
				local nX = cellX+x;
				if nX<1 or nX>self.columnAmount then
					nX = ((nX-1)%self.columnAmount) + 1
				end
				local nY = cellY+y;
				if nY<1 or nY>self.rowAmount then
					nY = ((nY-1)%self.rowAmount) + 1
				end
				table.insert(neighbors,self.grid[nX][nY])
			end
		end
	end
	return neighbors
end

function Board:update()
	gridBuffer = {}
	for cDex,column in ipairs(self.grid) do
		gridBuffer[cDex] = {}
		for rDex, cell in ipairs(column) do
			-- evaluate neighbors
			local neighbors=self:getCellNeighbors(cDex,rDex)
				-- evaluate living count
			local nCount = 0;
			local nFactions = {}
			local majorityFaction = {Color.getc('white'), 0}
			for _,neighbor in ipairs(neighbors) do
				if neighbor.alive then
					local thisF = nFactions[neighbor.faction]
					nCount = nCount + 1
					nFactions[neighbor.faction] = thisF and thisF + 1 or 1;
				end
			end
			for faction,count in pairs(nFactions) do
				if count > majorityFaction[2] then majorityFaction[1] = faction; end
			end
			local alive 
			
			if cell.alive then
				for faction, count in pairs(nFactions) do
					if not(faction == cell.faction) then
						nCount = nCount - 1
					end
				end
				alive = 2 <= nCount and nCount <= 3
			else
				alive = (nCount == 3)
			end
			gridBuffer[cDex][rDex] = Cell:new(cell.x,cell.y):setAlive(alive):setFaction(majorityFaction[1])
		end
	end
	self.grid = gridBuffer
end


-- x,y is upper left
function Board:anchorSprite(sprite, x, y, faction)
	if type(faction) == 'string' then faction = Color.getc(faction) end 
	local sx = x;
	local sy = y;
	for dex=1, sprite:length()  do
		if sprite[dex] == 1 then
			self.grid[sx][sy]:setAlive(true):setFaction(faction);
		end
		if dex%sprite.info.xdim == 0 then sy=sy+1; sx = x;
		else sx = sx + 1; end
	end
end

return Board