local xPlayer = PlayerPedId()

local money = {}
local moneyGenerate = false
local hasTaladro = false
local llamada=false
local hackeado=false

local noti=false

local bankId="Flecca1"

--
--Funciones
--

-- EVENT IF FAILS
RegisterNetEvent('cenu:inicioFleccaFallo')
AddEventHandler('cenu:inicioFleccaFallo',function(num)
    print(num)
    if num == 1 and noti==false then
        ESX.ShowNotification('Tu arma no altera al banquero')
        noti=true
        Citizen.CreateThread(function()
            Wait(5000)
            noti=false
        end)
    elseif num == 2 and noti==false then
        ESX.ShowNotification('El banco ya fue robado hace poco y no tiene nada de dinero')
        noti=true
        Citizen.CreateThread(function()
            Wait(5000)
            noti=false
        end)
    elseif num==3 and noti==false then
        ESX.ShowNotification('No hay policia suficiente para hacer el atraco')
        noti=true
        Citizen.CreateThread(function()
            Wait(5000)
            noti=false
        end)
    end
end)

-- EVENT START FLECCA
RegisterNetEvent('cenu:inicioFlecca')
AddEventHandler('cenu:inicioFlecca',function(taladro)
    ESX.ShowNotification('Robo iniciado')
    Banks[bankId]["Robado"] = {false, false, false}
    Banks[bankId]["DoorOpen"] = false
    Banks[bankId]["hackeado"] = false
    Banks[bankId]["Sincro"]=false
    --sonidoAlarma()
    hasTaladro=taladro
    Banks[bankId]["Iniciado"]=true
end)

-- GENERATE MONEY PROP
function generateMoney(banco)
    RequestModel(moneyModel)
    while not HasModelLoaded(moneyModel) do
        print('Esperando a que cargar el prop')
        Wait(100)
    end

    for _, coordMoney in ipairs(Banks[banco]["Money"]) do
        local cash = CreateObject(GetHashKey(moneyModel), coordMoney.x, coordMoney.y, coordMoney.z - 1, false, true, true)
        SetEntityRotation(cash, 0.0, 0.0, 70.0)
        table.insert(money, cash)
    end
end

-- DELETE MONEY PROP
function deleteMoney(banco)
    local list = money
    for _, object in ipairs(list) do
        if DoesEntityExist(object) then
            DeleteEntity(object)
        end
    end
end

function OpenDoor(time_cooldown)
    Banks[bankId]["Sincro"]=false
    local door = GetClosestObjectOfType(Banks[bankId]["Terminal"].x, Banks[bankId]["Terminal"].y, Banks[bankId]["Terminal"].z, 3.0, 2121050683)
    rotation = Banks[bankId]["Rotation"][1]
    Banks[bankId]["DoorOpen"] = true
    while rotation ~= Banks[bankId]["Rotation"][2] do
        Wait(10)
        rotation = rotation - 0.125
        SetEntityRotation(door, 0.0, 0.0, rotation)
        -- CALLBACK TO SERVER
        TriggerServerEvent('cenu:sincroPuerta', Banks[bankId]["Terminal"], rotation)
    end
    ESX.ShowNotification('La puerta se cerrará en 2 minutos')
    CloseDoor(time_cooldown)
    --Wait(5000)
end

RegisterNetEvent('cenu:animacionPuerta')
AddEventHandler('cenu:animacionPuerta', function(coords, rotation)
    local door = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, 2121050683)
    SetEntityRotation(door, 0.0, 0.0, rotation)
end)

function CloseDoor(time_cooldown)
    Citizen.CreateThread(function()
        Wait(time_cooldown)
        local door = GetClosestObjectOfType(Banks[bankId]["Terminal"].x, Banks[bankId]["Terminal"].y, Banks[bankId]["Terminal"].z, 3.0, 2121050683)
        while rotation ~= Banks[bankId]["Rotation"][1] do
            Wait(10)
            rotation = rotation + 0.125
            SetEntityRotation(door, 0.0, 0.0, rotation)
            -- CALLBACK TO SERVER
            TriggerServerEvent('cenu:sincroPuerta', Banks[bankId]["Terminal"], rotation)
        end
        Banks[bankId]["Iniciado"]=false
        --Wait(5000)
    end)
end

function propmoney()
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            for bankName, _ in pairs(Banks) do
                if GetDistanceBetweenCoords(GetEntityCoords(xPlayer) - Banks[bankName]["Terminal"]) < 20 and moneyGenerate==false then
                    bankId=bankName
                    print(bankId)
                    generateMoney(bankName)
                    moneyGenerate=true
                elseif GetDistanceBetweenCoords(GetEntityCoords(xPlayer) - Banks[bankId]["Terminal"]) > 20 and moneyGenerate == true then
                    deleteMoney(bankId)
                    moneyGenerate=false
                end
            end
        end
    end)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('cenu:roboMoneyClient')
