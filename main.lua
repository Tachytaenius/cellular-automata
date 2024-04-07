local canvasWidth, canvasHeight
local canvas, canvas2
local ruleShader
local timer, timerLength

function love.load(args)
	local i = 1
	local function getArgStr()
		local ret = args[i]
		i = i + 1
		return ret
	end
	local function getArgNum()
		return tonumber(getArgStr())
	end

	canvasWidth = getArgNum() or 256
	canvasHeight = getArgNum() or 256
	local canvasWrap = getArgStr() or "repeat"
	local windowScale = getArgNum() or 2
	timerLength = getArgNum() or 0.125

	love.window.setMode(windowScale * canvasWidth, windowScale * canvasHeight)

	local imageData = love.image.newImageData(canvasWidth, canvasHeight)
	imageData:mapPixel(function(x, y)
		-- local r = (x + y) % 2 == 0 and 0 or 1
		local r = (
			(
				-- x == canvasWidth / 2 - 1 or
				x == canvasWidth / 2
			) and
			(
				-- y == canvasHeight / 2 - 1 or
				y == canvasHeight / 2
			)
		) and 1 or 0
		return r, r, r, 1
	end)
	local image = love.graphics.newImage(imageData)
	love.graphics.setDefaultFilter("nearest", "nearest")
	canvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
	canvas:setWrap(canvasWrap)
	love.graphics.setCanvas(canvas)
	love.graphics.draw(image)
	love.graphics.setCanvas()
	canvas2 = love.graphics.newCanvas(canvasWidth, canvasHeight)
	canvas2:setWrap(canvasWrap)
	ruleShader = love.graphics.newShader("shaders/rule.glsl")

	timer = 0
end

function love.update(dt)
	local timeMultiplier = love.keyboard.isDown("space") and 4 or 1
	timer = timer - dt * timeMultiplier
	if timer <= 0 then
		timer = timerLength
		canvas, canvas2 = canvas2, canvas
		love.graphics.setShader(ruleShader)
		love.graphics.setCanvas(canvas)
		-- No clear, because there isn't (shouldn't be, anyway) any transparency in shader return values
		love.graphics.draw(canvas2)
		love.graphics.setCanvas()
		love.graphics.setShader()
	end
end

function love.draw()
	local scale = math.floor(
		math.min(love.graphics.getDimensions())
		/ math.max(canvas:getDimensions())
	)
	local x = (love.graphics.getWidth() - scale * canvas:getWidth()) / 2
	local y = (love.graphics.getHeight() - scale * canvas:getHeight()) / 2
	love.graphics.draw(canvas, x, y, 0, scale)
end
