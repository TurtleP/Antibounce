function loadScripts(dir)
	if not dir then
		dir = ""
	end

	local files = love.filesystem.getDirectoryItems(dir)

	for k = #files, 1, -1 do
		if files[k] == "main.lua" then
			table.remove(files, k)
		end
	end

	for k = 1, #files do
		if files[k]:sub(-4) == ".lua" then
			print("requiring " .. files[k])
			require(dir .. files[k]:gsub(".lua", ""))
		else
			loadScripts(dir .. files[k] .. "/")
		end
	end
end

loadScripts()
love.graphics.setDefaultFilter("nearest", "nearest")
love.window.setIcon(love.image.newImageData("graphics/icon.png"))
function love.load()
	state = "game"

	controls =
	{
		["right"] = "right",
		["left"] = "left",
	}

	highscore = 0

	tileimg = love.graphics.newImage("graphics/tile.png")

	spikeimg = love.graphics.newImage("graphics/spike.png")
	spikequads = {}
	for k = 1, 2 do
		spikequads[k] = love.graphics.newQuad((k - 1) * 8, 0, 8, 4, spikeimg:getWidth(), spikeimg:getHeight())
	end

	playerdeathimg = love.graphics.newImage("graphics/death.png")
	deathquads = {}
	for k = 1, 9 do
		deathquads[k] = love.graphics.newQuad((k - 1) * 9, 0, 8, 8, playerdeathimg:getWidth(), playerdeathimg:getHeight())
	end

	playbutton = love.graphics.newImage("graphics/playbutton.png")
	quitbutton = love.graphics.newImage("graphics/quitbutton.png")

	bgm = love.audio.newSource("audio/bgm.wav")
	bgm:setLooping(true)
	bgm:play()

	jumpsnd = love.audio.newSource("audio/jump.wav")
	coinsnd = love.audio.newSource("audio/coin.wav")
	diesnd = love.audio.newSource("audio/die.wav")
	selectsnd = love.audio.newSource("audio/selection.wav")

	myFont = love.graphics.newFont("graphics/upheaval.ttf", 16)
	myOtherFont = love.graphics.newFont("graphics/upheaval.ttf", 32)

	love.window.setMode(400, 240)

	love.window.setTitle("Antibounce")

	menu_load()
end

function love.update(dt)
	dt = math.min(1/60, dt)
	if _G[state .. "_update"] then
		_G[state .. "_update"](dt)
	end
end

function love.draw()
	if _G[state .. "_draw"] then
		_G[state .. "_draw"]()
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