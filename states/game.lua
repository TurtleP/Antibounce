function game_load()
	state = "game"

	score = 0
	gameover = false
	paused = false

	colortimer = 0
	currentBackground = {0, love.math.random(140, 216), 43}
	toBackground = {0, love.math.random(140, 216), 43}

	gravity = 1

	gravityTimer = love.math.random(10, 16)

	gravityNotice = 0
	gameoverfade = 1

	currentLevel = 0
	difficultyMod = 1 + (currentLevel / 100)

	--[[
		Coins
		Spikes
		Rockets
		Tiles fall?
	--]]

	spikeTimer = 0
	spikeRate = 3

	coinTimer = 0
	coinRate = 2

	coinsCollected = 0

	rocketRate = 4
	rocketTimer = 0

	shieldRate = 6
	shieldTimer = 0

	combo = 0
	comboTimeout = 0

	gameSetup()
	
	gravityNotify = false
	gameBegin = false

	screenShake = 0
	shakeIntensity = 0
end

function game_update(dt)
	if shakeIntensity > 0 and not paused then
		shakeIntensity = shakeIntensity - 20 * dt
	end

	if difficultyMod > 0 then
		dt = dt * difficultyMod
	end

	if paused then
		return
	end

	if combo > 0 then
		if comboTimeout < 3 then
			comboTimeout = comboTimeout + dt
		else
			comboTimeout = 0
			combo = 0
			updateDifficulty()
		end
	end

	for k, v in ipairs(squares) do
		v:update(dt)
	end

	if colortimer > 3 then
		currentBackground = toBackground
		toBackground = {0, love.math.random(140, 216), 43}
		colortimer = 0
	else
		colortimer = colortimer + 2 * dt
	end

	if gameover then
		if gameoverfade < 1 then
			gameoverfade = math.min(gameoverfade + 0.6 * dt, 1)
		else
			gameover_load()
		end
		return
	end

	physicsupdate(dt)

	for k, v in pairs(objects) do
		for j, w in pairs(v) do
			if w.update then
				w:update(dt)
			end

			if w.remove then
				table.remove(objects[k], j)
			end
		end
	end
	
	if not gameBegin then
		if gameoverfade > 0 then
			gameoverfade = math.max(gameoverfade - 0.6 * dt, 0)
		else
			objects["player"][1]:setMoving(true)
			gameBegin = true
		end
	end

	gameUpdateSpawns(dt)
end

