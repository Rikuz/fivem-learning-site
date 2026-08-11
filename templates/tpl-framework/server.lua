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

    print(('^2[my-resource] 検出したフレームワーク: %s^0'):format(FRAMEWORK or '未検出'))
end)

-- 共通関数として、識別子・所持金の取得をフレームワークごとに吸収する
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

local function getMoney(playerId)
    if FRAMEWORK == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        return xPlayer and xPlayer.getMoney() or 0
    elseif FRAMEWORK == 'qbcore' and QBCore then
        local Player = QBCore.Functions.GetPlayer(playerId)
        return Player and Player.PlayerData.money['cash'] or 0
    end
    return 0
end

-- 使用例
RegisterCommand('mymoney', function(source)
    local playerId = source
    print(('所持金: $%d(識別子: %s)'):format(getMoney(playerId), getIdentifier(playerId)))
end, false)
