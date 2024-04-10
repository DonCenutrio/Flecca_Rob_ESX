local taladro=false
local xPlayer
local _source
local item

--
--Funciones
--

--VALIDATE THE WEAPON
function IsWeaponValid(weapon)
    --This function validate if the player has a weapon that is in the following list
    local list_firearms = {
        "WEAPON_PISTOL",
        "WEAPON_COMBATPISTOL",
        "WEAPON_SMG",
        "WEAPON_ASSAULTRIFLE",
        "WEAPON_HEAVYPISTOL",
        --add more weapons here
    }

    for _, firearm in ipairs(list_firearms) do
        if weapon == GetHashKey(firearm) then
            return true
        end
    end
    return false
end

--VALIDATE THE POSITION
function validPosition(coord,coord_flecca)  
    --This function calculate if the player is inside the flecca
    if coord_flecca[1][1]<coord.x and coord_flecca[2][1]>coord.x and coord_flecca[3][1]>coord.y and coord_flecca[4][1]<coord.y and coord_flecca[5][1]<coord.z and coord_flecca[6][1]>coord.z then
        return true
    end
    return false
end

RegisterServerEvent('cenu:sincroMoneyServer')
AddEventHandler('cenu:sincroMoneyServer',function()
    print('Trigger robo dinero server')
    TriggerClientEvent('cenu:roboMoneyClient',-1)
end)

--FUNCTION TO CALCULATE THE COOLDOWN
function cooldown(bankId)
    Citizen.CreateThread(function()
        Wait(Banks[bankId]["Time"])
        Banks[bankId]["Cooldown"]=false
        Banks[bankId]["Iniciado"]=false
    end)
end

RegisterServerEvent('cenu:sincroPuerta')
AddEventHandler('cenu:sincroPuerta', function(coords, rotation)
    Citizen.CreateThread(function()
        TriggerClientEvent('cenu:animacionPuerta', -1, coords, rotation)
    end)
end)

RegisterServerEvent('cenu:giveMoney')
AddEventHandler('cenu:giveMoney',function(num,bankId)
    if Banks[bankId]["Robado"][num]==false then
        if num==1 or num==2 then
            TriggerClientEvent('cenu:actionRob',source,num)
            xPlayer=ESX.GetPlayerFromId(source)
            local cash=math.random(25,35)*1000
            print(cash)
            Banks[bankId]["Robado"][num]=true
            xPlayer.addAccountMoney('black_money',cash)
        elseif num==3 then
            TriggerClientEvent('cenu:actionRob',source,num)
            xPlayer=ESX.GetPlayerFromId(source)
            local cash=math.random(25,35)*1000
            print(cash)
            Banks[bankId]["Robado"][num]=true
            xPlayer.addAccountMoney('black_money',cash)
        end
    end
end)

RegisterServerEvent('cenu:compTaladroInicio')
AddEventHandler('cenu:compTaladroInicio',function()
    TriggerClientEvent('cenu:taladroInventory',-1)
end)

RegisterServerEvent('cenu:taladroInventoryServer')
AddEventHandler('cenu:taladroInventoryServer',function()
    item=xPlayer.getInventoryItem('taladro')
    if item.count>0 then
        taladro=true
    else
        taladro=false
    end
    TriggerClientEvent('cenu:taladroInventoryClient',source,taladro)
end)

--
--Citizens
--
ESX=exports["es_extended"]:getSharedObject()

-- TRIGGER TO START ROBBERY
RegisterServerEvent('cenu:inicioFlecca')
AddEventHandler('cenu:inicioFlecca', function(bankId)
    local policeConnected=0
    local xPlayersCop=ESX.GetExtendedPlayers('job', 'police')
    policeConnected=#xPlayersCop

    if isSheriffActive then
        local xPlayersSheriff = ESX.GetExtendedPlayers('job', 'sheriff')
        policeConnected = policeConnected + #xPlayersSheriff
    end
    local _source = source
    xPlayer = ESX.GetPlayerFromId(_source)
    local coord = GetEntityCoords(GetPlayerPed(_source))
    local weapon = GetSelectedPedWeapon(GetPlayerPed(_source))
    if policeConnected >= minPolice then
        if validPosition(coord,Banks[bankId]["Area"])==true then
            if Banks[bankId]["Cooldown"]==false then
                if IsWeaponValid(weapon) then
                    print('se inicia el robo')
                    Banks[bankId]["Iniciado"]=true
                    Banks[bankId]["Robado"]={false,false,false}
                    Banks[bankId]["Cooldown"]=true
                    cooldown(bankId)
                    TriggerClientEvent('cenu:inicioFlecca', _source, taladro)
                else
                    print('No se inicia el robo')
                    TriggerClientEvent('cenu:inicioFleccaFallo', _source, 1)
                    iniciado=false
                end
            elseif Banks[bankId]["Cooldown"]==true then
                TriggerClientEvent('cenu:inicioFleccaFallo', source, 2)
            end
        end
    else
        TriggerClientEvent('cenu:inicioFleccaFallo', source, 3)
    end
end)
