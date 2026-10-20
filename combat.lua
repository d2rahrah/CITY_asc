local combat = {}
--local NPC = require("npc")


function combat:load()
    -- Add combat system init here later if needed
end




-- Fallback weapon for unarmed attacks
local defaultUnarmed = {
    name = "Fists",
    type = "unarmed",
    handed = 2,
    price = 0,
    minDamage = 1,
    maxDamage = 3,
    statScaling = { strength = 2.8 }
}

-- Helper: Pick the first valid weapon in inventory if none wielded
local function chooseWeapon(entity)
    if entity.wieldedWeapon then
        return entity.wieldedWeapon
    end

    -- Check inventory for weapon-like item
    if entity.inventory then
        for _, item in pairs(entity.inventory) do
            if type(item) == "table" and (item.handed == 1 or item.handed == 2) then
                return item
            end
        end
    end

    return defaultUnarmed -- if nothing else, fists and str
end

-- Calculates final damage from weapon + stats
function combat.calculateDamage(attacker, weapon)
    weapon = weapon or defaultUnarmed
    local base = math.random(weapon.minDamage, weapon.maxDamage)
    local bonus = 0

    for stat, scale in pairs(weapon.statScaling or {}) do
        bonus = bonus + (attacker.stats[stat] or 0) * scale
    end

    return math.floor(base + bonus)
end

-- Main entry point for resolving an attack
function combat.resolveAttack(attacker, target)
    if not target or not target.stats then return end  -- Avoid nil or malformed target

    local weapon = chooseWeapon(attacker)
    local damage = combat.calculateDamage(attacker, weapon)

    target.stats.hp = math.max(0, target.stats.hp - damage)
	if target.stats.hp <= 0 then
		if target.die then
        target:die()
		end
	end
	
    if attacker.addMessage then
        attacker:addMessage(string.format("You hit %s for %d damage.", target.name or "the target", damage))
    end

    if target.stats.hp <= 0 then
        if attacker.addMessage then
            attacker:addMessage((target.name or "An NPC") .. " has been defeated.")
        end

        -- Require and call NPC death logic safely
        local NPC = require("npc")
        if NPC and NPC.kill then
            NPC:kill(target)
        end
	end
	
if target.isDead and target.xp and player.gainXP then
    player:gainXP(target.xp)
end


    return {
        damage = damage,
        weapon = weapon.name or "Unknown",
        remainingHp = target.stats.hp
    }
	


	
end



return combat