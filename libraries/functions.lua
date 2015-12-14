function colorfade(currenttime, maxtime, c1, c2) --Color function, HugoBDesigner
	local tp = currenttime/maxtime
	local ret = {} --return color

	for i = 1, #c1 do
		ret[i] = c1[i]+(c2[i]-c1[i])*tp
		ret[i] = math.max(ret[i], 0)
		ret[i] = math.min(ret[i], 255)
	end

	return ret
end

function dist(x1, y1, x2, y2, ab)
	local ab = ab or "absolute" --true by default
	local width = x2-x1
	local height = y2-y1
	if ab == "absolute" then
		width = math.abs(width)
		height = math.abs(height)
	end
	return math.sqrt(width^2+height^2)
end

function makeShaders()
	shaders = {}

	shaders.bloom = love.graphics.newShader([[extern vec2 size;
	extern int samples = 5; // pixels per axis; higher = bigger glow, worse performance
	extern float quality = 2.5; // lower = smaller glow, better quality

	vec4 effect(vec4 colour, Image tex, vec2 tc, vec2 sc)
	{
	  vec4 source = Texel(tex, tc);
	  vec4 sum = vec4(0);
	  int diff = (samples - 1) / 2;
	  vec2 sizeFactor = vec2(1) / size * quality;
	  
	  for (int x = -diff; x <= diff; x++)
	  {
	    for (int y = -diff; y <= diff; y++)
	    {
	      vec2 offset = vec2(x, y) * sizeFactor;
	      sum += Texel(tex, tc + offset);
	    }
	  }
	  
	  return ((sum / (samples * samples)) + source) * colour;
	}]])
end