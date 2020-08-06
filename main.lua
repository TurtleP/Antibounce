local nest = require("libraries.nest")

state      = require("libraries.state")
utility    = require("libraries.utility")
tiled      = require("libraries.tiled")
physics    = require("libraries.physics")
debug      = require("libraries.debug")

audio      = require("data.audio")

--[[
    == TO DO LIST ==
    - Rockets
    - Shields (spawn)
    - Health pickups (spawn)

    - Difficulties:
        - Easy: No background squares, 5 health, coins last for 8s
        - Normal: Background squares, 3 health, coins last for 4s
        - Hard: Background squares, 1 health, fast paced, coins last for 2s?

    - High Score
    - Combos
    - "Dashing"
--]]

function love.load()
    nest.init("hac")

    love.graphics.setDefaultFilter("nearest", "nearest")

    mainFont = love.graphics.newFont("graphics/04B_30.ttf", 32)
    titleFont = love.graphics.newFont("graphics/04B_30.ttf", 80)
    scoreFont = love.graphics.newFont("graphics/04B_30.ttf", 18)

    backgroundMusic = love.audio.newSource("audio/bgm.ogg", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:play()

    colorTimer = 0

    currentBackground = utility.Hex2Color("#338a3e")
    toBackground = utility.Hex2Color("#66bb6a")

    love.math.setRandomSeed(os.time())

    state:switch("game")
end

function love.update(dt)
    dt = math.min(dt, 1 / 60)

    if colorTimer > 3 then
        local tmp = currentBackground
        currentBackground = toBackground
        toBackground = tmp
        colorTimer = 0
    else
        colorTimer = colorTimer + 2 * dt
    end

    state:update(dt)
end

function love.draw()
    local r, g, b = unpack(utility.ColorFade(colorTimer, 3, currentBackground, toBackground))

    love.graphics.setBackgroundColor(r, g, b)

    state:draw()

    debug:draw()
end

function love.gamepadpressed(joy, button)
    if button == "a" then
        debug:toggle()
    end
    state:gamepadpressed(joy, button)
end

function love.gamepadaxis(joy, axis, value)
    state:gamepadaxis(joy, axis, value)
end
