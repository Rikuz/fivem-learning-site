RegisterCommand('syndicate_grow', function()
    local success = lib.progressBar({
        duration = 4000,
        label = '栽培しています...',
        canCancel = true,
        disable = { move = true, car = true },
    })

    if success then
        TriggerServerEvent('ex11crime:grow')
    end
end, false)

RegisterCommand('syndicate_refine', function()
    local success = lib.progressBar({
        duration = 5000,
        label = '精製しています...',
        canCancel = true,
        disable = { move = true, car = true },
    })

    if success then
        TriggerServerEvent('ex11crime:refine')
    end
end, false)

RegisterCommand('syndicate_sell', function()
    TriggerServerEvent('ex11crime:sell')
end, false)

RegisterNetEvent('ex11crime:notify')
AddEventHandler('ex11crime:notify', function(message)
    TriggerEvent('chat:addMessage', { args = { '[シンジケート]', message } })
end)
