function newPlayer(x, y)
	local player = {}

	player.x = x
	player.y = y

	player.width = 8
	player.height = 8
	player.r = 4

	player.mask =
	{
		["tile"] = true,
		["spike"] = true
	}

	player.speedx = 0
	player.speedy = 0

	player.gravity = 600
	player.active = true

	player.quadi = 1
	player.deathtimer = 0
	--double tap to run/dash thing
	player.runpresses = {0, 0}

	function player:moveright(move)
		self.rightkey = move
	end

	function player:moveleft(move)
		self.leftkey = move
	end

	function player:moveactivate(move)
		self.activate = move
	end

	function player:upCollide(name, data)
		if name == "spike" then
			self:die()
		end

		if name == "tile" then
			self.speedy = 300
			jumpsnd:play()
			return false
		end
	end

	function player:flipGravity(g)
		self.gravity = 600
		if g < 0 then
			self.gravity = -600
		end
	end

	function player:die()
		if not self.dead then
			diesnd:play()
			self.dead = true
		end
	end

	function player:downCollide(name, data)
		if name == "spike" then
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
				self.remove = true
				gameover = true
			end

			self.speedx = 0
			self.speedy = 0

			return
		end

		local speed
		if not self.rightkey and not self.leftkey then
			speed = 0
		elseif self.leftkey then
			speed = -120
		elseif self.rightkey then
			speed = 120
		end

		self.speedx = speed
	end

	function player:passiveCollide(name, data)
		if name == "coin" then
			data:delete()
		end
	end

	function player:draw()
		if not self.dead then
			love.graphics.setColor(0, 90, 0)
			love.graphics.circle("fill", self.x + self.r, self.y + self.r, self.r)
			love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r)
		else
			if self.quadi < 7 then
				love.graphics.setColor(0, 90, 0)
				love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r)
				love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r)
			end

			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(playerdeathimg, deathquads[self.quadi], self.x, self.y)
		end
	end

	return player
end