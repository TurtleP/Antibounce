local Entity = require("data.classes.entity")
local Tile = Entity:extend()

Tile.graphic = love.graphics.newImage("graphics/wall.png")
local CONST_TILE_SIZE = 32

function Tile:new(x, y, width, height)
    Tile.super.new(self, x, y, width or 32, height or 32)

    self.tileWidth = self.width / CONST_TILE_SIZE
    self.tileHeight = self.height / CONST_TILE_SIZE
end

function Tile:draw()
    love.graphics.setColor(1, 1, 1, 1)

    for y = 1, self.tileHeight do
        for x = 1, self.tileWidth do
            love.graphics.draw(Tile.graphic, self.x + (x - 1) * 32, self.y + (y - 1) * 32)
        end
    end
end

function Tile:static()
    return true
end

function Tile:__tostring()
    return "tile"
end

return Tile
