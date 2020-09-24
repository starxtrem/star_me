ESX = nil
local defaultScale = 0.5 -- Text scale
local color = { r = 230, g = 230, b = 230, a = 255 } -- Text color
local font = 0 -- Text font
local displayTime = 5000 -- Duration to display the text (in ms)
local distToDraw = 250 -- Min. distance to draw 
local idserver = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    ESX.TriggerServerCallback('me:recupid',function(valeurduserveur)
        idserver = valeurduserveur
    end)	
end)

local pedDisplaying = {}


local function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    --if onScreen then
		--print(text)
		
		if text == "*La personne x *" or text == "*La personne  x *" then
			return
		else
			-- Format the text
			SetTextColour(color.r, color.g, color.b, color.a)
			SetTextScale(0.0, defaultScale * scale)
			SetTextDropshadow(0, 0, 0, 0, 55)
			SetTextDropShadow()
			SetTextCentre(true)

			-- Diplay the text
			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(text)
			SetDrawOrigin(coords, 0)
			EndTextCommandDisplayText(0.0, 0.0)
			ClearDrawOrigin()
		end
end

local function Display(ped, text, iddebase)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

	
	if pedCoords ~= playerCoords or iddebase == idserver then
		if dist <= distToDraw then

			pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

			-- Timer
			local display = true

			Citizen.CreateThread(function()
				Wait(displayTime)
				display = false
			end)

			-- Display
			local offset = 0.8 + pedDisplaying[ped] * 0.1
			while display do
				if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
					local x, y, z = table.unpack(GetEntityCoords(ped))
					z = z + offset
						DrawText3D(vector3(x, y, z), text)
				end
				Wait(0)
			end

			pedDisplaying[ped] = pedDisplaying[ped] - 1

		end
	end
end

-- --------------------------------------------
-- Event
-- --------------------------------------------

RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, serverId)
    local ped = GetPlayerPed(GetPlayerFromServerId(serverId))
    Display(ped, text, serverId)
end)


--######################################
--########### BY STARXTREM #############
--######################################