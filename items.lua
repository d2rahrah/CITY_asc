local items = {}

items.data = {
    old_broom = {
        name = "Old broom",
        type = "unknown",
        handed = 1,
        price = 400,
        minDamage = 4,
        maxDamage = 9,
        statScaling = { strength = 1.0 }
    },

    antique_bearded_axe = {
        name = "An antique bearded axe",
        type = "axe",
        handed = 1,
        price = 11200,
        minDamage = 15,
        maxDamage = 36,
        statScaling = { strength = 1.2 }
    },

    heavy_scimitar = {
        name = "A heavy scimitar",
        type = "sword",
        handed = 1,
        price = 12800,
        minDamage = 16,
        maxDamage = 38,
        statScaling = { strength = 1.2 }
    },

    antique_schiavona = {
        name = "An antique schiavona",
        type = "sword",
        handed = 1,
        price = 13600,
        minDamage = 17,
        maxDamage = 40,
        statScaling = { strength = 1.2 }
    },

    battered_falchion = {
        name = "A battered falchion",
        type = "sword",
        handed = 1,
        price = 11200,
        minDamage = 15,
        maxDamage = 36,
        statScaling = { strength = 1.1 }
    },

    black_dagger = {
        name = "Black dagger",
        type = "dagger",
        handed = 1,
        price = 1600,
        minDamage = 6,
        maxDamage = 13,
        statScaling = { strength = 1.0 }
    },

    rusty_desert_sabre = {
        name = "Rusty desert sabre",
        type = "sword",
        handed = 1,
        price = 500,
        minDamage = 4,
        maxDamage = 9,
        statScaling = { strength = 0.9 }
    },

    bronze_shortsword = {
        name = "Bronze shortsword",
        type = "sword",
        handed = 1,
        price = 750,
        minDamage = 5,
        maxDamage = 10,
        statScaling = { strength = 0.9 }
    },

    black_morning_star = {
        name = "Black morning star",
        type = "mace",
        handed = 1,
        price = 2580,
        minDamage = 9,
        maxDamage = 20,
        statScaling = { strength = 1.1 }
    },

    pickaxe = {
        name = "Pickaxe",
        type = "axe",
        handed = 1,
        price = 1000,
        minDamage = 7,
        maxDamage = 15,
        statScaling = { strength = 1.0 }
    },

    rawhide_whip = {
        name = "A rawhide whip",
        type = "whip",
        handed = 1,
        price = 5000,
        minDamage = 11,
        maxDamage = 24,
        statScaling = { strength = 0.9 }
    },

    double_edged_dwarven_battle_axe = {
        name = "A double-edged dwarven battle axe",
        type = "axe",
        handed = 2,
        price = 2000,
        minDamage = 8,
        maxDamage = 17,
        statScaling = { strength = 1.2 }
    },

    huge_giant_sword = {
        name = "A huge giant sword",
        type = "sword",
        handed = 2,
        price = 2400,
        minDamage = 9,
        maxDamage = 19,
        statScaling = { strength = 1.2 }
    },

    massive_reddened_steel_sword = {
        name = "A massive sword made from reddened steel",
        type = "sword",
        handed = 2,
        price = 40000,
        minDamage = 30,
        maxDamage = 45,
        statScaling = { strength = 1.5 }
    }
    -- You can continue appending more entries here from your list
}

function items.get(id)
    return items.data[id]
end

return items
