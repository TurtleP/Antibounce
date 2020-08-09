local Tiled = {}

-- Game
local Tile      = require("data.classes.tile")
local Player    = require("data.classes.player")
local SpikeWall = require("data.classes.spikewall")
local Spike     = require("data.classes.spike")
local CoinZone  = require("data.classes.coinzone")

-- Menu / General
local Square    = require("data.classes.square")
local Beam      = require("data.classes.beam")

function Tiled:init()
    -- map listing
    self.maps = {}

    -- current map data
    self.data = {}

    if love.filesystem.getInfo("data/maps") then
        local items = love.filesystem.getDirectoryItems("data/maps")

        for i = 1, #items do
            if not items[i]:find(".tmx") then
                local name = items[i]:gsub(".lua", "")
                self.maps[name] = require("data.maps." .. name)
            end
        end
    end

    self.squares = {}
    for index = 1, 50 do
        self.squares[index] = Square(love.math.random(love.graphics.getWidth()), love.math.random(love.graphics.getHeight()))
    end
end

function Tiled:clear()
    self.data = {}
end

function Tiled:loadMap(name)
    self:clear()

    local data = self.maps[name]

    for layerIndex = 1, #data.layers do
        if data.layers[layerIndex].type:find("object") then
            for entityIndex = 1, #data.layers[layerIndex].objects do
                local entity = data.layers[layerIndex].objects[entityIndex]

                self:spawnEntity(entity.name, {x = entity.x, y = entity.y,
                                               width = entity.width, height = entity.height,
                                               properties = entity.properties})
            end
        end
    end

    return self.data
end

function Tiled:sortByDepth()
    table.sort(self.data, function(a, b)
        return a:depth() > b:depth()
    end)
end

--[[
---- Spawns an Entity with @name and @args
---- @name : string for the class name
---- @args : table for properties (usually size at minimum)
---- Used for Static map Entity loading (aka at loadtime)
--]]
function Tiled:spawnEntity(name, args)
    local triggers =
    {
        play = function()
            state:switch("game")
        end,

        credits = function()
            state:switch("credits")
        end,

        quit = love.event.quit
    }

    if name == "tile" then
        table.insert(self.data, Tile(args.x, args.y - 8, args.width, args.height))
    elseif name == "spawn" or name == "player" then
        table.insert(self.data, Player(args.x + 16, args.y + 8))
    elseif name == "trigger" then
        table.insert(self.data, Beam(args.x, args.y - 8, triggers[args.properties.script], args.properties.script))
    elseif name == "spikewall" then
        table.insert(self.data, SpikeWall(args.x, args.y - 8, args.width, args.height, args.properties.direction))
    elseif name == "coinzone" then
        table.insert(self.data, CoinZone(args.x, args.y - 8, args.width, args.height))
    end
end

--[[
---- Spawns an Entity @entity
---- @entity: Entity class created
---- Used for Dynamic map Entity loading (conditional stuff, etc)
--]]
function Tiled:addEntity(entity)
    physics:addEntity(entity)
    table.insert(self.data, entity)
end

function Tiled:removeEntity(entity, index)
    physics:removeEntity(entity)
    table.remove(self.data, index)
end

function Tiled:update(dt)
    physics:update(dt)

    for index, value in ipairs(self.data) do
        if value:remove() then
            self:removeEntity(value, index)
        end
    end

    for _, value in ipairs(self.squares) do
        value:update(dt)
    end
end

function Tiled:draw()
    for _, value in ipairs(self.squares) do
        value:draw()
    end

    for _, value in pairs(self.data) do
        value:draw()
    end
end

Tiled:init()

return Tiled
