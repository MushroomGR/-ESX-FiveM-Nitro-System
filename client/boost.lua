local vehicles = {}

function SetNitroBoostScreenEffectsEnabled(enabled)
  if enabled then
    StartScreenEffect('RaceTurbo', 0, false)
    SetTimecycleModifier('rply_motionblur')
    ShakeGameplayCam('SKY_DIVING_SHAKE', 0.30)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "nitro", 0.5)
  else
	StopScreenEffect('RaceTurbo')
    StopGameplayCamShaking(true)
    SetTransitionTimecycleModifier('default', 0.35)
  end
end

function IsVehicleNitroBoostEnabled(vehicle)
  return vehicles[vehicle] == true
end

function SetVehicleNitroBoostEnabled(vehicle, enabled)
  if IsVehicleNitroBoostEnabled(vehicle) == enabled then
    return
  end

  if IsPedInVehicle(PlayerPedId(), vehicle) then
    SetNitroBoostScreenEffectsEnabled(enabled)
  end

  SetVehicleBoostActive(vehicle, enabled)
  vehicles[vehicle] = enabled or nil
end

Citizen.CreateThread(function ()
  local function BackfireLoop()
    for vehicle in pairs(vehicles) do
      CreateVehicleExhaustBackfire(vehicle, 1.25)
    end
  end

  while true do
    Citizen.Wait(0)
    BackfireLoop()
  end
end)

Citizen.CreateThread(function ()
  local function BoostLoop()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local enabled = IsVehicleNitroBoostEnabled(vehicle)

    if vehicle == 0 or driver ~= player or not enabled then
      return
     end
  end

  while true do
    Citizen.Wait(0)
    BoostLoop()
  end
end)
