function menu_load()
	state = "menu"

	love.saveData(true)

	love.graphics.setBackgroundColor(unpack({0, love.math.random(100, 216), 43}))

	squares = {}
	for k = 1, 100 do
		squares[k] = newBackgroundSquare(love.math.random(love.window.getWidth()), love.math.random(love.window.getHeight()))
	end

	objects = {}
	objects["tile"] = {}
	objects["player"] = {newPlayer(6 * 8, 20 * 8)}

	for k = 1, 50 do
		if not (k > 19 and k < 22) and not (k > 29 and k < 32) then
			table.insert(objects["tile"], newTile((k - 1) * 8, 232))
		end
	end

	for k = 1, 30 do
		table.insert(objects["tile"], newTile(-8, (k - 1) * 8))
		table.insert(objects["tile"], newTile(400, (k - 1) * 8))
	end


	doTransition = false
	menubeam = nil

	menufade = 0
end

function menu_draw()
	love.graphics.setFont(myOtherFont)
	love.graphics.setColor(0, 90, 0)
	love.graphics.print("Antibounce", love.window.getWidth() / 2 - myOtherFont:getWidth("Antibounce") / 2, love.window.getHeight() / 2 - myOtherFont:getHeight() / 2)

	for k, v in ipairs(squares) do
		v:draw()
	end

	for k, v in pairs(objects) do
		for j, w in pairs(v) do
			w:draw()
		end
	end

	love.graphics.draw(playbutton, (17.5 * 8), 26 * 8)
	love.graphics.draw(quitbutton, (27.5 * 8), 26 * 8)

	if menubeam then
		menubeam:draw(dt)
	end

	if doTransition then
		love.graphics.setColor(0, 0, 0, 255 * menufade)
		love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())
	end
end

function menu_update(dt)
	for k, v in ipairs(squares) do
		v:update(dt)
	end

	physicsupdate(dt)
	for k, v in pairs(objects) do
		for j, w in pairs(v) do
			if w.update then
				w:update(dt)
			end
		end
	end

	if objects["player"][1].y > love.window.getHeight() then
		if not menubeam then
			local x = math.floor(objects["player"][1].x / 8)
			if x >= 19 and x <= 22 then
				menubeam = newBeam(x * 8, love.window.getHeight(), function() game_load() end)
			elseif x >= 29 and x <= 32 then
				menubeam = newBeam(x * 8, love.window.getHeight(), function() love.event.quit() end)
			end
		end
	end

	if menubeam then
		menubeam:update(dt)
	end

	if doTransition then
		if menufade < 1 then
			menufade = math.min(menufade + 0.6 * dt, 1)
		else
			menubeam.func()
		end
	end
end

function menu_keypressed(key)
	if key == controls["right"] then
		objects["player"][1]:moveright(true)
	elseif key == controls["left"] then
		objects["player"][1]:moveleft(true)
	end
end

function menu_keyreleased(key)
	if key == controls["right"] then
		objects["player"][1]:moveright(false)
	elseif key == controls["left"] then
		objects["player"][1]:moveleft(false)
	end
end

function newBeam(x, y, f)
	local beam = {}

	beam.x = x
	beam.y = y
	beam.width = 16
	beam.maxWidth = 16
	beam.timer = 3
	beam.beamx = x
	beam.func = f

	selectsnd:play()

	function beam:update(dt)
		self.timer = math.max(self.timer - dt / 0.3, 0)

		self.beamx = (self.x + self.width / 2) - (8 * self.timer) / 2
		self.maxWidth = 8*self.timer

		if self.maxWidth == 0 then
			doTransition = true
		end
	end

	function beam:draw()
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", self.beamx, 0, self.maxWidth, self.y)
	end

	return beam
end