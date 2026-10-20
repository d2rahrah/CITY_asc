-- life.lua
-- World tick + Game of Life on "park" tiles.
-- NPCs will live here later, on the same slow tick.

local life = {}

life.TICK     = 4        -- seconds between world ticks (3-5s keeps things readable)
life.paused   = false
life.alive    = "park"   -- tile type that counts as a living cell
life.birthOn  = "ground" -- empty tile type a cell may be born onto (never roads/buildings/water)
life.npcs     = {}       -- reserved for later

local timer = 0

local function countNeighbors(map, x, y)
local n = 0
for dy = -1, 1 do
	for dx = -1, 1 do
		if dx ~= 0 or dy ~= 0 then
			local row = map[y + dy]
			if row and row[x + dx] == life.alive then n = n + 1 end
				end
				end
				end
				return n
				end

				-- One Conway step (B3/S23). Returns a list of changes: {x, y, to, kind="born"|"died"}.
				-- Changes are collected first and applied after, so every cell sees the same old state.
				function life.step(map, w, h)
				local changes = {}
				for y = 1, h do
					for x = 1, w do
						local t = map[y][x]
						if t == life.alive then
							local n = countNeighbors(map, x, y)
							if n < 2 or n > 3 then
								changes[#changes + 1] = {x = x, y = y, to = life.birthOn, kind = "died"}
								end
								elseif t == life.birthOn then
									if countNeighbors(map, x, y) == 3 then
										changes[#changes + 1] = {x = x, y = y, to = life.alive, kind = "born"}
										end
										end
										end
										end
										for _, c in ipairs(changes) do map[c.y][c.x] = c.to end
											return changes
											end

											-- Call every frame. Returns the change list on a tick frame, otherwise nil.
											function life.update(dt, map, w, h)
											if life.paused then return nil end
												timer = timer + dt
												if timer < life.TICK then return nil end
													timer = timer - life.TICK

													-- later: move NPCs here, scaled by their agi/speed
													-- later: roll for events (goblin raid, flood)

													return life.step(map, w, h)
													end

													-- Skip turn: run a tick right now and restart the countdown.
													-- Returns the change list, same as life.update does on a tick frame.
													function life.skip(map, w, h)
													timer = 0

													-- later: move NPCs here too, so skipping advances them as well

													return life.step(map, w, h)
													end

													-- 0..1, handy for a small "next tick" bar in the HUD
													function life.progress()
													return timer / life.TICK
													end

													return life
