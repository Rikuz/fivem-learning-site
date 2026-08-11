-- プレイヤーの状態をStateBagsで管理し、全clientに同期する(Tier5-03参照)
RegisterCommand('setstatus', function(source, args)
    local playerId = source
    local status = args[1] or 'idle'

    -- 第3引数をtrueにすると全clientに同期される(replicated)
    Player(playerId).state:set('myStatus', status, true)
end, false)
