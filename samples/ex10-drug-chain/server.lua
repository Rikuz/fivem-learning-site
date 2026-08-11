local COOLDOWN_MS = 15000 -- 各工程共通のクールダウン(Tier5-04の考え方)

local playerInventory = {} -- playerId -> { raw = n, product = n }
local playerCooldown = {} -- playerId -> 次回実行可能時刻(GetGameTimer基準)
local playerMoney = {} -- playerId -> 所持金(デモ用の簡易管理)

local function getInv(playerId)
    playerInventory[playerId] = playerInventory[playerId] or { raw = 0, product = 0 }
    return playerInventory[playerId]
end

local function getMoney(playerId)
    playerMoney[playerId] = playerMoney[playerId] or 0
    return playerMoney[playerId]
end

local function isOnCooldown(playerId)
    return playerCooldown[playerId] and GetGameTimer() < playerCooldown[playerId]
end

local function setCooldown(playerId)
    playerCooldown[playerId] = GetGameTimer() + COOLDOWN_MS
end

RegisterNetEvent('ex10drugchain:grow')
AddEventHandler('ex10drugchain:grow', function()
    local playerId = source

    if isOnCooldown(playerId) then
        TriggerClientEvent('ex10drugchain:notify', playerId, 'まだ休憩が必要です')
        return
    end
    setCooldown(playerId)

    -- 70%の確率で成功する(失敗すると何も得られない)
    if math.random() > 0.7 then
        TriggerClientEvent('ex10drugchain:notify', playerId, '栽培に失敗しました')
        return
    end

    local inv = getInv(playerId)
    inv.raw = inv.raw + 1
    TriggerClientEvent('ex10drugchain:notify', playerId, ('生の原料を1個入手しました(所持: %d個)'):format(inv.raw))
end)

RegisterNetEvent('ex10drugchain:refine')
AddEventHandler('ex10drugchain:refine', function()
    local playerId = source

    if isOnCooldown(playerId) then
        TriggerClientEvent('ex10drugchain:notify', playerId, 'まだ休憩が必要です')
        return
    end

    local inv = getInv(playerId)
    local RAW_REQUIRED = 3

    if inv.raw < RAW_REQUIRED then
        TriggerClientEvent('ex10drugchain:notify', playerId, ('生の原料が足りません(必要: %d個)'):format(RAW_REQUIRED))
        return
    end
    setCooldown(playerId)

    -- 精製工程は「原料を消費してから成否を判定する」ことで失敗のリスクを持たせる
    inv.raw = inv.raw - RAW_REQUIRED

    if math.random() > 0.8 then
        TriggerClientEvent('ex10drugchain:notify', playerId, '精製に失敗し、原料を失いました')
        return
    end

    inv.product = inv.product + 1
    TriggerClientEvent('ex10drugchain:notify', playerId, ('完成品を1個精製しました(所持: %d個)'):format(inv.product))
end)

RegisterNetEvent('ex10drugchain:sell')
AddEventHandler('ex10drugchain:sell', function()
    local playerId = source
    local inv = getInv(playerId)

    -- 精製をスキップして売却はできない(完成品を持っていなければ売れない)
    if inv.product < 1 then
        TriggerClientEvent('ex10drugchain:notify', playerId, '売却できる完成品がありません')
        return
    end

    local PRICE_PER_UNIT = 300
    inv.product = inv.product - 1
    playerMoney[playerId] = getMoney(playerId) + PRICE_PER_UNIT

    TriggerClientEvent('ex10drugchain:notify', playerId, ('完成品を$%sで売却しました(所持金: $%s)'):format(PRICE_PER_UNIT, getMoney(playerId)))
end)
