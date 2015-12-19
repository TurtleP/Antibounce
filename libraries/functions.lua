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

function changeScale(s)
	if s then
		scale = s
		love.window.setMode(400 * scale, 240 * scale, {vsync = true})
	else
		love.window.setFullscreen(true, "normal")

		local width, height = love.window.getDesktopDimensions()

		love.window.setMode(width, height, {vsync = true})

		scale = math.floor(math.max(width / 400, height / 240))
	end
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

function newNotice(text, duration)
	table.insert(notices, notice:new(text, duration))
end