enemies = {}

function spawnEnemy(x, y)
	local enemy = world:newRectangleCollider(x, y, 70, 90, { collision_class = "Danger" })
	enemy.direction = 1
	enemy.speed = 200
	enemy.animation = animations.enemy

	table.insert(enemies, enemy)
end

function updateEnemies(dt)
	for _, enemy in ipairs(enemies) do
		enemy.animation:update(dt)
		local ex, ey = enemy:getPosition()

		local colliders = world:queryRectangleArea(ex + 40 * enemy.direction, ey + 40, 10, 10, { "Platform" })
		if #colliders == 0 then
			enemy.direction = -enemy.direction
		else
			for _, collider in ipairs(colliders) do
				if collider.name == "obstacle" then
					enemy.direction = -enemy.direction
					break
				end
			end
		end

		enemy:setX(ex + enemy.speed * dt * enemy.direction)
	end
end

function drawEnemies()
	for _, enemy in ipairs(enemies) do
		local ex, ey = enemy:getPosition()
		enemy.animation:draw(sprites.enemySheet, ex, ey, 0, enemy.direction, 1, 50, 50)
	end
end
