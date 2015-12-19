backgroundSquare = class("backgroundSquare")

function backgroundSquare:init(x, y)
	self.x = x
	self.y = y

	self.width = love.math.random(2, 10)

	self.color = {0, love.math.random(130, 170), love.math.random(20, 40)}
	self.speed = love.math.random(80, 140)
end
	
function backgroundSquare:update(dt)
	self.x = self.x - self.speed * dt
	if self.x + self.width < -self.width then
		self.x = getWidth() + self.width
	end
end

function backgroundSquare:draw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.width)
end