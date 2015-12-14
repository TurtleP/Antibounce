function newSpike(x, y, gravity)
	local spike = {}

	spike.x = x
	spike.y = y

	spike.passive = true
	spike.width = 8
	spike.height = 4
	spike.static = true
	spike.staticY = y

	spike.mask = {}
	spike.speedx = 0
	spike.speedy = 0
	spike.timer = 0

	local q = 1
	if gravity == -1 then
		q = 2
	end
	spike.quadi = q

	function spike:update(dt)
		if not self.start then

			if self.quadi == 1 then
				if self.y > self.staticY - self.height then
					self.y = self.y - 40 * dt
				else
					self.start = true
					self.passive = false
				end
			else
				self.start = true
				self.passive = false
			end
		end
	
		if self.start then
			self.timer = self.timer + dt
			if self.timer > 16 then
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
		end
	end

	function spike:draw()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(spikeimg, spikequads[self.quadi], self.x, self.y)
	end

	return spike
end