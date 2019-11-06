Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/chrono/Timer'
Camera = require 'libraries/stalker-x/Camera'
Physics = require 'libraries/windfield'
Moses = require 'libraries/moses/Moses'
require 'rooms/Room'
require 'objects/GameObject'

function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end

function slow(amount, duration)
    slow_amount = amount
    timer:tween(duration, _G, {slow_amount = 1}, 'in-out-cubic', 'slow')
end

function flash(frames)
    flash_frames = frames
end

function love.load()
    love.math.setRandomSeed(os.time())
    love.graphics.setDefaultFilter('nearest')
    love.graphics.setLineStyle('rough')

    slow_amount = 1

    resize(3)

    local room_files = {}
    recursiveEnumerate('rooms', room_files)
    requireFiles(room_files)
    
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)
    
    timer = Timer()

    input = Input()
    input:bind('up', 'up')
    input:bind('down', 'down')
    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('f1', function()
        print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end)
    input:bind('f2', function() gotoRoom('Stage', UUID()) end)
    input:bind('f3', function() current_room:destroy() end)

    camera = Camera()
    input:bind('f5', function() camera:shake(4, 2, 10) end)

    rooms = {}
    current_room = gotoRoom('Stage', UUID())
end

function love.update(dt)
    timer:update(dt*slow_amount)
    camera:update(dt*slow_amount)

    if current_room then current_room:update(dt*slow_amount) end
end

function love.draw()
    love.graphics.print("Hello World", 0, 0)

    if current_room then current_room:draw() end

    if flash_frames then 
        flash_frames = flash_frames - 1
        if flash_frames == -1 then flash_frames = nil end
    end
    if flash_frames then
        love.graphics.setColor(background_color)
        love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
        love.graphics.setColor(255, 255, 255)
    end
end

function love.keypressed(key)
    print('key pressed:', key)
end

function love.keyreleased(key)
    print('key released:', key)
end

function love.mousepressed(x, y, button)
    print('mouse pressed:', x, y, button)
end

function love.mousereleased(x, y, button)
    print('mouse released:', x, y, button)
end
