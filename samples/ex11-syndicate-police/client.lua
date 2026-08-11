local isHandcuffed = false

RegisterNetEvent('ex11police:onHandcuffed')
AddEventHandler('ex11police:onHandcuffed', function(handcuffed)
    isHandcuffed = handcuffed
    local ped = PlayerPedId()

    if handcuffed then
        DisablePlayerFiring(ped, true)
    else
        DisablePlayerFiring(ped, false)
    end
end)

-- 拘束中は攻撃・狙う操作を無効化する(Tier4-29参照)
CreateThread(function()
    while true do
        Wait(0)
        if isHandcuffed then
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
        end
    end
end)

RegisterNetEvent('ex11police:jailed')
AddEventHandler('ex11police:jailed', function(minutes)
    TriggerEvent('chat:addMessage', { args = { '[警察]', ('投獄されました(%d分)'):format(minutes) } })
end)

RegisterNetEvent('ex11police:notify')
AddEventHandler('ex11police:notify', function(message)
    TriggerEvent('chat:addMessage', { args = { '[警察]', message } })
end)
