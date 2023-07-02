function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function CreateBuyer(hash, buyer_type, v3, heading)
	RequestModel(hash)
	
	while not HasModelLoaded(hash) do
		Wait(1)
	end

	local buyer = CreatePed(1, hash, v3.x, v3.y, v3.z, 60, false, true)
	SetBlockingOfNonTemporaryEvents(buyer, true)
	SetEntityHeading(buyer, heading)
	SetPedDiesWhenInjured(buyer, false)
	SetPedCanPlayAmbientAnims(buyer, true)
	SetPedCanRagdollFromPlayerImpact(buyer, false)
	SetEntityInvincible(buyer, true)
	FreezeEntityPosition(buyer, true)
	TaskStartScenarioInPlace(buyer, "WORLD_HUMAN_AA_COFFEE", 0, true);

	Citizen.CreateThread(function()
		while true do
			Wait(0)
			if close_enough_to_player(buyer) then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to sell your hunting loot")
				if(IsControlJustReleased(1, 38)) then
					TriggerServerEvent("hunt:sellLoot", buyer_type)
				end
			end
		end
	end)
end

function CreateNPC(hash, v3, heading, prompt, handler)
	RequestModel(hash)
	
	while not HasModelLoaded(hash) do
		Wait(1)
	end

	local npc = CreatePed(1, hash, v3.x, v3.y, v3.z, 60, false, true)
	SetBlockingOfNonTemporaryEvents(npc, true)
	SetEntityHeading(npc, heading)
	SetPedDiesWhenInjured(npc, false)
	SetPedCanPlayAmbientAnims(npc, true)
	SetPedCanRagdollFromPlayerImpact(npc, false)
	SetEntityInvincible(npc, true)
	FreezeEntityPosition(npc, true)
	TaskStartScenarioInPlace(npc, "WORLD_HUMAN_AA_COFFEE", 0, true);

	Citizen.CreateThread(function()
		while true do
			Wait(0)
			if close_enough_to_player(npc) then
				DisplayHelpText(prompt)
				if(IsControlJustReleased(1, 38)) then
					handler()
				end
			end
		end
	end)
end


function close_enough_to_player(entity, overwrite_radius)
	if not overwrite_radius then overwrite_radius = 1.5 end
	local A = GetEntityCoords(PlayerPedId(), false)
	local B = GetEntityCoords(entity, false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < overwrite_radius
end

function setupBlip(info)
	info.blip = AddBlipForCoord(info.x, info.y, info.z)
	SetBlipSprite(info.blip, info.id)
	SetBlipDisplay(info.blip, 4)
	SetBlipScale(info.blip, 0.9)
	SetBlipColour(info.blip, info.colour)
	SetBlipAsShortRange(info.blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(info.title)
	EndTextCommandSetBlipName(info.blip)
end