local Object = require("libraries.classic")
local Entity = Object:extend()

local Vector = require("libraries.vector")

function Entity:new(x, y, width, height)
    self.x = x
    self.y = y

    self.width = width
    self.height = height

    self.speed = Vector()
    self.removed = false

    self.flags = {}

    self.flags.passive = false
    self.flags.remove  = false
end

function Entity:update(dt)

end

function Entity:draw()
    error("Entity.draw not implemented!")
end

function Entity:debugDraw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", unpack(self:bounds()))
end

function Entity:filter()
    return function(entity, other)
        if other:passive() then
            return false
        end
        return "slide"
    end
end

function Entity:is(name)
    return tostring(self) == name
end

function Entity:depth()
    return 1
end

function Entity:setPosition(x, y)
    self.x = x
    self.y = y
end

function Entity:gravity()
    return 360
end

function Entity:remove()
    return self.flags.remove
end

function Entity:setRemove(should)
    self.flags.remove = should
end

function Entity:bounds()
    return {self.x, self.y, self.width, self.height}
end

function Entity:size()
    return {self.width, self.height}
end

function Entity:static()
    return false
end

function Entity:setPassive(set)
    self.flags.passive = set
end

function Entity:passive()
    return self.flags.passive
end

return Entity
