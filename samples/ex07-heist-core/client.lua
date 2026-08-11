RegisterNetEvent('ex07heist:missionStarted')
AddEventHandler('ex07heist:missionStarted', function(bucketId)
    TriggerEvent('chat:addMessage', { args = { '[強盗]', ('ミッションを開始しました(バケットID: %d)'):format(bucketId) } })
end)

RegisterNetEvent('ex07heist:notify')
AddEventHandler('ex07heist:notify', function(message)
    TriggerEvent('chat:addMessage', { args = { '[強盗]', message } })
end)
