-- Marker location is at Mission Row PD. On the back side by the Sally Port
local markerPos = vector3(473.36, -1023.25, 28.13)
local HasAlreadyGotMessage = false
ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


Citizen.CreateThread(function()

   while true do
	local ped = GetPlayerPed(-1)	
	Citizen.Wait(0)
	local playerCoords = GetEntityCoords(ped)
	local distance = #(playerCoords - markerPos)
	local isInMarker = false	
	
		-- if you are closer than 10, show the marker
		if distance < 10.0 then
			DrawMarker(1, markerPos.x, markerPos.y, markerPos.z , 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 50, false, false, 2, nil, nil, false)
		
			-- if you are closer than 2, you are considered in the marker		   
			if distance < 2.0 then
				isInMarker = true
			else
				HasAlreadyGotMessage = false
			end
		else
			Citizen.Wait(2000)
		end
	

	
		-- if you are in the marker, do stuff
		if isInMarker and not HasAlreadyGotMessage then
				yourJob = ESX.PlayerData.job.name
				
			-- check to see if your job is police, sheriff or highway patrol
			if yourJob == "police" or yourJob == "sheriff" or yourJob == "highway" then
			
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
				if vehicle == 0 then	
				TriggerEvent('chat:addMessage', 'You are not in a vehicle.')
				HasAlreadyGotMessage = true
				else
				local vehicle = GetVehiclePedIsIn(PlayerPedId(), true )
				-- Fix Engine Damage
				SetVehicleEngineHealth(vehicle, 1000.0) 
				TriggerEvent('chat:addMessage', 'We repaired the engine damage.')
				Citizen.Wait(500)			

				-- Repair vehicle body damage
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				TriggerEvent('chat:addMessage', 'We fixed all the dents.')
				Citizen.Wait(500)

				-- Top off with a tank of gas
				SetVehicleFuelLevel(vehicle, 100.0)
				TriggerEvent('chat:addMessage', 'Your vehicle has been refueled.')
				Citizen.Wait(500)

				-- Wash the vehicle
				SetVehicleDirtLevel(vehicle, 0.1)
				TriggerEvent('chat:addMessage', 'Your vehicle has been washed. Try to keep it clean.')
				HasAlreadyGotMessage = true
				Citizen.Wait(5000)
				end
			else
				TriggerEvent('chat:addMessage', 'You have no business here.')
				HasAlreadyGotMessage = true
				Citizen.Wait(500)
	end
		end

	
    end
end)
