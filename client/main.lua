local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData              = {}
local treinando = false
local descansado = false
local membro = false
local busy = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()
	end

	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(10)
	end

	Citizen.Wait(100)
	FetchSkills()

	while true do
		Citizen.Wait(10)
		local seconds = Config.UpdateFrequency * 1000
		Citizen.Wait(seconds)

		for skill, value in pairs(Config.Skills) do
			Citizen.Wait(100)
			UpdateSkill(skill, value["RemoveAmount"])
		end

		Citizen.Wait(100)
		TriggerServerEvent("slayn_skills:update", json.encode(Config.Skills))
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

local blips = {
	{title="Ginásio", colour=9, id=311, x = -1201.2257, y = -1568.8670, z = 4.6101}
}
	
Citizen.CreateThread(function()
	Citizen.Wait(100)
	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.6)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)

RegisterNetEvent('slayn_skills:Membro')
AddEventHandler('slayn_skills:Membro', function()
	Citizen.Wait(100)
	membro = true
end)

RegisterNetEvent('slayn_skills:NaoMembro')
AddEventHandler('slayn_skills:NaoMembro', function()
	Citizen.Wait(100)
	membro = false
end)

local arms = {
    {x = -1202.9837,y = -1565.1718,z = 4.6115}
}

local pushup = {
    {x = -1203.3242,y = -1570.6184,z = 4.6115}
}

local yoga = {
    {x = -1204.7958,y = -1560.1906,z = 4.6115}
}

local situps = {
    {x = -1206.1055,y = -1565.1589,z = 4.6115}
}

