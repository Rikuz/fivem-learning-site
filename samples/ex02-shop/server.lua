local SHOP_ITEMS = {
    { name = 'water', label = 'ミネラルウォーター', price = 10 },
    { name = 'bread', label = 'パン', price = 25 },
    { name = 'phone', label = '携帯電話', price = 500 },
}

local playerMoney = {} -- playerId -> 所持金(メモリ上の簡易管理。DB連携はTier3-03以降で扱う)

local function getMoney(playerId)
    if not playerMoney[playerId] then
        playerMoney[playerId] = 1000 -- 初期所持金
    end
    return playerMoney[playerId]
end

local function findItem(name)
    for _, item in ipairs(SHOP_ITEMS) do
        if item.name == name then return item end
    end
    return nil
end

RegisterNetEvent('ex02shop:requestOpen')
AddEventHandler('ex02shop:requestOpen', function()
    local playerId = source
    TriggerClientEvent('ex02shop:open', playerId, SHOP_ITEMS, getMoney(playerId))
end)

RegisterNetEvent('ex02shop:purchase')
AddEventHandler('ex02shop:purchase', function(itemName)
    local playerId = source
    local item = findItem(itemName)

    if not item then
        TriggerClientEvent('ex02shop:purchaseResult', playerId, false, '存在しない商品です', getMoney(playerId))
        return
    end

    local money = getMoney(playerId)
    if money < item.price then
        TriggerClientEvent('ex02shop:purchaseResult', playerId, false, '所持金が足りません', money)
        return
    end

    playerMoney[playerId] = money - item.price
    TriggerClientEvent('ex02shop:purchaseResult', playerId, true, ('%sを購入しました'):format(item.label), playerMoney[playerId])
end)
