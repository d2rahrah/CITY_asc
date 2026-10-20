--character_creator
local CharacterCreator = {}
local selectedIndex = 1
local selectable = { "str", "dex", "vit", "mag", "class", "name", "start" }

local statOrder = { "str", "dex", "vit", "mag" }

local statNames = {
    str = "Strength",
    dex = "Dexterity",
    vit = "Vitality",
    mag = "Magic"
}

local classes = {
    { name = "Warrior",      color = {1, 0, 0},    description = "Strong melee fighter." },
    { name = "Rogue",        color = {0, 1, 0},    description = "Agile and stealthy." },
    { name = "Mage",         color = {0.4, 0.4, 1}, description = "Master of spells." },
    { name = "Cleric",       color = {1, 1, 0.6},  description = "Healer and support." },
    { name = "Hunter",       color = {0.6, 0.4, 0.1}, description = "Ranged expert." },
    { name = "Monk",         color = {1, 0.6, 0},  description = "Balanced warrior." },
    { name = "Necromancer",  color = {0.5, 0, 0.5}, description = "Dark magic wielder." },
    { name = "Paladin",      color = {0.8, 0.8, 1}, description = "Holy warrior." },
}

local font_middle = love.graphics.newFont("fonts/PressStart2P-Regular.ttf", 16)
local font_large = love.graphics.newFont("fonts/PressStart2P-Regular.ttf", 28)

local minStat, maxStat = 4, 16

local stats = {}
local remainingPoints = 10
local selectedClass = 1
local playerName = ""

function CharacterCreator:load()
	_G.gameState = "character_creator"
    selectedIndex = 1
    selectedClass = 1
    playerName = ""
    remainingPoints = 10
    stats = {
        str = love.math.random(minStat, maxStat),
        dex = love.math.random(minStat, maxStat),
        vit = love.math.random(minStat, maxStat),
        mag = love.math.random(minStat, maxStat)
    }
end

function CharacterCreator:update(dt) end

function CharacterCreator:draw()
    love.graphics.setFont(font_middle)
    love.graphics.printf("Create Your Character", 0, 50, love.graphics.getWidth(), "center")

    local startX, startY = 60, 100

    love.graphics.print("Stats (Use ↑↓ to select, Enter to add):", startX, startY - 30)

    for i, key in ipairs(statOrder) do
        local y = startY + (i - 1) * 40
        local isSelected = (selectedIndex == i)
        if isSelected then
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", startX - 10, y - 4, 220, 28)
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(statNames[key] .. ": " .. stats[key], startX, y)
    end

    love.graphics.print("Points left: " .. remainingPoints, startX, startY + 180)

    -- Class selector
    local classY = startY + 240
    if selectedIndex == 5 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", startX - 10, classY - 4, 280, 28)
    end
    love.graphics.setColor(classes[selectedClass].color)
    love.graphics.print("Class: " .. classes[selectedClass].name, startX, classY)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(classes[selectedClass].description, startX, classY + 25)

    -- Name input
    local nameY = classY + 70
    if selectedIndex == 6 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", startX - 10, nameY - 4, 300, 28)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Name: " .. playerName, startX, nameY)

    -- Centered player character preview
    love.graphics.setFont(font_large)
    love.graphics.setColor(classes[selectedClass].color)
    love.graphics.printf("@", 0, 180, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(font_middle)

    -- Start Game
    local startXBtn = love.graphics.getWidth() - 180
    local startYBtn = love.graphics.getHeight() - 60
    if selectedIndex == 7 then
        love.graphics.rectangle("line", startXBtn - 10, startYBtn - 4, 160, 44)
    end
    love.graphics.print("Start Game", startXBtn, startYBtn)
end

function CharacterCreator:keypressed(key)
    if key == "up" then
        selectedIndex = math.max(1, selectedIndex - 1)
    elseif key == "down" then
        selectedIndex = math.min(#selectable, selectedIndex + 1)
    elseif key == "return" then
        local current = selectable[selectedIndex]
        if stats[current] then
            -- Stat upgrade
            if remainingPoints > 0 and stats[current] < maxStat then
                stats[current] = stats[current] + 1
                remainingPoints = remainingPoints - 1
            end
        elseif current == "start" and playerName ~= "" then
            self:startGame()
        end
    elseif key == "left" or key == "right" then
        if selectable[selectedIndex] == "class" then
            if key == "left" then
                selectedClass = (selectedClass - 2 + #classes) % #classes + 1
            else
                selectedClass = (selectedClass % #classes) + 1
            end
        end
    elseif key == "backspace" and selectable[selectedIndex] == "name" then
        playerName = playerName:sub(1, -2)
    end
end

function CharacterCreator:textinput(t)
    if selectable[selectedIndex] == "name" and #playerName < 12 then
        playerName = playerName .. t
    end
end

function CharacterCreator:startGame()
    local data = {
        name = playerName,
        class = classes[selectedClass].name,
        color = classes[selectedClass].color,
        stats = {
            Strength = stats.str,
            Dexterity = stats.dex,
            Vitality = stats.vit,
            Magic = stats.mag
        }
    }

    local Player = require("player")
    local Map = require("map")
    Player:initFromCharacterCreator(data) -- ✅ fixed (use : not .)
    Player.x, Player.y = 2, 2
    Map:load()
    _G.gameState = "playing"
end

return CharacterCreator
