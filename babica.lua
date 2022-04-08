--[[

  ____          ____ _____ _____             _______     _______ _______ ______ __  __ 
 |  _ \   /\   |  _ \_   _/ ____|   /\      / ____\ \   / / ____|__   __|  ____|  \/  |
 | |_) | /  \  | |_) || || |       /  \    | (___  \ \_/ / (___    | |  | |__  | \  / |
 |  _ < / /\ \ |  _ < | || |      / /\ \    \___ \  \   / \___ \   | |  |  __| | |\/| |
 | |_) / ____ \| |_) || || |____ / ____ \   ____) |  | |  ____) |  | |  | |____| |  | |
 |____/_/    \_\____/_____\_____/_/    \_\ |_____/   |_| |_____/   |_|  |______|_|  |_|
                                                                                       
--]]                                                                                
ESX = nil

CreateThread(function() while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end end)

if not Babica.qtarget then -- Ako je QTARGET iskljucen
CreateThread(function ()
	while true do
		Wait(5)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local babica = #(coords - vector3(-53.6833, -2523.3218, 7.4012))
        	local babica2 = #(coords - vector3(-440.4526, 1595.0342, 358.4680))

		local pauza = true
        
    if babica < 20.0 then
   	DrawMarker(20, vector3(-53.6833, -2523.3218, 7.4012), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 49, 105, 235, 100, false, true, 2, true, false, false, false)
	pauza = false
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -53.6833, -2523.3218, 7.4012, true) < 2 then
       pokazi3dtext(GetEntityCoords(PlayerPedId()), 'Pritisnite ~INPUT_CONTEXT~ za ~b~ozivljavanje~s~.', 250)
        if IsControlJustPressed(0, 38) and IsPedOnFoot(playerPed) then
              babuska()
            end
        end
    end

    if babica2 < 20.0 then
        DrawMarker(20, vector3(-440.4526, 1595.0342, 358.4680), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 49, 105, 235, 100, false, true, 2, true, false, false, false)
        pauza = false
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -440.4526, 1595.0342, 358.4680, true) < 2 then
          pokazi3dtext(GetEntityCoords(PlayerPedId()), 'Pritisnite ~INPUT_CONTEXT~ za ~b~ozivljavanje~s~.', 250)
            if IsControlJustPressed(0, 38) and IsPedOnFoot(playerPed) then
              babuska()
            end
        end
    end
		if pauza then
		    Wait(1000)
		end
	end
end)

pokazi3dtext = function(pos, text)
	local pocni = text
    local pocetak, kraj = string.find(text, '~([^~]+)~')
    if pocetak then
        pocetak = pocetak - 2
        kraj = kraj + 2
        pocni = ''
        pocni = pocni .. string.sub(text, 0, pocetak) .. '   '.. string.sub(text, pocetak+2, kraj-2) .. string.sub(text, kraj, #text)
    end
    AddTextEntry(GetCurrentResourceName(), pocni)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(2, false, false, -1)
    SetFloatingHelpTextWorldPosition(1, pos + vector3(0.0, 0.0, 1.0))
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    end
end

if Babica.qtarget then -- Ako je QTARGET ukljucen
-- Npcevi
local NPC = {
    {model = "cs_mrs_thornhill", x = -53.8833, y = -2523.3218, z = 6.4012, h = 57.3296}, --Lokacija 1
    {model = "cs_mrs_thornhill", x = -440.4526, y = 1595.0342, z = 357.4680, h = 227.1398}, --Lokacija 2
}

CreateThread(function()
    for _, v in pairs(NPC) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do 
            Wait(1)
        end
        local npc = CreatePed(4, v.model, v.x, v.y, v.z, v.h,  false, true)
        SetPedFleeAttributes(npc, 0, 0)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        SetEntityInvincible(npc , true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
    end
end)
	
local peds = {
    'cs_mrs_thornhill',
}

exports['qtarget']:AddTargetModel(peds, {
    options = {
        {
            action = function()
              babuska()
            end,
            icon = "fa-solid fa-hand-holding-medical",
            label = "Ozivi se",
        },
    },
    distance = 2.0
})
end

local mrtav = false

babuska = function()
    local player = PlayerPedId()
    local ozivljavanje = Babica.vrijeme * 1000
    if mrtav then
    FreezeEntityPosition(player, true)
    exports.rprogress:Start('Lijecite se...', ozivljavanje)
    TriggerEvent('esx_ambulancejob:revive')
    FreezeEntityPosition(player, false)
    else
	ESX.ShowNotification('Nisi mrtav!')	
    end
end

AddEventHandler('playerSpawned', function(spawn) mrtav = false end)
AddEventHandler('esx:onPlayerDeath', function(data) mrtav = true end)
