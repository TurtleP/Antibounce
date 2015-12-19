function menu_load()
	state = "menu"
	
	if not bgm:isPlaying() then
		bgm:play()
	end
	
	love.saveData(true)

	love.graphics.setBackgroundColor(unpack({0, 180, 43}))

	squares = {}
	for k = 1, 50 do
		squares[k] = backgroundSquare:new(love.math.random(getWidth()), love.math.random(getHeight()))
	end

	objects = {}
	objects["tile"] = {}
	objects["player"] = {player:new(6 * 8, 20 * 8, true)}

	for k = 1, 50 do
		if not (k > 10 and k < 14) and not (k > 19 and k < 23) and not (k > 28 and k < 32) and not (k > 37 and k < 41) then
			table.insert(objects["tile"], tile:new((k - 1) * 8, 232))
		end
	end

	for k = 1, 30 do
		table.insert(objects["tile"], tile:new(-8, (k - 1) * 8))
		table.insert(objects["tile"], tile:new(400, (k - 1) * 8))
	end

	menuTriggers = {}

	local triggerFuncs = { {function() game_load() end, playbutton}, {function() credits_load() end, creditsbutton}, {function() love.event.quit() end, quitbutton}, {function() love.deleteSave() menu_load() end, deletebutton} }
	for k = 1, 4 do
		menuTriggers[k] = newMenuTrigger((10 * 8) + (k - 1) * 9 * 8, 232, triggerFuncs[k][1], triggerFuncs[k][2])
	end

	doTransition = false
	menubeam = nil

	menufade = 1
end

function menu_draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(titleimg, getWidth() / 2 - titleimg:getWidth() / 2, getHeight() / 2 - titleimg:getHeight() / 2)

	for k, v in ipairs(squares) do
		v:draw()
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	for k, v in pairs(objects) do
		for j, w in pairs(v) do
			w:draw()
		end
	end

	if menubeam then
		menubeam:draw(dt)
	end

	for k, v in pairs(menuTriggers) do
		v:draw()
	end

	if doTransition then
		love.graphics.setColor(0, 0, 0, 255 * menufade)
		love.graphics.rectangle("fill", 0, 0, getWidth(), getHeight())
	else
		if menufade > 0 then
			love.graphics.setColor(0, 0, 0, 255 * menufade)
			love.graphics.rectangle("fill", 0, 0, getWidth(), getHeight())
		end
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

	for k, v in pairs(menuTriggers) do
		v:update(dt)
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
	else
		menufade = math.max(menufade - 0.6 * dt, 0)
		
		if menufade < 0.6 then
			if objects["player"][1] then
				if not objects["player"][1]:isMoving() then
					objects["player"][1]:setMoving(true)
				end
			end
		end
	end
end

function menu_keypressed(key)
	if not objects["player"][1] then
		return
	end

	if key == controls["right"] then
		objects["player"][1]:moveright(true)
	elseif key == controls["left"] then
		objects["player"][1]:moveleft(true)
	end
end

function menu_keyreleased(key)
	if not objects["player"][1] then
		return
	end

	if key == controls["right"] then
		objects["player"][1]:moveright(false)
	elseif key == controls["left"] then
		objects["player"][1]:moveleft(false)
	end

	if key == "escape" then
		love.event.quit()
	end	
end

function newBeam(x, y, f)
	local beam = {}

	beam.x = x
	beam.y = y
	beam.width = 24
	beam.maxWidth = 24
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

function newMenuTrigger(x, y, f, img)
	local trigger = {}

	trigger.x = x
	trigger.y = y
	trigger.width = 24
	trigger.height = 8
	trigger.fire = false
	trigger.func = f
	trigger.graphic = img

	function trigger:update(dt)
		if objects["player"][1] then
			local v = objects["player"][1]
			if not self.fire then
				if aabb(self.x, self.y, self.width, self.height, v.x, v.y, v.width, v.height) then
					self.fire = true
				end
			else
				if not menubeam then
					menubeam = newBeam(self.x, getHeight(), self.func)
					objects["player"][1] = nil
				end
			end
		end
	end

	function trigger:draw()
		--[[love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)]]
		love.graphics.setColor(255, 255, 255)

		love.graphics.draw(self.graphic, self.x + self.width / 2 - self.graphic:getWidth() / 2, self.y - self.height - self.graphic:getHeight())
	end

	return trigger
end