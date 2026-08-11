-- プレイヤーの所持数は簡易的にメモリ上のテーブルで管理する(実運用ではox_inventory等と連携する、Tier3-04参照)
local playerInventory = {} -- playerId -> { [itemName] = amount }

local function getPlayerItemCount(playerId, itemName)
    return (playerInventory[playerId] and playerInventory[playerId][itemName]) or 0
end

local function addPlayerItem(playerId, itemName, amount)
    playerInventory[playerId] = playerInventory[playerId] or {}
    playerInventory[playerId][itemName] = getPlayerItemCount(playerId, itemName) + amount
end

local function removePlayerItem(playerId, itemName, amount)
    playerInventory[playerId][itemName] = getPlayerItemCount(playerId, itemName) - amount
end

RegisterNetEvent('ex04stash:requestOpen')
AddEventHandler('ex04stash:requestOpen', function(stashId)
    local playerId = source
    local items = MySQL.query.await('SELECT item_name, amount FROM ex04_stash_items WHERE stash_id = ?', { stashId })
    TriggerClientEvent('ex04stash:showContents', playerId, items or {})
end)

RegisterNetEvent('ex04stash:deposit')
AddEventHandler('ex04stash:deposit', function(stashId, itemName, amount)
    local playerId = source

    if not itemName or not amount or amount < 1 or getPlayerItemCount(playerId, itemName) < amount then
        TriggerClientEvent('chat:addMessage', playerId, { args = { '[倉庫]', '所持数が足りません' } })
        return
    end

    removePlayerItem(playerId, itemName, amount)

    MySQL.query([[
        INSERT INTO ex04_stash_items (stash_id, item_name, amount) VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE amount = amount + VALUES(amount)
    ]], { stashId, itemName, amount })

    TriggerClientEvent('chat:addMessage', playerId, { args = { '[倉庫]', ('%sを%d個預けました'):format(itemName, amount) } })
end)

RegisterNetEvent('ex04stash:withdraw')
AddEventHandler('ex04stash:withdraw', function(stashId, itemName, amount)
    local playerId = source

    if not itemName or not amount or amount < 1 then return end

    local current = MySQL.scalar.await('SELECT amount FROM ex04_stash_items WHERE stash_id = ? AND item_name = ?', { stashId, itemName })
    if not current or current < amount then
        TriggerClientEvent('chat:addMessage', playerId, { args = { '[倉庫]', '倉庫の在庫が足りません' } })
        return
    end

    MySQL.query('UPDATE ex04_stash_items SET amount = amount - ? WHERE stash_id = ? AND item_name = ?', { amount, stashId, itemName })
    addPlayerItem(playerId, itemName, amount)

    TriggerClientEvent('chat:addMessage', playerId, { args = { '[倉庫]', ('%sを%d個引き出しました'):format(itemName, amount) } })
end)

-- デバッグ用: ox_inventory等が無い環境でも預け入れを試せるよう、所持アイテムを直接付与する
RegisterNetEvent('ex04stash:debugGiveItem')
AddEventHandler('ex04stash:debugGiveItem', function(itemName, amount)
    local playerId = source
    if not itemName or not amount then return end

    addPlayerItem(playerId, itemName, amount)
    TriggerClientEvent('chat:addMessage', playerId, { args = { '[倉庫]', ('%sを%d個所持しました(デバッグ)'):format(itemName, amount) } })
end)
