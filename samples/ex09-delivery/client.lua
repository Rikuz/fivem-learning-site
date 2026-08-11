local APP_ID = 'ex09_delivery'

RegisterNetEvent('ex09delivery:open')
AddEventHandler('ex09delivery:open', function()
    exports['lb-phone']:SendCustomAppMessage(APP_ID, { action = 'showForm' })
end)

RegisterNUICallback('requestDelivery', function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('ex09delivery:request', coords.x, coords.y, coords.z)
    cb('ok')
end)

RegisterNetEvent('ex09delivery:incomingRequest')
AddEventHandler('ex09delivery:incomingRequest', function(requestId, requesterName, coords)
    -- ドライバー側の画面に依頼内容を表示し、Blipで依頼者の位置を示す(Tier2-03参照)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 280)
    SetBlipColour(blip, 5)
    SetBlipRoute(blip, true)

    exports['lb-phone']:SendCustomAppMessage(APP_ID, {
        action = 'newRequest',
        requestId = requestId,
        requesterName = requesterName,
    })
end)

RegisterNUICallback('acceptDelivery', function(data, cb)
    TriggerServerEvent('ex09delivery:accept', data.requestId)
    cb('ok')
end)

RegisterNUICallback('completeDelivery', function(data, cb)
    TriggerServerEvent('ex09delivery:complete', data.requestId)
    cb('ok')
end)

RegisterNetEvent('ex09delivery:statusUpdate')
AddEventHandler('ex09delivery:statusUpdate', function(status, message, requestId)
    exports['lb-phone']:SendCustomAppMessage(APP_ID, { action = 'statusUpdate', status = status, message = message, requestId = requestId })
end)
