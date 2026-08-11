RegisterCommand('shop', function()
    TriggerServerEvent('ex02shop:requestOpen')
end, false)

RegisterNetEvent('ex02shop:open')
AddEventHandler('ex02shop:open', function(items, money)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openShop', items = items, money = money })
end)

RegisterNetEvent('ex02shop:purchaseResult')
AddEventHandler('ex02shop:purchaseResult', function(success, message, money)
    SendNUIMessage({ action = 'purchaseResult', success = success, message = message, money = money })
end)

RegisterNUICallback('purchase', function(data, cb)
    TriggerServerEvent('ex02shop:purchase', data.itemName)
    cb('ok')
end)

RegisterNUICallback('closeShop', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)
