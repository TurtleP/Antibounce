local Audio = {}

local CONST_AUDIO_PATH = "audio"

Audio.Bounce     = love.audio.newSource(CONST_AUDIO_PATH .. "/bounce.ogg",     "static")
Audio.Coin       = love.audio.newSource(CONST_AUDIO_PATH .. "/coin.ogg",       "static")
Audio.CoinBad    = love.audio.newSource(CONST_AUDIO_PATH .. "/coinbad.ogg",    "static")
Audio.Death      = love.audio.newSource(CONST_AUDIO_PATH .. "/dead.ogg",       "static")
Audio.Gravity    = love.audio.newSource(CONST_AUDIO_PATH .. "/gravity.ogg",    "static")
Audio.Heart      = love.audio.newSource(CONST_AUDIO_PATH .. "/oneup.ogg",      "static")
Audio.Hurt       = love.audio.newSource(CONST_AUDIO_PATH .. "/die.ogg",        "static")
Audio.Jump       = love.audio.newSource(CONST_AUDIO_PATH .. "/jump.ogg",       "static")
Audio.Pause      = love.audio.newSource(CONST_AUDIO_PATH .. "/pause.ogg",      "static")
Audio.Rocket     = love.audio.newSource(CONST_AUDIO_PATH .. "/rocket.ogg",     "static")
Audio.Selection  = love.audio.newSource(CONST_AUDIO_PATH .. "/selection.ogg",  "static")
Audio.Shield     = love.audio.newSource(CONST_AUDIO_PATH .. "/shield.ogg",     "static")
Audio.ShieldDown = love.audio.newSource(CONST_AUDIO_PATH .. "/shielddown.ogg", "static")

function Audio:play(name)
    if not self[name] then
        print("Failed to play sound '" .. name .. "'!")
        return
    end

    self[name]:play()
end

return Audio
