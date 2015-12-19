--[[
	Lower ball bounce volume
	Speed up music as levels grow
	Spike spawns increase as levels grow

	difficultyMod = 1 + (currentLevel) / 100 (max levels)
	spawnTimer + dt * difficultyMod

	spikeTimer = 0
	spikeRate = 5

	spikeTimer = spikeTimer + dt * difficultyMod
	if spikeTimer > spikeRate then
		--spawn
	end

	musicPitch = 1 * difficultyMod
--]]

function loadScripts()
	local path = "classes/"

	require (path .. 'backgroundsquare')
	require (path .. 'coin')
	require (path .. 'notice')
	require (path .. 'player')
	require (path .. 'spike')
	require (path .. 'tile')
	require (path .. 'rocket')
	require (path .. 'shield')
	require (path .. 'particle')

	path = "libraries/"

	require (path .. "functions")
	require (path .. "physics")

	path = "states/"

	require (path .. "credits")
	require (path .. "game")
	require (path .. "gameover")
	require (path .. "intro")
	require (path .. "menu")
end

function love.load()
	if love.system.getOS() ~= "3ds" then
		love.window.setTitle("Antibounce")
		love.graphics.setDefaultFilter("nearest", "nearest")
		love.window.setIcon(love.image.newImageData("graphics/icon.png"))
	end

	controls =
	{
		["right"] = "right",
		["left"] = "left",

		--not gameplay
		["pause"] = "escape"
	}

	highscore = 0

	tileimg = love.graphics.newImage("graphics/tile.png")

	spikeimg = love.graphics.newImage("graphics/spike.png")
	spikequads = {}
	for k = 1, 2 do
		spikequads[k] = love.graphics.newQuad((k - 1) * 8, 0, 8, 8, spikeimg:getWidth(), spikeimg:getHeight())
	end

	playerdeathimg = love.graphics.newImage("graphics/death.png")
	deathquads = {}
	for k = 1, 9 do
		deathquads[k] = love.graphics.newQuad((k - 1) * 9, 0, 8, 8, playerdeathimg:getWidth(), playerdeathimg:getHeight())
	end

	introimg = love.graphics.newImage("graphics/intro.png")
	pauseimg = love.graphics.newImage("graphics/pause.png")

	playbutton = love.graphics.newImage("graphics/playbutton.png")
	quitbutton = love.graphics.newImage("graphics/quitbutton.png")
	creditsbutton = love.graphics.newImage("graphics/creditsbutton.png")

	titleimg = love.graphics.newImage("graphics/title.png")
	hiscoreimg = love.graphics.newImage("graphics/hiscore.png")
	scoreimg = love.graphics.newImage("graphics/score.png")
	gravityimg = love.graphics.newImage("graphics/gravityshift.png")

	numberstring = "0123456789"
	numbersimg = love.graphics.newImage("graphics/numbers.png")
	numberquads = {}
	for k = 1, 10 do
		numberquads[k] = love.graphics.newQuad((k - 1) * 9, 0, 8, 8, numbersimg:getWidth(), numbersimg:getHeight())
	end

	bignumbersimg = love.graphics.newImage("graphics/bignumbers.png")
	bignumberquads = {}
	for k = 1, 10 do
		bignumberquads[k] = love.graphics.newQuad((k - 1) * 18, 0, 17, 16, bignumbersimg:getWidth(), bignumbersimg:getHeight())
	end

	gameoverimg = love.graphics.newImage("graphics/gameover.png")
	finalscore = love.graphics.newImage("graphics/scorefinal.png")
	gameoverdone = love.graphics.newImage("graphics/done.png")
	deletebutton = love.graphics.newImage("graphics/deletebutton.png")

	levelimg = love.graphics.newImage("graphics/wave.png")

	bgm = love.audio.newSource("audio/bgm.wav")

	jumpsnd = love.audio.newSource("audio/jump.wav")
	shielddownsnd = love.audio.newSource("audio/shielddown.wav")

	gravitysnd = love.audio.newSource("audio/gravity.wav")
	shieldsnd = love.audio.newSource("audio/shield.wav")
	coinsnd = love.audio.newSource("audio/coin.wav")
	diesnd = love.audio.newSource("audio/die.wav")
	selectsnd = love.audio.newSource("audio/selection.wav")
	pausesnd = love.audio.newSource("audio/pause.wav")

	winFont = love.graphics.newFont("graphics/upheaval.ttf", 20)

	--Require
	class = require 'libraries.middleclass'

	--SCALE
	scale = 2
	mobileMode = false

	loadScripts()

	local mobileDevices =
	{
		["iOS"] = true,
		["Android"] = true
	}

	changeScale(scale)
	if mobileDevices[love.system.getOS()] then
		mobileMode = true

		joystick = love.joystick.getJoysticks()[1]

		require 'classes/gyro'

		gyroController = newGyro(
			function(self, value)
				if not objects then
					return
				end

				local deadZone = 0.12
				local player = objects["player"][1]

				if not player then
					return
				end

				if value > deadZone then
					player:moveright(true)
					player:moveleft(false)
				elseif value >= 0 and value < deadZone then
					player:moveleft(false)
					player:moveright(false)
				elseif value < -deadZone then
					player:moveleft(true)
					player:moveright(false)
				elseif value > -deadZone and value <= 0 then
					player:moveleft(false)
					player:moveright(false)
				end
		end, nil, nil,
		
		function(self, id, x, y, pressure)
			if pressure > 0.5 then
				paused = not paused
			end
		end)

		changeScale()
	elseif love.system.getOS() == "3ds" then
		require 'libraries/3ds'
	end

	notices = {}

	intro_load()
