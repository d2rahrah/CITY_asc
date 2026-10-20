-- menu.lua
local menu = {}
_G.gameState = "menu"

function menu:load()
    -- Initialization logic for menu, if any
    self.selectedIndex = 1
    self.options = { "Start Game", "Character Creator", "Quit" }
end

function menu:update(dt)
    -- Animation or input delay handling here
end

function menu:draw()
    for i, option in ipairs(self.options) do
        local y = 100 + (i * 30)
        if i == self.selectedIndex then
            love.graphics.setColor(1, 1, 0) -- Highlight selected
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(option, 100, y)
    end
end

function menu:keypressed(key)
    if key == "down" then
        self.selectedIndex = self.selectedIndex % #self.options + 1
    elseif key == "up" then
        self.selectedIndex = (self.selectedIndex - 2) % #self.options + 1
    elseif key == "return" or key == "space" then
        local selection = self.options[self.selectedIndex]
        if selection == "Start Game" then
		local Player = require("player")
		local Map = require("map")
		Player:initRandom()
		Map:load()
		_G.gameState = "playing"
        elseif selection == "Character Creator" then
            _G.gameState = "character_creator"
        elseif selection == "Quit" then
            love.event.quit()
        end
    end
end

return menu
