-- フレームワークからプレイヤーの現金所持額を取得する処理はTier4-01参照。ここでは概念を示すダミー実装にしている。
local playerCash = {} -- playerId -> 所持現金(デモ用の簡易管理)

local function getCash(playerId)
    playerCash[playerId] = playerCash[playerId] or 1000
    return playerCash[playerId]
end

local function getSociety(playerId)
    return GetPlayerIdentifierByType(playerId, 'license') -- 実際にはcitizenid等、導入環境に合わせる(Tier4-06参照)
end

RegisterNetEvent('ex06atm:transaction')
AddEventHandler('ex06atm:transaction', function(txType, amount)
    local playerId = source
    local society = getSociety(playerId)

    local account = exports['okokBanking']:GetAccount(society)
    if not account then
        TriggerClientEvent('okokNotify:Alert', playerId, 'ATM', '口座が見つかりません', 5000, 'error', true)
        return
    end

    if txType == 'deposit' then
        if getCash(playerId) < amount then
            TriggerClientEvent('okokNotify:Alert', playerId, 'ATM', '所持金が足りません', 5000, 'error', true)
            return
        end

        playerCash[playerId] = getCash(playerId) - amount
        exports['okokBanking']:AddMoney(society, amount)
        exports['okokBanking']:AddTransaction(society, { value = amount, type = 'deposit', reason = 'ATM入金' })

        TriggerClientEvent('okokNotify:Alert', playerId, 'ATM', ('$%sを入金しました'):format(amount), 5000, 'success', true)
    elseif txType == 'withdraw' then
        -- account.moneyのような残高フィールド名は導入しているokokBankingのバージョンによって異なる可能性があるため、
        -- 実際の導入時は公式ドキュメント・config.luaで正確なフィールド名を確認し、残高不足チェックを追加すること
        exports['okokBanking']:RemoveMoney(society, amount)
        playerCash[playerId] = getCash(playerId) + amount
        exports['okokBanking']:AddTransaction(society, { value = amount, type = 'withdraw', reason = 'ATM出金' })

        TriggerClientEvent('okokNotify:Alert', playerId, 'ATM', ('$%sを出金しました'):format(amount), 5000, 'success', true)
    end
end)
