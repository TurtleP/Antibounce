credits =
{
	":: Antibounce ::",
	"",
	"A Ludum Dare #34 Game",
	"",
	":: Programming/Code ::",
	"TurtleP",
	"",
	":: Design/Art ::",
	"TurtleP",
	"",
	":: Music ::",
	"Tjakka5",
	"",
	":: Beta Testers ::",
	"Soso",
	"xkaype",
	"MMaker",
	"HugoBDesigner",
	"SauloFX",
	"Odyssey",
	"Muddmaker",
	"Idiot9.0",
	"",
	"",
	"This has been updated",
	"since initial release",
	"",
	"Check out my blog:",
	"http://www.jpostelnek.blogspot.com/"
}

function credits_load()
	state = "credits"
	creditsscroll = 0
	love.graphics.setFont(winFont)
end

function credits_update(dt)
	if creditsscroll < (((#credits - 1) * 21) + getHeight() / 2) - winFont:getHeight() / 2 then
		creditsscroll = creditsscroll + 60 * dt
	end
end

function credits_draw()
	love.graphics.translate(0, -creditsscroll)
	for k = 1, #credits do
		love.graphics.setColor(0, 90, 0)
		love.graphics.print(credits[k], getWidth() / 2 - winFont:getWidth(credits[k]) / 2, (getHeight() + (k - 1) * 21)) 
	end
end

function credits_keypressed(key)
	menu_load()
end

function credits_mousepressed(x, y, button)
	menu_load()
end