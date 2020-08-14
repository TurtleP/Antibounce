local Entity = require("data.classes.entity")
local Player = Entity:extend()

local CONST_PLAYER_RADIUS = 16
local CONST_PLAYER_BOUNCE = 640
local CONST_PLAYER_MAX_SPEED = 320

local Ghost = require("data.classes.ghost")

Player.graphic = love.graphics.newImage("graphics/player.png")

function Player:new(x, y)
    Player.super.new(self, x, y, 32, 32)

    self.maxHearts = 3
    self.hearts = self.maxHearts

    self.flags.invincible = false
    self.flags.shield = false
    self.flags.dashing = false

    self.rightHeld = false
    self.leftHeld = false
    self.upHeld = false
    self.downHeld = false

    self.dashTimer = 0
    self.invincibleTimer = 0

    self.gravityPull = self:gravity()
end

function Player:update(dt)
    if self.flags.invincible then
        self.invincibleTimer = self.invincibleTimer + 24 * dt

        if self.invincibleTimer > 72 then
            self.flags.invincible = false
            self.invincibleTimer = 0
        end
    end

    if self.flags.dashing then
        self.dashTimer = self.dashTimer + 8 * dt
        if math.floor(self.dashTimer % 2) == 0 then
            tiled:addEntity(Ghost(self.x, self.y))
        end

        if self.dashTimer > 5.5 then
            self.dashTimer = 0
            self.flags.dashing = false
        end

        return
    end

    if self.rightHeld then
        self.speed.x = math.min(self.speed.x + CONST_PLAYER_MAX_SPEED * dt, CONST_PLAYER_MAX_SPEED)
    elseif self.leftHeld then
        self.speed.x = math.max(self.speed.x - CONST_PLAYER_MAX_SPEED * dt, -CONST_PLAYER_MAX_SPEED)
    else
        if self.speed.x > 0 then
            self.speed.x = math.max(self.speed.x - CONST_PLAYER_MAX_SPEED * dt, 0)
        else
            self.speed.x = math.min(self.speed.x + CONST_PLAYER_MAX_SPEED * dt, 0)
        end
    end
end

function Player:draw()
    if self.flags.invincible and math.floor(self.invincibleTimer % 4) == 0 then
        return
    end

    local color = colors:get("DarkGreen")
    if self.flags.shield then
        color = colors:get("DarkestGreen")
    end
    love.graphics.setColor(color)

    love.graphics.draw(Player.graphic, self.x, self.y)

    love.graphics.setColor(1, 1, 1)
end

local CONST_PLAYER_COLLECT =
{
    coin = true,
    heart = true,
    shield = true,
    rocket = true
}

local CONST_PLAYER_NOCOLLIDE =
{
    particle = true,
    coinzone = true,
    ghost = true,
    beam = true
}

function Player:filter()
    return function(entity, other)
        if CONST_PLAYER_COLLECT[tostring(other)] then
            if other:is("rocket") then
                if self:dashing() then
                    return
                end
                self:addHealth(-1)
            end

            other:collect()

            if other:is("heart") then
                self:addHealth(1)
            elseif other:is("shield") then
                self.flags.shield = true
            end

            return false
        elseif CONST_PLAYER_NOCOLLIDE[tostring(other)] or other:passive() then
            return false
        elseif not other:is("tile") and not other:is("spike") and not other:is("spikewall") and self:dashing() then
            return false
        end

        return "slide"
    end
end

function Player:gravity()
    if self.flags.dashing then
        return 0
    end
    return 1080
end

function Player:heartCount()
    return self.maxHearts
end

function Player:health()
    return self.hearts
end

function Player:addHealth(amount)
    if self.flags.invincible or self.flags.shield then
        if self.flags.shield then
            audio:play("ShieldDown")
            self.flags.shield = false
        end
        return
    end

    self.hearts = math.min(self.hearts + amount, self.maxHearts)

    if amount < 0 then
        audio:play("Hurt")

        if self.hearts > 0 then
            self.flags.invincible = true
        end
    end

    if self.hearts <= 0 then
        self:die()
    end
end

function Player:hasShield()
    return self.flags.shield
end

function Player:die()
    self.flags.remove = true

    state:call("spawnParticles", self, utility.Hex2Color("#2e7d32"))
    state:call("shakeScreen", 10)

    state:call("setGameover")
end

function Player:floorCollide(entity, name, type)
    if name == "tile" or name == "spike" then
        self.speed.y = -CONST_PLAYER_BOUNCE
        audio:play("Jump")

        if name == "spike" and entity:facing("up") then
            self:addHealth(-1)
        else
            if not physics:flipped() then
                self.flags.dashing = false
            end
        end

        return true
    end
end

function Player:leftCollide(entity, name, type)
    if name == "tile" or name == "spike" then
        self.speed.x = -self.speed.x
        audio:play("Jump")

        if name == "spike" and entity:facing("right") then
            self:addHealth(-1)
        end

        return true
    end
end

function Player:rightCollide(entity, name)
    if name == "tile" or name == "spike" then
        self.speed.x = -self.speed.x
        audio:play("Jump")

        if name == "spike" and entity:facing("left") then
            self:addHealth(-1)
        end

        return true
    end
end

function Player:ceilCollide(entity, name)
    if name == "tile" or name == "spike" then
        self.speed.y = CONST_PLAYER_BOUNCE
        audio:play("Jump")

        if name == "spike" and entity:facing("down") then
            self:addHealth(-1)
        end

        if physics:flipped() then
            self.flags.dashing = false
        end

        return true
    end
end

function Player:flipGravity()
    self.gravity = function(self)
        if self:dashing() then
            return 0
        end

        return self.gravityPull * state:call("gravity")
    end
end

function Player:moveRight(held)
    self.leftHeld = false
    self.rightHeld = held
end

function Player:moveLeft(held)
    self.rightHeld = false
    self.leftHeld = held
end

function Player:moveUp(held)
    self.downHeld = false
    self.upHeld = held
end

function Player:moveDown(held)
    self.upHeld = false
    self.downHeld = held
end

function Player:stop(hor)
    if hor then
        self.leftHeld = false
        self.rightHeld = false
    else
        self.downHeld = false
        self.upHeld = false -- what's upheld?
    end
end

function Player:anyHeld()
    return self.leftHeld or self.rightHeld or
           self.upHeld or self.downHeld
end

function Player:setDashing(isDashing)
    -- don't dash when not holding any buttons
    if not self:anyHeld() then
        return
    end

    if not self.flags.dashing and isDashing then
        self:setVelocity(0, 0)

        local gravity = state:call("gravity")

        if self.leftHeld then
            self.speed.x = -180
        elseif self.rightHeld then
            self.speed.x = 180
        end

        if self.upHeld then
            self.speed.y = -180 * gravity
        elseif self.downHeld then
            self.speed.y = 180 * gravity
        end
    end
    self.flags.dashing = isDashing
end

function Player:dashing()
    return self.flags.dashing
end

function Player:__tostring()
    return "player"
end

return Player
