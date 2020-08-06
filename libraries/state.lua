local state = {}

local ERRORS =
{
    EXIST = "Failed to load State '%s' does not exist!",
    INVALID = "Failed to load State '%s'! (didn't return its table?)",
    LOAD = "Failed to load State '%s'! (no load function?)"
}

function state:init()
    self.states = {}

    self.activeState = nil
    self.unloadingState = false

    if love.filesystem.getInfo("states") then
        local items = love.filesystem.getDirectoryItems("states")

        for i = 1, #items do
            local name = items[i]:gsub(".lua", "")
            self.states[name] = require("states." .. name)
        end
    end

    return self
end

-- UPDATE & DRAW CALLBACKS --

function state:isCurrentStateValid(funcname)
    local hasState = self.activeState ~= nil

    if funcname == "unload" then
        self.unloadingState = true
    end

    if not hasState then
        return false
    end

    local hasFunction = self.activeState[funcname]
    local isUnloading = self.unloadingState

    if not hasFunction or isUnloading then
        return false
    end

    return true
end

function state:update(dt)
    if not self:isCurrentStateValid("update") then
        return
    end

    self.activeState:update(dt)
end

function state:draw()
    if not self:isCurrentStateValid("draw") then
        return
    end

    self.activeState:draw()
end

-- GAMEPAD CALLBACKS --

function state:gamepadpressed(joy, button)
    if not self:isCurrentStateValid("gamepadpressed") then
        return
    end

    self.activeState:gamepadpressed(joy, button)
end

function state:gamepadreleased(joy, button)
    if not self:isCurrentStateValid("gamepadpressed") then
        return
    end

    self.activeState:gamepadreleased(joy, button)
end

function state:gamepadaxis(joy, axis, value)
    if not self:isCurrentStateValid("gamepadaxis") then
        return
    end

    self.activeState:gamepadaxis(joy, axis, value)
end

-- [[ OTHER STUFF ]] --

function state:call(func, ...)
    local args = {...}

    if self.activeState[func] then
        local ret = self.activeState[func](self.activeState, unpack(args))

        if ret then
            return ret
        end
    end
end

function state:unload()
    if self:isCurrentStateValid("unload") then
        self.activeState:unload()
    end
end

function state:load(which, ...)
    local arg = {...}

    assert(self.states[which], ERRORS.EXIST:format(which))

    assert(type(self.states[which]) ~= "boolean", ERRORS.INVALID:format(which))
    assert(self.states[which].load and type(self.states[which].load) == "function", ERRORS.LOAD:format(which))

    self.activeState:load(unpack(arg))
end

function state:switch(which, ...)
    self:unload()

    self.activeState = self.states[which]

    self:load(which, ...)

    self.unloadingState = false
end

return state:init()
