local QBCore = exports['qb-core']:GetCoreObject()

isLoggedIn = true

local menuOpen = false
local wasOpen = false
local spawnedWeed = 0
local weedPlants = {}

local isPickingUp, isProcessing, isProcessing2 = false, false, false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	CheckCoords()
	Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 1000 then
		SpawnWeedPlants()
	end
end)

function CheckCoords()
	CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 1000 then
				SpawnWeedPlants()
			end
			Wait(1 * 60000)
		end
	end)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CheckCoords()
	end
end)

RegisterNetEvent("weed:collect", function()

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID


		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		--if nearbyObject and IsPedOnFoot(playerPed) then



			if not isPickingUp then
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
				QBCore.Functions.Progressbar("search_register", "Picking up Cannabis..", 3000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					QBCore.Functions.DeleteObject(nearbyObject)

					table.remove(weedPlants, nearbyID)
					spawnedWeed = spawnedWeed - 1

					TriggerServerEvent('qb-weedpicking:pickedUpCannabis')
				end, function()
					ClearPedTasks(PlayerPedId())
					QBCore.Functions.DeleteObject('prop_weed_02')
				end)

				isPickingUp = false
			--end
		--else
			Wait(500)
		--end
	end
end)


AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			QBCore.Functions.DeleteObject(nearbyObject)
		end
	end
end)




function SpawnWeedPlants()
	while spawnedWeed < 20 do
		Wait(1)
		local weedCoords = GenerateWeedCoords()

		QBCore.Functions.SpawnLocalObject('prop_weed_02', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)


			table.insert(weedPlants, obj)
			spawnedWeed = spawnedWeed + 1
		end)
	end
	Wait(45 * 60000)
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeed > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-10, 10)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-10, 10)

		weedCoordX = Config.CircleZones.WeedField.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField.coords.y + modY

		local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZWeed(x, y)
	local groundCheckHeights = { 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 31.85
end

RegisterNetEvent("weed:process", function()
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)



			if not isProcessing then
				local hasBag = false
				local s1 = false
				local hasWeed = false
				local s2 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasWeed = result
					s1 = true
				end, 'cannabis')

				while(not s1) do
					Wait(100)
				end
				Wait(100)
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag = result
					s2 = true
				end, 'empty_weed_bag')

				while(not s2) do
					Wait(100)
				end

				if (hasWeed and hasBag) then
					Processweed()
				elseif (hasWeed) then
					QBCore.Functions.Notify('You dont have enough plastic bags.', 'error')
				elseif (hasBag) then
					QBCore.Functions.Notify('You dont have enough cannabis.', 'error')
				else
					QBCore.Functions.Notify('You dont have enough cannabis and plastic bags.', 'error')
				end
		Wait(500)
    end
end)

function Processweed()
	isProcessing = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	--SetEntityHeading(PlayerPedId(), 108.06254)

	QBCore.Functions.Progressbar("search_register", "Trying to Process..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-weedpicking:processweed')

		local timeLeft = Config.Delays.WeedProcessing / 1000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 4 then
				TriggerServerEvent('qb-weedpicking:cancelProcessing')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel

	isProcessing = false
end

RegisterNetEvent("weed:sell", function()
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)


			if not isProcessing2 then
				local hasWeed2 = false
				local hasBag2 = false
				local s3 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasWeed2 = result
					hasBag2 = result
					s3 = true

				end, 'weed_bag')

				while(not s3) do
					Wait(100)
				end


				if (hasWeed2) then
					SellDrug()
				elseif (hasWeed2) then
					QBCore.Functions.Notify('You dont have enough plastic bags.', 'error')
				elseif (hasBag2) then
					QBCore.Functions.Notify('You dont have enough cannabis.', 'error')
				else
					QBCore.Functions.Notify('You dont have enough weed bags to sell.', 'error')
				end
			Wait(500)
	end
end)

function SellDrug()
	isProcessing2 = true
	local playerPed = PlayerPedId()

	--
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	--SetEntityHeading(PlayerPedId(), 108.06254)

	QBCore.Functions.Progressbar("search_register", "Trying to Sell..", 1500, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-weedpicking:selld')

		local timeLeft = Config.Delays.WeedProcessing / 1000

		while timeLeft > 0 do
			Wait(500)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 4 then
				break
			end
		end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel

	isProcessing2 = false
end
