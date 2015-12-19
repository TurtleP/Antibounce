controltypes = {love.graphics.newImage("graphics/circlepadnotice.png"), love.graphics.newImage("graphics/dpadnotice.png")}
controli = 1
controlNotice = love.graphics.newImage("graphics/controlnotice.png")

controls["right"] = "cpadright"
controls["left"] = "cpadleft"
controls["pause"] = "start"

local screens = {"top", "bottom"}

love.deleteSave = function()
	os.remove("smdc:/3ds/Antibounce/save.txt")
	highscore = 0

	if not saveDataDeleted then
		saveDataDeleted = love.graphics.newImage("graphics/savedatanotice.png")
	end

	newNotice(saveDataDeleted, 4)
end

love.saveData = function(isLoaded)
	local saveFile = io.open("smdc:/3ds/Antibounce/save.txt")
	if not isLoaded then
		if file then
			file:write("return {" .. score .. "," .. controli .. "}")
		end
	else
		if not file then
			highscore =  0
			return
		end
		data = loadstring(file:read("*a"))()

		highscore = tonumber(data[1])
		controli = tonumber(data[2])

		setControls()
	end
end

if love.system.getOS() ~= "3ds" then
	function love.graphics.setDepth() end
	function love.graphics.set3D() end

	love.window.setMode(400, 480)
	scale = 1

	local screen = "top"

	function love.graphics.getWidth()
		local ret = 400
		if screen == "bottom" then
			ret = 320
		end

		return ret
	end

	function love.graphics.setScreen(s)
		love.graphics.setScissor()
		love.graphics.origin()
		if s == "top" then
			love.graphics.setScissor(0,0,400,240)
			screen = "top"
		elseif s == "bottom" then
			love.graphics.setScissor(40,240,320,240)
			love.graphics.translate(40,240)
			screen = "bottom"
		end
	end
	
	if love.draw then
		local olddraw = love.draw
		
		function love.draw()
			if screen == "top" then
				love.graphics.setScissor(0,0,400,240)
			elseif screen == "bottom" then
				love.graphics.setScissor(40,240,320,240)
				love.graphics.translate(40,240)
			end
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("fill",0,240,40,240)
			love.graphics.rectangle("fill",360,240,40,240)
			love.graphics.setColor(255,255,255)
			olddraw()
			love.graphics.setScissor()
		end
	end

	controls =
	{
		["right"] = "right",
		["left"] = "left",

		--not gameplay
		["pause"] = "escape"
	}
else
	love.math = {}
	love.math.random = math.random
	scale = 1
end

love.graphics.set3D(true)

--hook into states for things
local oldMenuLoad = menu_load
menu_load = function()
	oldMenuLoad()

	newNotice(controlNotice, 4)

	squares = {}

	for k = 1, 2 do
		for x = 1, 25 do
			table.insert(squares, backgroundSquare:new(love.math.random(getWidth()), love.math.random(getHeight()), screens[k]))
		end
	end
end

local oldMenuDraw = menu_draw
menu_draw = function()
	love.graphics.setScreen("top")
	oldMenuDraw()

	if doTransition then
		love.graphics.setScreen("bottom")
		love.graphics.setColor(0, 0, 0, 255 * menufade)
		love.graphics.rectangle("fill", 0, 0, getWidth(), getHeight())
	else
		love.graphics.setScreen("bottom")
		if menufade > 0 then
			love.graphics.setColor(0, 0, 0, 255 * menufade)
			love.graphics.rectangle("fill", 0, 0, getWidth(), getHeight())
		end
	end

	love.graphics.setScreen("top")
end

local oldCreditsLoad = credits_load
credits_load = function()
	oldCreditsLoad()

	for k = 1, #credits do
		credits[k] = {credits[k], "bottom", (getHeight() + (k - 1) * 21)}
	end
end

credits_update = function(dt)
	for k, v in ipairs(credits) do
		if v[2] == "bottom" then
			if v[3] + winFont:getHeight() < 0 then
				v[3] = getHeight()
				v[2] = "top"
			else
				v[3] = v[3] - 80 * dt
			end
		else
			v[3] = v[3] - 80 * dt
		end
	end
end

credits_draw = function()
	for k = 1, #credits do
		love.graphics.setScreen(credits[k][2])
		love.graphics.setColor(0, 90, 0)
		love.graphics.print(credits[k][1], love.graphics.getWidth() / 2 - winFont:getWidth(credits[k][1]) / 2, credits[k][3]) 
	end
