spriteImage = love.graphics.newImage("sprite.png")

ball_x = 40 
ball_y = 40 

ball_speed_x = 4
ball_speed_y = 4

ball_radius = 3
ball_sprite = love.graphics.newQuad(0, 0, 6, 6, spriteImage:getDimensions())

paddle_x = 0
paddle_y = 150
paddle_width = 24
paddle_height = 8
paddle_sprite = love.graphics.newQuad(0, 8, 24, 8, spriteImage:getDimensions())
paddle_speed = 0

brick_sprite = {
	love.graphics.newQuad(0, 16, 16, 8, spriteImage:getDimensions()),
	love.graphics.newQuad(16, 16, 16, 8, spriteImage:getDimensions()),
	love.graphics.newQuad(32, 16, 16, 8, spriteImage:getDimensions()),
	love.graphics.newQuad(48, 16, 16, 8, spriteImage:getDimensions())
}

bricks = {
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 4,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3	
}

-- screen configuration
canvasResolution = {width = 320, height = 180}
canvasScale = 1
canvasOffset = {x = 0, y = 0}

configuration = {
	windowedScreenScale = 3,
	fullscreen = false,
	azerty = false
}

local mainCanvas = nil
function setupScreen()
	canvasScale = configuration.windowedScreenScale 

	if configuration.fullscreen then
		local dw, dh = love.window.getDesktopDimensions()
		--print(dw, dh)

		canvasScale = math.floor(math.min(dw / canvasResolution.width, dh / canvasResolution.height))
		canvasOffset.x = (dw - (canvasResolution.width * canvasScale)) * 0.5
		canvasOffset.y = (dh - (canvasResolution.height * canvasScale)) * 0.5
	else
		canvasOffset.x = 0
		canvasOffset.y = 0
	end

	local windowW = canvasResolution.width * canvasScale
	local windowH = canvasResolution.height * canvasScale
	love.window.setMode(windowW, windowH, {fullscreen = configuration.fullscreen})

	local formats = love.graphics.getCanvasFormats()
	if formats.normal then
		mainCanvas = love.graphics.newCanvas(canvasResolution.width, canvasResolution.height)
		mainCanvas:setFilter("nearest", "nearest")
	end
end

function love.load()
	setupScreen()

	ball_x = canvasResolution.width * 0.5
	ball_y = 140

	ball_speed_x = 120
	ball_speed_y = -80

	-- bricks

end

function love.update(dt)
	ball_x = ball_x + ball_speed_x * dt
	ball_y = ball_y + ball_speed_y * dt

	width = canvasResolution.width
	height = canvasResolution.height
	-- border collision
	-- left
	if ball_x - ball_radius < 0 then
		ball_x = ball_radius
		ball_speed_x = -ball_speed_x
	end

	-- right
	if ball_x + ball_radius >= width then
		ball_x = width - ball_radius - 1
		ball_speed_x = -ball_speed_x
	end

	-- top
	if ball_y - ball_radius < 0 then
		ball_y = ball_radius
		ball_speed_y = -ball_speed_y
	end

	-- bottom = lost
	


	-- update paddle
	mx, my = love.mouse.getPosition()
	local old_paddle_x = paddle_x
	paddle_x = math.min(width - paddle_width - 1, mx / canvasScale)
	paddle_speed = ((paddle_x - old_paddle_x) / dt) * 0.8 + 0.2 * paddle_speed

	-- ball/paddle collision
	if ball_x >= paddle_x and ball_x <= paddle_x + paddle_width then
		if ball_y > paddle_y - ball_radius and ball_y <= paddle_y + paddle_height - ball_radius then
			ball_speed_y = -ball_speed_y

			ball_speed_x = ball_speed_x + paddle_speed * 0.5
		end

	end
end

function love.draw()
	love.graphics.setCanvas(mainCanvas)
	love.graphics.clear()

	love.graphics.draw(spriteImage, ball_sprite, ball_x - ball_radius, ball_y - ball_radius)
	love.graphics.draw(spriteImage, paddle_sprite, paddle_x, paddle_y)

	-- bricks
	for i=1, 20 * 4, 1 do
		if bricks[i] ~=0 then
			local x = (i - 1) % 20
			local y = math.floor((i - 1) / 20)
			love.graphics.draw(spriteImage, brick_sprite[bricks[i]], x * 16, y * 8)
		end
	end

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.print(paddle_speed * 0.5, 0, 50)

	love.graphics.setCanvas()
	love.graphics.draw(mainCanvas, canvasOffset.x, canvasOffset.y, 0, canvasScale, canvasScale)	
end