local chins = {
    {x = -1200.1284,y = -1570.9903,z = 4.6115}
}

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
        for k in pairs(arms) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, arms[k].x, arms[k].y, arms[k].z)
			if dist <= 2.5 then
				letSleep = false
				if IsControlJustPressed(0, Keys['E']) then
					if treinando == false then
						TriggerServerEvent('slayn_skills:VerificarMembro')
						exports['slayn_notify']:DoHudText('inform', 'A Preparar o Exercício...')
						Citizen.Wait(1500)					
						if membro == true then
							busy = true
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_muscle_free_weights", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							exports['slayn_notify']:DoHudText('error', 'Precisas De Descansar Por 60 Segundos.')	
							UpdateSkill("Força", 0.1)						
							treinando = true
							busy = false
						elseif membro == false then
							exports['slayn_notify']:DoHudText('error', 'Precisas De Ser Membro Do Ginásio.')
						end
					elseif treinando == true then
						descansado = true
						VerificarDescanso()
					end
				end			
            else
				letSleep = true		
			end

			if letSleep then
				Citizen.Wait(1500)
			end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
        for k in pairs(chins) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chins[k].x, chins[k].y, chins[k].z)
			if dist <= 2.5 then	
				letSleep = false			
				if IsControlJustPressed(0, Keys['E']) then
					if treinando == false then
						TriggerServerEvent('slayn_skills:VerificarMembro')
						exports['slayn_notify']:DoHudText('inform', 'A Preparar o Exercício...')
						Citizen.Wait(1500)					
						if membro == true then
							busy = true
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "prop_human_muscle_chin_ups", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							exports['slayn_notify']:DoHudText('error', 'Precisas De Descansar Por 60 Segundos.')
							UpdateSkill("Stamina", 0.1)	
							treinando = true
							busy = false
						elseif membro == false then
							exports['slayn_notify']:DoHudText('error', 'Precisas De Ser Membro Do Ginásio.')
						end
					elseif treinando == true then
						descansado = true
						VerificarDescanso()
					end
				end			
            else
				letSleep = true		
			end

			if letSleep then
				Citizen.Wait(1500)
			end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
        for k in pairs(pushup) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pushup[k].x, pushup[k].y, pushup[k].z)
			if dist <= 2.5 then	
				letSleep = false			
				if IsControlJustPressed(0, Keys['E']) then
					if treinando == false then
						TriggerServerEvent('slayn_skills:VerificarMembro')
						exports['slayn_notify']:DoHudText('inform', 'A Preparar o Exercício...')
						Citizen.Wait(1500)					
						if membro == true then	
							busy = true
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_push_ups", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							exports['slayn_notify']:DoHudText('error', 'Precisas De Descansar Por 60 Segundos.')
							UpdateSkill("Força", 0.1)
							treinando = true
							busy = false
						elseif membro == false then
							exports['slayn_notify']:DoHudText('error', 'Precisas De Ser Membro Do Ginásio.')
						end							
					elseif treinando == true then
						descansado = true
						VerificarDescanso()
					end
				end			
            else
				letSleep = true		
			end

			if letSleep then
				Citizen.Wait(1500)
			end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
        for k in pairs(yoga) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, yoga[k].x, yoga[k].y, yoga[k].z)
			if dist <= 2.5 then
				letSleep = false				
				if IsControlJustPressed(0, Keys['E']) then
					if treinando == false then
						TriggerServerEvent('slayn_skills:VerificarMembro')
						exports['slayn_notify']:DoHudText('inform', 'A Preparar o Exercício...')
						Citizen.Wait(1500)					
						if membro == true then
							busy = true
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_yoga", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							exports['slayn_notify']:DoHudText('error', 'Precisas De Descansar Por 60 Segundos.')		
							UpdateSkill("Respiração", 0.1)				
							treinando = true
							busy = false
						elseif membro == false then
							exports['slayn_notify']:DoHudText('error', 'Precisas De Ser Membro Do Ginásio.')
						end
					elseif treinando == true then
						descansado = true
						VerificarDescanso()
					end
				end			
            else
				letSleep = true		
			end

			if letSleep then
				Citizen.Wait(1500)
			end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
        for k in pairs(situps) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, situps[k].x, situps[k].y, situps[k].z)
			if dist <= 2.5 then	
				letSleep = false			
				if IsControlJustPressed(0, Keys['E']) then
					if treinando == false then
						TriggerServerEvent('slayn_skills:VerificarMembro')
						exports['slayn_notify']:DoHudText('inform', 'A Preparar o Exercício...')
						Citizen.Wait(1500)					
						if membro == true then
							busy = true
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_sit_ups", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							exports['slayn_notify']:DoHudText('error', 'Precisas De Descansar Por 60 Segundos.')
							UpdateSkill("Cavalinhos", 0.1)
							treinando = true
							busy = false
						elseif membro == false then
							exports['slayn_notify']:DoHudText('error', 'Precisas De Ser Membro Do Ginásio.')
						end
					elseif treinando == true then		
						descansado = true
						VerificarDescanso()
					end
				end	
			else
				letSleep = true		
			end
			
			if letSleep then
				Citizen.Wait(1500)
			end
        end
    end
end)

function VerificarDescanso()
	if descansado == true then
		exports['slayn_notify']:DoHudText('error', 'Estás a Descansar...')
		descansado = false
		Citizen.Wait(60000)
		treinando = false
	end
	if descansado == false then
		exports['slayn_notify']:DoHudText('success', 'Podes Exercitar Novamente.')
	end
