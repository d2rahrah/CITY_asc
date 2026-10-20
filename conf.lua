function love.conf(t)
    t.window.title = "ASCII Roguelike Farm"
    t.window.width = 640
    t.window.height = 480
    t.window.resizable = false
    t.window.vsync = 1

    -- Pixel-perfect scaling (important for retro style)
    t.window.minwidth = 640
    t.window.minheight = 480

    -- Disable anti-aliasing for crisp pixels
    t.modules.joystick = false
    t.modules.physics = false
end
