local activeMissions = {} -- bucketId -> { players = {}, doorBreached = false }
local nextBucketId = 1

local function startMission(playerIds)
    local bucketId = nextBucketId
    nextBucketId = nextBucketId + 1

    activeMissions[bucketId] = { players = playerIds, doorBreached = false }

    for _, playerId in ipairs(playerIds) do
        -- 参加プレイヤーを一意なルーティングバケットに移動させる(Tier5-08参照)
        -- 同じ座標に一般プレイヤーがいても、バケットが異なれば互いに見えなくなる
        SetPlayerRoutingBucket(playerId, bucketId)
        Player(playerId).state:set('heistBucket', bucketId, true)
    end

    return bucketId
end

local function payReward(bucketId, amountPerPlayer)
    local mission = activeMissions[bucketId]
    if not mission then return end

    for _, playerId in ipairs(mission.players) do
        -- 実際にはokokBanking等で口座に振り込む(Tier4-06参照)。ここでは通知のみのデモ実装。
        TriggerClientEvent('ex07heist:notify', playerId, ('報酬$%sを受け取りました'):format(amountPerPlayer))
        SetPlayerRoutingBucket(playerId, 0) -- 通常ワールド(バケット0)に帰還させる
    end

    activeMissions[bucketId] = nil
end

-- 他resourceから呼び出せるようexportsで公開する(Tier3-06参照)
exports('StartMission', startMission)
exports('PayReward', payReward)

RegisterCommand('heiststart', function(source)
    local playerId = source
    local bucketId = startMission({ playerId }) -- デモのため実行者1人だけを参加者にする

    TriggerClientEvent('ex07heist:missionStarted', playerId, bucketId)
end, false)

RegisterCommand('heistcomplete', function(source)
    local playerId = source
    local bucketId = Player(playerId).state.heistBucket
    if not bucketId then return end

    payReward(bucketId, 5000)
end, false)

-- ドアギミック(ex07-heist-door)からの通知を受け、参加プレイヤー全員のStateBagsを更新する(Tier5-03参照)
RegisterNetEvent('ex07heistcore:doorBreached')
AddEventHandler('ex07heistcore:doorBreached', function(bucketId)
    local mission = activeMissions[bucketId]
    if not mission then return end

    mission.doorBreached = true

    for _, playerId in ipairs(mission.players) do
        Player(playerId).state:set('doorBreached', true, true)
    end
end)

-- 参加プレイヤーが強盗中に切断した場合の後始末(Tier2-15参照)
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local bucketId = Player(playerId).state.heistBucket

    if bucketId and activeMissions[bucketId] then
        activeMissions[bucketId] = nil
    end
end)
