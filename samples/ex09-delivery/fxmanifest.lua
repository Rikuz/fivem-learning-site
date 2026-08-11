fx_version 'cerulean'
game 'gta5'

author 'FiveM学習サイト サンプル'
description 'ex-09: lb-phone配車/デリバリー依頼アプリ'
version '1.0.0'

dependency 'lb-phone'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

client_script 'client.lua'
server_script 'server.lua'
