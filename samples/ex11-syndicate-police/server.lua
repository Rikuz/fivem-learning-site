local jailedPlayers = {} -- playerId -> releaseAt(GetGameTimer基準)

-- 証拠品保管庫を登録する(Tier3-37・Tier4-31参照)
CreateThread(function()
    exports.ox_inventory:RegisterStash('ex11_evidence_bag', '証拠品保管庫', 100, 500000, false, { police = 0 })
end)

-- MDT(簡易版): コアから指名手配度が高いプレイヤーの一覧を取得して表示する(Tier4-28参照)
RegisterCommand('mdtcheck', function(source)
    local playerId = source
    local wantedPlayers = exports['ex11-syndicate-core']:GetAllWantedPlayers()

    if #wantedPlayers == 0 then
        TriggerClientEvent('ex11police:notify', playerId, '現在指名手配中のプレイヤーはいません')
        return
    end

    for _, p in ipairs(wantedPlayers) do
        TriggerClientEvent('ex11police:notify', playerId, ('[%d] %s — 指名手配度: %d'):format(p.id, p.name, p.level))
    end
end, false)

RegisterCommand('arrest', function(source, args)
    local officerId = source
    local targetId = tonumber(args[1])
    if not targetId then return end

    local officerPed = GetPlayerPed(officerId)
    local targetPed = GetPlayerPed(targetId)
    if targetPed == 0 then return end

    local distance = #(GetEntityCoords(officerPed) - GetEntityCoords(targetPed))
    if distance > 3.0 then
        TriggerClientEvent('ex11police:notify', officerId, '対象に近づいてください')
        return
    end

    -- 押収: 所持している薬物をevidence bagに移す(Tier4-31参照)
    -- ※スタッシュへの直接AddItemはox_inventoryのバージョンによって挙動が変わる可能性があるため、
    --   導入時は必ず動作確認と公式ドキュメントの確認を行うこと
    local drugCount = exports.ox_inventory:GetItemCount(targetId, 'ex11_processed_drugs')
    if drugCount > 0 then
        exports.ox_inventory:RemoveItem(targetId, 'ex11_processed_drugs', drugCount)
        exports.ox_inventory:AddItem('ex11_evidence_bag', 'ex11_processed_drugs', drugCount)
    end

    -- 拘束状態をStateBagsで同期する(Tier5-03・Tier4-29参照)
    Player(targetId).state:set('isHandcuffed', true, true)
    TriggerClientEvent('ex11police:onHandcuffed', targetId, true)

    -- 投獄する(Tier4-30参照): 5分後に自動釈放する
    local releaseAt = GetGameTimer() + (5 * 60 * 1000)
    jailedPlayers[targetId] = releaseAt

    TriggerClientEvent('ex11police:jailed', targetId, 5)
    TriggerClientEvent('ex11police:notify', officerId, ('%sを逮捕し、押収品%d個を確保しました'):format(GetPlayerName(targetId), drugCount))
end, false)

-- 投獄完了(時間経過での自動釈放)を定期的にチェックする(Tier4-30参照)
CreateThread(function()
    while true do
        Wait(30000)

        for playerId, releaseAt in pairs(jailedPlayers) do
            if GetGameTimer() >= releaseAt then
                jailedPlayers[playerId] = nil
                Player(playerId).state:set('isHandcuffed', false, true)
                TriggerClientEvent('ex11police:onHandcuffed', playerId, false)

                -- 投獄完了で指名手配度をリセットする(コアのexport経由)
                exports['ex11-syndicate-core']:ResetWantedLevel(playerId)
                TriggerClientEvent('ex11police:notify', playerId, '釈放されました。指名手配度がリセットされました')
            end
        end
    end
end)
