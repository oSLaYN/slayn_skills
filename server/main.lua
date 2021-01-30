ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('slayn_skills:VerificarMembro')
AddEventHandler('slayn_skills:VerificarMembro', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('gym_membership').count > 0 then
		TriggerClientEvent('slayn_skills:Membro', source)
	else
		TriggerClientEvent('slayn_skills:NaoMembro', source)
	end
end)

ESX.RegisterServerCallback("slayn_skills:fetchStatus", function(source, cb)
	local src = source
	local user = ESX.GetPlayerFromId(src)
	local fetch = [[ SELECT skills FROM users WHERE identifier = @identifier ]]
	MySQL.Async.fetchScalar(fetch, {
		 ["@identifier"] = user.identifier
	}, function(status)
		 if status ~= nil then
			  cb(json.decode(status))
		 else
			  cb(nil)
		 end
	end)
end)


RegisterServerEvent("slayn_skills:update")
AddEventHandler("slayn_skills:update", function(data)
	local src = source
	local user = ESX.GetPlayerFromId(src)
	local insert = [[ UPDATE users SET skills = @skills WHERE identifier = @identifier ]]
	MySQL.Async.execute(insert, {
		 ["@skills"] = data,
		 ["@identifier"] = user.identifier
	})
end)