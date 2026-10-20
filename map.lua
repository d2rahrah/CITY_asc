local NPC = require("npc")
local npc_data = require("npc_data")

local map = {}

function map:load()
    -- spawn a goblin at (5,5)
    NPC:new{
        name = npc_data.goblin.name,
        char = npc_data.goblin.char,
        color = npc_data.goblin.color,
        hp = npc_data.goblin.hp,
        str = npc_data.goblin.str,
        dex = npc_data.goblin.dex,
        hostile = npc_data.goblin.hostile,
        x = 5,
        y = 5
    }

    -- spawn a villager at (2,2)
    NPC:new{
        name = npc_data.villager.name,
        char = npc_data.villager.char,
        color = npc_data.villager.color,
        hp = npc_data.villager.hp,
        str = npc_data.villager.str,
        dex = npc_data.villager.dex,
        hostile = npc_data.villager.hostile,
        x = 2,
        y = 2
    }
end

return map
