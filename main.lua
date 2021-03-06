local core = {}
local key = {}
local buf = {}
Y = 0
local x
local y 
combo = 0

function core.glowRectangle()
	if love.keyboard.isDown("q") then
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("line", 795, 550, 59, -49)
		love.graphics.setColor(1, 1, 1, 1)
	end
	if love.keyboard.isDown("s") then
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.rectangle("line", 870, 550, 59, -49)
		love.graphics.setColor(1, 1, 1, 1)
	end
	if love.keyboard.isDown("d") then
		love.graphics.setColor(0, 0, 1, 1)
		love.graphics.rectangle("line", 945, 550, 59, -49)
		love.graphics.setColor(1, 1, 1, 1)
	end
	if love.keyboard.isDown("f") then
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("line", 1020, 550, 59, -49)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function love.draw()
	core.ui()
	if core.scene == 1 then
	   core.drawSceneGame()
	end
	for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end
	for i = 0, core.touch do
		if (buf[i] ~= nil) then
			love.graphics.setColor(math.random(0, 1), math.random(0,1), math.random(0,1), math.random(0,1))
			love.graphics.rectangle("fill", buf[i].x, buf[i].y, 50, 30)
		end
	    core.glowRectangle()
	end
	if core.scene == 0 then
	   core.drawSceneMenu()
	end
end

function key.setting()
	key[0], key[1], key[2], key[3] = {}, {}, {}, {}
	key[0].x = 800
	key[0].y = -50
	key[0].width = 50
	key[0].height = 50
	key[0].mode = 0
	key[1].x = 875
	key[1].y = -50
	key[1].width = 50
	key[1].height = 50
	key[1].mode = 0
	key[2].x = 950
	key[2].y = -50
	key[2].width = 50
	key[2].height = 50
	key[2].mode = 0
	key[3].x = 1025
	key[3].y = -50
	key[3].width = 50
	key[3].height = 50
	key[3].mode = 0
end

function love.load()
	love.window.setMode(1920, 1080, flags)
--	love.window.setFullscreen(true)
    require ('constants')
	key.setting()
	core["scene"] = 0 -- Scene : menu / game /other
	core["touch"] = -1 -- Nbr of items generated by the game
	core["mem"] = 0 -- Garbage collector cycles
	core["score"] = 0
	core["logo"] = love.graphics.newImage("images/menu.png")
	core["music"] = love.audio.newSource("audio/The Rolling Stones - Paint It, Black (Official Lyric Video).mp3", 'stream')
	core["music"]:setVolume(0.10)
	background = love.graphics.newImage("images/playing.png")
end

function key.appendBuffer()
     if (math.random(500) < 25) then
     	core.touch = core.touch + 1
     	buf[core.touch] = {}
     	buf[core.touch].x = key[math.random(4) - 1].x
     	buf[core.touch].anim = 1
      	buf[core.touch].y = -50
    end
end

function key.scrolling()
	for i = 0, core.touch do
		if (buf[i] ~= nil) then
			buf[i].y = buf[i].y + 5
		end
		if (buf[i] ~= nil and buf [i].y == 600) then
			buf[i].y = nil
			buf[i].x = nil
			buf[i] = nil
			combo = 0
		end
	end
end

function memoryCleaner()
	core.mem = core.mem + 1
	if (core.mem == 500) then
		  collectgarbage()
	end
end

function love.update(dt)
	x = love.mouse.getX()
	y = love.mouse.getY()
   	if core.scene == 1 then
		key.appendBuffer()
		key.scrolling()
		memoryCleaner()
	end
	if core.scene == 0 then
		if love.mouse.isDown(1) then
			core.scene = 1
		end
	end
end

function core.ui()
	love.graphics.setColor(1, 1, 1, 0.8)
	love.graphics.rectangle("fill", 795, 0, 60, 600)
	love.graphics.rectangle("fill", 870, 0, 60, 600)
	love.graphics.rectangle("fill", 945, 0, 60, 600)
	love.graphics.rectangle("fill", 1020, 0, 60, 600)
end

function key.checkClicked(x)
	for i = 0, core.touch do
		if (buf[i] ~= nil and buf[i].x == x and buf[i].y > 500 and buf[i].y < 650) then
		     buf[i].y = nil
		     buf[i].x = nil
		     buf[i] = nil
--	         buf[i].anim = buf[i].anim - 0.4
	         return (1)
		end
	end
	return(0)
end

function love.keypressed(myKey)
	if myKey == "q" and key.checkClicked(800) == 1 then
		core.score = core.score + 100
	    combo = combo + 1
	end
	if myKey == "s" and key.checkClicked(875) == 1 then
		core.score = core.score + 100
		combo = combo + 1
	end
	if myKey == "d" and key.checkClicked(950) == 1 then
		core.score = core.score + 100
		combo = combo + 1
	end
	if myKey == "f" and key.checkClicked(1025) == 1 then
		core.score = core.score + 100
		combo = combo + 1
	end
end

function core.drawSceneGame()
	love.graphics.setColor(1, 1, 1, 0.8)
	core.ui()
	love.graphics.setColor(0, 1, 0, 1)	
	love.graphics.print(core.score, 1650, 170, 0, 4, 4)
	for i = 0, core.touch do
		if (buf[i] ~= nil) then
			love.graphics.setColor(0, 0.66, 0.66, 1)
			if buf[i].anim < 1 then
				love.graphics.setColor(0, 0.33, 0.33, buf[i].anim)
			end
			love.graphics.rectangle("fill", buf[i].x, buf[i].y, 50, 30)
		end
	end
	love.graphics.setColor(0, 1, 0, 1)	
 	love.graphics.print(combo, 1650, 500, 0, 4, 4)
	love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.rectangle("fill", 423, 500, 1096, 40)
 	love.audio.play(core.music)
end

function core.drawSceneMenu()
	love.graphics.draw(core.logo, 0, 0)
end

function key.fadeOut()
	for i = 0, core.touch do
	    if (buf[i] ~= nil and buf[i].anim < 1) then
		      buf[i].anim = buf[i].anim - 0.1
		end
	    if (buf[i] ~= nil and buf[i].anim == 0) then
		     buf[i].y = nil
		     buf[i].x = nil
		     buf[i] = nil
		end
	end 
end