-- 常駐HUD: SetNuiFocusは一切呼ばず、resource起動時からずっと表示され続ける(Tier3-39参照)

CreateThread(function()
    -- ミニマップをHUDのレイアウトに合わせて調整する(Tier3-40参照)
    SetMinimapComponentPosition('minimap', 'L', 'B', 0.0, -0.047, 0.1638, 0.183)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.020, 0.020, 0.128, 0.20)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.008, 0.010, 0.170, 0.240)
end)

-- 速度計は乗車中のみ表示・更新する(Tier3-40参照)
CreateThread(function()
    while true do
        Wait(200)

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 then
            local speedKmh = math.floor(GetEntitySpeed(vehicle) * 3.6)
            SendNUIMessage({ action = 'updateSpeed', visible = true, speed = speedKmh })
        else
            SendNUIMessage({ action = 'updateSpeed', visible = false })
        end
    end
end)

-- getHunger/ThirstValueは、導入しているフレームワークに合わせて実装する想定の関数(Tier4-01参照)
-- ここでは概念を示すため、固定値を返すダミー実装にしている
local function getHungerValue()
    return 80
end

local function getThirstValue()
    return 65
end

-- 体力は変化が早いため、上記の速度計より短くはないが十分な頻度で更新する(Tier3-41参照)
CreateThread(function()
    while true do
        Wait(1000)

        local ped = PlayerPedId()
        SendNUIMessage({
            action = 'updateStatusBars',
            health = GetEntityHealth(ped) - 100, -- GetEntityHealthの最低値100を補正する
            hunger = getHungerValue(),
            thirst = getThirstValue(),
        })
    end
end)