AddEventHandler('cenu:roboMoneyClient',function()
    Citizen.CreateThread(function()
        TriggerServerEvent('cenu:compTaladroInicio')
        while true do
            local xPlayerMoneyRob=PlayerPedId()
            Wait(0)
            local num
            if GetDistanceBetweenCoords(Banks[bankId]["Money"][1] - GetEntityCoords(xPlayerMoneyRob)) < 1.1 and IsControlJustPressed(0, 38) then
                num=1
                TriggerServerEvent('cenu:giveMoney',num,bankId)
            elseif GetDistanceBetweenCoords(Banks[bankId]["Money"][2] - GetEntityCoords(xPlayerMoneyRob)) < 1.1 and IsControlJustPressed(0, 38) then
                num=2
                TriggerServerEvent('cenu:giveMoney',num,bankId)
            end
            if hasTaladro == true and Banks[bankId]["Robado"][3] == false and GetDistanceBetweenCoords(Banks[bankId]["Taladro"]-GetEntityCoords(xPlayerMoneyRob))<5 then
                DrawMarker(2, Banks[bankId]["Taladro"].x, Banks[bankId]["Taladro"].y, Banks[bankId]["Taladro"].z, 0, 0, 0, 0, 0, 0, 0.8001, 0.8001, 0.6001, 52, 155, 0, 200, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(Banks[bankId]["Taladro"] - GetEntityCoords(xPlayerMoneyRob)) < 1.1 then
                    ESX.ShowHelpNotification('~g~E~w~ Para usar taladro')
                    if IsControlJustPressed(0, 38) then
                        print('inicio taladro')
                        Banks[bankId]["Robado"][3] = true
                        TriggerServerEvent('cenu:giveMoney',3,bankId)
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('cenu:taladroInventory')
AddEventHandler('cenu:taladroInventory',function()
    Citizen.CreateThread(function()
        while Banks[bankId]["Robado"][3]==false do
            Wait(2000)
            TriggerServerEvent('cenu:taladroInventoryServer')
        end
    end)
end)

RegisterNetEvent('cenu:taladroInventoryClient')
AddEventHandler('cenu:taladroInventoryClient',function(taladro)
    hasTaladro=taladro
    local xPlayerMoneyRob=PlayerPedId()
    TaskStartScenarioInPlace(xPlayerMoneyRob, "mini@repair", 0, true)
    Wait(90000)
    ClearPedTasks(xPlayerMoneyRob)
end)

RegisterNetEvent('cenu:actionRob')
AddEventHandler('cenu:actionRob',function(num)
    if num==1 or num==2 then
        local xPlayerMoneyRob=PlayerPedId()
        TaskStartScenarioInPlace(xPlayerMoneyRob, "mp_safebox_carry", 0, true)
        Wait(30000)
        ClearPedTasks(xPlayerMoneyRob)
    elseif num==3 then
        ESX.ShowNotification('Taladrado')
    end
end)

--
--Citizens
--
ESX = exports["es_extended"]:getSharedObject()

while true do
    Wait(0)
    xPlayer = PlayerPedId()
    -- DETECT IF PLAYER SHOOTS AND SEND TRIGGER TO SERVER
    if IsPedShooting(xPlayer) then
        for bankName, _ in pairs(Banks) do
            if IsPedShootingInArea(xPlayer,Banks[bankName]["Area"][1][1],Banks[bankName]["Area"][3][1],Banks[bankName]["Area"][5][1],Banks[bankName]["Area"][2][1],Banks[bankName]["Area"][4][1],Banks[bankName]["Area"][6][1],false,false) then
                bankId=bankName
                print(bankId)
                TriggerServerEvent('cenu:inicioFlecca',bankId)
            end
        end
    end
    if llamada==false then
        propmoney()
        llamada=true
    end
    local playerData=ESX.GetPlayerData()
    if playerData.job.label=='police' and Banks[bankId]["Iniciado"]==true and GetDistanceBetweenCoords(Banks[bankId]["Terminal"] - GetEntityCoords(xPlayer)) < 5 then
        DrawMarker(2, Banks[bankId]["Terminal"].x, Banks[bankId]["Terminal"].y, Banks[bankId]["Terminal"].z, 0, 0, 0, 0, 0, 0, 0.8001, 0.8001, 0.6001, 52, 155, 0, 200, 0, 0, 0, 0)
        if GetDistanceBetweenCoords(Banks[bankId]["Terminal"] - GetEntityCoords(xPlayer)) < 1.1 then
            ESX.ShowHelpNotification('~g~E~w~ Para abrir caja fuerte')
            if IsControlJustPressed(0, 38) then
                    OpenDoor(300000)
            end
        end
    else
        if Banks[bankId]["hackeado"] == false and Banks[bankId]["Iniciado"] == true and Banks[bankId]["DoorOpen"] == false then
            DrawMarker(2, Banks[bankId]["Terminal"].x, Banks[bankId]["Terminal"].y, Banks[bankId]["Terminal"].z, 0, 0, 0, 0, 0, 0, 0.8001, 0.8001, 0.6001, 52, 155, 0, 200, 0, 0, 0, 0)
            if GetDistanceBetweenCoords(Banks[bankId]["Terminal"] - GetEntityCoords(xPlayer)) < 1.1 then
                ESX.ShowHelpNotification('~g~E~w~ Para hackear caja fuerte')
                if IsControlJustPressed(0, 38) then
                        -- method 1:
                        TriggerEvent("utk_fingerprint:Start", levels, lifes, time, function(outcome, reason)
                            if outcome == true then
                                Banks[bankId]["hackeado"]=true
                                Wait(3000)
                                print('inicio script abrir caja fuerte')
                                ESX.Progressbar("Hackeando", 10000,{
                                    FreezePlayer = true, 
                                })
                                OpenDoor(Banks[bankId]["Time"])
                            elseif outcome == false then
                                print("Failed! Reason: "..reason)
                            end
                        end)

                        -- method 2:
                        --TriggerEvent("utk_fingerprint:Start", levels, lifes, time, HackFinished)

                        --function HackFinished(outcome, reason)
                        --    if outcome == true then
                        --        print("Success!!")
                        --    elseif outcome == false then
                        --        print("Failed! Reason: "..reason)
                        --    end
                        --end
                end
            end
        elseif Banks[bankId]["Iniciado"] == true and Banks[bankId]["hackeado"]==true and Banks[bankId]["DoorOpen"] == true then
            if Banks[bankId]["Sincro"]==false then
                TriggerServerEvent('cenu:sincroMoneyServer')
                Wait(1000)
                Banks[bankId]["Sincro"]=true
            end
        end
    end
end
