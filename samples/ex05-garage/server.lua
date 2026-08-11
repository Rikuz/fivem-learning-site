-- フレームワーク検知(Tier4-01参照)
local function detectFramework()
    if GetResourceState('es_extended') == 'started' then
        return 'esx'
    elseif GetResourceState('qbx_core') == 'started' then
        return 'qbox'
    elseif GetResourceState('qb-core') == 'started' then
        return 'qbcore'
    end
    return nil
end

local FRAMEWORK = detectFramework()
local ESX, QBCore

CreateThread(function()
    if FRAMEWORK == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
    elseif FRAMEWORK == 'qbcore' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

local function getIdentifier(playerId)
    if FRAMEWORK == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        return xPlayer and xPlayer.identifier
    elseif FRAMEWORK == 'qbcore' and QBCore then
        local Player = QBCore.Functions.GetPlayer(playerId)
        return Player and Player.PlayerData.citizenid
    end
    return GetPlayerIdentifierByType(playerId, 'license') -- フレームワーク未検出時のフォールバック
end

RegisterNetEvent('ex05garage:requestVehicles')
AddEventHandler('ex05garage:requestVehicles', function(garageName)
    local playerId = source
    local identifier = getIdentifier(playerId)

    local vehicles = MySQL.query.await(
        'SELECT * FROM ex05_owned_vehicles WHERE identifier = ? AND garage = ? AND stored = 1',
        { identifier, garageName }
    )

    TriggerClientEvent('ex05garage:showVehicles', playerId, vehicles or {})
end)

RegisterNetEvent('ex05garage:takeOut')
AddEventHandler('ex05garage:takeOut', function(plate)
    local playerId = source
    local identifier = getIdentifier(playerId)

    local vehicle = MySQL.single.await('SELECT * FROM ex05_owned_vehicles WHERE identifier = ? AND plate = ?', { identifier, plate })

    -- 既に出庫中の車両を二重に出庫できないよう、storedフラグを必ず確認する
    if not vehicle or vehicle.stored ~= 1 then
        TriggerClientEvent('ex05garage:notify', playerId, 'この車両は出庫できません')
        return
    end

    MySQL.update('UPDATE ex05_owned_vehicles SET stored = 0 WHERE id = ?', { vehicle.id })
    TriggerClientEvent('ex05garage:spawnVehicle', playerId, vehicle)
end)

RegisterNetEvent('ex05garage:store')
AddEventHandler('ex05garage:store', function(plate, fuel, engineHealth, bodyHealth)
    local playerId = source
    local identifier = getIdentifier(playerId)

    MySQL.update(
        'UPDATE ex05_owned_vehicles SET stored = 1, fuel = ?, engine_health = ?, body_health = ? WHERE identifier = ? AND plate = ?',
        { fuel, engineHealth, bodyHealth, identifier, plate }
    )

    TriggerClientEvent('ex05garage:notify', playerId, '車両を格納しました')
end)

-- デバッグ用: オーナーシップ登録画面を作る代わりに、コマンドで所有車両を直接登録する
RegisterNetEvent('ex05garage:debugRegisterVehicle')
AddEventHandler('ex05garage:debugRegisterVehicle', function(model, plate, garageName)
    local playerId = source
    local identifier = getIdentifier(playerId)

    MySQL.insert('INSERT INTO ex05_owned_vehicles (identifier, model, plate, garage) VALUES (?, ?, ?, ?)', {
        identifier, model, plate, garageName
    })

    TriggerClientEvent('ex05garage:notify', playerId, ('%sを所有車両として登録しました'):format(plate))
end)
