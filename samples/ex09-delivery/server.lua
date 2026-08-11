local activeRequests = {} -- requestId -> { requesterId, driverId, status, coords }
local nextRequestId = 1

RegisterNetEvent('ex09delivery:request')
AddEventHandler('ex09delivery:request', function(x, y, z)
    local playerId = source
    local requestId = nextRequestId
    nextRequestId = nextRequestId + 1

    activeRequests[requestId] = { requesterId = playerId, status = 'waiting', coords = vec3(x, y, z) }

    -- 対応可能な全プレイヤーに通知する(実際にはJob確認等でドライバー役に絞る、Tier4-02参照)
    for _, targetId in ipairs(GetPlayers()) do
        local targetIdNum = tonumber(targetId)
        if targetIdNum ~= playerId then
            TriggerClientEvent('ex09delivery:incomingRequest', targetIdNum, requestId, GetPlayerName(playerId), activeRequests[requestId].coords)
        end
    end

    TriggerClientEvent('ex09delivery:statusUpdate', playerId, 'waiting', '依頼を送信しました。ドライバーを待っています...', requestId)
end)

RegisterNetEvent('ex09delivery:accept')
AddEventHandler('ex09delivery:accept', function(requestId)
    local driverId = source
    local request = activeRequests[requestId]

    -- 1件の依頼を複数のドライバーが同時に受注しようとしても、最初の1人だけが受注できる
    if not request or request.status ~= 'waiting' then
        TriggerClientEvent('ex09delivery:statusUpdate', driverId, 'error', 'この依頼は既に受注済みです', requestId)
        return
    end

    request.status = 'accepted'
    request.driverId = driverId

    TriggerClientEvent('ex09delivery:statusUpdate', request.requesterId, 'accepted', ('%sが向かっています'):format(GetPlayerName(driverId)), requestId)
    TriggerClientEvent('ex09delivery:statusUpdate', driverId, 'accepted', '受注しました。依頼者の元へ向かってください', requestId)
end)

RegisterNetEvent('ex09delivery:complete')
AddEventHandler('ex09delivery:complete', function(requestId)
    local driverId = source
    local request = activeRequests[requestId]

    if not request or request.driverId ~= driverId then return end

    request.status = 'completed'
    TriggerClientEvent('ex09delivery:statusUpdate', request.requesterId, 'completed', '依頼が完了しました', requestId)
    TriggerClientEvent('ex09delivery:statusUpdate', driverId, 'completed', '依頼を完了しました', requestId)

    activeRequests[requestId] = nil
end)