end

local function setControls()
	if controli == 1 then
		controls["right"] = "cpadright"
		controls["left"] = "cpadleft"
	else
		controls["right"] = "dright"
		controls["left"] = "dleft"
	end
	
	newNotice(controltypes[controli], 4)
end

local oldMenuKeyPress = menu_keypressed
menu_keypressed = function(key)
	oldMenuKeyPress(key)

	if #notices > 0 then
		return
	end

	if key == "lbutton" then
		controli = controli - 1
		if controli < 1 then
			controli = #controltypes
		end

		setControls()
	elseif key == "rbutton" then
		controli = controli + 1
		if controli > #controltypes then
			controli = 1
		end

		setControls()
	end
end

local oldIntroDraw = intro_draw
intro_draw = function()
	love.graphics.setScreen("top")

	oldIntroDraw()
end

--game
gameMakeTiles = function(func)
	--HORIZONTAL--

	--TOP
	table.insert(objects["tile"], tile:new(0, 0, 400, 8, screens[1]))

	table.insert(objects["tile"], tile:new(8, 232, 40, 8, screens[1]))

	table.insert(objects["tile"], tile:new(96, 232, 216, 8, screens[1]))

	table.insert(objects["tile"], tile:new(352, 232, 40, 8, screens[1]))

	--BOTTOM
	table.insert(objects["tile"], tile:new(56, 0, 216, 8, screens[2]))

	table.insert(objects["tile"], tile:new(8, 232, 312, 8, screens[2]))
	-----------------

	--VERTICAL--

	--TOP
	table.insert(objects["tile"], tile:new(0, 0, 8, 30 * 8, screens[1]))

	table.insert(objects["tile"], tile:new(392, 0, 8, 30 * 8, screens[1]))

	--BOTTOM
	table.insert(objects["tile"], tile:new(0, 0, 8, 30 * 8, screens[2]))

	table.insert(objects["tile"], tile:new(312, 0, 8, 30 * 8, screens[2]))
end

local oldGameDraw = game_draw
game_draw = function()
	oldGameDraw()

	if gameover or not gameBegin then
		love.graphics.setScreen("bottom")
		love.graphics.setColor(0, 0, 0, 255 * gameoverfade)
		love.graphics.rectangle("fill", 0, 0, 320, getHeight())
	end
end

--fancy things! hook into functions for 3D depth/screens
local entityLayer = 2

--BACKGROUND PARTICLES--
local oldSquareInit = backgroundSquare.init
backgroundSquare.init = function(self, x, y, screen)
	oldSquareInit(self, x, y)

	self.layer = love.math.random(2)

	self.screen = screen
end

local oldSquareDraw = backgroundSquare.draw
backgroundSquare.draw = function(self)
	love.graphics.setDepth(self.layer)

	love.graphics.setScreen(self.screen)

	oldSquareDraw(self)

	love.graphics.setScreen("top")

	love.graphics.setDepth(0)
end

--PLAYER--
local oldPlayerInit = player.init
player.init = function(self, x, y)
	oldPlayerInit(self, x, y)
	self.screen = "top"
end

player.getScreen = function(self)
	return self.screen
end

local oldPlayerUpdate = player.update
player.update = function(self, dt)
	oldPlayerUpdate(self, dt)

	if self.screen == "top" then
		if self.y > getHeight() then
			self.screen = "bottom"

			self.x = self.x - 40
			self.y = 0
		end
	else
		if self.y + self.height < 0 then
			self.screen = "top"

			self.x = self.x + 40
			self.y = 240 - self.height
		end
	end
end

local oldPlayerDraw = player.draw
player.draw = function(self)
	love.graphics.setDepth(entityLayer)

	love.graphics.setScreen(self.screen)

	oldPlayerDraw(self)

	love.graphics.setScreen("top")

	love.graphics.setDepth(0)
end

local oldUpCollide = player.upCollide
player.upCollide = function(self, name, data)
	if data.screen then
		if data.screen == self.screen then
			return oldUpCollide(self, name, data)
		else
			return false
		end
	end
end

local oldDownCollide = player.downCollide
player.downCollide = function(self, name, data)
	if data.screen then
		if data.screen == self.screen then
			return oldDownCollide(self, name, data)
		else
			return false
		end
	end
