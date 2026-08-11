-- 他プレイヤーのStateBagsの変化を監視する(Tier5-03参照)
AddStateBagChangeHandler('myStatus', '', function(bagName, key, value, reserved, replicated)
    print(('%sのmyStatusが%sに変わりました'):format(bagName, tostring(value)))
end)

-- 自分自身の状態を確認する
RegisterCommand('mystatus', function()
    local status = LocalPlayer.state.myStatus
    print('自分の状態:', status or '未設定')
end, false)

-- 特定エンティティの状態を確認する例
local function getEntityStatus(entity)
    return Entity(entity).state.myStatus
end
