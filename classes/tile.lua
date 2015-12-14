function newTile(x, y, i, layer)
	local tile = {}

	tile.x = x
	tile.y = y
	tile.width = 8
	tile.height = 8

	tile.speedx = 0
	tile.speedy = 0

	function tile:draw()
		love.graphics.draw(tileimg, self.x, self.y)
	end

	return tile
end