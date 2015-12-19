notice = class("notice")

function notice:init(t, duration)
	self.x = 0

	self.text = t

	self.width = t:getWidth() + 4
	self.height = t:getHeight() + 4

	self.y = -self.height
	self.start = false
	self.remove = false
	self.timer = duration or 4
end

function notice:update(dt)
	if not self.start then
		if self.y < 0 then
			self.y = math.min(self.y + 80 * dt, 0)
		else
			self.start = true
		end
	else
		if self.timer > 0 then
			self.timer = self.timer - dt
		else
			if self.y > -self.height then
				self.y = math.max(self.y - 80 * dt, -self.height)
			else
				self.remove = true
			end
		end
	end
end

function notice:draw()
	love.graphics.setColor(0, 120, 0, 255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.text, self.x + self.width / 2 - self.text:getWidth() / 2, self.y + self.height / 2 - self.text:getHeight() / 2)
end