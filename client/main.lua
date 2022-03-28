ESX = nil
local INPUT_CHARACTER_WHEEL = 21
local INPUT_VEH_ACCELERATE = 71
local INPUT_VEH_DUCK = 73

local function IsNitroControlPressed()
  if not IsInputDisabled(2) then
    DisableControlAction(2, INPUT_VEH_DUCK)
    return IsDisabledControlPressed(2, INPUT_VEH_DUCK)
  end

  return IsControlPressed(0, INPUT_CHARACTER_WHEEL)
end

local function IsDrivingControlPressed()
  return IsControlPressed(0, INPUT_VEH_ACCELERATE)
end
models = {
	[1] = -2007231801,
	[2] = 1339433404,
	[3] = 1694452750,
	[4] = 1933174915,
	[5] = -462817101,
	[6] = -469694731,
	[7] = -164877493
}
ramp = {
	[1] = 2138646444,
	[2] = -1029296059,
	[3] = 1096997751,
	[4] = -573669520,
	[5] = 1742634574,
	[6] = -1326111298,
	[7] = -946793326
}
local nearPump = false
local nearRamp = false
local pumpLoc = {}
local rampLoc = {}
local NitroStart=false
local cooldown = false
local nitrocount = 0
local nitrocooldown = false
local tick
local idleTime
local driftTime
local mult = 0.2
local previous = 0
local total = 0
local curAlpha = 0
local purge = false
local hasnitro = false
local nitrocheck = false
local alreadycheck = false
local currentPlate = ''
local incar = false
local checked = false
local nitrolevel = 0
local newlevel = false
PlayerData={}
Citizen.CreateThread(function()

	while ESX == nil do
	
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
	PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
	PlayerData = xPlayer 
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)
function LocalPed()
	return GetPlayerPed(-1)
end


Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsIn(playerPed, false)
		local vehicleClass = GetVehicleClass(playerVeh)
		local speed1 = GetEntitySpeed(playerVeh)
		local speed = speed1*3.6
		local engine = GetIsVehicleEngineRunning(playerVeh)
		if IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed then
		incar = true
		if alreadycheck == false then 
		currentPlate = GetVehicleNumberPlateText(playerVeh)
		alreadycheck = true
		nitrocheck = true 
		end
		else
		incar = false
		hasnitro = false
		alreadycheck = false
		end
		if IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed and hasnitro == true then --and nearPump == true then
		if purge == true then 
		DrawAdvancedText(0.965,0.62,0.005, 0.0028, 0.5,"Purging", 140,255,100,255,6,1) 
		end
		if GetDistanceBetweenCoords(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'],GetEntityCoords(playerPed)) <= 3.0 then 
		ESX.ShowHelpNotification("Press ~Input_Context~ to refill nitro")
		if IsControlJustPressed(0,38) then 
		TriggerServerEvent('levelcheck',currentPlate,nitrolevel)
		end
		end
		end
		if IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed and nitrocooldown == false and hasnitro == true then
		if IsControlPressed(0,21) and speed <= 50 and not IsControlPressed(0,32) and nitrolevel > 0 and engine then	
		purge = true 
		else
		purge = false
		end
		end
		if nitrolevel == 0 and IsControlPressed(0,21) and speed <= 50 and not IsControlPressed(0,32) and IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed and nitrocooldown == false and hasnitro == true then   
		ESX.ShowNotification('~y~Your nitro is empty,go refill it!')
		end
		if IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed and hasnitro == true  and engine then
		if cooldown == true then 
		DrawAdvancedText(0.953,0.72,0.005, 0.0028, 0.5,"Nitro: Cooldown",255,50,50,255,6,1)
		elseif NitroStart == true then 
		DrawAdvancedText(0.953,0.72,0.005, 0.0028, 0.5,"Nitro: Boosting",255,150,250,255,6,1)
		elseif cooldown == false and nitrolevel == 100 then 
		DrawAdvancedText(0.947,0.72,0.005, 0.0028, 0.5,"Nitro: 4/4 charges", 0,255,0,255,6,1)
		elseif cooldown == false and nitrolevel == 75 then 
		DrawAdvancedText(0.947,0.72,0.005, 0.0028, 0.5,"Nitro: 3/4 charges", 80,255,0,255,6,1)
		elseif cooldown == false and nitrolevel == 50 then 
		DrawAdvancedText(0.947,0.72,0.005, 0.0028, 0.5,"Nitro: 2/4 charges", 150,255,0,255,6,1)
		elseif cooldown == false and nitrolevel == 25 then 
		DrawAdvancedText(0.947,0.72,0.005, 0.0028, 0.5,"Nitro: 1/4 charges", 150,80,180,255,6,1)
		elseif cooldown == false and nitrolevel == 0 then 
		DrawAdvancedText(0.955,0.72,0.005, 0.0028, 0.5,"Nitro: Empty",0,100,255,255,6,1)
		end
		end
	end
end)


