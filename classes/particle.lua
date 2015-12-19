particle = class("particle")

function particle:init(x, y, speedx, speedy)
	self.x = x 
	self.y = y

	self.r = 0.5
	self.width = 1
	self.height = self.width

	self.active = true

	self.speedx = speedx or 0
	self.speedy = speedy or 0

	self.gravity = 300 * gravity

	self.mask =
	{
		["tile"] = true,
	}

end

function particle:draw()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(255, 255, 255, 255)
end

function particle:downCollide(name, data)
	if name == "tile" then
		self.remove = true
	end
end

function particle:upCollide(name, data)
	if name == "tile" then
		self.remove = true
	end
end