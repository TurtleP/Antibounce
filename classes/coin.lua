coin = class("coin")

function coin:init(x, y)
	self.x = x
	self.y = y
	self.width = 4
	self.height = self.width

	self.r = self.width / 2
	self.fade = 1
	self.timer = 0
end

function coin:delete()
	addScore(1, combo + 1)
	coinsCollected = coinsCollected + 1

	if coinsCollected == math.floor(((currentLevel * 8) / 2) * difficultyMod) then
		nextLevel(currentLevel + 1)
	end

	coinsnd:play()
	self.remove = true
end

function coin:update(dt)
	self.timer = self.timer + dt
	if self.timer > 4 then
		self.fade = math.max(self.fade - 0.6 * dt, 0)
	end

	if self.fade == 0 then
		self.remove = true
	end
end

function coin:draw()
	love.graphics.setColor(255, 200, 0, 255 * self.fade)
	love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r, 64)
	love.graphics.circle("fill", self.x + self.r, self.y + self.r, self.r, 64)
end