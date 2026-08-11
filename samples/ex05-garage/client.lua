local GARAGE_NAME = 'downtown'
local GARAGE_COORDS = vec3(-200.0, -1300.0, 31.0)

exports.ox_target:addBoxZone({
    coords = GARAGE_COORDS,
    size = vec3(4.0, 4.0, 3.0),
    options = {
        {
            name = 'garage_take_out',
            icon = 'fa-solid fa-car',
            label = '車両を出庫する',
            onSelect = function()
                TriggerServerEvent('ex05garage:requestVehicles', GARAGE_NAME)
            end,
        },
        {
            name = 'garage_store',
            icon = 'fa-solid fa-warehouse',
            label = '車両を格納する',
            onSelect = function()
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(ped, false)
                if vehicle == 0 then
                    TriggerEvent('chat:addMessage', { args = { '[ガレージ]', '車両に乗っていません' } })
                    return
                end

                local plate = GetVehicleNumberPlateText(vehicle)
                local fuel = GetVehicleFuelLevel(vehicle)
                local engineHealth = GetVehicleEngineHealth(vehicle)
                local bodyHealth = GetVehicleBodyHealth(vehicle)

                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteEntity(vehicle)

                TriggerServerEvent('ex05garage:store', plate, fuel, engineHealth, bodyHealth)
            end,
        },
    }
})

RegisterNetEvent('ex05garage:showVehicles')
AddEventHandler('ex05garage:showVehicles', function(vehicles)
    if #vehicles == 0 then
        TriggerEvent('chat:addMessage', { args = { '[ガレージ]', '格納中の車両がありません' } })
        return
    end

    for _, v in ipairs(vehicles) do
        TriggerEvent('chat:addMessage', { args = { '[ガレージ]', ('%s (%s) — /garagetakeout %s'):format(v.model, v.plate, v.plate) } })
    end
end)

RegisterCommand('garagetakeout', function(source, args)
    TriggerServerEvent('ex05garage:takeOut', args[1])
end, false)

RegisterNetEvent('ex05garage:spawnVehicle')
AddEventHandler('ex05garage:spawnVehicle', function(vehicleData)
    RequestModel(vehicleData.model)
    while not HasModelLoaded(vehicleData.model) do Wait(0) end

    local vehicle = CreateVehicle(vehicleData.model, GARAGE_COORDS.x, GARAGE_COORDS.y, GARAGE_COORDS.z, 0.0, true, false)
    SetVehicleNumberPlateText(vehicle, vehicleData.plate)
    SetModelAsNoLongerNeeded(vehicleData.model)

    -- DBに保存されたダメージ状態・燃料を復元してから出庫する
    SetVehicleFuelLevel(vehicle, vehicleData.fuel + 0.0)
    SetVehicleEngineHealth(vehicle, vehicleData.engine_health + 0.0)
    SetVehicleBodyHealth(vehicle, vehicleData.body_health + 0.0)

    SetVehicleOnGroundProperly(vehicle)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
end)

RegisterNetEvent('ex05garage:notify')
AddEventHandler('ex05garage:notify', function(message)
    TriggerEvent('chat:addMessage', { args = { '[ガレージ]', message } })
end)

-- デバッグ用: 所有車両を登録する(オーナーシップ画面が無いため)
RegisterCommand('garageregister', function(source, args)
    TriggerServerEvent('ex05garage:debugRegisterVehicle', args[1], args[2], GARAGE_NAME)
end, false)
