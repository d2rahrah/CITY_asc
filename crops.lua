-- crops.lua
-- Wheat variants and the breeding rules. Rank 1 = poor, 2 = normal, 3 = good.
-- The tile name doubles as the stock resource name, so harvesting a wheat_good
-- tile adds one "wheat_good" to stock. Prices live in prices.lua, not here.

local crops = {}

crops.variants = {
	{tile = "wheat_poor",   ch = '"', color = {0.25, 0.45, 0.25}},  -- darker = worse
	{tile = "wheat_normal", ch = '"', color = {0.45, 0.80, 0.45}},
	{tile = "wheat_good",   ch = '"', color = {0.35, 0.95, 0.35}},  -- more saturated = better
}

crops.start = "wheat_normal"   -- the tile the player plants

-- Tunables
crops.mutateChance = 0.005     -- per birth: chance to move one rank up or down (50/50)
crops.failChance   = 0.15      -- mixed birth with a poor parent: chance the seed doesn't grow

-- tile name -> rank
crops.byTile = {}
for i, v in ipairs(crops.variants) do crops.byTile[v.tile] = i end

	-- Returns the rank for a crop tile, or nil if the tile isn't a crop.
	function crops.rank(tile)
	return crops.byTile[tile]
	end

	-- ranks: the ranks of the 3 parent cells. Returns the child's tile name, or
	-- nil, true when the seed fails.
	--   * all parents the same  -> same variant, never fails
	--   * mixed parents         -> the median variant (majority wins; all different = middle)
	--   * fail roll             -> only when mixed AND a poor parent is involved
	--   * mutation              -> rare, one rank up or down, on any birth
	function crops.child(ranks)
	table.sort(ranks)
	local rank = ranks[2]
	local mixed = ranks[1] ~= ranks[3]

	if mixed and ranks[1] == 1 and love.math.random() < crops.failChance then
		return nil, true
		end

		if love.math.random() < crops.mutateChance then
			local step = (love.math.random() < 0.5) and -1 or 1
			rank = math.max(1, math.min(#crops.variants, rank + step))
			end

			return crops.variants[rank].tile, false
			end

			return crops
