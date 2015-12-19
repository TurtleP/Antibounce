shield = class("shield")

function shield:init(x, y)
	self.x = x
	self.y = y

	self.r = 3
	self.width = 6
	self.height = 6

	self.active = true
	self.mask = 
	{
		["tile"] = true
	}

	self.gravity = 600

	self.speedy = 0
	self.speedx = 0

	self.glowa = 1
	self.glowtime = 0

	self.lifeTime = 5
	self.life = 0
	self.alpha = 1
end

function shield:draw()
	love.graphics.setColor(69, 109, 165, 200 * self.alpha)
	love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r)
	love.graphics.circle("fill", self.x + self.r, self.y + self.r, self.r)

	love.graphics.setColor(255, 255, 200, 255 * self.alpha)
	love.graphics.rectangle("fill", self.x + self.width * 0.51, self.y + self.height * 0.23, 1, 1)
	love.graphics.rectangle("fill", self.x + self.width * 0.65, self.y + self.height * 0.40, 1, 1)
end

function shield:update(dt)
	self.life = self.life + dt
	if self.life > self.lifeTime then
		self.alpha = math.max(self.alpha - 0.6 * dt, 0)
	end

	if self.alpha == 0 then
		self.remove = true
	end
end

function shield:upCollide(name, data)
	if name == "tile" then
		if math.floor(self.speedy) < 0 then
			self.speedy = -(self.speedy * 0.5)
			return false
		end
	end
end

function shield:flipGravity()
	local g = gravity
	self.gravity = 600
	if g < 0 then
		self.gravity = -600
	end	
end

function shield:downCollide(name, data)
	if name == "tile" then
		if math.floor(self.speedy) > 0 then
			self.speedy = -(self.speedy * 0.5)
			return false
		end
	end
end