end

function love.focus(f)
	if not f then
		paused = true
	end
end

function love.update(dt)
	dt = math.min(1/60, dt)

	if _G[state .. "_update"] then
		_G[state .. "_update"](dt)
	end

	if state ~= "intro" then
		if not bgm:isPlaying() then
			bgm:play()
		end
	end

	if gyroController and joystick then
		gyroController:axis(1, joystick:getAxis(1))
	end

	if #notices > 0 then
		for k, v in ipairs(notices) do
			v:update(dt)

			if v.remove then
				table.remove(notices, k)
			end
		end
	end
end

function love.draw()
	if love.graphics.scale then
		love.graphics.scale(scale, scale)
	end

	if mobileMode then
		love.graphics.translate((love.window.getWidth() / scale) / 2 - getWidth() / 2, (love.window.getHeight() / scale) / 2 - getHeight() / 2)
	end

	if _G[state .. "_draw"] then
		_G[state .. "_draw"]()
	end

	if #notices > 0 then
		for k, v in ipairs(notices) do
			v:draw()
		end
	end
end

function love.keypressed(key)
	if _G[state .. "_keypressed"] then
		_G[state .. "_keypressed"](key)
	end
end

function love.keyreleased(key)
	if _G[state .. "_keyreleased"] then
		_G[state .. "_keyreleased"](key)
	end
end

function love.saveData(isLoaded)
	if not isLoaded then
		if score > highscore then
			love.filesystem.write("highscore.txt", score)
		end
	else
		if not love.filesystem.exists("highscore.txt") then
			highscore = 0
			return
		end
		local s = love.filesystem.read("highscore.txt")
		highscore = tonumber(s)
	end
end

function love.deleteSave()
	love.filesystem.remove("highscore.txt")
	highscore = 0

	if not saveDataDeleted then
		saveDataDeleted = love.graphics.newImage("graphics/savedatanotice.png")
	end

	newNotice(saveDataDeleted, 4)
end

function love.mousepressed(x, y, button)
	if _G[state .. "_mousepressed"] then
		_G[state .. "_mousepressed"](x, y, button)
	end
end

function getWidth()
	return 400
end

function getHeight()
	return 240
end