local WEBHOOK_URL = 'https://discord.com/api/webhooks/xxxxx/yyyyy' -- 実際のWebhook URLに置き換える

-- 権限レベルの入れ子構造(Tier3-42参照)
local PERMISSION_LEVELS = { moderator = 1, admin = 2, developer = 3 }

local function getPermissionLevel(playerId)
    if IsPlayerAceAllowed(playerId, 'group.developer') then return PERMISSION_LEVELS.developer end
    if IsPlayerAceAllowed(playerId, 'group.admin') then return PERMISSION_LEVELS.admin end
    if IsPlayerAceAllowed(playerId, 'group.moderator') then return PERMISSION_LEVELS.moderator end
    return 0
end

local function hasPermission(playerId, requiredLevel)
    return getPermissionLevel(playerId) >= PERMISSION_LEVELS[requiredLevel]
end

-- 重要操作をDiscord Webhookでログ収集する(Tier3-22参照)
local function logToDiscord(title, description)
    local payload = json.encode({
        embeds = { { title = title, description = description, color = 15158332 } }
    })

    PerformHttpRequest(WEBHOOK_URL, function() end, 'POST', payload, {
        ['Content-Type'] = 'application/json'
    })
end

-- 通報一覧はTier3-21と同じくメモリ上のテーブルで簡易管理する
local reports = {}

RegisterCommand('adminreport', function(source, args)
    local playerId = source
    local message = table.concat(args, ' ')

    reports[#reports + 1] = { reporter = GetPlayerName(playerId), message = message }
    TriggerClientEvent('chat:addMessage', playerId, { args = { '[通報]', '通報を受け付けました' } })
end, false)

RegisterCommand('adminpanel', function(source)
    local playerId = source
    local level = getPermissionLevel(playerId)

    if level < PERMISSION_LEVELS.moderator then
        TriggerClientEvent('chat:addMessage', playerId, { args = { '[管理者]', '権限がありません' } })
        return
    end

    local playerList = {}
    for _, targetId in ipairs(GetPlayers()) do
        table.insert(playerList, { id = tonumber(targetId), name = GetPlayerName(targetId) })
    end

    TriggerClientEvent('ex15admin:open', playerId, level, playerList, reports)
end, false)

RegisterNetEvent('ex15admin:spectate')
AddEventHandler('ex15admin:spectate', function(targetServerId)
    local playerId = source
    if not hasPermission(playerId, 'moderator') then return end

    TriggerClientEvent('ex15admin:doSpectate', playerId, targetServerId)
end)

RegisterNetEvent('ex15admin:kick')
AddEventHandler('ex15admin:kick', function(targetServerId, reason)
    local playerId = source
    if not hasPermission(playerId, 'admin') then return end -- キックはadmin以上のみ実行可能(Tier4-07参照)

    local targetId = tonumber(targetServerId)
    local targetName = GetPlayerName(targetId)

    -- 実行前に証拠としてスクリーンショットを取得する(Tier4-11参照)
    exports['screenshot-basic']:requestClientScreenshot(targetId, { encoding = 'jpg', quality = 0.8 }, function(err, data)
        logToDiscord('プレイヤーがキックされました', ('対象: %s\n理由: %s\n実行者: %s'):format(targetName, reason or '理由未記載', GetPlayerName(playerId)))
    end)

    DropPlayer(targetId, ('管理者によってキックされました: %s'):format(reason or '理由未記載'))
end)

RegisterNetEvent('ex15admin:ban')
AddEventHandler('ex15admin:ban', function(targetServerId, reason)
    local playerId = source
    if not hasPermission(playerId, 'admin') then return end -- BANもadmin以上のみ実行可能

    local targetId = tonumber(targetServerId)
    local targetName = GetPlayerName(targetId)

    -- 実際にはBANリストへの永続化(DB保存、Tier4-07参照)が必要。ここではキックのみのデモ実装。
    exports['screenshot-basic']:requestClientScreenshot(targetId, { encoding = 'jpg', quality = 0.8 }, function(err, data)
        logToDiscord('プレイヤーがBANされました', ('対象: %s\n理由: %s\n実行者: %s'):format(targetName, reason or '理由未記載', GetPlayerName(playerId)))
    end)

    DropPlayer(targetId, ('管理者によってBANされました: %s'):format(reason or '理由未記載'))
end)