end

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local p = GetGameplayCamCoords()
	local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
	local scale = (1 / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	if onScreen then
	SetTextScale(0.20, 0.20)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	end
end

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
		for k in pairs(arms) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, arms[k].x, arms[k].y, arms[k].z)
			if dist <= 2.5 and busy == false then
				letSleep = false
				Draw3DText(arms[k].x, arms[k].y, arms[k].z-0.20, '[~g~E~s~] Treinar Braços')
				DrawMarker(20, arms[k].x, arms[k].y, arms[k].z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 255, 50, 100, 0, 0, 0, 0)
			else
				letSleep = true
			end
		end
		
		if letSleep then
			Citizen.Wait(1500)
		end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
		for k in pairs(pushup) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pushup[k].x, pushup[k].y, pushup[k].z)
			if dist <= 2.5 and busy == false then
				letSleep = false
				Draw3DText(pushup[k].x, pushup[k].y, pushup[k].z-0.20, '[~g~E~s~] Treinar Flexões')
           	 	DrawMarker(20, pushup[k].x, pushup[k].y, pushup[k].z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 255, 50, 100, 0, 0, 0, 0)
			else
				letSleep = true
			end
		end
	
		if letSleep then
			Citizen.Wait(1500)
		end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
		for k in pairs(yoga) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, yoga[k].x, yoga[k].y, yoga[k].z)
			if dist <= 2.5 and busy == false then
				letSleep = false
				Draw3DText(yoga[k].x, yoga[k].y, yoga[k].z-0.20, '[~g~E~s~] Treinar Yoga')
            	DrawMarker(20, yoga[k].x, yoga[k].y, yoga[k].z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 255, 50, 100, 0, 0, 0, 0)
			else
				letSleep = true
			end
		end

		if letSleep then
			Citizen.Wait(1500)
		end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
		for k in pairs(situps) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, situps[k].x, situps[k].y, situps[k].z)
			if dist <= 2.5 and busy == false then
				letSleep = false
				Draw3DText(situps[k].x, situps[k].y, situps[k].z-0.20, '[~g~E~s~] Treinar Abdominais')
            	DrawMarker(20, situps[k].x, situps[k].y, situps[k].z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 255, 50, 100, 0, 0, 0, 0)
			else
				letSleep = true
			end
		end

		if letSleep then
			Citizen.Wait(1500)
		end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		local letSleep = true
		for k in pairs(chins) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chins[k].x, chins[k].y, chins[k].z)
			if dist <= 2.5 and busy == false then
				letSleep = false
				Draw3DText(chins[k].x, chins[k].y, chins[k].z-0.20, '[~g~E~s~] Treinar Queixo')
           		DrawMarker(20, chins[k].x, chins[k].y, chins[k].z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 255, 50, 100, 0, 0, 0, 0)
			else
				letSleep = true
			end
		end

		if letSleep then
			Citizen.Wait(1500)
		end
    end
end)

FetchSkills = function()
	Citizen.Wait(100)
    ESX.TriggerServerCallback("slayn_skills:fetchStatus", function(data)
		if data then
            for status, value in pairs(data) do
                if Config.Skills[status] then
                    Config.Skills[status]["Current"] = value["Current"]
                end
            end
		end
        RefreshSkills()
    end)
end

SkillMenu = function()
	Citizen.Wait(100)
    ESX.UI.Menu.CloseAll()
    local skills = {}
	for type, value in pairs(Config.Skills) do
		table.insert(skills, {
			["label"] = type .. ': <span style="color:green">' .. value["Current"] .. "</span>%"
		})
	end
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "skill_menu",
	{
		["title"] = "Menu De Skills",
		["align"] = "left",
		["elements"] = skills

	}, function(data, menu)
	end, function(data, menu)
		menu.close()
	end)
end

GetCurrentSkill = function(skill)
	Citizen.Wait(100)
    return Config.Skills[skill]
end

UpdateSkill = function(skill, amount)
	Citizen.Wait(100)
    if not Config.Skills[skill] then
        return
    end
    local SkillAmount = Config.Skills[skill]["Current"]
    if SkillAmount + tonumber(amount) < 0 then
        Config.Skills[skill]["Current"] = 0
    elseif SkillAmount + tonumber(amount) > 100 then
        Config.Skills[skill]["Current"] = 100
    else
        Config.Skills[skill]["Current"] = SkillAmount + tonumber(amount)
    end
    RefreshSkills()
    if tonumber(amount) > 0 then
		exports['slayn_notify']:DoHudText('success', '+' .. amount .. '% De ' .. skill)
    end
	TriggerServerEvent("slayn_skills:update", json.encode(Config.Skills))
end


function round(num) 
	Citizen.Wait(100)
    return math.floor(num+.5) 
end

RefreshSkills = function()
	Citizen.Wait(100)
    for type, value in pairs(Config.Skills) do
        if value["Stat"] then
            StatSetInt(value["Stat"], round(value["Current"]), true)
        end
    end
end

RegisterCommand('skills', function()
	if not ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "skill_menu") then
		SkillMenu()
	end
end)