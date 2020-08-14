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
    self.flags.flipped = false

    self.rect_position = {x, y}
    self.rect_size = {width, height}
    self.rect_bounds = {x, y, width, height}
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

function Entity:flipGravity()
    local current = self:gravity()

    self.gravity = function(self)
        local multiplier = 1
        if physics:flipped() then
            multiplier = -1
        end

        return current * multiplier
    end
end

function Entity:is(name)
    return tostring(self) == name
end

function Entity:setVelocity(x, y)
    if type(x) == "table" and x.isvector then
        self.speed = vector
    else
        self.speed = Vector(x, y)
    end
end

function Entity:velocity()
    return self.speed
end

function Entity:depth()
    return 1
end

function Entity:setPosition(x, y)
    self.x = x
    self.y = y

    self.rect_position[1] = x
    self.rect_position[2] = y

    self.rect_bounds[1] = x
    self.rect_bounds[2] = y
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
    return self.rect_bounds
end

function Entity:position()
    return self.rect_position
end

function Entity:center()
    local x, y = self.x + (self.width / 2), self.y + (self.height / 2)

    return Vector(x, y)
end

function Entity:size()
    return self.rect_size
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
