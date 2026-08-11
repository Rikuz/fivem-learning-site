local function getPlayerIdentifier(playerId)
    return GetPlayerIdentifierByType(playerId, 'license')
end

RegisterNetEvent('ex08messenger:requestMessages')
AddEventHandler('ex08messenger:requestMessages', function()
    local playerId = source
    local identifier = getPlayerIdentifier(playerId)

    local messages = MySQL.query.await(
        'SELECT id, sender_name, body, created_at FROM ex08_messages WHERE receiver_identifier = ? ORDER BY created_at DESC',
        { identifier }
    )

    TriggerClientEvent('ex08messenger:receiveMessages', playerId, messages or {})
end)

RegisterNetEvent('ex08messenger:send')
AddEventHandler('ex08messenger:send', function(receiverServerId, body)
    local senderId = source

    if not body or body == '' or not receiverServerId then
        TriggerClientEvent('ex08messenger:sendResult', senderId, false, '宛先と本文を入力してください')
        return
    end

    local receiverId = tonumber(receiverServerId)
    local receiverPed = receiverId and GetPlayerPed(receiverId)
    if not receiverPed or receiverPed == 0 then
        TriggerClientEvent('ex08messenger:sendResult', senderId, false, '相手が見つかりません')
        return
    end

    local senderIdentifier = getPlayerIdentifier(senderId)
    local senderName = GetPlayerName(senderId)
    local receiverIdentifier = getPlayerIdentifier(receiverId)

    MySQL.insert('INSERT INTO ex08_messages (sender_identifier, sender_name, receiver_identifier, body) VALUES (?, ?, ?, ?)', {
        senderIdentifier, senderName, receiverIdentifier, body
    })

    TriggerClientEvent('ex08messenger:sendResult', senderId, true, '送信しました')

    -- 受信者がオンラインなら、アプリを開いていなくても未読バッジを表示する(Tier4-23参照)
    local unreadCount = MySQL.scalar.await('SELECT COUNT(*) FROM ex08_messages WHERE receiver_identifier = ?', { receiverIdentifier })
    TriggerClientEvent('ex08messenger:newMessageBadge', receiverId, unreadCount)
end)
