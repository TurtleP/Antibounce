player = class("player")

function player:init(x, y, respawns)
	self.x = x
	self.y = y

	self.oldx = x
	self.oldy = y

	self.width = 8
	self.height = 8
	self.r = 4

	self.mask =
	{
		["tile"] = true,
		["spike"] = true,
		["rocket"] = true
	}

	self.speedx = 0
	self.speedy = 0

	self.gravity = 600
	self.active = true

	self.quadi = 1
	self.deathtimer = 0

	self.canMove = true

	self.leftkey = false
	self.rightkey = false

	self.shield = false
	self.shieldPulse = 0
	self.shieldGlow = 0
end

function player:moveright(move)
	self.rightkey = move
end

function player:moveleft(move)
	self.leftkey = move
end

function player:upCollide(name, data)
	if name == "spike" then
		if self.shield then
			return self:loseShield()
		end
		self:die()
	end

	if name == "rocket" then
		shakeIntensity = 6
		data.remove = true
		if self.shield then
			return self:loseShield()
		end
		self:die()
	end

	if name == "tile" then
		self.speedy = 300
		jumpsnd:play()
		return false
	end
end

function player:loseShield(hor)
	shielddownsnd:play()

	if not hor then
		self.speedy = -self.speedy
	else
		self.speedx = -self.speedx
	end

	self.shield = false
	return false
end

function player:flipGravity(g)
	self.gravity = 600
	if g < 0 then
		self.gravity = -600
	end	
end

function player:die()
	if self.shield then
		return
	end

	if not self.dead then
		diesnd:play()
		self.dead = true
	end
end

function player:downCollide(name, data)
	if name == "spike" then
		if self.shield then
			return self:loseShield()
		end
		self:die()
	end

	if name == "rocket" then
		shakeIntensity = 6
		data.remove = true
		if self.shield then
			return self:loseShield()
		end
		self:die()
	end

	if name == "tile" then
		self.speedy = -300
		jumpsnd:play()
		return false
	end
end

function player:update(dt)
	if self.dead then
		self.deathtimer = self.deathtimer + 8 * dt
		if self.quadi < 9 then
			self.quadi = math.floor(self.deathtimer % 9) + 1
		else
			if not self.respawns then
				self.remove = true
				gameover = true
			else
				self.x = self.oldx
				self.y = self.oldy
			end
		end

		self.speedx = 0
		self.speedy = 0

		return
	end

	if self.shield then
		self.shieldPulse = self.shieldPulse + 8 * dt
		self.shieldGlow = (math.sin(self.shieldPulse)) / 2 + 0.5
	end

	if not self.canMove then
		return
	end
		
	if not self.rightkey and not self.leftkey then
		if self.speedx > 0 then
			self.speedx = self.speedx - 480 * dt
		else
			self.speedx = self.speedx + 480 * dt
		end
	elseif self.leftkey then
		if self.speedx > 0 then
			self.speedx = self.speedx - 480 * dt
		else
			self.speedx = math.max(self.speedx - 240 * dt, -200)
		end
	elseif self.rightkey then
		if self.speedx < 0 then
			self.speedx = self.speedx + 480 * dt
		else
			self.speedx = math.min(self.speedx + 240 * dt, 200)
		end
	end
end
	
function player:leftCollide(name, data)
	if name == "tile" then
		self.speedx = -self.speedx
		return false
	end

	if name == "rocket" then
		shakeIntensity = 6
		data.remove = true
		if self.shield then
			return self:loseShield(true)
		end
		self:die()
	end

	if name == "spike" then
		self.speedx = -self.speedx
		return false
	end
end
	
function player:rightCollide(name, data)
	if name == "tile" then
		self.speedx = -self.speedx
		return false
	end

	if name == "rocket" then
		shakeIntensity = 6
		data.remove = true
		if self.shield then
			return self:loseShield(true)
		end
		self:die()
	end

	if name == "spike" then
		self.speedx = -self.speedx
		return false
	end
end
	
function player:setMoving(lock)
	self.canMove = lock
end

function player:isMoving()
	return self.canMove
end
	
function player:passiveCollide(name, data)
	if name == "coin" then
		data:delete()
	elseif name == "shield" then
		self.shield = true
		shieldsnd:play()
		data.remove = true
	end
end

function player:draw()
	if not self.dead then
		love.graphics.setColor(0, 90, 0, 255)
		love.graphics.circle("fill", self.x + self.r, self.y + self.r, self.r)
		love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r)

		if self.shield then
			love.graphics.setColor(69, 109, 165, 160)
			love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r)
			love.graphics.circle("fill", self.x + self.r, self.y + self.r, self.r)
			love.graphics.setColor(255, 255, 255, 255)
		end
	else
		if self.quadi < 7 then
			love.graphics.setColor(0, 90, 0, 255)
			love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r)
			love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r)
		end
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(playerdeathimg, deathquads[self.quadi], self.x, self.y)
	end
end