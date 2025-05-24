function love.load()
	target = {}
	target.x = 300
	target.y = 300
	target.radius = 50

	score = 0
	timer = 10
	gameState = 1

	gameFont = love.graphics.newFont(40)

	sprites = {}
	sprites.sky = love.graphics.newImage("sprites/sky.png")
	sprites.target = love.graphics.newImage("sprites/target.png")
	sprites.crosshairs = love.graphics.newImage("sprites/crosshairs.png")

	love.mouse.setVisible(false)
end

function love.update(dt)
	if timer > 0 then
		timer = timer - dt
	elseif timer <= 0 then
		timer = 0
		gameState = 1
	end
end

function love.draw()
	love.graphics.draw(sprites.sky, 0, 0)

	love.graphics.setColor(1, 1, 1)

	if gameState == 1 then
		love.graphics.setFont(gameFont)
		love.graphics.printf(
			"Click anywhere to begin!",
			0,
			love.graphics.getHeight() / 2 - 20,
			love.graphics.getWidth(),
			"center"
		)
	end

	if gameState == 2 then
		love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
		love.graphics.draw(
			sprites.crosshairs,
			love.mouse.getX(),
			love.mouse.getY(),
			0,
			1,
			1,
			sprites.crosshairs:getWidth() / 2,
			sprites.crosshairs:getHeight() / 2
		)

		love.graphics.setFont(gameFont)
		love.graphics.print("Score: " .. score, 10, 10)
		love.graphics.print("Time: " .. math.ceil(timer), 10, 60)
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	if gameState == 2 then
		if distance(x, y, target.x, target.y) <= target.radius then
			if button == 1 then
				score = score + 1
			elseif button == 2 then
				score = score + 2
				timer = timer - 1
			end
			target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
			target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
		else
			score = score - 1
			score = math.max(score, 0) -- Ensure score doesn't go negative
		end
	elseif button == 1 and gameState == 1 then
		gameState = 2
		timer = 30
		score = 0
	end
end

function distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
