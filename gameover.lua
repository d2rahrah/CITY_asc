-- gameover.lua
function gameover:keypressed(key)
    if key == "return" then
        _G.gameState = "menu"
    end
end
