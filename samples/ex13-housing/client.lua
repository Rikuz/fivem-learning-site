local PROPERTY_ID = 'house_01'
local PROPERTY_COORDS = vec3(250.0, 400.0, 110.0)
local DOOR_ID = 'ex13_house_01_door' -- ox_doorlockの/doorlockコマンドで事前に登録しておく前提(Tier4-14参照)

-- 収納の登録(Tier3-37参照): resource起動時に1度だけ登録しておく
CreateThread(function()
    exports.ox_inventory:RegisterStash('ex13_stash_' .. PROPERTY_ID, '自宅の収納', 40, 80000)
end)

exports.ox_target:addBoxZone({
    coords = PROPERTY_COORDS,
    size = vec3(2.0, 2.0, 2.5),
    options = {
        {
            name = 'purchase_property',
            icon = 'fa-solid fa-house',
            label = '物件を購入する',
            onSelect = function()
                TriggerServerEvent('ex13housing:purchase', PROPERTY_ID)
            end,
        },
        {
            name = 'sell_property',
            icon = 'fa-solid fa-house-circle-xmark',
            label = '物件を転売する',
            onSelect = function()
                TriggerServerEvent('ex13housing:sell', PROPERTY_ID)
            end,
        },
        {
            name = 'enter_property',
            icon = 'fa-solid fa-door-open',
            label = '中に入る',
            onSelect = function()
                TriggerServerEvent('ex13housing:requestEnter', PROPERTY_ID)
            end,
        },
        {
            name = 'open_stash',
            icon = 'fa-solid fa-box',
            label = '収納を開ける',
            onSelect = function()
                TriggerServerEvent('ex13housing:requestOpenStash', PROPERTY_ID)
            end,
        },
        {
            name = 'toggle_door',
            icon = 'fa-solid fa-lock',
            label = '施錠/解錠を切り替える',
            onSelect = function()
                TriggerServerEvent('ex13housing:requestToggleDoor', PROPERTY_ID)
            end,
        },
    }
})

-- 所有者であることがserver側で確認された場合のみ、実際にドアの状態を切り替える(Tier4-14参照)
RegisterNetEvent('ex13housing:toggleDoor')
AddEventHandler('ex13housing:toggleDoor', function()
    local door = exports.ox_doorlock:getDoor(DOOR_ID)
    if not door then return end

    exports.ox_doorlock:setDoorState(DOOR_ID, not door.state)
end)

RegisterNetEvent('ex13housing:loadFurniture')
AddEventHandler('ex13housing:loadFurniture', function(furnitureList)
    for _, item in ipairs(furnitureList) do
        RequestModel(item.model)
        while not HasModelLoaded(item.model) do Wait(0) end

        local obj = CreateObject(item.model, item.x, item.y, item.z, false, false, false)
        SetEntityHeading(obj, item.heading)
        FreezeEntityPosition(obj, true)
        SetModelAsNoLongerNeeded(item.model)
    end

    TriggerEvent('chat:addMessage', { args = { '[住居]', ('家具%d個を復元しました'):format(#furnitureList) } })
end)

-- 家具設置(Tier4-35のプレビュー方式を簡略化: コマンド実行位置にそのまま設置する)
RegisterCommand('placefurniture', function(source, args)
    local model = args[1]
    if not model then return end

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(obj, heading)
    FreezeEntityPosition(obj, true)
    SetModelAsNoLongerNeeded(model)

    TriggerServerEvent('ex13housing:saveFurniture', PROPERTY_ID, model, coords.x, coords.y, coords.z, heading)
end, false)

RegisterNetEvent('ex13housing:openStash')
AddEventHandler('ex13housing:openStash', function(stashId)
    exports.ox_inventory:openInventory('stash', { id = stashId })
end)

RegisterNetEvent('ex13housing:notify')
AddEventHandler('ex13housing:notify', function(message)
    TriggerEvent('chat:addMessage', { args = { '[住居]', message } })
end)
