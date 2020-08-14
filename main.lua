local nest = require("libraries.nest")

colors  = require("data.colors")
audio   = require("data.audio")

state   = require("libraries.state")
utility = require("libraries.utility")
tiled   = require("libraries.tiled")
physics = require("libraries.physics")
debug   = require("libraries.debug")
msgpack = require("libraries.msgpack")

function love.load()
    nest.init("hac")

    love.graphics.setDefaultFilter("nearest", "nearest")

    mainFont = love.graphics.newFont("graphics/04B_30.ttf", 32)
    scoreFont = love.graphics.newFont("graphics/04B_30.ttf", 18)

    backgroundMusic = love.audio.newSource("audio/bgm.ogg", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:play()

    highScore = nil

    if love.filesystem.getInfo("highscore") then
        highScore = msgpack.unpack(love.filesystem.read("highscore"))
    end

    love.math.setRandomSeed(os.time())
    love.graphics.setBackgroundColor(colors:get("Background"))

    state:switch("menu")
end

function love.update(dt)
    -- dt = math.min(dt, 1 / 60)

    state:update(dt)
end

function love.draw()
    state:draw()

    debug:draw()
end

function love.gamepadpressed(joy, button)
    if button == "a" then
        debug:toggle("fps")
    elseif button == "back" then
        love.event.quit()
    elseif button == "b" then
        colors:toggleMode()
    end

    state:gamepadpressed(joy, button)
end

function love.gamepadaxis(joy, axis, value)
    state:gamepadaxis(joy, axis, value)
end
