-- ここにclient側の処理を書く。以下は動作確認用のサンプルコマンド。

RegisterCommand('hello', function()
    print('Hello from client!')
end, false)
