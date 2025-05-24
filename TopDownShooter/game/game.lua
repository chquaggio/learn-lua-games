local Player = require("game.player")
local Zombie = require("game.zombie")
local Bullet = require("game.bullet")
local Utils = require("game.utils")

local Game = {}

-- Game constants
local COLLISION_DISTANCE = 30
local INITIAL_MAX_TIME = 2
local MIN_TIME = 0.2
local SPAWN_TIME_REDUCTION = 0.95

function Game.load()
	math.randomseed(os.time())

	-- Load sprites
	Game.sprites = {}
	Game.sprites.background = love.graphics.newImage("assets/sprites/background.png")
	Game.sprites.bullet = love.graphics.newImage("assets/sprites/bullet.png")
	Game.sprites.player = love.graphics.newImage("assets/sprites/player.png")
	Game.sprites.zombie = love.graphics.newImage("assets/sprites/zombie.png")

	Game.font = love.graphics.newFont(30)

	-- Initialize game state
	Game.state = 1 -- 1 = menu, 2 = playing
	Game.score = 0
	Game.maxTime = INITIAL_MAX_TIME
	Game.timer = Game.maxTime
	Game.isInjured = false

	-- Initialize entities
	Player.init(Game.sprites.player)
	Game.zombies = {}
	Game.bullets = {}
end

function Game.update(dt)
	if Game.state == 2 then
		Player.update(dt)
		Game.updateZombies(dt)
		Game.updateBullets(dt)
		Game.updateSpawning(dt)
		Game.checkCollisions()
	end
end

function Game.updateZombies(dt)
	for _, zombie in ipairs(Game.zombies) do
		zombie:update(dt, Player.getPosition())
	end
	Utils.despawnEntities(Game.zombies)
end

function Game.updateBullets(dt)
	for _, bullet in ipairs(Game.bullets) do
		bullet:update(dt)
	end
	Utils.despawnEntities(Game.bullets)
end

function Game.updateSpawning(dt)
	Game.timer = Game.timer - dt
	if Game.timer <= 0 then
		Game.timer = Game.maxTime
		Game.spawnZombie()
		if Game.maxTime > MIN_TIME then
			Game.maxTime = SPAWN_TIME_REDUCTION * Game.maxTime
		end
	end
end

function Game.checkCollisions()
	local playerX, playerY = Player.getPosition()

	-- Player-zombie collisions
	for _, zombie in ipairs(Game.zombies) do
		if Utils.distance(playerX, playerY, zombie.x, zombie.y) < COLLISION_DISTANCE then
			if not Game.isInjured then
				Game.isInjured = true
				Player.setInjured(true)
				zombie.dead = true
				break
			else
				Game.gameOver()
				return
			end
		end
	end

	-- Bullet-zombie collisions
	for _, bullet in ipairs(Game.bullets) do
		for _, zombie in ipairs(Game.zombies) do
			if Utils.distance(bullet.x, bullet.y, zombie.x, zombie.y) < COLLISION_DISTANCE then
				zombie.dead = true
				bullet.dead = true
				Game.score = Game.score + 1
			end
		end
	end
end

function Game.gameOver()
	for _, zombie in ipairs(Game.zombies) do
		zombie.dead = true
	end
	Game.isInjured = false
	Player.reset()
	Game.state = 1
end

function Game.spawnZombie()
	local zombie = Zombie.new(Game.sprites.zombie)
	table.insert(Game.zombies, zombie)
end

function Game.spawnBullet()
	local playerX, playerY = Player.getPosition()
	local angle = Player.getMouseAngle()
	local bullet = Bullet.new(Game.sprites.bullet, playerX, playerY, angle)
	table.insert(Game.bullets, bullet)
end

function Game.draw()
	love.graphics.draw(Game.sprites.background, 0, 0)

	if Game.state == 1 then
		love.graphics.setFont(Game.font)
		love.graphics.printf("Click anywhere to begin!", 0, 40, love.graphics.getWidth(), "center")
	end

	if Game.state == 2 then
		love.graphics.setFont(Game.font)
		love.graphics.printf("Score: " .. Game.score, 10, 10, love.graphics.getWidth(), "left")
		if Game.isInjured then
			love.graphics.setColor(1, 0, 0)
		end
	end

	Player.draw()
	love.graphics.setColor(1, 1, 1)

	for _, zombie in ipairs(Game.zombies) do
		zombie:draw()
	end

	for _, bullet in ipairs(Game.bullets) do
		bullet:draw()
	end
end

function Game.keypressed(key)
	if key == "space" and Game.state == 2 then
		Game.spawnZombie()
	end
end

function Game.mousepressed(x, y, button)
	if button == 1 then
		if Game.state == 2 then
			Game.spawnBullet()
		elseif Game.state == 1 then
			Game.state = 2
			Game.maxTime = INITIAL_MAX_TIME
			Game.timer = Game.maxTime
			Game.score = 0
			Player.reset()
		end
	end
end

return Game
