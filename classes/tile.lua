tile = class("tile")

function tile:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width or 8
	self.height = height or 8

	self.speedx = 0
	self.speedy = 0

	self.hasSpike = false
end

function tile:draw()
	love.graphics.setColor(255, 255, 255, 255)

	for y = 1, self.height / 8 do
		for x = 1, self.width / 8 do
			love.graphics.draw(tileimg, self.x + (x - 1) * 8, self.y + (y - 1) * 8)
		end
	end
end