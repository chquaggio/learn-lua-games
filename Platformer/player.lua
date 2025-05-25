player = world:newRectangleCollider(360, 100, 40, 100, { collision_class = "Player" })
player:setFixedRotation(true)
player.speed = 240
player.animation = animations.idle
player.isMoving = false
player.direction = 1
player.grounded = true

function updatePlayer(dt)
	if player.body then
		local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + 50, 80, 2, { "Platform" })
		if #colliders > 0 then
			player.grounded = true
		else
			player.grounded = false
		end

		player.isMoving = false
		local px, py = player:getPosition()
		if love.keyboard.isDown("right") then
			player:setX(px + player.speed * dt)
			player.isMoving = true
			player.direction = 1
		end
		if love.keyboard.isDown("left") then
			player:setX(px - player.speed * dt)
			player.isMoving = true
			player.direction = -1
		end

		if player:enter("Danger") then
			player:setPosition(360, 100)
		end
		if player:enter("Goal") and saveData.currentLevel < 2 then
			saveData.currentLevel = saveData.currentLevel + 1
			loadMap("level" .. saveData.currentLevel)
		elseif player:enter("Goal") and saveData.currentLevel == 2 then
			hasWon = true
		end
	end

	if player.grounded then
		if player.isMoving then
			player.animation = animations.run
		else
			player.animation = animations.idle
		end
	else
		player.animation = animations.jump
	end
	player.animation:update(dt)
end

function drawPlayer()
	if player.body then
		local px, py = player:getPosition()
		player.animation:draw(sprites.playerSheet, px, py, 0, 0.25 * player.direction, 0.25, 130, 300)
	end
end
