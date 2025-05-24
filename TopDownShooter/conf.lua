function love.conf(t)
	t.identity = "TopDownShooter"
	t.window.title = "Top Down Shooter"
	t.window.width = 800
	t.window.height = 600
	t.window.resizable = false
	t.window.vsync = true

	-- Disable unused modules for better performance
	t.modules.joystick = false
	t.modules.physics = false
	t.modules.thread = false
	t.modules.video = false
	t.modules.touch = false
end
