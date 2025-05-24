local Player = {}

local player = {}
sprite = nil
NORMAL_SPEED = 1.5 * 120
INJURED_SPEED_MULTIPLIER = 1.5

function Player.init(playerSprite)
	sprite = playerSprite
	Player.reset()
end

function Player.reset()
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.speed = NORMAL_SPEED
	player.isInjured = false
end

function Player.update(dt)
	-- Movement input
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

function Player.draw()
	love.graphics.draw(
		sprite,
		player.x,
		player.y,
		Player.getMouseAngle(),
		1,
		1,
		sprite:getWidth() / 2,
		sprite:getHeight() / 2
	)
end

function Player.getPosition()
	return player.x, player.y
end

function Player.getMouseAngle()
	local mouseX, mouseY = love.mouse.getPosition()
	return math.atan2(mouseY - player.y, mouseX - player.x)
end

function Player.setInjured(injured)
	player.isInjured = injured
	if injured then
		player.speed = NORMAL_SPEED * INJURED_SPEED_MULTIPLIER
	else
		player.speed = NORMAL_SPEED
	end
end

function Player.isInjured()
	return player.isInjured
end

return Player
