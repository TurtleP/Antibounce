local Audio = {}

local CONST_AUDIO_PATH = "audio"

Audio.Jump       = love.audio.newSource(CONST_AUDIO_PATH .. "/jump.ogg",       "static")
Audio.Coin       = love.audio.newSource(CONST_AUDIO_PATH .. "/coin.ogg",       "static")
Audio.Dead       = love.audio.newSource(CONST_AUDIO_PATH .. "/die.ogg",        "static")
Audio.Gravity    = love.audio.newSource(CONST_AUDIO_PATH .. "/gravity.ogg",    "static")
Audio.Pause      = love.audio.newSource(CONST_AUDIO_PATH .. "/pause.ogg",      "static")
Audio.Rocket     = love.audio.newSource(CONST_AUDIO_PATH .. "/rocket.ogg",     "static")
Audio.Shield     = love.audio.newSource(CONST_AUDIO_PATH .. "/shield.ogg",     "static")
Audio.ShieldDown = love.audio.newSource(CONST_AUDIO_PATH .. "/shielddown.ogg", "static")
Audio.Selection  = love.audio.newSource(CONST_AUDIO_PATH .. "/selection.ogg",  "static")

function Audio:play(name)
    self[name]:play()
end

return Audio
