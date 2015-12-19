rocket = class("rocket")

function rocket:init()
	self.x = getWidth() / 2 - 1
	self.y = getHeight() / 2 - 1
	self.r = 1

	self.width = 2
	self.height = self.width

	self.speedx = 0
	self.speedy = 0

	self.active = false

	self.speed = 100

	if objects["player"][1] then
		self.target = objects["player"][1]
	end

	self.lifeTime = love.math.random(3, 6)
	self.life = 0
end

function rocket:update(dt)
	if not self.target then
		self.remove = true
		return
	end

	local spinfactor = math.pi/90
	
	local a = math.atan2(self.speedy, self.speedx)
	local a2 = math.atan2((self.target.y + (self.target.height / 2))-self.y, self.target.x-self.x)
	if a < a2 and a2 - a > math.pi then spinfactor = spinfactor * (-1)
	elseif a > a2 and a - a2 <= math.pi then spinfactor = spinfactor * (-1) end
	
	a = a + spinfactor
	if a < 0 then a = a + math.pi*2
	elseif a >= math.pi*2 then a = a - math.pi*2 end
	
	self.speedx = self.speed*math.cos(a)
	self.speedy = self.speed*math.sin(a)

	self.x = self.x + self.speedx * dt
	self.y = self.y + self.speedy * dt

	self.life = self.life + dt
	if self.life > self.lifeTime then
		self.remove = true
	end

	if self.remove then
		table.insert(objects["rocket"], particle:new(self.x + self.r, self.y + self.r, -100))
		table.insert(objects["rocket"], particle:new(self.x + self.r * 2, self.y + self.r, 100))
	end
end

function rocket:draw()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r)
	love.graphics.circle("fill", self.x + self.r, self.y + self.r, self.r)
end