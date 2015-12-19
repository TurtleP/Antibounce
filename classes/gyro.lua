--[[
	Handle the gyro controls!
--]]

function newGyro(xAxis, yAxis, Zaxis, touch, unTouch)

	local gyro = {}

	if xAxis then
		gyro.onXAxis = xAxis
	end

	if yAxis then
		gyro.onYAxis = yAxis
	end

	if Zaxis then
		gyro.onZAxis = Zaxis
	end

	if touch then
		gyro.onTouch = touch
	end

	if unTouch then
		gyro.onReleaseTouch = unTouch
	end

	function gyro:touchPressed(id, x, y, pressure)
		self:onTouch(id, x, y, pressure)
	end

	function gyro:touchReleased(id, x, y, pressure)
		self:onReleaseTouch(id, x, y, pressure)
	end

	function gyro:axis(axis, value)
		if axis == 1 then
			self:onXAxis(value)
		elseif axis == 2 then
			self:onYAxis(value)
		elseif axis == 3 then
			self:onZAxis(value)
		end
	end

	return gyro
end

gameoverdone = love.graphics.newImage("graphics/doneandroid.png")