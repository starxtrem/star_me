
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	
end)


local function TableToString(tab)
	local str = ""
	for i = 1, #tab do
		str = str .. " " .. tab[i]
	end
	return str
end

RegisterCommand('me', function(source, args)
    local text = "*La personne " .. TableToString(args) .. " *"
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end)

ESX.RegisterServerCallback('me:recupid', function(source, cb)
	cb(source)
end)