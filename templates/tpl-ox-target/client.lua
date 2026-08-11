-- 座標範囲でのインタラクション登録(Tier3-07参照)
exports.ox_target:addBoxZone({
    coords = vec3(0.0, 0.0, 0.0), -- 実際の座標に置き換える
    size = vec3(2.0, 2.0, 2.0),
    options = {
        {
            name = 'my_interaction',
            icon = 'fa-solid fa-hand-pointer',
            label = 'インタラクションのラベル',
            onSelect = function()
                TriggerServerEvent('my-resource:onInteract')
            end,
        },
    }
})

-- 特定モデルへのインタラクション登録(そのモデルの全エンティティに反映される)
exports.ox_target:addModel('prop_atm_01', {
    {
        name = 'my_model_interaction',
        icon = 'fa-solid fa-hand-pointer',
        label = 'モデル向けインタラクション',
        onSelect = function(data)
            print('選択したエンティティ:', data.entity)
        end,
    }
})

RegisterNetEvent('my-resource:onInteract')
AddEventHandler('my-resource:onInteract', function()
    TriggerEvent('chat:addMessage', { args = { '[テンプレート]', 'インタラクションが実行されました' } })
end)