function game_draw()
	love.graphics.setBackgroundColor(unpack(colorfade(colortimer, 3, currentBackground, toBackground)))

	for k, v in ipairs(squares) do
		v:draw()
	end

	if shakeIntensity > 0 then
		love.graphics.translate( (love.math.random() * 2 - 1) * shakeIntensity, (love.math.random() * 2 - 1) * shakeIntensity ) 
	end
	
	for k, v in pairs(objects["spike"]) do
		v:draw()
	end
	
	for k, v in pairs(objects["tile"]) do
		v:draw()
	end

	for k, v in pairs(objects["rocket"]) do
		v:draw()
	end

	for k, v in pairs(objects["rocketParticle"]) do
		v:draw()
	end
	
	for k, v in pairs(objects["shield"]) do
		v:draw()
	end

	for k, v in pairs(objects["coin"]) do
		v:draw()
	end
	
	for k, v in pairs(objects["player"]) do
		v:draw()
	end

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(scoreimg, 2, 0)
	numberPrint(score, 2 + scoreimg:getWidth() + 4, 0)

	love.graphics.draw(hiscoreimg, getWidth() - hiscoreimg:getWidth() - (#tostring(highscore) * 8) - 6, 0)
	numberPrint(highscore, getWidth() - (#tostring(highscore) * 8) - 2, 0)

	if paused then
		love.graphics.draw(pauseimg, getWidth() / 2 - pauseimg:getWidth() / 2, getHeight() / 2 - pauseimg:getHeight())
	else
		if gameover or not gameBegin then
			love.graphics.setColor(0, 0, 0, 255 * gameoverfade)
			love.graphics.rectangle("fill", 0, 0, getWidth(), getHeight())
		end
	end
end

function numberPrint(str, x, y, big)
	local var = tostring(str)

	local out = {}
	for k = 1, #var do
		for x = 1, #numberstring do
			if var:sub(k, k) == numberstring:sub(x, x) then
				table.insert(out, x)
			end
		end
	end

	local img = numbersimg
	local quad = numberquads
	local space = 9 
	if big then
		space = 18
		img = bignumbersimg
		quad = bignumberquads
	end

	for j = 1, #out do
		love.graphics.draw(img, quad[out[j]], x + (j - 1) * space, y)
	end
end

function addScore(s, c)
	combo = math.min(c, 4)
	local comboValue = s * combo
	local add = s

	updateDifficulty()
	if combo > 1 then
		add = comboValue
		comboTimeout = 0
	end

	score = score + add
end

function updateDifficulty()
	if combo > 1 then
		difficultyMod = 1 + math.min(combo * 0.05 , 1.75) - 0.05
		updateBGMPitch(1 * difficultyMod)
	else
		difficultyMod = 1
		updateBGMPitch(1)
	end
end

function updateBGMPitch(i)
	if bgm.setPitch then
		bgm:setPitch(i)
	end
end

function gameUpdateSpawns(dt)
	if gameoverfade > 0 then
		return
	end
	
	--SPIKES
	spikeTimer = spikeTimer + dt
	if spikeTimer > spikeRate then
		gameSpawnSpike()
	end

	--COINS
	coinTimer = coinTimer + dt
	if coinTimer > coinRate then
		gameSpawnCoin()
	end
	
	--ROCKETS
	rocketTimer = rocketTimer + dt
	if rocketTimer > rocketRate then
		if spawnRocket then
			table.insert(objects["rocket"], rocket:new())
		end
		rocketTimer = 0
	else
		if rocketTimer > rocketRate - 1 then
			if not hasChecked then
				if love.math.random(100) < 20 then
					rocketalert:play()
					spawnRocket = true
				else
					spawnRocket = false
				end
				hasChecked = true
			end
		else
			hasChecked = false
			spawnRocket = false
		end	
	end

	--SHIELDS
	shieldTimer = shieldTimer + dt
	if shieldTimer > shieldRate then
		gameSpawnShield()
	end

	--GRAVITY
	if gravityTimer > 0 then
		gravityTimer = gravityTimer - dt
	else
		gravity = gravity * -1
		objects["player"][1]:flipGravity(gravity)

		if objects["shield"][1] then
			objects["shield"][1]:flipGravity(gravity)
		end

		gravityTimer = love.math.random(10, 16)
	end

	if gravityTimer < 1 then
		gravityNotice = gravityNotice + 8 * dt
		
		if not gravityNotify then
			gravitysnd:play()
			gravityNotify = true
		end
	else
		gravityNotify = false
		gravityNotice = 0
	end
end

function gameSpawnSpike()
	local v = objects["tile"][love.math.random(#objects["tile"])]

	if v.y >= 0 and v.x > 0 and v.x < getWidth() - 8 then
		if not v.hasSpike then
			local dir = 1
			if v.y == 0 then
				dir = -1
			end

			table.insert(objects["spike"], spike:new(v.x, v.y, dir, v))

			v.hasSpike = true
			spikeTimer = 0
		end
	else
		gameSpawnSpike()
	end
end

function gameSpawnCoin()
	local g = gravity

	local x = love.math.random(2 * 8, 48 * 8)
	local y
	if g == 1 then
		y = love.math.random(21 * 8, 28 * 8)
	else
		y = love.math.random(1 * 8, 8 * 8)
	end

	if #objects["coin"] > 0 then
		local lastCoin = objects["coin"][#objects["coin"]]

		if dist(lastCoin.x, lastCoin.y, x, y) <= 24 then
			gameSpawnCoin()
			return
		end
	end
	table.insert(objects["coin"], coin:new(x, y))

	coinTimer = 0
end

function gameSpawnShield()
	if objects["player"][1] then
		if objects["player"][1].shield or #objects["shield"] > 0 then
			shieldTimer = 0
			return
		end
	end

	if love.math.random(100) < 4 then
		table.insert(objects["shield"], shield:new(love.math.random(8, 48 * 8), 26 *  8))
	end
	shieldTimer = 0
end

function gameSetup()
	objects = {}

	objects["tile"] = {}
	objects["player"] = {}
	objects["coin"] = {}
	objects["spike"] = {}
	objects["rocket"] = {}
	objects["shield"] = {}
	objects["rocketParticle"] = {}

	objects["player"][1] = player:new(25 * 8, 26 * 8)

	gameMakeTiles()
end

function gameMakeTiles()
	for k = 1, 50 do
		table.insert(objects["tile"], tile:new((k - 1) * 8, 232))
		table.insert(objects["tile"], tile:new((k - 1) * 8, 0))
	end

	for k = 1, 30 do
		table.insert(objects["tile"], tile:new(0, (k - 1) * 8))
		table.insert(objects["tile"], tile:new(392, (k - 1) * 8))
	end
end

function game_keypressed(key)
	if key == controls["pause"] then
		if not gameover then
			paused = not paused

			if paused then
				pausesnd:play()
			end
		end
	end

	if not objects["player"][1] then
		return
	end

	if key == controls["right"] then
		objects["player"][1]:moveright(true)
	elseif key == controls["left"] then
		objects["player"][1]:moveleft(true)
	end
end

function game_keyreleased(key)
	if not objects["player"][1] then
		return
	end

	if key == controls["right"] then
		objects["player"][1]:moveright(false)
	elseif key == controls["left"] then
		objects["player"][1]:moveleft(false)
	end
end