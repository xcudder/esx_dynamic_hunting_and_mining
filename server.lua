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

function item_multiplier(itemname)
	if itemname == 'meat' then return 3 end
	if itemname == 'hide' then return 5 end
	return 1
end

RegisterNetEvent("hunt:sellLoot")
AddEventHandler("hunt:sellLoot", function(itemname)
	local xPlayer = ESX.GetPlayerFromId(source)
	local license = MySQL.scalar.await("SELECT type FROM user_licenses WHERE type = 'hunting' AND owner = ?", {xPlayer.getIdentifier()})

	if not license then
		xPlayer.showNotification("You need a hunting license to sell these")
	else
		local item_count = xPlayer.getInventoryItem(itemname).count
		xPlayer.removeInventoryItem(itemname, item_count)
	    local reward = item_count * item_multiplier(itemname)
	    xPlayer.addMoney(reward)
	end
end)

ESX.RegisterServerCallback("hunt:acquireHuntingLicense", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= 2000 then
		xPlayer.removeMoney(2000, "Hunting License")

		TriggerEvent('esx_license:addLicense', source, 'hunting', function()
			cb(true)
		end)
	else
		cb(false)
	end
end)