end

local oldRightCollide = player.rightCollide
player.rightCollide = function(self, name, data)
	if data.screen then
		if data.screen == self.screen then
			return oldRightCollide(self, name, data)
		else
			return false
		end
	end
end

local oldLeftCollide = player.leftCollide
player.leftCollide = function(self, name, data)
	if data.screen then
		if data.screen == self.screen then
			return oldLeftCollide(self, name, data)
		else
			return false
		end
	end
end

local oldPassiveCollide = player.passiveCollide
player.passiveCollide = function(self, name, data)
	if data.screen then
		if data.screen == self.screen then
			return oldPassiveCollide(self, name, data)
		end
	end
end

--SHIELD
local oldShieldInit = shield.init
shield.init = function(self, x, y)
	oldShieldInit(self, x, y)

	self.screen = screens[love.math.random(#screens)]
end

local oldShieldUpdate = shield.update
shield.update = function(self, dt)
	oldShieldUpdate(self, dt)

	if self.screen == "bottom" then
		if self.y > getHeight() then
			self.remove = true
		end
	end

	if self.screen == "top" then
		if self.y > getHeight() then
			self.screen = "bottom"

			self.x = self.x - 40
			self.y = 0
		end
	else
		if self.y + self.height < 0 then
			self.screen = "top"

			self.x = self.x + 40
			self.y = 240 - self.height
		end
	end
end

local oldShieldDraw = shield.draw
shield.draw = function(self)
	love.graphics.setDepth(entityLayer)

	love.graphics.setScreen(self.screen)

	oldShieldDraw(self)

	love.graphics.setDepth(0)
end

local oldShieldUpCollide = shield.upCollide
shield.upCollide = function(self, name, data)
	if data.screen then
		if data.screen == self.screen then
			return oldShieldUpCollide(self, name, data)
		else
			return false
		end
	end
end

local oldShieldDownCollide = shield.downCollide
shield.downCollide = function(self, name, data)
	if data.screen then
		if data.screen == self.screen then
			return oldShieldDownCollide(self, name, data)
		else
			return false
		end
	end
end

--ROCKET
local oldRocketInit = rocket.init
rocket.init = function(self)
	oldRocketInit(self)

	if objects["player"][1] then
		self.screen = objects["player"][1]:getScreen()
	end
end

local oldRocketUpdate = rocket.update
rocket.update = function(self, dt)
	oldRocketUpdate(self, dt)

	if self.screen == "top" then
		if self.y > getHeight() then
			self.screen = "bottom"

			self.x = self.x - 40
			self.y = 0
		end
	else
		if self.y + self.height < 0 then
			self.screen = "top"

			self.x = self.x + 40
			self.y = 240 - self.height
		end
	end
end

local oldRocketDraw = rocket.draw
rocket.draw = function(self)
	love.graphics.setDepth(entityLayer)

	love.graphics.setScreen(self.screen)

	oldRocketDraw()
	
	love.graphics.setDepth(0)
end

--COINS--
local oldCoinInit = coin.init
coin.init = function(self, x, y)
	oldCoinInit(self, x, y)

	self.screen = screens[love.math.random(#screens)]
end

local oldCoinDraw = coin.draw
coin.draw = function(self)
	love.graphics.setDepth(entityLayer)

	love.graphics.setScreen(self.screen)

	oldCoinDraw(self)

	love.graphics.setDepth(0)
end

--SPIKES
local oldSpikeInit = spike.init
spike.init = function(self, x, y, gravity, tileObject)
	oldSpikeInit(self, x, y, gravity, tileObject)

	self.screen = tileObject.screen
end

local oldSpikeDraw = spike.draw
spike.draw = function(self)
	love.graphics.setDepth(entityLayer)

	love.graphics.setScreen(self.screen)

	oldSpikeDraw(self)

	love.graphics.setDepth(0)
end

--TILES--
local oldTileInit = tile.init
tile.init = function(self, x, y, width, height, screen)
	oldTileInit(self, x, y, width, height)

	self.screen = screen or "top"
end

local oldTileDraw = tile.draw
tile.draw = function(self)
	love.graphics.setDepth(entityLayer)

	love.graphics.setScreen(self.screen)

	oldTileDraw(self)

	love.graphics.setDepth(0)
end