function love.load()
	number = 0
end

function love.update(dt)
	number = number + dt
end

function love.draw()
	-- love.graphics.circle("fill", 100, 100, 50)
	love.graphics.arc("line", "open", 100, 100, 50, 0, number)
	love.graphics.arc("line", "open", 100, 200, 50, 0, number)
end
