ESX.RegisterServerCallback('hunt:create_inventory', function(source, cb, drop)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(exports.ox_inventory:CreateTemporaryStash({
		['label'] = drop.label .. drop.ped, 
		['slots'] = 5,
		['maxWeight'] = 100,
		['coords'] = drop.coords,
		['items'] = drop.items
	}))
end)

