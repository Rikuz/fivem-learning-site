local DEALERSHIP_COORDS = vec3(-56.0, -1096.0, 26.0)
local TEST_DRIVE_DURATION_MS = 3 * 60 * 1000 -- 3分間

local testDriveVehicle = nil
local testDriveEndsAt = nil

RegisterCommand('dealershipopen', function()
    TriggerServerEvent('ex16dealership:requestInventory')
end, false)

RegisterNetEvent('ex16dealership:showInventory')
AddEventHandler('ex16dealership:showInventory', function(inventory)
    for i, v in ipairs(inventory) do
        TriggerEvent('chat:addMessage', { args = { '[ディーラー]', ('%d: %s ($%s)'):format(i, v.label, v.price) } })
    end
    TriggerEvent('chat:addMessage', { args = { '[ディーラー]', '/testdrive [車種] /buyfull [車種] /buyloan [車種] [分割回数]' } })
end)

RegisterCommand('testdrive', function(source, args)
    local model = args[1]
    if not model then return end

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    testDriveVehicle = CreateVehicle(model, DEALERSHIP_COORDS.x, DEALERSHIP_COORDS.y, DEALERSHIP_COORDS.z, 0.0, true, false)
    SetVehicleOnGroundProperly(testDriveVehicle)
    SetModelAsNoLongerNeeded(model)

    local ped = PlayerPedId()
    TaskWarpPedIntoVehicle(ped, testDriveVehicle, -1)

    testDriveEndsAt = GetGameTimer() + TEST_DRIVE_DURATION_MS
    TriggerEvent('chat:addMessage', { args = { '[ディーラー]', '試乗開始(3分間)' } })
end, false)

local function endTestDrive(reason)
    if not testDriveVehicle or not DoesEntityExist(testDriveVehicle) then return end

    local ped = PlayerPedId()
    if IsPedInVehicle(ped, testDriveVehicle, false) then
        TaskLeaveVehicle(ped, testDriveVehicle, 0)
    end

    SetEntityAsMissionEntity(testDriveVehicle, true, true)
    DeleteEntity(testDriveVehicle)
    testDriveVehicle = nil
    testDriveEndsAt = nil

    TriggerEvent('chat:addMessage', { args = { '[ディーラー]', ('試乗を終了しました(%s)'):format(reason) } })
end

CreateThread(function()
    while true do
        Wait(1000)

        if testDriveEndsAt then
            if GetGameTimer() >= testDriveEndsAt then
                endTestDrive('時間切れ')
            elseif testDriveVehicle and DoesEntityExist(testDriveVehicle) then
                local distance = #(GetEntityCoords(testDriveVehicle) - DEALERSHIP_COORDS)
                if distance > 500.0 then -- 販売店から離れすぎたら強制終了する
                    endTestDrive('エリア外')
                end
            end
        end
    end
end)

RegisterCommand('buyfull', function(source, args)
    TriggerServerEvent('ex16dealership:purchaseFull', args[1])
end, false)

RegisterCommand('buyloan', function(source, args)
    TriggerServerEvent('ex16dealership:purchaseLoan', args[1], tonumber(args[2]))
end, false)

RegisterNetEvent('ex16dealership:deliverVehicle')
AddEventHandler('ex16dealership:deliverVehicle', function(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local vehicle = CreateVehicle(model, DEALERSHIP_COORDS.x, DEALERSHIP_COORDS.y, DEALERSHIP_COORDS.z, 0.0, true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetModelAsNoLongerNeeded(model)

    -- 納車時、ダメージ状態を初期化してから引き渡す(Tier2-14参照)
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)

    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
end)

RegisterNetEvent('ex16dealership:notify')
AddEventHandler('ex16dealership:notify', function(message)
    TriggerEvent('chat:addMessage', { args = { '[ディーラー]', message } })
end)
