ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('nitro:__sync')
AddEventHandler('nitro:__sync', function (boostEnabled, purgeEnabled, lastVehicle)
  local source = source
  for _, player in ipairs(GetPlayers()) do
    if player ~= tostring(source) then
      TriggerClientEvent('nitro:__update', player, source, boostEnabled, purgeEnabled, lastVehicle)
    end
  end
end)

RegisterServerEvent('newnitrocheck')
AddEventHandler('newnitrocheck', function(plate)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	if Config.UseoxMYSQL == true then
	MySQL.query('SELECT * FROM owned_vehicles WHERE plate = @plate', 
	    	{['@plate']   = plate
			},
	    function (result)
		if #result == 0 then
		TriggerClientEvent('esx:showNotification', _source, "~r~You can't install nitro on a civilian car")
		else
		TriggerEvent('nitrocheck1',plate,_source)
		end
	end)
	else 
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', 
	    	{['@plate']   = plate
			},
	    function (result)
		if #result == 0 then
		TriggerClientEvent('esx:showNotification', _source, "~r~You can't install nitro on a civilian car")
		else
		TriggerEvent('nitrocheck1',plate,_source)
		end
	end)
	end
end)

RegisterServerEvent('nitrocheck1')
AddEventHandler('nitrocheck1', function(plate,source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local nitroplates = {}
	if Config.UseoxMYSQL == true then
		MySQL.query('SELECT * FROM nitrocars WHERE plate = @plate', 
		{['@plate']   = plate
			},
	    function (result)
		if #result == 0 then 
		print('oeo2')
		TriggerClientEvent('installit',_source)
		TriggerEvent('install',plate)
		TriggerClientEvent('hasnitro',_source,100)
		else
		print('oeo')
	    TriggerClientEvent('esx:showNotification', _source, "~b~Car with plate ~y~"..plate.." ~b~has already got nitro.")
			end
		end)
		else
		MySQL.Async.fetchAll('SELECT * FROM nitrocars WHERE plate = @plate', 
		{['@plate']   = plate
			},
	    function (result)
		if #result == 0 then 
		print('oeo2')
		TriggerClientEvent('installit',_source)
		TriggerEvent('install',plate)
		TriggerClientEvent('hasnitro',_source,100)
		else
		print('oeo')
	    TriggerClientEvent('esx:showNotification', _source, "~b~Car with plate ~y~"..plate.." ~b~has already got nitro.")
			end
		end)
		end
	end)

RegisterServerEvent('nitrocheck')
AddEventHandler('nitrocheck', function(plate)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local nitroplates = {}
	if Config.UseoxMYSQL == true then
		MySQL.query('SELECT * FROM nitrocars WHERE plate = @plate', 
		{['@plate']   = plate
			},
	    function (result)
		 for i = 1, #result, 1 do
	        table.insert(nitroplates, result[i])
			if result[i].nitro == true then
			TriggerClientEvent('hasnitro',_source,nitroplates[i].nitrolevel)
			end
		end
	end)
	else
	MySQL.Async.fetchAll('SELECT * FROM nitrocars WHERE plate = @plate', 
		{['@plate']   = plate
			},
	    function (result)
		 for i = 1, #result, 1 do
	        table.insert(nitroplates, result[i])
			if result[i].nitro == true then
			TriggerClientEvent('hasnitro',_source,nitroplates[i].nitrolevel)
			end
		end
	end)
	end
end)

RegisterServerEvent('nitro:removeInventoryItem')
AddEventHandler('nitro:removeInventoryItem', function(item, quantity)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem(item, quantity)
end)


ESX.RegisterUsableItem('nitro', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('nitroinstall',source)
end)

RegisterServerEvent('setnitrolevel')
AddEventHandler('setnitrolevel', function(plate,level)
local xPlayer = ESX.GetPlayerFromId(source)
	if Config.UseoxMYSQL == true then
	MySQL.query('UPDATE nitrocars SET nitrolevel= @nitrolevel WHERE plate = @plate',
	{
		['@plate']   = plate,
		['@nitrolevel']	 = level,
	}, function (rowsChanged)
	end)
	else
	MySQL.Async.execute('UPDATE nitrocars SET nitrolevel= @nitrolevel WHERE plate = @plate',
	{
		['@plate']   = plate,
		['@nitrolevel']	 = level,
	}, function (rowsChanged)
	end)
	end
end)

RegisterServerEvent('install')
AddEventHandler('install', function(plate)
local xPlayer = ESX.GetPlayerFromId(source)
	if Config.UseoxMYSQL == true then
	MySQL.query('INSERT INTO nitrocars (`plate`, `nitro`, `nitrolevel`) VALUES (@plate, @nitro, @nitrolevel)',
	{
		['@plate']   = plate,
		['@nitro']	 = 1,
		['@nitrolevel']	 = 100,
	}, function (rowsChanged)
	end)
	else
	MySQL.Async.execute('INSERT INTO nitrocars (`plate`, `nitro`, `nitrolevel`) VALUES (@plate, @nitro, @nitrolevel)',
	{
		['@plate']   = plate,
		['@nitro']	 = 1,
		['@nitrolevel']	 = 100,
	}, function (rowsChanged)
	end)
	end
end)

RegisterServerEvent('levelcheck')
AddEventHandler('levelcheck', function(plate,level)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local nitroplates = {}
	if Config.UseoxMYSQL == true then
		MySQL.query('SELECT * FROM nitrocars WHERE plate = @plate', 
		{['@plate']   = plate
			},
	    function (result)
		 for i = 1, #result, 1 do
	        table.insert(nitroplates, result[i])
			if nitroplates[i].nitrolevel == 100 then
			TriggerClientEvent('esx:showNotification', _source, "~o~Your nitro is full!")
			elseif nitroplates[i].nitrolevel == 75 then
			if xPlayer.getMoney() >= 2500 then
			TriggerEvent('setnitrofuel',plate,100)
			TriggerClientEvent('hasnitro',_source,100)
			xPlayer.removeMoney(2500)
			TriggerClientEvent('esx:showNotification', _source,('~g~You paid 2500$. ~b~Nitro Refilled'))
			else 
			TriggerClientEvent('esx:showNotification', _source,('~h~~g~You got no $$ to pay respects'))
			end
			elseif nitroplates[i].nitrolevel == 50 then 
			if xPlayer.getMoney() >= 5000 then
			TriggerEvent('setnitrofuel',plate,100)
			TriggerClientEvent('hasnitro',_source,100)
			xPlayer.removeMoney(5000)
			TriggerClientEvent('esx:showNotification', _source,('~g~You paid 5000$. ~b~Nitro Refilled'))
			else 
			TriggerClientEvent('esx:showNotification', _source,('~h~~g~You got no $$ to pay respects'))
			end
			elseif nitroplates[i].nitrolevel == 25 then 
			if xPlayer.getMoney() >= 7500 then
			TriggerEvent('setnitrofuel',plate,100)
			TriggerClientEvent('hasnitro',_source,100)
			xPlayer.removeMoney(7500)
			TriggerClientEvent('esx:showNotification', _source,('~g~You paid 7500$. ~b~Nitro Refilled'))
			else 
			TriggerClientEvent('esx:showNotification', _source,('~h~~g~You got no $$ to pay respects'))
			end
			elseif nitroplates[i].nitrolevel == 0 then 
			if xPlayer.getMoney() >= 10000 then
			TriggerEvent('setnitrofuel',plate,100)
			TriggerClientEvent('hasnitro',_source,100)
			xPlayer.removeMoney(10000)
			TriggerClientEvent('esx:showNotification', _source,('~g~You paid 10000$. ~b~Nitro Refilled'))
			else 
			TriggerClientEvent('esx:showNotification', _source,('~h~~g~You got no $$ to pay respects'))
			end
			end
		end
	end)
	else
	MySQL.Async.fetchAll('SELECT * FROM nitrocars WHERE plate = @plate', 
		{['@plate']   = plate
			},
	    function (result)
		 for i = 1, #result, 1 do
	        table.insert(nitroplates, result[i])
			if nitroplates[i].nitrolevel == 100 then
			TriggerClientEvent('esx:showNotification', _source, "~o~Your nitro is full!")
			elseif nitroplates[i].nitrolevel == 75 then
			if xPlayer.getMoney() >= 2500 then
			TriggerEvent('setnitrofuel',plate,100)
			TriggerClientEvent('hasnitro',_source,100)
			xPlayer.removeMoney(2500)
			TriggerClientEvent('esx:showNotification', _source,('~g~You paid 2500$. ~b~Nitro Refilled'))
			else 
			TriggerClientEvent('esx:showNotification', _source,('~h~~g~You got no $$ to pay respects'))
			end
			elseif nitroplates[i].nitrolevel == 50 then 
			if xPlayer.getMoney() >= 5000 then
			TriggerEvent('setnitrofuel',plate,100)
			TriggerClientEvent('hasnitro',_source,100)
			xPlayer.removeMoney(5000)
			TriggerClientEvent('esx:showNotification', _source,('~g~You paid 5000$. ~b~Nitro Refilled'))
			else 
			TriggerClientEvent('esx:showNotification', _source,('~h~~g~You got no $$ to pay respects'))
			end
			elseif nitroplates[i].nitrolevel == 25 then 
			if xPlayer.getMoney() >= 7500 then
			TriggerEvent('setnitrofuel',plate,100)
			TriggerClientEvent('hasnitro',_source,100)
			xPlayer.removeMoney(7500)
			TriggerClientEvent('esx:showNotification', _source,('~g~You paid 7500$. ~b~Nitro Refilled'))
			else 
			TriggerClientEvent('esx:showNotification', _source,('~h~~g~You got no $$ to pay respects'))
			end
			elseif nitroplates[i].nitrolevel == 0 then 
			if xPlayer.getMoney() >= 10000 then
			TriggerEvent('setnitrofuel',plate,100)
			TriggerClientEvent('hasnitro',_source,100)
			xPlayer.removeMoney(10000)
			TriggerClientEvent('esx:showNotification', _source,('~g~You paid 10000$. ~b~Nitro Refilled'))
			else 
			TriggerClientEvent('esx:showNotification', _source,('~h~~g~You got no $$ to pay respects'))
			end
			end
		end
	end)
	end
end)

RegisterServerEvent('setnitrofuel')
AddEventHandler('setnitrofuel', function(plate,level)
local xPlayer = ESX.GetPlayerFromId(source)
	if Config.UseoxMYSQL == true then
	MySQL.query('UPDATE nitrocars SET nitrolevel= @nitrolevel WHERE plate = @plate',
	{
		['@plate']   = plate,
		['@nitrolevel']	 = level,
	}, function (rowsChanged)
	end)
	else
	MySQL.Async.execute('UPDATE nitrocars SET nitrolevel= @nitrolevel WHERE plate = @plate',
	{
		['@plate']   = plate,
		['@nitrolevel']	 = level,
	}, function (rowsChanged)
	end)
	end
end)


ESX.RegisterServerCallback('checkitem', function(source,cb,inp)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(inp)
	if xItem.count<=0 or xItem==nil then
		cb('fail')
	else
		cb('gotit')
	end
	end)
