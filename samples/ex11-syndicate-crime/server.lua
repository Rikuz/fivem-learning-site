local COOLDOWN_MS = 15000 -- Tier5-04のクールダウンの考え方
local playerCooldown = {}
local RAW_ITEM = 'ex11_raw_material'
local PRODUCT_ITEM = 'ex11_processed_drugs'

local function isOnCooldown(playerId)
    return playerCooldown[playerId] and GetGameTimer() < playerCooldown[playerId]
end

local function setCooldown(playerId)
    playerCooldown[playerId] = GetGameTimer() + COOLDOWN_MS
end

RegisterNetEvent('ex11crime:grow')
AddEventHandler('ex11crime:grow', function()
    local playerId = source
    if isOnCooldown(playerId) then return end
    setCooldown(playerId)

    -- ex-10と同じ栽培工程(70%成功)
    if math.random() > 0.7 then
        TriggerClientEvent('ex11crime:notify', playerId, '栽培に失敗しました')
        return
    end

    exports.ox_inventory:AddItem(playerId, RAW_ITEM, 1)
    -- 生産行為も指名手配度を上げる(コアのexport経由、Tier4-24参照)
    exports['ex11-syndicate-core']:AddWantedLevel(playerId, 5)

    TriggerClientEvent('ex11crime:notify', playerId, '生の原料を1個入手しました')
end)

RegisterNetEvent('ex11crime:refine')
AddEventHandler('ex11crime:refine', function()
    local playerId = source
    if isOnCooldown(playerId) then return end

    local RAW_REQUIRED = 3
    local count = exports.ox_inventory:GetItemCount(playerId, RAW_ITEM)
    if count < RAW_REQUIRED then
        TriggerClientEvent('ex11crime:notify', playerId, ('生の原料が足りません(必要: %d個)'):format(RAW_REQUIRED))
        return
    end
    setCooldown(playerId)

    exports.ox_inventory:RemoveItem(playerId, RAW_ITEM, RAW_REQUIRED)

    if math.random() > 0.8 then
        TriggerClientEvent('ex11crime:notify', playerId, '精製に失敗し、原料を失いました')
        return
    end

    exports.ox_inventory:AddItem(playerId, PRODUCT_ITEM, 1)
    exports['ex11-syndicate-core']:AddWantedLevel(playerId, 10)

    TriggerClientEvent('ex11crime:notify', playerId, '完成品を1個精製しました')
end)

RegisterNetEvent('ex11crime:sell')
AddEventHandler('ex11crime:sell', function()
    local playerId = source
    local count = exports.ox_inventory:GetItemCount(playerId, PRODUCT_ITEM)

    if count < 1 then
        TriggerClientEvent('ex11crime:notify', playerId, '売却できる完成品がありません')
        return
    end

    exports.ox_inventory:RemoveItem(playerId, PRODUCT_ITEM, 1)
    exports['ex11-syndicate-core']:AddWantedLevel(playerId, 15) -- 売却は最も指名手配度が上がる

    TriggerClientEvent('ex11crime:notify', playerId, '完成品を$300で売却しました')
end)
