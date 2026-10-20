local items = require("items")
local ids = {}
for id in pairs(items.data) do ids[#ids + 1] = id end
	table.sort(ids)
	for _, id in ipairs(ids) do
		print(("    %s = %d,"):format(id, items.data[id].price))
		end
