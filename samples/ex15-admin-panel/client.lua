RegisterNetEvent('ex15admin:open')
AddEventHandler('ex15admin:open', function(level, playerList, reports)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', level = level, players = playerList, reports = reports })
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('spectate', function(data, cb)
    TriggerServerEvent('ex15admin:spectate', data.targetId)
    cb('ok')
end)

RegisterNUICallback('kick', function(data, cb)
    TriggerServerEvent('ex15admin:kick', data.targetId, data.reason)
    cb('ok')
end)

RegisterNUICallback('ban', function(data, cb)
    TriggerServerEvent('ex15admin:ban', data.targetId, data.reason)
    cb('ok')
end)

local isSpectating = false

RegisterNetEvent('ex15admin:doSpectate')
AddEventHandler('ex15admin:doSpectate', function(targetServerId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(tonumber(targetServerId)))
    if targetPed == 0 then return end

    NetworkSetInSpectatorMode(true, targetPed)
    isSpectating = true
end)

RegisterCommand('adminstopspectate', function()
    if not isSpectating then return end
    NetworkSetInSpectatorMode(false, PlayerPedId())
    isSpectating = false
end, false)
