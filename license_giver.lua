local v3 = vector3(1855.819, 3688.813, 34.25 - 1.0)
setupBlip({
	title="Hunter License Acquisition", colour=2,
	id=160, x=v3.x, y=v3.y,
})

CreateNPC(0x9AB35F63, v3, 207.62, "Press ~INPUT_CONTEXT~ to buy your hunting license", function()
	ESX.TriggerServerCallback('hunt:acquireHuntingLicense', function (success)
		if success then
			ESX.ShowNotification("Congratuliations! You're now a certified hunter")
		else
			ESX.ShowNotification("Come back when you get some money, buddy ^^")
		end
	end)
end)