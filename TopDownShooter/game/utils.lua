local Utils = {}

function Utils.distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function Utils.despawnEntities(entities)
	for i = #entities, 1, -1 do
		local entity = entities[i]
		if entity.dead then
			table.remove(entities, i)
		end
	end
end

return Utils
