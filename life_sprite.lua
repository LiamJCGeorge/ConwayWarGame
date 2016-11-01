-- Life Sprite manager

LifeSprite = {
	
	index = function(t,k) 
		if type(k) == 'number' then return 0 end;
		return LifeSprite[k];
	end;
	
	new = function(self, patternName)
		print(patternName..' initialized.')
		setmetatable(self[patternName], {__index = function(t,k) return LifeSprite.index(t,k) end})
	end;
	
	-- range of values to cover
	length = function(self) return self.info.xdim*self.info.ydim; end;
	
	longest = function(self)
		local longest = 0;
		for dex = 1, self:length() do
			local v = ex%self.info.xdim;
			if v > longest then longest = v end;
		end
		return longest
	end;
	
	copy = function(self)
		local copy
		copy = {}
		for orig_key, orig_value in pairs(self) do
			copy[orig_key] = orig_value
		end
		return copy
	end;
	
	
	-- anchorX,Y must be positive
	combine = function(self, sprite2, anchorX, anchorY)
	
		assert(anchorX>=0 and anchorY>=0)
		local o = self:copy()
		local buffer = self:copy()
		local xDimChange = false
		
		local newXdim = math.max(anchorX+sprite2.info.xdim, o.info.xdim);
		if newXdim ~= o.info.xdim then
		
			xDimChange = newXdim - o.info.xdim
			
			o.info.xdim = newXdim
			print(self.info.xdim)
			buffer.info.xdim = newXdim
		end
		
		local newYdim = math.max(anchorY+sprite2.info.ydim, o.info.ydim);
		o.info.ydim = newYdim
		buffer.info.ydim = newYdim
		
		-- rescale existing indices to the new dimensions of the table
		local increment = 0
		if xDimChange then
			
			for dex=1, (o.info.xdim*o.info.ydim) do
				if buffer[dex] and buffer[dex]>0 then
					--print(string.format('changing %d to %d',dex, dex+increment))
					o[dex] = nil;
					o[dex+increment] = 1
					print(string.format('dex: %d  dex+inc: %d',dex, dex+increment))
				end
				if dex%self.info.xdim == 0 then
					increment = increment + xDimChange
				end
			end
		end
	
		-- add new indices from sprite2 to the table
		local start = (math.max(anchorY-1, 0)*o.info.xdim) + math.max(anchorX-1,0)
		--print(start)
		local increment = 1
		local rowInc = (o.info.xdim-sprite2.info.xdim)
		for dex=1, sprite2:length() do
			--print(string.format('dex: %d   inc: %d',dex,increment))
			if sprite2[dex] and sprite2[dex]>0 then
				o[start+increment] = 1
				--print(start+increment)
			end
			if dex%sprite2.info.xdim == 0 then
				increment = increment + rowInc
			end
			increment = increment + 1
		end
		
		return setmetatable(o,{__index = function(t,k) return LifeSprite.index(t,k) end})
	end;
	
	
	displayPattern = function(self)
		local stringPattern = '';
		local adder = ','
		for dex=1, self:length()  do
			if dex%self.info.xdim == 0 then adder = '\n' end
			stringPattern = stringPattern..self[dex]..adder
			adder = ','
		end
		return stringPattern;
	end;

}

-- SHIPS
-- glider
	LifeSprite.glider = {info = {xdim = 3, ydim = 3},
	0,0,1,
	1,0,1,
	0,1,1,
	}
	
	
	
-- STILL LIFE
-- block
	LifeSprite.block = { info = {xdim = 2, ydim = 2},
	1,1,
	1,1,
	};
	
	
--  OSCILLATORS
-- beacon 
	LifeSprite.beacon = { info = {xdim = 4, ydim = 4},
	1,1,0,0,
	1,1,0,0,
	0,0,1,1,
	0,0,1,1,
	};
	
-- blinker
	LifeSprite.blinker = { info = {xdim = 3, ydim = 1},
	1,1,1,
	};
	
-- toad
	LifeSprite.toad = { info = {xdim = 4, ydim = 2},
	1,1,1,0,
	0,1,1,1,
	};
	
-- base
	LifeSprite.base = { info = {xdim = 0, ydim = 0},};
	
--gunHandle
	LifeSprite.gunHandle = { info = {xdim = 8, ydim = 7},
	0,0,1,1,0,0,0,0,
	0,1,0,0,0,1,0,0,
	1,0,0,0,0,0,1,0,
	1,0,0,0,1,0,1,1,
	1,0,0,0,0,0,1,0,
	0,1,0,0,0,1,0,0,
	0,0,1,1,0,0,0,0,
	};

-- gunBarrel
	LifeSprite.gunBarrel = { info= {xdim = 5, ydim = 7},
	0,0,0,0,1,
	0,0,1,0,1,
	1,1,0,0,0,
	1,1,0,0,0,
	1,1,0,0,0,
	0,0,1,0,1,
	0,0,0,0,1,
	};

-- initializes all base patterns
for name, v in pairs(LifeSprite) do
	if type(v) == 'table' then
		LifeSprite:new(name)
	end
end

-- combinations can be created after this point

-- gliderGun
LifeSprite.gliderGun = LifeSprite.base:combine(LifeSprite.block, 0,6)
LifeSprite.gliderGun = LifeSprite.gliderGun:combine(LifeSprite.block, 6,0)
LifeSprite:new('gliderGun')


return LifeSprite