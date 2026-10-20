-- game.lua

local Map = require("map")
local Player = require("player")
local NPC = require("npc")

local Game = {}

function Game:load()
    Map:load()
    Player:load()
end



function Game:draw()
    Map:draw()
    Player:draw()
    for _, npc in ipairs(Map.npcs or {}) do
        npc:draw()
    end
end

function Game:keypressed(key)
    Player:keypressed(key)
end
function Game:update(dt)
    Player:update(dt)
end
return Game
