-- colors
Color = {}

function Color.create(_r, _g, _b, _a)
	return function(fn) return fn(_r, _g, _b, _a) end
end

	function Color.r(_r, _g, _b, _a) return _r end
	function Color.g(_r, _g, _b, _a) return _g end
	function Color.b(_r, _g, _b, _a) return _b end
	function Color.a(_r, _g, _b, _a) return _a end
	
	function Color.set(_r, _g, _b, _a) love.graphics.setColor(_r,_g,_b,_a) end
	
	function Color.test(_r, _g, _b, _a) print('Hello World') end
	
Color.colors = {
		Color.create(0,0,255,255), --blue
		Color.create(255,0,0,255), -- red
		Color.create(0,255,0,255), --green
		Color.create(160,32,240,255), --purple
		Color.create(255,165,0,255), --orange
		Color.create(255,255,0,255), -- yellow
		Color.create(255,127,80,255), --coral
		Color.create(0,255,255,255), --cyan
		Color.create(50,205,50,255), --lime
		Color.create(255,192,203,255), --pink
		Color.create(255,255,255,255), --white
		Color.create(121,121,121,50), --divider
	}
	
Color.reverse = {
		blue = 1;
		red = 2;
		green = 3;
		purple = 4;
		orange = 5;
		yellow = 6;
		coral = 7;
		cyan = 8;
		lime = 9;
		pink = 10;
		white = 11;
		divider = 12;
	}
	
function Color.getc(colorName)
	return Color.reverse[colorName]
end
	
return Color