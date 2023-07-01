local close_rock
local ROCKS = {
	`prop_rock_4_c`,
	`prop_rock_4_c_2`,
	`rock_4_cl_2_2`,
	`prop_rock_4_d`,
	`prop_rock_3_b`,
	`prop_rock_2_a`,
	`prop_rock_1_f`,
	`prop_rock_4_a`,
	`prop_rock_1_g`,
	`prop_rock_3_g`,
	`prop_rock_1_h`,
	`prop_rock_3_c`,
	`prop_rock_1_e`,
	`prop_rock_3_f`,
	`prop_rock_4_b`,
	`prop_rock_4_cl_1`,
	`prop_rock_2_c`,
	`prop_rock_3_h`,
	`prop_rock_4_cl_2`,
	`prop_rock_3_a`,
	`prop_rock_3_j`,
	`prop_rock_3_i`,
	`prop_rock_5_smash3`,
	`prop_rock_2_f`,
	`prop_rock_5_smash2`,
	`rock_4_cl_2_1`,
	`prop_rock_1_i`,
	`prop_rock_2_d`,
	`prop_rock_5_b`,
	`prop_rock_4_e`,
	`prop_rock_5_c`,
	`prop_rock_1_d`,
	`prop_rock_5_e`,
	`prop_rock_4_big`,
	`prop_rock_3_e`,
	`prop_rock_1_a`,
	`prop_rock_2_g`,
	`prop_rock_5_d`,
	`prop_rock_4_big2`,
	`prop_rock_5_a`,
	`prop_rock_1_c`,
	`prop_rock_1_b`,
	`prop_rock_3_d`,
	`prop_rock_5_smash1`,
	`cs_x_rubweea`,
	`cs_x_rubweec`,
	`cs_x_rubweed`,
	`cs_x_rubweee`,
	`cs_x_weesmlb`,
}

Citizen.CreateThread(function()
	local playercoords = {}
	local rock_prop = 0

	while true do
		Wait(1000)
		playercoords = GetEntityCoords(PlayerPedId())
		for rock_index = 1, #ROCKS do
			rock_prop = GetClosestObjectOfType(playercoords.x, playercoords.y, playercoords.z, 0.85, ROCKS[rock_index])
			if rock_prop ~= 0 then
				close_rock = ROCKS[rock_index]
				rock_index = #ROCKS -- get out the loop
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if close_rock then
			DisplayHelpText("Mine this rock (" .. close_rock .. ")")
		end
	end
end)