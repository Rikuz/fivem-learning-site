local wantedLevels = {} -- playerId -> スコア
local MAX_WANTED = 100

local function addWantedLevel(playerId, amount)
    wantedLevels[playerId] = math.min(MAX_WANTED, (wantedLevels[playerId] or 0) + amount)
    TriggerClientEvent('ex11core:wantedUpdated', playerId, wantedLevels[playerId])
    return wantedLevels[playerId]
end

local function getWantedLevel(playerId)
    return wantedLevels[playerId] or 0
end

local function resetWantedLevel(playerId)
    wantedLevels[playerId] = 0
    TriggerClientEvent('ex11core:wantedUpdated', playerId, 0)
end

local function getAllWantedPlayers()
    local result = {}
    for playerId, level in pairs(wantedLevels) do
        if level > 0 then
            table.insert(result, { id = playerId, name = GetPlayerName(playerId), level = level })
        end
    end
    return result
end

-- 他resourceから呼び出せるようexportsで公開する(Tier3-06参照)
exports('AddWantedLevel', addWantedLevel)
exports('GetWantedLevel', getWantedLevel)
exports('ResetWantedLevel', resetWantedLevel)
exports('GetAllWantedPlayers', getAllWantedPlayers)