Citizen.CreateThread(function()
    while true do
	Citizen.Wait(1000)
	if nitrocheck == true and incar == true then
	TriggerServerEvent('nitrocheck',currentPlate)
	nitrocheck = false
	end
	end
	end)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsIn(ped, false)
		local engine = GetIsVehicleEngineRunning(playerVeh)
			if  IsControlJustPressed(0, 21) and IsControlPressed(0, 32) and IsPedInAnyVehicle(ped,false) then
					if NitroStart == false and cooldown == false and hasnitro == true and engine then
						if  nitrolevel > 0 then 
							if GetPedInVehicleSeat(playerVeh, -1) == ped then 
								NitroStart=true
								nitrocooldown = true
								nitrolevel = nitrolevel - 25
								newlevel = true
							else
							ESX.ShowNotification("You got to be on a car ~g~driver's seat")
							end
						else
						ESX.ShowNotification("~y~You need to recharge nitro at any gas station")
						end
					end
				end
		if NitroStart == true then
		DisableControlAction(0,23,true)
			local playerPed = GetPlayerPed(-1)
			SetVehicleEnginePowerMultiplier(playerVeh,55.0)	
			Citizen.Wait(3000)
				SetVehicleEnginePowerMultiplier(playerVeh,1.0)
				NitroStart=false
				nitrocooldown = false
				cooldown= true
				Citizen.Wait(30000)
				cooldown = false
		end
    end
end)

Citizen.CreateThread(function()
    while true do
	Citizen.Wait(1000)
	if newlevel == true then
	TriggerServerEvent('setnitrolevel',currentPlate,nitrolevel)
	newlevel = false
	end
	end
	end)

local function NitroLoop(lastVehicle)
  local player = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(player)
  local driver = GetPedInVehicleSeat(vehicle, -1)

  if lastVehicle ~= 0 and lastVehicle ~= vehicle then
    SetVehicleNitroBoostEnabled(lastVehicle, false)
    SetVehicleLightTrailEnabled(lastVehicle, false)
	SetVehicleNitroPurgeEnabled(lastVehicle, false)
    TriggerServerEvent('nitro:__sync', false, false, true)
  end
  
  if vehicle == 0 or driver ~= player then
    return 0
  end
  
  local model = GetEntityModel(vehicle)

  if not IsThisModelACar(model) then
    return 0
  end
  
  local isBoosting = IsVehicleNitroBoostEnabled(vehicle)
  local isPurging = IsVehicleNitroPurgeEnabled(vehicle)
  local isRunning = GetIsVehicleEngineRunning(vehicle)
  local isDriving = IsDrivingControlPressed()
  
  if isRunning then
  if not isPurging and purge then
        SetVehicleNitroBoostEnabled(vehicle, false)
        SetVehicleLightTrailEnabled(vehicle, false)
        SetVehicleNitroPurgeEnabled(vehicle, true)
        TriggerServerEvent('nitro:__sync', false, true, false)
  end
  
 
	if NitroStart then
      if not isBoosting then
        SetVehicleNitroBoostEnabled(vehicle, true)
        SetVehicleLightTrailEnabled(vehicle, true)
        SetVehicleNitroPurgeEnabled(vehicle, false)
        TriggerServerEvent('nitro:__sync', true, false, false)

	end
  elseif isBoosting or isPurging then
    SetVehicleNitroBoostEnabled(vehicle, false)
    SetVehicleLightTrailEnabled(vehicle, false)
    SetVehicleNitroPurgeEnabled(vehicle, false)
    TriggerServerEvent('nitro:__sync', false, false, false)
  end
end
  return vehicle
end

Citizen.CreateThread(function ()
  local lastVehicle = 0

  while true do
    Citizen.Wait(0)
    lastVehicle = NitroLoop(lastVehicle)
  end
end)

