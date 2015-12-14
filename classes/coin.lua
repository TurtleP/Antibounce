function newCoin(x, y)
	local coin = {}

	coin.x = x
	coin.y = y
	coin.width = love.math.random(2, 4)
	coin.height = coin.width

	coin.r = coin.width / 2

	function coin:delete()
		score = score + 1

		if score%4 == 0 then
			gameSpawnSpike()	
		end

		if score > 8 then
			if score%2 == 0 then
				gameSpawnSpike()
			end
		end

		coinsnd:play()

		self.remove = true
	end

	function coin:draw()
		love.graphics.setColor(255, 200, 0)
		love.graphics.circle("line", self.x + self.r, self.y + self.r, self.r, 64)
		love.graphics.circle("fill", self.x + self.r, self.y + self.r, self.r, 64)
	end

	return coin
end