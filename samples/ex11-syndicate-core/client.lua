RegisterNetEvent('ex11core:wantedUpdated')
AddEventHandler('ex11core:wantedUpdated', function(level)
    TriggerEvent('chat:addMessage', { args = { '[指名手配]', ('指名手配度: %d'):format(level) } })
end)
