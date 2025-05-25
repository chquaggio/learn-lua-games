function love.load()
	love.window.setMode(1000, 768)

	anim8 = require("libraries/anim8/anim8")
	sti = require("libraries/Simple-Tiled-Implementation/sti")
	cameraFile = require("libraries/hump/camera")

	cam = cameraFile()

	sprites = {}
	sprites.playerSheet = love.graphics.newImage("assets/sprites/playerSheet.png")
	sprites.enemySheet = love.graphics.newImage("assets/sprites/enemySheet.png")
	sprites.flag = love.graphics.newImage("assets/maps/flag.png")

	local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
	local enemyGrid = anim8.newGrid(100, 79, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())

	animations = {}
	animations.idle = anim8.newAnimation(grid("1-15", 1), 0.05)
	animations.jump = anim8.newAnimation(grid("1-7", 2), 0.05)
	animations.run = anim8.newAnimation(grid("1-15", 3), 0.05)
	animations.enemy = anim8.newAnimation(enemyGrid("1-2", 1), 0.04)

	wf = require("libraries.windfield.windfield")
	world = wf.newWorld(0, 700, false)
	world:setQueryDebugDrawing(true)
	require("player")
	require("enemy")
	require("libraries.show")

	world:addCollisionClass("Platform")
	world:addCollisionClass("Goal")
	world:addCollisionClass("Danger")
	world:addCollisionClass("Player"--[[, { ignores = { "Platform" } }]])

	-- dangerZone = world:newRectangleCollider(0, 550, 800, 50, { collision_class = "Danger" })
	-- dangerZone:setType("static")

	platforms = {}

	goals = {}

	saveData = {}

	saveData.currentLevel = 1
	hasWon = false

	loadMap("level" .. saveData.currentLevel)
end

function love.update(dt)
	gameMap:update(dt)
	world:update(dt)
	updatePlayer(dt)
	updateEnemies(dt)

	cam:lookAt(player:getX(), love.graphics.getHeight() / 2)
	if hasWon then
		player:setPosition(360, 100)
		player:setType("static")
		destroyAll()
	end
end

function love.draw()
	cam:attach()
	world:draw()
	gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
	drawPlayer()
	drawEnemies()
	cam:detach()

	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Use arrow keys to move", 10, 10)
	if hasWon then
		love.graphics.setFont(love.graphics.newFont(32))
		love.graphics.print("You won! Press R to reset.", 10, 50)
	end
end

function love.keypressed(key)
	if key == "up" then
		if player.grounded then
			player:applyLinearImpulse(0, -4000)
		end
	end
	if key == "r" then
		hasWon = false
		player:setType("dynamic")
		saveData.currentLevel = 1
		loadMap("level" .. saveData.currentLevel)
	end
end

function love.mousepressed(x, y, button)
	if button == 1 then
		local colliders = world:queryCircleArea(x, y, 200, { "Platform", "Danger" })
		for _, c in ipairs(colliders) do
			c:destroy()
		end
	end
end

function spawnPlatform(x, y, width, height, name)
	if width > 0 and height > 0 then
		local newPlatform = world:newRectangleCollider(x, y, width, height, { collision_class = "Platform" })
		newPlatform:setType("static")
		newPlatform.name = name or "Platform"
		table.insert(platforms, newPlatform)
	end
end

function spawnGoals(x, y, width, height)
	if width > 0 and height > 0 then
		local newGoal = world:newRectangleCollider(x, y, width, height, { collision_class = "Goal" })
		newGoal:setType("static")
		table.insert(goals, newGoal)
	end
end

function destroyAll()
	local i = #platforms
	while i > -1 do
		if platforms[i] ~= nil then
			platforms[i]:destroy()
			table.remove(platforms, i)
		end
		i = i - 1
	end
	local j = #enemies
	while j > -1 do
		if enemies[j] ~= nil then
			enemies[j]:destroy()
			table.remove(enemies, j)
		end
		j = j - 1
	end
	local k = #goals
	while k > -1 do
		if goals[k] ~= nil then
			goals[k]:destroy()
			table.remove(goals, k)
		end
		k = k - 1
	end
end

function loadMap(mapName)
	player:setPosition(360, 100)
	destroyAll()
	gameMap = sti("assets/maps/" .. mapName .. ".lua", { "bump" })
	for _, obj in pairs(gameMap.layers["Platforms"].objects) do
		spawnPlatform(obj.x, obj.y, obj.width, obj.height, obj.name)
	end
	for _, obj in pairs(gameMap.layers["Enemies"].objects) do
		spawnEnemy(obj.x, obj.y)
	end
	for _, obj in pairs(gameMap.layers["Flag"].objects) do
		spawnGoals(obj.x, obj.y, obj.width, obj.height)
	end
end
