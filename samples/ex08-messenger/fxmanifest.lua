fx_version 'cerulean'
game 'gta5'

author 'FiveM学習サイト サンプル'
description 'ex-08: lb-phoneメッセージ/掲示板アプリ'
version '1.0.0'

dependency 'lb-phone'
dependency 'oxmysql'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

client_script 'client.lua'
server_script 'server.lua'
