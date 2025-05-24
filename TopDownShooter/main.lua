function love.load()
	math.randomseed(os.time())

	sprites = {}
	sprites.background = love.graphics.newImage("sprites/background.png")
	sprites.bullet = love.graphics.newImage("sprites/bullet.png")
	sprites.player = love.graphics.newImage("sprites/player.png")
	sprites.zombie = love.graphics.newImage("sprites/zombie.png")

	player = {}
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.speed = 1.5 * 120
	player.rotation = 0

	myfont = love.graphics.newFont(30)

	zombies = {}

	bullets = {}

	collisionDistance = 30

	gameState = 1
	maxTime = 2
	score = 0
	timer = maxTime
	minTime = 0.2

	isInjured = false
end

function love.update(dt)
	if gameState == 2 then
		if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then
			player.x = player.x + player.speed * dt
		end
		if love.keyboard.isDown("a") and player.x > 0 then
			player.x = player.x - player.speed * dt
		end
		if love.keyboard.isDown("w") and player.y > 0 then
			player.y = player.y - player.speed * dt
		end
		if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then
			player.y = player.y + player.speed * dt
		end
	end

	for _, zombie in ipairs(zombies) do
		zombie.x = zombie.x + math.cos(playerZombieAngle(zombie)) * zombie.speed * dt
		zombie.y = zombie.y + math.sin(playerZombieAngle(zombie)) * zombie.speed * dt
		if distance(player.x, player.y, zombie.x, zombie.y) < collisionDistance then
			if not isInjured then
				isInjured = true
				player.speed = 1.5 * player.speed
				zombie.dead = true
				break
			end
			for _, v in ipairs(zombies) do
				v.dead = true
				isInjured = false
				gameState = 1
			end
			player.x = love.graphics.getWidth() / 2
			player.y = love.graphics.getHeight() / 2
		end
	end

	for _, bullet in ipairs(bullets) do
		bullet.x = bullet.x + math.cos(bullet.angle) * bullet.speed * dt
		bullet.y = bullet.y + math.sin(bullet.angle) * bullet.speed * dt
		if
			bullet.x < 0
			or bullet.x > love.graphics.getWidth()
			or bullet.y < 0
			or bullet.y > love.graphics.getHeight()
		then
			bullet.dead = true
		end

		for _, zombie in ipairs(zombies) do
			if distance(bullet.x, bullet.y, zombie.x, zombie.y) < collisionDistance then
				zombie.dead = true
				bullet.dead = true
				score = score + 1
			end
		end
	end

	despawnEntities(zombies)
	despawnEntities(bullets)

	if gameState == 2 then
		timer = timer - dt
		if timer <= 0 then
			timer = maxTime
			spawnZombie()
			if maxTime > minTime then
				maxTime = 0.95 * maxTime
			end
		end
	end
end

function love.draw()
	love.graphics.draw(sprites.background, 0, 0)

	if gameState == 1 then
		love.graphics.setFont(myfont)
		love.graphics.printf("Click anywhere to begin!", 0, 40, love.graphics.getWidth(), "center")
	end

	if gameState == 2 then
		love.graphics.setFont(myfont)
		love.graphics.printf("Score: " .. score, 10, 10, love.graphics.getWidth(), "left")
		if isInjured then
			love.graphics.setColor(1, 0, 0)
		end
	end

	love.graphics.draw(
		sprites.player,
		player.x,
		player.y,
		playerMouseAngle(),
		1,
		1,
		sprites.player:getWidth() / 2,
		sprites.player:getHeight() / 2
	)
	love.graphics.setColor(1, 1, 1) -- Reset color to white

	for _, zombie in ipairs(zombies) do
		love.graphics.draw(
			sprites.zombie,
			zombie.x,
			zombie.y,
			playerZombieAngle(zombie),
			1,
			1,
			sprites.zombie:getWidth() / 2,
			sprites.zombie:getHeight() / 2
		)
	end

	for _, bullet in ipairs(bullets) do
		love.graphics.draw(
			sprites.bullet,
			bullet.x,
			bullet.y,
			bullet.angle,
			0.3,
			0.3,
			sprites.bullet:getWidth() / 2,
			sprites.bullet:getHeight() / 2
		)
	end
end

function love.keypressed(key)
	if key == "space" then
		spawnZombie()
	end
end

function love.mousepressed(x, y, button)
	if button == 1 and gameState == 2 then
		spawnBullet()
	elseif button == 1 and gameState == 1 then
		gameState = 2
		maxTime = 2
		timer = maxTime
		score = 0
	end
end

function playerMouseAngle()
	local mouseX, mouseY = love.mouse.getPosition()
	local angle = math.atan2(mouseY - player.y, mouseX - player.x)
	return angle
end

function playerZombieAngle(zombie)
	local angle = math.atan2(player.y - zombie.y, player.x - zombie.x)
	return angle
end

function spawnZombie()
	local zombie = {}
	local spawn = math.random(4)
	if spawn == 1 then
		zombie.x = math.random(0, love.graphics.getWidth())
		zombie.y = math.random(10, 20)
	elseif spawn == 2 then
		zombie.x = math.random(0, love.graphics.getWidth())
		zombie.y = love.graphics.getHeight() - math.random(10, 20)
	elseif spawn == 3 then
		zombie.x = math.random(10, 20)
		zombie.y = math.random(0, love.graphics.getHeight())
	else
		zombie.x = love.graphics.getWidth() - math.random(10, 20)
		zombie.y = math.random(0, love.graphics.getHeight())
	end
	zombie.speed = 0.5 * 120
	zombie.dead = false
	table.insert(zombies, zombie)
end

function spawnBullet()
	local bullet = {}
	bullet.x = player.x
	bullet.y = player.y
	bullet.angle = playerMouseAngle()
	bullet.speed = 5 * 120
	table.insert(bullets, bullet)
end

function despawnEntities(entity)
	for i = #entity, 1, -1 do
		local e = entity[i]
		if e.dead == true then
			table.remove(entity, i)
		end
	end
end

function distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