RegisterNetEvent('nitro:__update')
AddEventHandler('nitro:__update', function (playerServerId, boostEnabled, purgeEnabled, lastVehicle)
  local playerId = GetPlayerFromServerId(playerServerId)

  if not NetworkIsPlayerConnected(playerId) then
    return
  end

  local player = GetPlayerPed(playerId)
  local vehicle = GetVehiclePedIsIn(player, lastVehicle)
  local driver = GetPedInVehicleSeat(vehicle, -1)

  SetVehicleNitroBoostEnabled(vehicle, boostEnabled)
  SetVehicleLightTrailEnabled(vehicle, boostEnabled)
  SetVehicleNitroPurgeEnabled(vehicle, purgeEnabled)
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
	end
	
	

RegisterNetEvent('nitroinstall')
AddEventHandler('nitroinstall',function()
if incar == false then
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
	local vehicleClass = GetVehicleClass(vehicle)
	if DoesEntityExist(vehicle) then 
	if vehicleClass == 0 or vehicleClass == 1 or vehicleClass == 2 or vehicleClass == 3 or vehicleClass == 4 or vehicleClass == 5 or vehicleClass == 6 or vehicleClass == 7 or vehicleClass == 9 or vehicleClass == 12 then
	if Config.mechanicjob == true then
	if PlayerData.job.name == 'mechanic' then 
	if GetDistanceBetweenCoords(rampLoc['x'], rampLoc['y'], rampLoc['z'],GetEntityCoords(playerPed)) <= 15.0 then 
	ESX.TriggerServerCallback('checkitem',function(ans)
        if ans=="gotit" then
        TriggerServerEvent('newnitrocheck',currentPlate)
		elseif ans=="fail" then
        ESX.ShowNotification('~r~You dont have the proper item to do this')
        end
        end,Config.mechanicitem)
	else
	ESX.ShowNotification("~r~You need to be near mechanic workshop to do this")
	end
	else
	ESX.ShowNotification("~r~Only mechanic can do this")
	end
	else
	for _, pos in pairs(Config.Zones) do
	if GetDistanceBetweenCoords(pos.spot.x,pos.spot.y, pos.spot.z,GetEntityCoords(playerPed)) <= pos.radius then
	TriggerServerEvent('newnitrocheck',currentPlate)
	else
	ESX.ShowNotification("~r~You need to be near nitro spot to do this")
	end
	end
	end
	else
	ESX.ShowNotification("~r~Not allowed vehicle class")
	end
	else 
	ESX.ShowNotification("~r~You got to go near vehicle")
	end
	else
ESX.ShowNotification("~r~You got to be outside of vehicle")
end
end)

RegisterNetEvent('hasnitro')
AddEventHandler('hasnitro',function(nitrofuel)
hasnitro = true
nitrolevel= nitrofuel
end)

RegisterNetEvent('installit')
AddEventHandler('installit',function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local door = 4
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
			ESX.ShowNotification("~b~Installing nitro...")
			TriggerServerEvent('nitro:removeInventoryItem','nitro', 1)
			ESX.UI.Menu.CloseAll()
			SetVehicleDoorOpen(vehicle, door, false, false)    
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			Citizen.CreateThread(function()
			Citizen.Wait(6000)
			ClearPedTasksImmediately(playerPed)
			SetVehicleDoorShut(vehicle, door, false)
			ESX.ShowNotification("~g~Nitro Installed!!")
			end)
	end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local myCoords = GetEntityCoords(GetPlayerPed(-1))
		
		for i = 1, #models  do
			local closestPump = GetClosestObjectOfType(myCoords.x, myCoords.y, myCoords.z, 2.0, models[i], false, false)
		
		if closestPump ~= nil and closestPump ~= 0 then
		local coords    = GetEntityCoords(closestPump)
		nearPump = true
		pumpLoc  = {['x'] = coords.x, ['y'] = coords.y, ['z'] = coords.z + 1.2}
		else 
		nearPump = false
			end
		end
		for i=1 , #ramp do 
		local closestRamp = GetClosestObjectOfType(myCoords.x, myCoords.y, myCoords.z, 2.0, ramp[i], false, false)
		
		if closestRamp ~= nil and closestRamp ~= 0 then 
		local rampcoords = GetEntityCoords(closestRamp)	
		rampLoc =  {['x'] = rampcoords.x, ['y'] = rampcoords.y, ['z'] = rampcoords.z + 1.2}
		end
		end
	end
end)

Citizen.CreateThread(function()
    for _, blips in pairs(Config.Zones) do
            blips.blip = AddBlipForCoord(blips.spot.x, blips.spot.y, blips.spot.z)
            SetBlipSprite(blips.blip, blips.mapBlipId)
            SetBlipDisplay(blips.blip, 4)
            SetBlipScale(blips.blip, 1.0)
            SetBlipColour(blips.blip, blips.mapBlipColor)
            SetBlipAsShortRange(blips.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blips.title)
            EndTextCommandSetBlipName(blips.blip)
    end
end)
		
