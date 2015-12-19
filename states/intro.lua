function intro_load()
	state = "intro"
	
	introtimer = 0
	introtext = "A game by TurtleP"
	love.graphics.setFont(winFont)
	introfade = 1
	introDoFade = 0
end

function intro_update(dt)
	if introDoFade < 1 then
		introDoFade = introDoFade + dt
	else
		introtimer = introtimer + dt / 2
	end
	
	if math.floor(introtimer * 2) == 2 then
		menu_load()
	end
end

function intro_draw()
	love.graphics.setColor(255, 255, 255, 255 * math.max(introfade - introtimer, 0))
	love.graphics.draw(introimg, getWidth() / 2 - introimg:getWidth() / 2, getHeight() / 2 - introimg:getHeight() / 2)
	love.graphics.print(introtext, getWidth() / 2 - winFont:getWidth(introtext) / 2, getHeight() * 0.75)
end

function intro_keypressed(key)
	if introDoFade > 0.5 then
		menu_load()
	end
end

function intro_mousepressed(x, y, button)
	if introDoFade > 0.5 then
		if introDoFade > 0.5 then
			menu_load()
		end
	end
end