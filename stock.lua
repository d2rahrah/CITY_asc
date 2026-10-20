-- stock.lua
-- The player's inventory. Money is just another item ("money").
-- Item names are free-form strings, so new resources need no changes here.

local stock = {}

local items = {}   -- name -> count
local order = {}   -- names in the order they first appeared (for the HUD)

local function touch(name)
if items[name] == nil then
	items[name] = 0
	order[#order + 1] = name
	end
	end

	function stock.get(name)
	return items[name] or 0
	end

	function stock.add(name, n)
	n = n or 1
	touch(name)
	items[name] = items[name] + n
	return items[name]
	end

	function stock.has(name, n)
	return stock.get(name) >= (n or 1)
	end

	-- Returns true if it took the items, false (and takes nothing) if you can't afford it.
	function stock.remove(name, n)
	n = n or 1
	if not stock.has(name, n) then return false end
		items[name] = items[name] - n
		return true
		end

		-- Multi-item costs, e.g. {money = 50, wood = 2}. All or nothing.
		function stock.canAfford(costs)
		for name, n in pairs(costs) do
			if not stock.has(name, n) then return false end
				end
				return true
				end

				function stock.spend(costs)
				if not stock.canAfford(costs) then return false end
					for name, n in pairs(costs) do items[name] = items[name] - n end
						return true
						end

						-- One-line summary for the HUD: "$500  food 3  wood 2". Zero-count items are hidden.
						function stock.format()
						local parts = {}
						for _, name in ipairs(order) do
							local n = items[name]
							if name == "money" then
								parts[#parts + 1] = ("$%d"):format(n)
								elseif n > 0 then
									parts[#parts + 1] = ("%s %d"):format(name, n)
									end
									end
									return table.concat(parts, "  ")
									end

									function stock.reset()
									items, order = {}, {}
									end

									return stock
