local GROW_COORDS = vec3(500.0, -500.0, 30.0)
local REFINE_COORDS = vec3(520.0, -500.0, 30.0)
local SELL_COORDS = vec3(540.0, -500.0, 30.0)
local INTERACT_DISTANCE = 3.0

local function isNear(coords)
    return #(GetEntityCoords(PlayerPedId()) - coords) <= INTERACT_DISTANCE
end

RegisterCommand('drug_grow', function()
    if not isNear(GROW_COORDS) then
        TriggerEvent('chat:addMessage', { args = { '[生産]', '栽培エリアに近づいてください' } })
        return
    end

    local success = lib.progressBar({
        duration = 4000,
        label = '栽培しています...',
        canCancel = true,
        disable = { move = true, car = true },
    })

    -- プログレスバーが完了した場合のみサーバーにリクエストする
    if success then
        TriggerServerEvent('ex10drugchain:grow')
    end
end, false)

RegisterCommand('drug_refine', function()
    if not isNear(REFINE_COORDS) then
        TriggerEvent('chat:addMessage', { args = { '[生産]', '精製エリアに近づいてください' } })
        return
    end

    local success = lib.progressBar({
        duration = 5000,
        label = '精製しています...',
        canCancel = true,
        disable = { move = true, car = true },
    })

    if success then
        TriggerServerEvent('ex10drugchain:refine')
    end
end, false)

RegisterCommand('drug_sell', function()
    if not isNear(SELL_COORDS) then
        TriggerEvent('chat:addMessage', { args = { '[生産]', '販売エリアに近づいてください' } })
        return
    end

    TriggerServerEvent('ex10drugchain:sell')
end, false)

RegisterNetEvent('ex10drugchain:notify')
AddEventHandler('ex10drugchain:notify', function(message)
    TriggerEvent('chat:addMessage', { args = { '[生産]', message } })
end)
