local APP_ID = 'ex08_messenger'

-- アプリを開いたら、自分宛のメッセージ一覧をserverにリクエストする(Tier4-21のスターターテンプレート参照)
RegisterNetEvent('ex08messenger:open')
AddEventHandler('ex08messenger:open', function()
    TriggerServerEvent('ex08messenger:requestMessages')
end)

RegisterNetEvent('ex08messenger:receiveMessages')
AddEventHandler('ex08messenger:receiveMessages', function(messages)
    exports['lb-phone']:SendCustomAppMessage(APP_ID, {
        action = 'showList',
        messages = messages,
    })
end)

-- JS側から送信リクエストを受け取る(Tier3-02のNUIコールバックと同じ仕組み)
RegisterNUICallback('sendMessage', function(data, cb)
    TriggerServerEvent('ex08messenger:send', data.receiverId, data.body)
    cb('ok')
end)

RegisterNetEvent('ex08messenger:sendResult')
AddEventHandler('ex08messenger:sendResult', function(success, message)
    exports['lb-phone']:SendCustomAppMessage(APP_ID, { action = 'sendResult', success = success, message = message })
end)

-- 新着メッセージバッジ(Tier4-23参照): 受信者がオンラインならアプリを開いていなくても表示される
RegisterNetEvent('ex08messenger:newMessageBadge')
AddEventHandler('ex08messenger:newMessageBadge', function(unreadCount)
    exports['lb-phone']:SendCustomAppMessage(APP_ID, { action = 'updateBadge', count = unreadCount })
end)
