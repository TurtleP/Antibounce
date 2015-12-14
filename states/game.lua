function game_load()
	state = "game"

	score = 0
	gameover = false

	colortimer = 0
	currentBackground = {0, love.math.random(100, 216), 43}
	toBackground = {0, love.math.random(100, 216), 43}

	cointimer = love.math.random(2, 4)
	gravity = 1

	gravityTimer = love.math.random(10, 16)

	gravityNotice = 0
	gameoverfade = 0

	gameSetup()
end

function game_update(dt)
	for k, v in ipairs(squares) do
		v:update(dt)
	end

	if colortimer > 3 then
		currentBackground = toBackground
		toBackground = {0, love.math.random(100, 216), 43}
		colortimer = 0
	else
		colortimer = colortimer + 2*dt
	end

	if gameover then
		if gameoverfade < 1 then
			gameoverfade = math.min(gameoverfade + 0.6 * dt, 1)
		else
			gameover_load()
		end
		return
	end

	if gravityTimer > 0 then
		gravityTimer = gravityTimer - dt
	else
		gravity = gravity * -1
		objects["player"][1]:flipGravity(gravity)
		gravityTimer = love.math.random(10, 16)
	end

	if gravityTimer < 2 then
		gravityNotice = gravityNotice + 8 * dt
	else
		gravityNotice = 0
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

	if cointimer > 0 then
		cointimer = cointimer - dt
	else
		if #objects["coin"] < 4 then
			local min, max = 20, 28
			if gravity == -1 then
				min, max = 2, 10
			end
			table.insert(objects["coin"], newCoin(love.math.random(2 * 8, 48 * 8), love.math.random(min * 8, max * 8)))
			cointimer = love.math.random(6)
		end

		if love.math.random(1, 7) == 1 then
			gameSpawnSpike()
		end
	end
end

function game_draw()
	love.graphics.setBackgroundColor(colorfade(colortimer, 3, currentBackground, toBackground))

	for k, v in ipairs(squares) do
		v:draw()
	end

	for k, v in pairs(objects) do
		for j, w in pairs(v) do
			if w.draw then
				w:draw()
			end
		end
	end

	love.graphics.setColor(0, 200, 0)
	love.graphics.setFont(myFont)
	love.graphics.print("Score: " .. score, 2, love.window.getHeight() - 12)

	love.graphics.print("Hi-Score: " .. highscore, love.window.getWidth() - myFont:getWidth("Hi-Score: " .. highscore) - 2, love.window.getHeight() - 12)

	if not gameover then
		love.graphics.setFont(myOtherFont)
		love.graphics.setColor(0, 100, 0, 255 * (math.floor(gravityNotice) % 2))
		love.graphics.print("GRAVITY SHIFTING!", love.window.getWidth() / 2 - myOtherFont:getWidth("GRAVITY SHIFTING!") / 2, love.window.getHeight() / 2 - myOtherFont:getHeight() / 2)
	else
		love.graphics.setColor(0, 0, 0, 255 * gameoverfade)
		love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())
	end
end

function gameSetup()
	objects = {}

	objects["tile"] = {}
	objects["player"] = {}
	objects["coin"] = {}
	objects["spike"] = {}

	objects["player"][1] = newPlayer(25 * 8, 26 * 8)

	for k = 1, 50 do
		table.insert(objects["tile"], newTile((k - 1) * 8, 232))
		table.insert(objects["tile"], newTile((k - 1) * 8, 0))
	end

	for k = 1, 30 do
		table.insert(objects["tile"], newTile(0, (k - 1) * 8))
		table.insert(objects["tile"], newTile(392, (k - 1) * 8))
	end
end

function gameSpawnSpike()
	local v = objects["player"][1]
	local trace = math.ceil((v.y + (v.height / 2)) / 8)

	if gravity == -1 then
		repeat
			trace = trace - 1
			print(trace, "!")
		until trace < 2
	else
		repeat
			trace = trace + 1
			print(trace, "!")
		until trace > 28
	end

	table.insert(objects["spike"], newSpike(math.floor(v.x / 8) * 8, trace * 8, gravity))
end

function game_keypressed(key)
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

function newBackgroundSquare(x, y)
	local squares = {}

	squares.x = x
	squares.y = y

	squares.width = love.math.random(2, 10)

	squares.color = {0, love.math.random(130, 170), love.math.random(20, 40)}
	squares.speed = love.math.random(80, 140)

	function squares:update(dt)
		self.x = self.x - self.speed * dt
		if self.x + self.width < -self.width then
			self.x = love.window.getWidth() + self.width
		end
	end

	function squares:draw()
		love.graphics.setColor(unpack(self.color))
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.width)
	end

	return squares
end