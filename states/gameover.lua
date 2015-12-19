function gameover_load()
	state = "gameover"

	updateBGMPitch(1)
	
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

	love.graphics.setColor(0, 90, 0)
	love.graphics.draw(gameoverimg, getWidth() / 2 - gameoverimg:getWidth() / 2, 80)

	love.graphics.draw(finalscore, getWidth() / 2 - finalscore:getWidth() / 2, getHeight() / 2 - 8)
	numberPrint(score, (getWidth() / 2 - (#tostring(score) * 18) / 2), 144, true)
	
	love.graphics.draw(gameoverdone, getWidth() / 2 - gameoverdone:getWidth() / 2, 184)
end

function gameover_keypressed(key)
	menu_load()
end

function gameover_mousepressed(x, y, button)
	menu_load()
end