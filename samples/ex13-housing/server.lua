-- resource起動時にテーブルを作成する(このサンプルでは.sqlファイルを分けず、ここでまとめて定義する)
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `ex13_properties` (
            `id` VARCHAR(50) PRIMARY KEY,
            `label` VARCHAR(100) NOT NULL,
            `x` FLOAT NOT NULL,
            `y` FLOAT NOT NULL,
            `z` FLOAT NOT NULL,
            `price` INT NOT NULL,
            `door_id` VARCHAR(50) NOT NULL
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `ex13_property_owners` (
            `property_id` VARCHAR(50) PRIMARY KEY,
            `owner_identifier` VARCHAR(64) NOT NULL
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `ex13_furniture` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `property_id` VARCHAR(50) NOT NULL,
            `model` VARCHAR(50) NOT NULL,
            `x` FLOAT NOT NULL,
            `y` FLOAT NOT NULL,
            `z` FLOAT NOT NULL,
            `heading` FLOAT NOT NULL
        )
    ]])

    -- サンプル物件を1件登録する(実際には複数物件を管理する設計にする)
    MySQL.query('INSERT IGNORE INTO ex13_properties (id, label, x, y, z, price, door_id) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        'house_01', 'サンプル物件1号', 250.0, 400.0, 110.0, 50000, 'ex13_house_01_door'
    })
end)

local function getIdentifier(playerId)
    return GetPlayerIdentifierByType(playerId, 'license')
end

-- 所有権の確認(Tier4-34参照): 家具設置・施錠・収納など、この後のあらゆる機能で繰り返し使う
local function isOwner(playerId, propertyId)
    local identifier = getIdentifier(playerId)
    local owner = MySQL.scalar.await('SELECT owner_identifier FROM ex13_property_owners WHERE property_id = ?', { propertyId })
    return owner == identifier
end

RegisterNetEvent('ex13housing:purchase')
AddEventHandler('ex13housing:purchase', function(propertyId)
    local playerId = source
    local property = MySQL.single.await('SELECT * FROM ex13_properties WHERE id = ?', { propertyId })
    if not property then return end

    local existingOwner = MySQL.scalar.await('SELECT owner_identifier FROM ex13_property_owners WHERE property_id = ?', { propertyId })
    if existingOwner then
        TriggerClientEvent('ex13housing:notify', playerId, 'この物件は既に売却済みです')
        return
    end

    -- 所持金の確認・減算は実際にはフレームワークAPI経由で行う(Tier4-01参照)
    MySQL.insert('INSERT INTO ex13_property_owners (property_id, owner_identifier) VALUES (?, ?)', {
        propertyId, getIdentifier(playerId)
    })

    TriggerClientEvent('ex13housing:notify', playerId, ('%sを購入しました'):format(property.label))
end)

RegisterNetEvent('ex13housing:sell')
AddEventHandler('ex13housing:sell', function(propertyId)
    local playerId = source
    if not isOwner(playerId, propertyId) then return end

    local property = MySQL.single.await('SELECT * FROM ex13_properties WHERE id = ?', { propertyId })
    local refund = math.floor(property.price * 0.7) -- 転売価格は購入価格の70%(下取りロスを設ける)

    MySQL.query('DELETE FROM ex13_property_owners WHERE property_id = ?', { propertyId })
    MySQL.query('DELETE FROM ex13_furniture WHERE property_id = ?', { propertyId })

    TriggerClientEvent('ex13housing:notify', playerId, ('%sを$%sで転売しました'):format(property.label, refund))
end)

RegisterNetEvent('ex13housing:requestEnter')
AddEventHandler('ex13housing:requestEnter', function(propertyId)
    local playerId = source
    if not isOwner(playerId, propertyId) then
        TriggerClientEvent('ex13housing:notify', playerId, 'この物件の所有者ではありません')
        return
    end

    local furniture = MySQL.query.await('SELECT model, x, y, z, heading FROM ex13_furniture WHERE property_id = ?', { propertyId })
    TriggerClientEvent('ex13housing:loadFurniture', playerId, furniture or {})
end)

RegisterNetEvent('ex13housing:saveFurniture')
AddEventHandler('ex13housing:saveFurniture', function(propertyId, model, x, y, z, heading)
    local playerId = source
    if not isOwner(playerId, propertyId) then return end

    MySQL.insert('INSERT INTO ex13_furniture (property_id, model, x, y, z, heading) VALUES (?, ?, ?, ?, ?, ?)', {
        propertyId, model, x, y, z, heading
    })
end)

RegisterNetEvent('ex13housing:requestOpenStash')
AddEventHandler('ex13housing:requestOpenStash', function(propertyId)
    local playerId = source
    if not isOwner(playerId, propertyId) then
        TriggerClientEvent('ex13housing:notify', playerId, 'この物件の所有者ではありません')
        return
    end

    TriggerClientEvent('ex13housing:openStash', playerId, 'ex13_stash_' .. propertyId)
end)

RegisterNetEvent('ex13housing:requestToggleDoor')
AddEventHandler('ex13housing:requestToggleDoor', function(propertyId)
    local playerId = source
    if not isOwner(playerId, propertyId) then
        TriggerClientEvent('ex13housing:notify', playerId, 'この物件の所有者ではありません')
        return
    end

    TriggerClientEvent('ex13housing:toggleDoor', playerId)
end)
