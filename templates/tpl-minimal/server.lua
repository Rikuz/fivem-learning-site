-- ここにserver側の処理を書く。以下は起動確認用のログ出力。

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    print(('^2[%s] リソースが起動しました^0'):format(resourceName))
end)
