local Bullet = {}
Bullet.__index = Bullet

local BULLET_SPEED = 5 * 120

function Bullet.new(bulletSprite, startX, startY, angle)
	local self = setmetatable({}, Bullet)

	self.sprite = bulletSprite
	self.x = startX
	self.y = startY
	self.angle = angle
	self.speed = BULLET_SPEED
	self.dead = false

	return self
end

function Bullet:update(dt)
	if self.dead then
		return
	end

	-- Move bullet in the direction it was fired
	self.x = self.x + math.cos(self.angle) * self.speed * dt
	self.y = self.y + math.sin(self.angle) * self.speed * dt

	-- Check if bullet is off screen
	if self:isOffScreen() then
		self.dead = true
	end
end

function Bullet:isOffScreen()
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()

	return self.x < 0 or self.x > screenWidth or self.y < 0 or self.y > screenHeight
end

function Bullet:draw()
	if self.dead then
		return
	end

	love.graphics.draw(
		self.sprite,
		self.x,
		self.y,
		self.angle,
		0.3,
		0.3,
		self.sprite:getWidth() / 2,
		self.sprite:getHeight() / 2
	)
end

function Bullet:getPosition()
	return self.x, self.y
end

function Bullet:kill()
	self.dead = true
end

function Bullet:isDead()
	return self.dead
end

return Bullet
