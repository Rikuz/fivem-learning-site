local STASH_ID = 'shared_warehouse_01'
local STASH_COORDS = vec3(150.0, 250.0, 30.0)

exports.ox_target:addBoxZone({
    coords = STASH_COORDS,
    size = vec3(2.0, 2.0, 2.0),
    options = {
        {
            name = 'open_stash',
            icon = 'fa-solid fa-box-open',
            label = '倉庫を開ける',
            onSelect = function()
                TriggerServerEvent('ex04stash:requestOpen', STASH_ID)
            end,
        },
    }
})

RegisterNetEvent('ex04stash:showContents')
AddEventHandler('ex04stash:showContents', function(items)
    if #items == 0 then
        TriggerEvent('chat:addMessage', { args = { '[倉庫]', '中身は空です' } })
        return
    end

    for _, item in ipairs(items) do
        TriggerEvent('chat:addMessage', { args = { '[倉庫]', ('%s x%d'):format(item.item_name, item.amount) } })
    end
end)

RegisterCommand('stashdeposit', function(source, args)
    local itemName = args[1]
    local amount = tonumber(args[2])
    if not itemName or not amount then
        TriggerEvent('chat:addMessage', { args = { '[倉庫]', '使い方: /stashdeposit [アイテム名] [個数]' } })
        return
    end
    TriggerServerEvent('ex04stash:deposit', STASH_ID, itemName, amount)
end, false)

RegisterCommand('stashwithdraw', function(source, args)
    local itemName = args[1]
    local amount = tonumber(args[2])
    if not itemName or not amount then
        TriggerEvent('chat:addMessage', { args = { '[倉庫]', '使い方: /stashwithdraw [アイテム名] [個数]' } })
        return
    end
    TriggerServerEvent('ex04stash:withdraw', STASH_ID, itemName, amount)
end, false)

-- デバッグ用: 所持アイテムを追加する(ox_inventory等が無い環境での動作確認用)
RegisterCommand('stashgiveitem', function(source, args)
    TriggerServerEvent('ex04stash:debugGiveItem', args[1], tonumber(args[2]))
end, false)
