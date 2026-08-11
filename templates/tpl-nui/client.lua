local isOpen = false

RegisterCommand('opennui', function()
    if isOpen then return end
    isOpen = true

    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
end, false)

RegisterNUICallback('close', function(data, cb)
    isOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

-- JS側からLuaへデータを送る例(Tier3-02参照)
RegisterNUICallback('submitData', function(data, cb)
    print('NUIから受け取ったデータ:', json.encode(data))
    cb('ok')
end)
