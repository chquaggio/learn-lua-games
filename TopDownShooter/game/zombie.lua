local Utils = require("game.utils")

local Zombie = {}
Zombie.__index = Zombie

local ZOMBIE_SPEED = 0.5 * 120

function Zombie.new(zombieSprite)
	local self = setmetatable({}, Zombie)

	self.sprite = zombieSprite
	self.speed = ZOMBIE_SPEED
	self.dead = false

	-- Spawn zombie at random edge of screen
	self:spawnAtEdge()

	return self
end

function Zombie:spawnAtEdge()
	local spawn = math.random(4)
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()

	if spawn == 1 then -- Top edge
		self.x = math.random(0, screenWidth)
		self.y = math.random(10, 20)
	elseif spawn == 2 then -- Bottom edge
		self.x = math.random(0, screenWidth)
		self.y = screenHeight - math.random(10, 20)
	elseif spawn == 3 then -- Left edge
		self.x = math.random(10, 20)
		self.y = math.random(0, screenHeight)
	else -- Right edge
		self.x = screenWidth - math.random(10, 20)
		self.y = math.random(0, screenHeight)
	end
end

function Zombie:update(dt, playerX, playerY)
	if self.dead then
		return
	end

	-- Move towards player
	local angle = self:getAngleToPlayer(playerX, playerY)
	self.x = self.x + math.cos(angle) * self.speed * dt
	self.y = self.y + math.sin(angle) * self.speed * dt
end

function Zombie:draw()
	if self.dead then
		return
	end

	love.graphics.draw(
		self.sprite,
		self.x,
		self.y,
		self.angle or 0,
		1,
		1,
		self.sprite:getWidth() / 2,
		self.sprite:getHeight() / 2
	)
end

function Zombie:getAngleToPlayer(playerX, playerY)
	self.angle = math.atan2(playerY - self.y, playerX - self.x)
	return self.angle
end

function Zombie:getPosition()
	return self.x, self.y
end

function Zombie:kill()
	self.dead = true
end

function Zombie:isDead()
	return self.dead
end

return Zombie
