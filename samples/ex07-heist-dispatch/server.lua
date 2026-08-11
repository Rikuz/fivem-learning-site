local WEBHOOK_URL = 'https://discord.com/api/webhooks/xxxxx/yyyyy' -- 実際のWebhook URLに置き換える

-- 重要操作をDiscord Webhookでログ収集する(Tier3-22参照)
local function logToDiscord(title, description)
    local payload = json.encode({
        embeds = { { title = title, description = description, color = 15158332 } }
    })

    PerformHttpRequest(WEBHOOK_URL, function() end, 'POST', payload, {
        ['Content-Type'] = 'application/json'
    })
end

-- doorBreachedのStateBags変化を検知したら警察に通報し、Discordにログを送る(Tier5-03・Tier4-16参照)
-- StateBagsはFiveMエンジン全体で共有される仕組みのため、どのresourceがsetしたかに関わらず検知できる
AddStateBagChangeHandler('doorBreached', '', function(bagName, key, value)
    if value ~= true then return end

    -- StateBagのbagNameは "player:<serverId>" の形式なので、そこからサーバーIDを取り出す
    local serverId = tonumber(bagName:match('player:(%d+)'))
    if not serverId then return end

    local ped = GetPlayerPed(serverId)
    local coords = GetEntityCoords(ped)

    TriggerEvent('cd_dispatch:AddNotification', {
        job_table = { 'police' },
        coords = coords,
        title = '10-90 - 強盗事件',
        message = '金庫室のドアが破られました',
        flash = 0,
        unique_id = tostring(math.random(0, 100000)),
    })

    logToDiscord('強盗が開始されました', ('プレイヤー: %s\n座標: %s'):format(GetPlayerName(serverId), tostring(coords)))
end)
