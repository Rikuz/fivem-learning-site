local isOnDuty = false
local deliveryBlips = {}
local jobVehicle = nil

local function clearBlips()
    for _, blip in ipairs(deliveryBlips) do
        RemoveBlip(blip)
    end
    deliveryBlips = {}
end

local function addDeliveryBlip(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 5)
    SetBlipRoute(blip, true)
    deliveryBlips[#deliveryBlips + 1] = blip
    return blip
end

RegisterCommand('deliveryduty', function()
    TriggerServerEvent('ex12job:toggleDuty')
end, false)

RegisterNetEvent('ex12job:onDutyChanged')
AddEventHandler('ex12job:onDutyChanged', function(onDuty)
    isOnDuty = onDuty

    if onDuty then
        local model = `speedo`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        local coords = vec4(-45.0, -1000.0, 26.0, 0.0)
        jobVehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
        SetVehicleOnGroundProperly(jobVehicle)
        SetModelAsNoLongerNeeded(model)

        TriggerEvent('chat:addMessage', { args = { '[配送]', '出勤しました。配送車両が貸し出されました' } })
    else
        clearBlips()
        if jobVehicle and DoesEntityExist(jobVehicle) then
            SetEntityAsMissionEntity(jobVehicle, true, true)
            DeleteEntity(jobVehicle)
            jobVehicle = nil
        end
        TriggerEvent('chat:addMessage', { args = { '[配送]', 'お疲れさまでした' } })
    end
end)

RegisterCommand('deliveryaccept', function()
    if not isOnDuty then
        TriggerEvent('chat:addMessage', { args = { '[配送]', '出勤してから仕事を受けてください' } })
        return
    end
    TriggerServerEvent('ex12job:accept')
end, false)

RegisterNetEvent('ex12job:jobStarted')
AddEventHandler('ex12job:jobStarted', function(points)
    clearBlips()
    for _, coords in ipairs(points) do
        addDeliveryBlip(coords)
    end
    TriggerEvent('chat:addMessage', { args = { '[配送]', ('%d件の配達先が設定されました'):format(#points) } })
end)

RegisterNetEvent('ex12job:nextPoint')
AddEventHandler('ex12job:nextPoint', function(coords)
    clearBlips()
    addDeliveryBlip(coords)
end)

RegisterNetEvent('ex12job:jobCompleted')
AddEventHandler('ex12job:jobCompleted', function(payout)
    clearBlips()
    TriggerEvent('chat:addMessage', { args = { '[配送]', ('配送完了!報酬$%sを受け取りました'):format(payout) } })
end)

RegisterNetEvent('ex12job:jobEnded')
AddEventHandler('ex12job:jobEnded', function(reason)
    clearBlips()
    TriggerEvent('chat:addMessage', { args = { '[配送]', reason } })
end)

RegisterNetEvent('ex12job:notify')
AddEventHandler('ex12job:notify', function(message)
    TriggerEvent('chat:addMessage', { args = { '[配送]', message } })
end)

-- 配達先で実行する荷下ろしアクション(距離チェックは省略し、コマンド実行=到着とみなす簡易実装)
RegisterCommand('deliverydropoff', function()
    local success = lib.progressBar({
        duration = 3000,
        label = '荷下ろししています...',
        canCancel = true,
        disable = { move = true, car = true },
    })

    if success then
        TriggerServerEvent('ex12job:arrivedAtPoint')
    end
end, false)
