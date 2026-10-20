-- prices.lua
-- Money costs. Tile names match the map tiles; all road tiles use "road".

return {
	road       = 5,
	tower      = 150,
	building   = 50,
	park       = 5,    -- field / green tile
	water      = 5,
	clear_bush = 10,   -- cost to take down one bush tile

	 wheat_normal = 5,  -- cost to plant a field tile (the starting variant)

	-- Item prices, keyed by the same ids as items.data
	items = {
		wheat_poor   = 1,   -- placeholder values, tune later
		wheat_normal = 2,
		wheat_good   = 4,
		old_broom = 400,
		antique_bearded_axe = 11200,
		heavy_scimitar = 12800,
		antique_schiavona = 13600,
		battered_falchion = 11200,
		black_dagger = 1600,
		rusty_desert_sabre = 500,
		bronze_shortsword = 750,
		black_morning_star = 2580,
		pickaxe = 1000,
		rawhide_whip = 5000,
		double_edged_dwarven_battle_axe = 20000,
		huge_giant_sword = 2400,
		massive_reddened_steel_sword = 40000,
	},
}
