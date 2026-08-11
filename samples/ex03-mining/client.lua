local isMining = false

RegisterCommand('mine', function()
    if isMining then return end
    isMining = true

    local ped = PlayerPedId()
    local dict = 'mini@repair'
    local anim = 'fixing_a_ped'

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 1, 0, false, false, false)

    local success = lib.progressBar({
        duration = 5000,
        label = '採掘しています...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true },
    })

    ClearPedTasks(ped)
    isMining = false

    -- プログレスバーが完了した場合のみサーバーにリクエストする(キャンセル時は何もしない)
    if success then
        TriggerServerEvent('ex03mining:requestResult')
    end
end, false)

RegisterNetEvent('ex03mining:result')
AddEventHandler('ex03mining:result', function(message)
    TriggerEvent('chat:addMessage', { args = { '[採掘]', message } })
end)
