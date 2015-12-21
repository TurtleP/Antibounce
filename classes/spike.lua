spike = class("spike")

function spike:init(x, y, gravity, tileObject)
	self.x = x
	self.y = y

	self.passive = true
	self.width = 8
	self.height = 8
	self.static = true
	self.staticY = y

	self.mask = {}
	self.speedx = 0
	self.speedy = 0
	self.timer = 0

	local q = 1
	if gravity == -1 then
		q = 2
	end
	self.quadi = q

	if not gravity then
		return
	end
	self.onTile = tileObject
	self.lifeTime = love.math.random(4, 8)
end

function spike:update(dt)
	if not self.start then
		if self.quadi == 1 then
			if self.y > self.staticY - self.height then
				self.y = math.min(self.y - 40 * dt, self.staticY - self.height)
			else
				self.start = true
				self.passive = false
			end
		else
			if self.y < self.staticY + self.height then
				self.y = math.max(self.y + 40 * dt, self.staticY + self.height)
			else
				self.start = true
				self.passive = false
			end
		end
	end
	
	if self.start and self.lifeTime then
		self.timer = self.timer + dt
		if self.timer > self.lifeTime then
			if self.quadi == 1 then
				self.y = self.y + 40 * dt
				if self.y > self.staticY then
					self.remove = true
				end
			else
				self.y = self.y - 40 * dt
				if self.y < self.staticY then
					self.remove = true
				end
			end
		end

		if self.remove then
			self.onTile.hasSpike = false
		end
	end
end
	
function spike:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(spikeimg, spikequads[self.quadi], self.x, self.y)
end