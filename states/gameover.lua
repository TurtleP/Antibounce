function gameover_load()
	state = "gameover"

	love.saveData()
end

function gameover_update(dt)
	for k, v in ipairs(squares) do
		v:update(dt)
	end
end

function gameover_draw()
	for k, v in ipairs(squares) do
		v:draw()
	end

	love.graphics.setFont(myOtherFont)

	love.graphics.setColor(0, 90, 0)
	love.graphics.print("Game Over", love.window.getWidth() / 2 - myOtherFont:getWidth("Game Over") / 2, love.window.getHeight() / 2 - myOtherFont:getHeight())

	love.graphics.print("Your score: " .. score, love.window.getWidth() / 2 - myOtherFont:getWidth("Your score: " .. score) / 2, love.window.getHeight() / 2 - myOtherFont:getHeight() / 2 + 8)

	love.graphics.setFont(myFont)
	love.graphics.print("Press ESCAPE to play again", love.window.getWidth() / 2 - myFont:getWidth("Press ESCAPE to play again") / 2, love.window.getHeight() / 2 + myFont:getHeight() / 2 + 16)
end

function gameover_keypressed(key)
	if key == "escape" then
		menu_load()
	end
end