
local current_drop = {}
local all_drops = {}

function isPedCloseToPlayer(otherPed, radius)
	if not radius then radius = 1.5 end
	local A = GetEntityCoords(PlayerPedId(), false)
	local B = GetEntityCoords(otherPed, false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) <= radius
end

-- Hunting and crime-fighting (and bum fighting?)
local drop = {
	animal_drop = {
		['label'] = 'animal_carcass_',
		['prompt'] = 'Get animal pelt',
		['items'] = {{'meat', 5}, {'hide', 5}},
	},
	criminal_drop = {
		['label'] = 'criminal_loot_',
		['prompt'] = 'Get criminal\'s spoils',
		['items'] = {{'WEAPON_DOUBLEACTION', 1 }, { 'ammo-38', 10 }}
	},
	bum_drop = {
		['label'] = 'bum_belongings_',
		['prompt'] = 'Get bum\'s belongings',
		['items'] = {{'mustard', 3}},
	}
}

function getMorePreciseItemsForAnimalSize(ped)
	local model = GetEntityModel(ped)
	if model == 0xD86B5A95 then return {{'meat', 5}, {'hide', 5}} end -- deer
	if model == 0xDFB55C81 then return {{'meat', 2}} end -- rabbit
	if model == 0xD3939DFD then return {{'meat', 2}} end -- seagul
	if model == 0xB11BAB56 then return {{'meat', 2}, {'hide', 2}} end -- pig
	if model == 0x1250D7BA then return {{'meat', 3}, {'hide', 10}} end -- mountain lion
	if model == 0x6AF51FAF then return {{'meat', 2}} end -- hen
	if model == 0xFCFA9E1E then return {{'meat', 5}, {'hide', 5}} end -- cow
	if model == 0x644AC75E then return {{'meat', 3}, {'hide', 3}} end -- coyote
	if model == 0xCE5FF074 then return {{'meat', 3}, {'hide', 3}} end -- boar
	return {{'meat', 2}}
end

RequestAnimSet('amb@medic@standing@kneel@base')
RequestAnimSet('anim@gangops@facility@servers@bodysearch@')

function createOrGetDrop(drop_type, ped)
	local drop_id = drop[drop_type].label .. ped
	local stash_identifier = false
	local hypothetical_drop = {}

	-- Get out early if pre-existing stash
	hypothetical_drop = all_drops[drop_id]
	if hypothetical_drop and hypothetical_drop.stash_identifier then
		current_drop = hypothetical_drop
		return
	end

	-- Create new stash
	hypothetical_drop = drop[drop_type]

	if drop_type == 'animal_drop' then
		hypothetical_drop['items'] = getMorePreciseItemsForAnimalSize(ped)
	end

	hypothetical_drop['ped'] = ped
	hypothetical_drop['coords'] = GetEntityCoords(ped)

	ESX.TriggerServerCallback("hunt:create_inventory", function(retval) stash_identifier = retval end, hypothetical_drop)
	while not stash_identifier do Wait(100) end
	hypothetical_drop['stash_identifier'] = stash_identifier
	
	-- add stash to globalss
	current_drop = hypothetical_drop
	all_drops[drop_id] = hypothetical_drop
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		for _,ped in ipairs(GetGamePool('CPed')) do
			if IsPedDeadOrDying(ped) and isPedCloseToPlayer(ped) then
				if GetPedType(ped) == 28 then
					createOrGetDrop('animal_drop', ped)
					break
				elseif (GetPedType(ped) <= 19 and GetPedType(ped) >= 8) or GetPedType(ped) == 23 then
					createOrGetDrop('criminal_drop', ped)
					break
				elseif GetPedType(ped) == 19 then
					createOrGetDrop('bum_drop', ped)
					break
				else
					current_drop = {} -- Clear out accessible drop global
				end
			else
				current_drop = {} -- Clear out accessible drop global
			end
		end
	end
end)

Citizen.CreateThread(function()
	local done = false
	while true do
		Wait(0)
		if current_drop.stash_identifier then DisplayHelpText(current_drop.prompt) end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if(IsControlJustReleased(1, 38) and current_drop.stash_identifier) then
			Citizen.CreateThread(function()
				TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, 1000, 1, 0, false, false, false )
				TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, 1000, 48, 0, false, false, false )
			end)
			Wait(2000)
			ClearPedTasksImmediately(PlayerPedId())
			if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_KNIFE') and current_drop.label == 'animal_carcass_' then
				ESX.ShowNotification('You need a knife to slaugther this beast!')
			else
				exports.ox_inventory:openInventory('stash', current_drop.stash_identifier)
			end
		end
	end
end)

RegisterCommand("current_drop", function(source, args) ESX.ShowNotification(json.encode(current_drop)) end)
