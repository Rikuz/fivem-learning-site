# CONTENT_OUTLINE.md — カリキュラム設計

このドキュメントが**コンテンツ制作の唯一の正とする仕様書**です。Claude Codeはレッスン本文を書く際、必ずこの一覧の説明・使用構文に従ってください。ここに書かれていない仕様を憶測で追加しないこと。

5つのtier × 各5レッスン = 計25レッスンをMVP(Phase 1実装範囲)とした。以降、要望に応じてレッスンを追加しており(2026-08-10時点で112レッスン)、tierごとの件数は5件に固定されない。追加する場合も、同じtier構造・カテゴリキーの枠組みを使うこと。プロジェクトトラック(`docs/TRACK_OUTLINE.md`)向けのレッスンも、この一覧・ルールにそのまま従う(トラック専用の特別ルールは設けない)。

---

## Tier 1: 入門(🟢 beginner)— 何もわからない状態からスタート

| ID | タイトル | カテゴリ | 前提 | 内容の要点 |
|---|---|---|---|---|
| `t1-01-setup-environment` | 開発環境を整える | `environment` | なし | txAdminでのローカルサーバー起動、VS Code + Lua用拡張機能の導入、resourcesフォルダの場所を理解する |
| `t1-02-lua-basics` | Lua基礎文法 | `lua-basics` | t1-01 | 変数、テーブル(連想配列)、関数、if文、for/whileループ、`print()`によるデバッグ出力 |
| `t1-03-first-script` | 最初のスクリプトを作る | `lua-basics`, `environment` | t1-02 | resourceフォルダ作成 → `fxmanifest.lua`作成 → `server.cfg`に`ensure`追加 → F8コンソールで動作確認(公式チュートリアル準拠の"Hello World") |
| `t1-04-fxmanifest` | fxmanifest.luaを理解する | `environment` | t1-03 | `fx_version`, `game`, `client_script`, `server_script`, `shared_script`, `dependency`の意味と使い分け |
| `t1-05-debug-basics` | デバッグの基本 | `lua-basics` | t1-03 | F8コンソールの開き方、エラーメッセージの読み方(ファイル名・行番号の見方)、`print()`を使った原因の切り分け方 |
| `t1-06-string-table-utils` | 文字列・テーブル操作の応用 | `lua-basics` | t1-02 | `string.format`, `string.upper`/`lower`, `string.find`、`table.insert`/`remove`、`pairs`と`ipairs`の違い |
| `t1-07-error-handling` | エラーハンドリング(pcall/xpcall) | `lua-basics` | t1-02 | `pcall`/`xpcall`でエラーを捕捉し、スクリプト全体を止めずに処理を継続する方法 |
| `t1-08-git-basics` | Gitでのバージョン管理 | `environment` | t1-01 | resourceフォルダのGit管理、コミット・巻き戻し、`.gitignore`の設定 |
| `t1-09-config-pattern` | Config.luaの設計パターン | `environment` | t1-04 | 設定値を`Config.lua`にまとめ`shared_script`として参照する設計パターン |
| `t1-10-native-reference` | ネイティブ関数リファレンスの読み方 | `lua-basics` | t1-01 | docs.fivem.netの読み方、引数・戻り値の見方、client/server対応の見分け方 |
| `t1-11-hash-strings` | GetHashKeyとハッシュ文字列 | `lua-basics` | t1-02 | `GetHashKey`の役割、`` `モデル名` ``バッククォート記法がハッシュ変換の糖衣構文であること |
| `t1-12-server-cfg-structure` | server.cfgの全体構造 | `environment` | t1-01 | `set`/`setr`/`sets`と`ensure`の違い、読み込み順序、よく使うconvar一覧、`exec`での分割管理 |
| `t1-13-vscode-lua-setup` | VS CodeでFiveM開発環境を整える | `environment` | t1-01 | sumneko.lua拡張機能とFiveM native定義ファイルによる補完・型チェックのセットアップ |

---

## Tier 2: 初級(🟡 novice)— 動くものを少しずつ作れるようになる

| ID | タイトル | カテゴリ | 前提 | 内容の要点 |
|---|---|---|---|---|
| `t2-01-events-basics` | イベントの基礎(client↔server通信) | `events` | t1-05 | `RegisterNetEvent`, `TriggerServerEvent`, `TriggerClientEvent`。なぜクライアント/サーバーで処理を分けるか |
| `t2-02-spawn-npc` | NPCを配置する | `npc-entity` | t2-01 | `CreatePed`でNPCを生成、`FreezeEntityPosition`で固定、`DeletePed`で削除。座標の取得方法(`GetEntityCoords`) |
| `t2-03-blip-marker` | Blip/Markerを表示する | `npc-entity` | t2-02 | `AddBlipForCoord`でミニマップにアイコン表示、`DrawMarker`で3D空間にマーカー表示 |
| `t2-04-commands` | コマンドを登録する | `events` | t2-01 | `RegisterCommand`、権限チェックの基本(`IsPlayerAceAllowed`) |
| `t2-05-threads-loops` | スレッドとループ | `lua-basics`, `performance` | t2-01 | `CreateThread`、`Wait()`を絶対に省略してはいけない理由(1フレームごとにCPUを専有し、サーバー全体を重くする) |
| `t2-06-spawn-vehicle` | 車両を生成・操作する | `vehicle` | t2-02 | `CreateVehicle`で車両を生成、`SetPedIntoVehicle`でプレイヤーを乗せる、`SetVehicleNumberPlateText`、`DeleteVehicle`での削除 |
| `t2-07-play-animation` | アニメーションを再生する | `animation` | t2-02 | `RequestAnimDict`でアニメ辞書を読み込み、`TaskPlayAnim`で再生、`RemoveAnimDict`で解放 |
| `t2-08-weather-time-sync` | 天候・時間を同期する | `world`, `events` | t2-01 | `NetworkOverrideClockTime`での時間設定、`SetWeatherTypeOvertimePersist`等の天候native、イベントで全clientに同期させる設計 |
| `t2-09-create-object` | オブジェクト(プロップ)を生成・設置する | `npc-entity` | t2-02 | `CreateObject`でプロップを生成、`DeleteObject`で削除 |
| `t2-10-camera-control` | カメラを演出する | `camera` | t2-01 | `CreateCamWithParams`、`RenderScriptCams`でカメラを切り替える簡易カットシーン |
| `t2-11-particle-effects` | パーティクルエフェクトを再生する | `effects` | t2-02 | `RequestNamedPtfxAsset`、`StartParticleFxNonLoopedAtCoord`で炎・煙・火花を再生 |
| `t2-12-play-sound` | サウンドを再生する | `effects` | t2-01 | `PlaySoundFrontend`、`PlaySoundFromCoord`で効果音・座標付きサウンドを再生 |
| `t2-13-ped-appearance` | ペドの服装・見た目を変更する | `appearance` | t2-02 | `SetPedComponentVariation`、`SetPedPropIndex`で服装・装飾品を変更 |
| `t2-14-vehicle-repair` | 車両の修理・ダメージ管理 | `vehicle` | t2-06 | `SetVehicleFixed`、`GetVehicleEngineHealth`で車両を修理・状態確認 |
| `t2-15-player-dropped` | 切断理由の取得と後処理 | `events` | t2-01 | `playerDropped`イベントで切断理由取得、切断時のクリーンアップ処理 |
| `t2-16-keybind-mapping` | キーバインド設定 | `events` | t2-04 | `RegisterKeyMapping`でプレイヤーが変更可能なキー割り当てを登録 |
| `t2-17-raycast-target` | 照準先のエンティティを取得する | `targeting` | t2-02 | `GetEntityPlayerIsFreeAimingAt`、`StartShapeTestRay`で照準先を取得 |
| `t2-18-custom-zones` | エリア判定を自作する | `world` | t2-01 | 座標・半径・多角形での範囲判定を自作するゾーンシステム |
| `t2-19-shared-modules` | shared_scriptを使ったモジュール分割 | `environment` | t1-04 | `shared_script`でclient/server共通コードを整理するファイル分割設計 |
| `t2-20-player-identifiers` | プレイヤー識別子(GetPlayerIdentifiers)の使い分け | `events`, `security` | t2-01 | `steam`/`discord`/`license`/`license2`/`fivem`/`ip`の各識別子の意味、DBの主キーにどれを使うべきかの指針 |

---

## Tier 3: 中級(🟠 intermediate)— 画面とデータを扱えるようになる

| ID | タイトル | カテゴリ | 前提 | 内容の要点 |
|---|---|---|---|---|
| `t3-01-nui-basics` | NUIの基礎(画面UIを表示する) | `nui` | t2-05 | `fxmanifest.lua`に`ui_page`を指定、`SendNUIMessage`でLua→JS方向にデータを送る、`SetNuiFocus`でマウス操作を有効化 |
| `t3-02-nui-callback` | NUIコールバック(双方向通信) | `nui` | t3-01 | `RegisterNUICallback`でJS→Lua方向を受け取る、JS側の`fetch()`による送信パターン |
| `t3-03-database-oxmysql` | DB連携の基礎(oxmysql) | `database` | t2-01 | `oxmysql`のインストール、`MySQL.Async.fetchAll` / `MySQL.Async.execute`によるSELECT/INSERTの基本、コールバックの受け方 |
| `t3-04-items-inventory` | アイテム・インベントリの基本 | `database`, `framework` | t3-03 | シンプルなアイテム所持データの管理例(テーブル設計 + 増減処理)に加えて、下記「ox_inventory 正確な構文」を使用し実際のexportも紹介する |
| `t3-30-ox-inventory-item-registry` | ox_inventoryにアイテムを追加する | `database` | t3-04 | 下記「ox_inventory アイテム定義 正確な構文」を使用。`data/items.lua`に新規アイテムを定義するフィールド(label, weight, stack, close, consume, client.image等) |
| `t3-31-ox-inventory-usable-items` | ox_inventoryで使用可能アイテムを作る | `database` | t3-30 | 下記「ox_inventory 使用可能アイテム 正確な構文」を使用。`client.export`とexportsの登録でインベントリから呼び出せるアイテムを作る |
| `t3-05-server-validation` | サーバー側バリデーション | `security` | t3-03 | クライアントから送られた値を無条件に信用しない設計、サーバー側での再チェックの実装例 |
| `t3-06-exports-between-resources` | exportsで関数を公開する | `events` | t2-01 | `exports('関数名', function)`でresource間から呼べる関数を公開する、`exports['resource名']:関数名(...)`で呼び出す |
| `t3-07-ox-target` | ox_targetでインタラクションを作る | `targeting` | t2-02 | 下記「ox_target 正確な構文」を使用。`addBoxZone`/`addModel`でターゲット可能なゾーン・モデルを登録する |
| `t3-08-ox-lib-notify-progress` | ox_libで通知・プログレスバーを出す | `ui-library` | t3-01 | 下記「ox_lib 正確な構文」を使用。`lib.notify`で通知、`lib.progressBar`で進捗バー付きアクションを実装する |
| `t3-09-multi-resource-structure` | 複数resourceにまたがるプロジェクト構成のコツ | `environment` | t3-06 | 機能ごとのresource分割基準、命名規則、`dependency`での依存関係管理 |
| `t3-10-death-revive-system` | 死亡・蘇生(リバイブ)システムの基礎 | `gameplay` | t2-01 | `wasted`イベントの検知、ダウン状態への遷移、蘇生コマンドでの復帰処理 |
| `t3-11-scaleform` | Scaleform(GTA組み込みUI部品)を使う | `nui` | t3-01 | `RequestScaleformMovie`、`BeginScaleformMovieMethod`でGTA標準UIを再現 |
| `t3-12-drawtext3d` | 頭上にフローティングテキストを表示する | `nui` | t2-01 | `SetDrawOrigin`等でワールド座標にテキストを描画する自作DrawText3D |
| `t3-13-custom-context-menu` | 独自のコンテキストメニューを自作する | `nui` | t3-02 | NUI+`RegisterNUICallback`でox_libなしのコンテキストメニューを自作 |
| `t3-14-notification-queue` | 通知のキュー管理 | `nui` | t3-01 | JS側で通知を順番に表示するキュー(待ち行列)の実装 |
| `t3-15-autosave-pattern` | プレイヤーデータの自動保存設計 | `database` | t3-03 | 切断時保存+定期オートセーブループでデータ損失を減らす設計 |
| `t3-16-cache-strategy` | キャッシュ戦略 | `database`, `performance` | t3-03 | 頻繁に参照するデータをメモリキャッシュしDB問い合わせを減らす |
| `t3-17-json-vs-relational` | JSON保存 vs リレーショナル設計の使い分け | `database` | t3-03 | JSON列にまとめる設計とテーブル正規化のメリット・デメリット比較 |
| `t3-18-garage-basics` | ガレージシステムの基礎設計 | `vehicle`, `framework` | t2-06, t3-03 | 所有車両のDB保存、格納/出庫の基本フロー |
| `t3-19-whitelist-application` | ホワイトリスト・応募フォームシステム | `security` | t3-05 | `playerConnecting`でのホワイトリスト外接続拒否、応募承認プロセスの設計 |
| `t3-20-admin-menu-basics` | 管理者メニューの基礎設計 | `admin-tools` | t3-02, t2-04 | 権限チェック付きコマンドでNUIメニューを開き、プレイヤー一覧・操作ボタンを実装 |
| `t3-21-report-ticket-system` | 通報・チケットシステムの基礎 | `admin-tools` | t3-03 | 通報のDB記録、管理者による一覧・対応済み管理の簡易チケットシステム |
| `t3-22-discord-webhook-log` | 重要操作をDiscord Webhookでログ収集する | `admin-tools`, `events` | t3-03 | `PerformHttpRequest`でDiscord Webhookに送信し重要操作を外部記録 |
| `t3-23-crafting-system` | クラフト(製作)システムの基礎 | `gameplay` | t3-04 | 素材チェック→消費→完成品付与のクラフト処理フロー |
| `t3-24-fishing-mining-minigame` | 釣り・採掘などのミニゲームループ | `gameplay` | t3-08 | プログレスバー+確率抽選での繰り返しアクションのゲームループ |
| `t3-25-skill-xp-system` | スキル・経験値(XP)システム | `gameplay` | t3-03 | 行動に応じたXP加算、レベルアップ判定、DB保存の基本設計 |
| `t3-26-vending-shop-system` | 自動販売機・ショップシステム | `gameplay`, `database` | t3-04 | 商品リスト定義、所持金チェック、購入処理の基本フロー |
| `t3-27-voice-proximity-concept` | 音声近接チャットの考え方 | `voice` | t2-01 | pma-voice等の近接ボイスがルーティングバケット等と組み合わさる仕組みの考え方 |
| `t3-28-radio-channel-system` | 無線チャンネルシステムの基礎 | `voice` | t3-27 | チャンネルIDでのプレイヤーグループ管理、同一チャンネル内通信の設計 |
| `t3-29-qb-target` | qb-targetでインタラクションを作る | `targeting` | t3-07 | 下記「qb-target 正確な構文」を使用。`AddBoxZone`等でox_targetの代替として使う |
| `t3-32-oxmysql-modern-api` | oxmysqlのモダンな書き方(MySQL.insert/update/scalar) | `database` | t3-03 | 下記「oxmysql モダンAPI 正確な構文」を使用。`?`プレースホルダと`.await`によるPromiseスタイルの書き方 |
| `t3-33-ox-lib-callback` | ox_libでコールバックを使う(lib.callback) | `ui-library`, `events` | t3-08 | 下記「ox_lib callback 正確な構文」を使用。`lib.callback.register`/`lib.callback.await`によるclient↔server往復の簡略化 |
| `t3-34-ox-lib-input-dialog` | ox_libで入力ダイアログを出す(lib.inputDialog) | `ui-library` | t3-08 | 下記「ox_lib inputDialog 正確な構文」を使用。フォーム入力をNUIを自作せず表示する |
| `t3-35-ox-lib-context-menu` | ox_libの組み込みコンテキストメニュー | `ui-library` | t3-08 | 下記「ox_lib context 正確な構文」を使用。`lib.registerContext`/`lib.showContext`で選択肢メニューを作る(Tier3-13の自作版との比較) |
| `t3-36-ox-inventory-shops` | ox_inventory組み込みのショップ登録 | `database` | t3-04 | 下記「ox_inventory RegisterShop 正確な構文」を使用。`RegisterShop`で商品リスト・座標・グループ制限を一括登録する(Tier3-26の自作版との比較) |
| `t3-37-ox-inventory-stashes` | ox_inventory組み込みのスタッシュ登録 | `database` | t3-04 | 下記「ox_inventory RegisterStash 正確な構文」を使用。`RegisterStash`とclient側`openInventory`で永続化された倉庫を作る(演習ex-04の自作版との比較) |
| `t3-38-nui-escape-key` | NUIをEscキーで閉じる標準パターン | `nui` | t3-02 | JS側の`keydown`イベントでEscapeを検知し、`RegisterNUICallback`経由でLua側に通知して`SetNuiFocus(false, false)`する定番実装 |
| `t3-39-persistent-hud-basics` | 常駐HUDの基礎設計(NUIを常時表示するパターン) | `nui` | t3-01 | 通常のNUI(開く/閉じる)と異なり`SetNuiFocus`を使わず常時表示し続ける設計。マウス操作を奪わないための注意点 |
| `t3-40-speedometer-minimap-hud` | スピードメーター・ミニマップのカスタマイズ | `nui`, `vehicle` | t3-39, t2-06 | `GetEntitySpeed`での速度取得とHUDへの反映、`SetMinimapComponentPosition`等でのミニマップ位置・サイズ調整 |
| `t3-41-status-bar-hud-sync` | ステータスバー(体力/満腹度/喉の渇き等)の同期 | `nui`, `events` | t3-39 | `GetEntityHealth`等のnativeと、フレームワーク非依存の汎用ステータス値をHUDに同期する設計 |
| `t3-42-admin-permission-tiers` | 管理者権限レベル(Permission Tier)の設計 | `admin-tools`, `security` | t3-20 | Ace権限とJobを組み合わせた多段階権限(モデレーター/管理者/開発者)の設計パターン |
| `t3-43-admin-player-list-spectate` | オンラインプレイヤー一覧とスペクテイト/ノークリップ | `admin-tools` | t3-42, t2-20 | NUIでのオンラインプレイヤー一覧表示、`NetworkSetInSpectatorMode`でのスペクテイト、`FREEZE_ENTITY_POSITION`を用いたノークリップの実装 |

### exports 正確な構文(FiveM公式ドキュメント準拠)

```lua
-- 公開する側(resource A)
local function GetPlayerLevel(source)
    return 5
end

exports('GetPlayerLevel', GetPlayerLevel)

-- 呼び出す側(resource B)
local level = exports['resource-a']:GetPlayerLevel(source)
```

### ox_target 正確な構文(要順守・憶測禁止。overextended.dev/docs/ox_target 及び ox_target/client/debug.lua で確認済み)

```lua
-- ボックス型のターゲットゾーンを作る
exports.ox_target:addBoxZone({
    coords = vec3(442.5363, -1017.666, 28.85637),
    size = vec3(3, 3, 3),
    rotation = 45,
    debug = false,
    options = {
        {
            name = 'my_zone_action',
            event = 'myscript:onTargetSelect', -- TriggerEventが発火する(クライアント側のイベント名)
            icon = 'fa-solid fa-cube',
            label = 'これを調べる',
        }
    }
})

-- 特定モデルのエンティティ全てにターゲットオプションを追加する
exports.ox_target:addModel('a_m_m_business_01', {
    {
        name = 'talk_to_npc',
        icon = 'fa-solid fa-comment',
        label = '話しかける',
        onSelect = function(data)
            print('選択されたエンティティ: ' .. tostring(data.entity))
        end,
    }
})
```
> ※`addBoxZone`の`options`は`event`(TriggerEventで発火するイベント名)または`onSelect`(直接呼ばれる関数)のどちらかを指定できる。`addEntity`(ネットワークID指定)・`addLocalEntity`(エンティティハンドル指定)・`removeZone`等の関数もある。ox_targetはOverextended(CommunityOx)がメンテナンスしており、バージョンによってオプションが追加される場合があるため、導入しているバージョンの公式ドキュメント(overextended.dev/docs/ox_target)も確認すること。

### qb-target 正確な構文(要順守・憶測禁止。docs.qbcore.org 及び github.com/qbcore-framework/qb-target/EXAMPLES.md で確認済み)

```lua
exports['qb-target']:AddBoxZone("MissionRowDutyClipboard", vector3(441.7989, -982.0529, 30.67834), 0.45, 0.35, {
    name = "MissionRowDutyClipboard",
    heading = 11.0,
    debugPoly = false,
    minZ = 30.77834,
    maxZ = 30.87834,
}, {
    options = {
        {
            type = "client", -- 'client'ならclient側イベント、'server'ならserver側イベントが発火する
            event = "qb-policejob:ToggleDuty",
            icon = "fas fa-sign-in-alt",
            label = "Sign In",
            job = "police", -- この職業のプレイヤーにしか選択肢を表示しない(省略可)
        },
    },
    distance = 2.5
})
```
> ※第1引数はゾーンの一意な名前、第2引数は中心座標、第3・4引数は長さ・幅(float)。`AddTargetModel`(モデル指定)・`AddTargetEntity`(エンティティ指定)・`RemoveZone`等の関数もある。qb-targetはox_targetと並んでよく使われる代替ライブラリで、どちらか一方を導入して使う(併用は非推奨)。バージョンによってオプションが変わる場合があるため、導入しているバージョンのドキュメント(docs.qbcore.org)も確認すること。

### qb-inventory 正確な構文(要順守・憶測禁止。docs.qbcore.org 及び github.com/qbcore-framework/qb-inventory で確認済み)

```lua
-- アイテムを追加する(info: metadata相当のテーブル、reason: ログ用の理由文字列。どちらも省略可)
exports['qb-inventory']:AddItem(source, 'phone', 1)
exports['qb-inventory']:AddItem(source, 'weapon_pistol', 1, false, { durability = 100, ammo = 12, serial = 'ABC123XYZ' })

-- アイテムを減らす(slotを指定すると特定のスロットからピンポイントで減らせる)
exports['qb-inventory']:RemoveItem(source, 'phone', 1)
exports['qb-inventory']:RemoveItem(source, 'phone', 1, 5)
```
```lua
-- 使用可能アイテムを登録する(QBCore本体の機能。ox_inventoryのclient.exportに相当する)
QBCore.Functions.CreateUseableItem('lockpick', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName('lockpick') then
        TriggerClientEvent('lockpick:client:use', source)
    end
end)
```
> ※qb-inventoryはox_inventory(Tier3-04, Tier3-30, Tier3-31)とは別系統のインベントリで、QBCore環境で標準的に使われる。<code>AddItem</code>/<code>RemoveItem</code>の引数順序・名前がox_inventoryと異なる点に注意(混同すると動かない)。使用可能アイテムの登録も、ox_inventoryが<code>items.lua</code>の<code>client.export</code>フィールド経由なのに対し、qb-inventoryは<code>QBCore.Functions.CreateUseableItem</code>をどこか(通常はserver側)で1回呼ぶ方式という違いがある。バージョンによって仕様が変わる場合があるため、公式ドキュメントも確認すること。

### ox_lib 正確な構文(要順守・憶測禁止。overextended.dev/ox_lib/Modules/Interface/Client 各ページで確認済み)

```lua
-- 通知を表示する
lib.notify({
    title = '入手',
    description = 'アイテムを入手しました',
    type = 'success' -- 'inform' / 'error' / 'success' / 'warning'
})

-- プログレスバー付きのアクションを実装する(完了時true、キャンセル時false)
if lib.progressBar({
    duration = 2000,
    label = '調べています...',
    useWhileDead = false,
    canCancel = true,
    disable = { move = true, car = true },
    anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
}) then
    print('完了')
else
    print('キャンセルされた')
end
```
> ※ox_libはclient側の`ox_lib/init.lua`を`shared_script`として読み込む(または`lib.locale()`等と合わせてfxmanifestに`ox_lib`への`dependency`を指定する)構成が必要。詳細な導入手順は導入しているox_libのバージョンのドキュメント(overextended.dev/ox_lib またはcoxdocs.dev)を確認すること。

### ox_lib callback 正確な構文(要順守・憶測禁止。overextended.dev/ox_lib/Modules/Callback 各ページで確認済み)

```lua
-- server.lua: コールバックを登録する
lib.callback.register('myscript:getPlayerCash', function(source)
    local cash = getPlayerMoney(source) -- Tier4-01のフレームワーク連携で取得する想定
    return cash
end)
```
```lua
-- client.lua: 呼び出す(コールバック関数スタイル。別コルーチンで結果を受け取る)
lib.callback('myscript:getPlayerCash', false, function(cash)
    print('所持金: ' .. cash)
end)

-- client.lua: 呼び出す(await/Promiseスタイル。結果が返るまで処理を止めて待つ)
local cash = lib.callback.await('myscript:getPlayerCash', false)
print('所持金: ' .. cash)
```
> ※`lib.callback`の第2引数は待機時間(ミリ秒)の指定で、`false`を渡すとタイムアウトしない。client側は`lib.callback.register`でserver→clientのコールバックを受けることもできる(方向を問わず同じ関数群で扱える)。

### ox_lib inputDialog 正確な構文(要順守・憶測禁止。overextended.dev/docs/ox_lib/Interface/Client/input で確認済み)

```lua
local input = lib.inputDialog('基本ダイアログ', { '1行目', '2行目' })
if not input then return end -- キャンセルされた場合はnilが返る

print(json.encode(input), input[1], input[2])
```
> ※戻り値はテーブル(配列)で、`rows`に渡した順番のインデックスに対応する値が入る(1行目の入力は`input[1]`)。`rows`の各要素は文字列(単純なテキスト入力欄)だけでなく、`type = 'number' / 'checkbox' / 'select' / 'slider' / 'color' / 'multi-select' / 'date' / 'date-range' / 'time' / 'textarea'`等を指定したテーブルにもできる。非同期関数のため、呼び出し元の関数もコルーチン(Tier5-07参照)またはasync的な文脈で呼ぶ必要がある。

### ox_lib context 正確な構文(要順守・憶測禁止。overextended.dev/docs/ox_lib/Interface/Client/context で確認済み)

```lua
lib.registerContext({
    id = 'garage_menu',
    title = 'Personal Garage',
    options = {
        {
            title = 'Retrieve Vehicle',
            description = 'Spawn your last saved car.',
            event = 'garage:retrieveVehicle',
        },
        {
            title = 'Store Vehicle',
            description = 'Save the vehicle you are currently in.',
            event = 'garage:storeVehicle',
        },
    },
})

lib.showContext('garage_menu')
```
> ※`options`は連番キー(配列)で書くこと。文字列キーにするとアルファベット順に並び替えられてしまい、意図した順序で表示されない。各項目は`event`(client側イベント)/`serverEvent`(server側イベント)/`onSelect`(直接呼ばれる関数)のいずれかで動作を指定でき、`menu`にIDを指定すると別のコンテキストメニューへのサブメニュー遷移になる。

### ox_inventory 正確な構文(要順守・憶測禁止)

```lua
-- アイテムを追加する(成功時true)
local success = exports.ox_inventory:AddItem(source, 'water', 1)

-- アイテムを減らす(成功時true。所持数が足りない場合はfalse)
local success = exports.ox_inventory:RemoveItem(source, 'water', 1)

-- 所持数を確認する
local count = exports.ox_inventory:GetItemCount(source, 'water')
```
> ※`source`はプレイヤーID(数値)。第4引数にmetadata(耐久値や刻印などアイテムごとの付加データ)、第5引数にslot番号を指定できる場合がある。ox_inventoryはバージョンによって引数が増減することがあるため、導入しているox_inventoryのREADME・公式ドキュメントも必ず確認すること。

### ox_inventory アイテム定義 正確な構文(要順守・憶測禁止。overextended.dev/docs/ox_inventory/Guides/creatingItems で確認済み)

```lua
-- data/items.lua(ox_inventory本体側のファイル)に新規アイテムを追加する
['burger'] = {
    label = 'Burger',
    description = 'Just what is the secret formula?',
    weight = 220,
    stack = true,
    close = true,
    client = {
        status = { hunger = 200000 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
        prop = {
            model = 'prop_cs_burger_01',
            pos = { x = 0.02, y = 0.02, z = -0.02 },
            rot = { x = 0.0, y = 0.0, z = 0.0 }
        },
        usetime = 2500,
    }
}
```
> ※主なフィールド: `label`(表示名), `description`(説明文), `weight`(重量), `stack`(スタック可能か), `close`(使用時にインベントリを閉じるか), `consume`(使用時に消費する個数。小数を指定すると耐久値として扱われる), `canUse`(武器を持ったまま使用できるか), `client.status`(esx_status等のステータス値を調整), `client.anim`/`client.prop`(使用時のアニメーション・持ち物), `client.usetime`(使用にかかる時間)。アイテム画像は既定では`web/images/アイテム名.png`のファイル名で自動的に読み込まれる(ファイル名がアイテム名と異なる場合の指定方法は導入バージョンのドキュメントを確認すること)。

### ox_inventory 使用可能アイテム 正確な構文(要順守・憶測禁止。overextended.dev/docs/ox_inventory/Guides/creatingItems 及び ox_inventory/modules/items/client.lua で確認済み)

```lua
-- data/items.lua側で、使用時に呼び出すexportを指定する
['water_bottle'] = {
    label = 'Water Bottle',
    weight = 500,
    stack = true,
    close = true,
    client = {
        export = 'my-resource.drinkWater' -- 'リソース名.export名' の形式
    }
}
```
```lua
-- my-resource側(自分のresource)でexportを登録する
-- 第1引数はexport名(items.luaのclient.exportで指定した名前)
exports('drinkWater', function(data, slot)
    -- exports.ox_inventory:useItem(...) でサーバー側に使用を通知し、承認されたら効果を適用する
    exports.ox_inventory:useItem(data, function(data)
        if data then
            -- ここで実際の効果(空腹度/喉の渇きの回復など)を適用する
            lib.notify({ description = '水を飲んで喉が潤った' })
        end
    end)
end)
```
> ※`item.client?.export`(または`client.event`)フィールドの有無で、ox_inventoryが使用時にexport/eventを呼ぶかどうかを判定している(ox_inventory本体のソースコードで確認済み)。`exports.ox_inventory:useItem(data, callback)`を挟むことで、実際にアイテムが消費されたかをサーバー側に確認してから効果を適用する設計になっている。バージョンによって仕様が変わる場合があるため、公式ドキュメントも確認すること。

### ox_inventory RegisterShop 正確な構文(要順守・憶測禁止。overextended.dev/docs/ox_inventory/Guides/shops で確認済み)

```lua
exports.ox_inventory:RegisterShop('TestShop', {
    name = 'Test shop',
    inventory = {
        { name = 'burger', price = 10 },
        { name = 'water', price = 10 },
        { name = 'cola', price = 10 },
    },
    locations = {
        vec3(223.832962, -792.619751, 30.695190),
    },
    groups = { police = 0 }, -- このグループ(job)のプレイヤーだけが利用できる(省略すると誰でも利用可)
})
```
> ※`RegisterShop`はserver側から呼び出す。ox_targetのような「近づいて選ぶ」インタラクションはox_inventory側が自動生成してくれるため、Tier3-07のox_targetを自分で組み合わせる必要はない(ただし公式ドキュメントには「Blip・Marker・ゾーンは作られない。`locations`であって`targets`ではない」という制約が明記されている)。複数の座標を`locations`に並べると、同じ品揃えの店舗を複数箇所に一括設置できる。

### ox_inventory RegisterStash 正確な構文(要順守・憶測禁止。overextended.dev/docs/ox_inventory/Guides/stashes で確認済み)

```lua
-- server.lua
exports.ox_inventory:RegisterStash(stashId, label, slots, weight, owner)
-- stashId: DB上でスタッシュを識別する一意な文字列
-- label: プレイヤーに表示される名前
-- slots: スロット数
-- weight: 最大重量
-- owner: 特定プレイヤー専用にする場合はcitizenid等を指定(省略すると共有スタッシュになる)
```
```lua
-- client.lua: 登録したスタッシュを開く
exports.ox_inventory:openInventory('stash', { id = stashId, owner = false })
```
> ※`RegisterStash`はプレイヤーがスタッシュを開く前に必ず一度呼ばれている必要がある(resource起動時にまとめて登録しておくのが一般的)。`owner`を指定すると個人専用ロッカーに、省略すると演習ex-04のような共有倉庫になる。`groups`引数でJobごとのアクセス制限も可能。

### oxmysql モダンAPI 正確な構文(要順守・憶測禁止。overextended.dev/docs/oxmysql/Functions 各ページで確認済み)

```lua
-- INSERT(挿入したレコードのIDが返る)
local id = MySQL.insert.await('INSERT INTO `users` (identifier, firstname, lastname) VALUES (?, ?, ?)', {
    identifier, firstName, lastName
})

-- UPDATE(影響を受けた行数が返る)
local affectedRows = MySQL.update.await('UPDATE users SET firstname = ? WHERE identifier = ?', { newName, identifier })

-- SELECT(1行の1列だけ取得)
local firstName = MySQL.scalar.await('SELECT `firstname` FROM `users` WHERE `identifier` = ? LIMIT 1', { identifier })

-- SELECT(1行をまとめて取得)
local row = MySQL.single.await('SELECT `firstname`, `lastname` FROM `users` WHERE `identifier` = ? LIMIT 1', { identifier })
```
```lua
-- .awaitを付けない場合は、Tier3-03のMySQL.Async.*と同様にコールバック関数で受け取れる
MySQL.insert('INSERT INTO `users` (identifier, firstname, lastname) VALUES (?, ?, ?)', {
    identifier, firstName, lastName
}, function(id)
    print(id)
end)
```
> ※Tier3-03で扱った`MySQL.Async.fetchAll`は<code>@name</code>形式のプレースホルダでしたが、こちらのモダンAPI(`MySQL.insert`/`update`/`scalar`/`single`/`query`)は<strong><code>?</code>形式の位置プレースホルダ</strong>で、パラメータは配列(<code>{ }</code>)で順番に渡します。混同しないよう注意すること。`.await`を付けるとコルーチン(Tier5-07参照)を使って結果を待つPromiseスタイルになり、付けなければ従来通りコールバック関数で受け取れる。

---

## Tier 4: 中上級(🔴 upper-intermediate)— 実際のRPサーバーの部品を組み込む

| ID | タイトル | カテゴリ | 前提 | 内容の要点 |
|---|---|---|---|---|
| `t4-01-framework-basics` | ESX/QBCore/Qbox/oxの基本 | `framework` | t3-04 | フレームワークの検知方法、プレイヤーデータの取得(お金・職業など)、ESX/QBCore/Qbox(qbx_core)/ox_coreでのAPIの違い。QboxはQBCore互換API(`exports['qb-core']:GetCoreObject()`)を提供する点に触れる |
| `t4-02-framework-jobs` | フレームワークで職業(Job)システムを使う | `framework` | t4-01 | ESX/QBCore/QboxのJob確認、ox_coreのgroup確認、Job/group専用のNPC/エリア制御、給料処理の実装例 |
| `t4-03-okok-integration` | okokシリーズと連携する | `okok`, `nui` | t3-02 | 下記「okokシリーズ 正確な構文」を使用。通知(okokNotify)とテキストUI(okokTextUI)を自作スクリプトから呼び出す |
| `t4-04-lb-phone-custom-app` | lb-phoneにカスタムアプリを追加する | `lb-phone` | t3-01 | 下記「lb-phone 正確な構文」を使用。`Config.CustomApps`へのアプリ登録、`AddCustomApp`/`RemoveCustomApp`エクスポート |
| `t4-05-lb-phone-nui-bridge` | lb-phoneアプリのUIとLua間通信 | `lb-phone`, `nui` | t4-04 | 通常のNUIとの違い(`SendNUIMessage`ではなく`SendCustomAppMessage`を使う点)、`onOpen`のタイミングとデータ送信の注意点 |
| `t4-06-okok-banking-integration` | okokBankingV2と連携する | `okok`, `framework` | t4-03 | 下記「okokBankingV2 正確な構文」を使用。口座残高の取得・入出金・取引履歴取得を自作スクリプトから呼び出す |
| `t4-07-ban-kick-system` | BAN・キック機能を実装する | `security` | t2-04, t3-05 | `DropPlayer`でキックする、`playerConnecting`イベントとdeferralsを使った接続時のBANチェック |
| `t4-08-db-schema-migration` | DBスキーマのバージョン管理・マイグレーション | `database` | t3-03 | テーブル構造変更を安全に反映するマイグレーションSQLファイルの管理方法 |
| `t4-09-player-loaded-event` | ログイン完了イベントを使う | `framework` | t4-01 | `esx:playerLoaded`、`QBCore:Client:OnPlayerLoaded`でのログイン後初期化処理 |
| `t4-10-business-account-management` | ビジネス/組織口座の管理 | `framework`, `okok` | t4-06 | job名を口座識別子に使ったsociety口座の管理・入出金設計 |
| `t4-11-screenshot-basic` | screenshot-basicでスクリーンショットを取得する | `admin-tools` | t3-20 | 下記「screenshot-basic 正確な構文」を使用。証拠保全用のスクリーンショット取得 |
| `t4-12-used-car-dealership` | 中古車販売店(ディーラー)システム | `gameplay`, `vehicle` | t3-18 | 車両カタログ提示、試乗、購入処理、所有車両登録の基本フロー |
| `t4-13-discord-oauth-integration` | Discord連携(OAuth・ロール確認) | `events` | t3-22 | Discord identifierとBot連携でのロール確認の概念 |
| `t4-14-ox-doorlock` | ox_doorlockでドアを施錠する | `targeting`, `world` | t3-07 | 下記「ox_doorlock 正確な構文」を使用。`setDoorState`等でドアを施錠・解錠 |
| `t4-15-ox-fuel` | ox_fuelで燃料システムを連携する | `vehicle` | t2-14 | 下記「ox_fuel 正確な構文」を使用。`setPaymentMethod`等で給油の支払い方法をカスタマイズ |
| `t4-16-cd-dispatch` | cd_dispatchで警察無線通知を送る | `dispatch` | t3-28 | 下記「cd_dispatch 正確な構文」を使用。事件情報を送りディスパッチ通知を表示 |
| `t4-17-illenium-appearance` | illenium-appearanceでキャラクリエイトする | `appearance` | t2-13 | 下記「illenium-appearance 正確な構文」を使用。`startPlayerCustomization`でキャラクリエイト画面を開く |
| `t4-18-qb-clothing` | qb-clothingで服屋システムを使う | `appearance`, `framework` | t4-17 | 下記「qb-clothing 正確な構文」を使用。服屋メニュー・ワードローブを開く |
| `t4-19-renewed-banking` | Renewed-Bankingと連携する | `framework`, `database` | t4-06 | 下記「Renewed-Banking 正確な構文」を使用。okokBanking以外の銀行スクリプト連携 |
| `t4-20-qb-inventory-basics` | qb-inventoryの基本 | `database`, `framework` | t3-04, t4-01 | 下記「qb-inventory 正確な構文」を使用。`AddItem`/`RemoveItem`とQBCore.Functions.CreateUseableItemによる使用可能アイテム登録(ox_inventoryとの対比) |
| `t4-21-lb-phone-starter-template` | lb-phoneアプリのスターターテンプレート | `lb-phone` | t4-04 | コピペで動く完成雛形一式(fxmanifest登録・ui/index.html・client.lua)を初めてひとまとめに提示。`lessons/tier4-upper-intermediate/samples/lb-phone-starter/`に実サンプル同梱 |
| `t4-22-lb-phone-screen-navigation` | アプリ内の画面遷移と戻る操作 | `lb-phone`, `nui` | t4-21 | リスト→詳細のSPA的JSルーティング基礎と、電話アプリの「戻るボタン」実装パターン |
| `t4-23-lb-phone-notification-badge` | アプリの新着通知バッジ | `lb-phone` | t4-05, t4-22 | `SendCustomAppMessage`の応用でアプリアイコンに未読件数を表示する |
| `t4-24-wanted-level-system` | 指名手配度(Wanted Level)システム | `crime` | t3-05, t2-01 | 犯罪行為でスコアを加算し、一定値でMDT(t4-28)側に可視化される仕組みを自作する |
| `t4-25-fence-black-market` | 故売/闇市場(fence NPC)システム | `crime` | t3-07, t3-04 | ox_targetでNPCに盗品を売却し現金化する。買取価格の変動・売却上限の設計 |
| `t4-26-chop-shop` | 盗難車両の解体(チョップショップ) | `crime`, `vehicle` | t2-06, t3-07 | 車両を解体してパーツアイテム化する処理。ナンバープレートの再発行との関連 |
| `t4-27-money-laundering` | マネーロンダリング | `crime`, `framework` | t4-10 | 汚れた現金を段階的に組織口座(t4-10)へ正規化する仕組み。時間経過・手数料の設計 |
| `t4-28-mdt-police-terminal` | MDT(警察端末)の基礎 | `law-enforcement`, `nui` | t3-01, t3-03 | 犯罪履歴・指名手配情報(t4-24)を確認する自作NUI画面。ox_target/oxmysqlのみで構築し外部MDTスクリプトには依存しない |
| `t4-29-arrest-handcuff-system` | 逮捕・拘束(handcuff)システム | `law-enforcement` | t2-07, t2-01 | 対象プレイヤーを拘束・護送するアニメーション同期の基本 |
| `t4-30-jail-system` | 投獄(Jail)システム | `law-enforcement` | t4-29 | 行動制限+時間経過での自動釈放。脱獄対策の考え方 |
| `t4-31-evidence-management` | 証拠品・押収品管理 | `law-enforcement`, `database` | t3-37 | `RegisterStash`(t3-37)の応用でevidence bagを実装し、押収品を記録する |
| `t4-32-job-loop-pattern` | ジョブループの基本設計(受注→実行→納品→報酬) | `framework`, `gameplay` | t4-02, t2-01 | 「仕事」を1つの状態遷移として設計する考え方。他のジョブ系スクリプト全般に応用できる核心パターン |
| `t4-33-job-duty-vehicle` | オンデューティ管理とジョブ専用車両の貸出 | `framework`, `vehicle` | t4-32, t2-06 | `job:setDuty`のトグルパターンと、勤務中のみ貸し出す専用車両のスポーン/返却処理 |
| `t4-34-property-ownership-basics` | 物件購入システムの基礎(所有権テーブル設計) | `housing`, `database` | t3-03, t3-07 | 物件マスタ・所有権テーブルの設計、購入・転売処理。演習ex-04(共有倉庫)との所有権設計の違い |
| `t4-35-furniture-placement-system` | 家具設置システム(プロップの設置・削除・保存) | `housing`, `database` | t4-34, t2-09 | 設置モード(仮配置→座標確定)、DBへの家具配置の永続化、resource再起動時の復元処理 |
| `t4-36-housing-storage-lock` | 自宅の収納・施錠システム(ox_inventory + ox_doorlockとの連携) | `housing`, `targeting` | t4-34, t3-37, t4-14 | 所有者以外は開錠・収納アクセス不可にする権限制御。複数物件所有時の管理設計 |
| `t4-37-test-drive-system` | 試乗(テストドライブ)システム | `vehicle`, `gameplay` | t4-12 | 制限時間付きの試乗車貸出、エリア外に出た場合の強制返却処理 |
| `t4-38-vehicle-financing-loan` | 分割払い(ローン)システム | `gameplay`, `framework` | t4-12, t4-06 | 頭金+分割回数の設計、定期的な引き落とし処理、滞納時の扱い |

### okokBankingV2 正確な構文(要順守・憶測禁止。docs.okokscripts.io/scripts/okokbankingv2/exports で確認済み)

```lua
-- 口座情報を取得する(society: 口座の識別子。個人口座はプレイヤーのcitizenid等、business口座は組織名など)
local account = exports['okokBanking']:GetAccount(society)

-- 入金する
exports['okokBanking']:AddMoney(society, value)

-- 出金する
exports['okokBanking']:RemoveMoney(society, value)

-- 取引履歴に記録を追加する(source省略可。Discord Webhook通知にも使われる)
exports['okokBanking']:AddTransaction(citizenid, transactionData, source)
-- transactionDataのtypeフィールドで使われる代表的な値:
--   deposit(入金) / withdraw(出金) / transfer(送金) /
--   savings_deposit(貯金への入金) / savings_withdraw(貯金からの出金) /
--   savings_transfer(貯金内送金) / loan_create(ローン作成)

-- プレイヤーの取引履歴を取得する(limit省略で全件、0以下なら空テーブル)
local transactions = exports['okokBanking']:GetPlayerTransactions(citizenid, limit)
```
> ※exportのリソース名は`'okokBanking'`(V2でも変わらず、`Config.SocietyResource = "okokBanking"`)。`transactionData`の詳細なテーブル構造(sender/receiver/value/type/reason等のキー名)は公式ドキュメントのconfig-file/exportsページにも一部しか明記されていないため、実際に導入しているバージョンのドキュメント・config.luaも確認すること。

### ESX/QBCore/Qbox/ox_core 検知・取得の構文

```lua
-- ESX(es_extended)
local ESX = exports['es_extended']:getSharedObject()
local xPlayer = ESX.GetPlayerFromId(source)
local money = xPlayer.getMoney()
local jobName = xPlayer.job.name

-- QBCore(qb-core)
local QBCore = exports['qb-core']:GetCoreObject()
local Player = QBCore.Functions.GetPlayer(source)
local cash = Player.PlayerData.money['cash']
local jobName2 = Player.PlayerData.job.name

-- Qbox(qbx_core)。QBCoreからの移行を前提に設計されており、
-- 上記と同じ 'qb-core' 互換exportがそのまま使える
local QBCore = exports['qb-core']:GetCoreObject()
-- Qbox独自のexportを直接使う場合は 'qbx_core' を指定する
-- local QBX = exports.qbx_core:GetCoreObject()

-- ox_core。ESX/QBCoreとは異なる設計(クラスベースのプレイヤーオブジェクト)
local player = exports.ox_core:GetPlayer(source)
-- player.get('money') のようなアクセサでデータを取得する想定
```
> ⚠️ **Qbox(qbx_core)・ox_coreの構文は、ESX/QBCoreほど本セッションで裏取りできていません。** QboxがQBCore互換の`'qb-core'`exportを提供する点は公式の設計方針として確度が高いですが、`qbx_core`独自export・`ox_core`のメソッド名(`get`/`getGroup`等)は必ず導入しているバージョンの公式ドキュメント(Qbox: docs.qbox.re、ox_core: Overextended/CommunityOxのドキュメント)で確認してから使うこと。okok/lb-phoneのように実ドキュメントで一字一句確認済みの構文ではない。

### okokシリーズ 正確な構文(要順守・憶測禁止)

**okokNotify(通知)**
```lua
-- クライアント側から呼ぶ場合
exports['okokNotify']:Alert('タイトル', 'メッセージ', 5000, 'success', true)
-- 第3引数: 表示時間(ミリ秒, 例 5000 = 5秒)
-- 第4引数: タイプ(success=緑 / info=青 / warning=黄 / error=赤 / neutral=灰)
-- 第5引数: 効果音を鳴らすか(true/false)

-- サーバー側から特定プレイヤーに通知を送る場合
TriggerClientEvent('okokNotify:Alert', source, 'タイトル', 'メッセージ', 5000, 'success', true)
```

**okokTextUI(画面下部などに出す簡易テキストUI)**
```lua
-- 表示
exports['okokTextUI']:Open('[E] 拾う', 'lightblue', 'right')
-- 第2引数: 色(例: lightblue, darkblue など)
-- 第3引数: 位置(left / right)

-- 非表示
exports['okokTextUI']:Close()
```

> ※okokシリーズはサーバーごとに購入・導入するスクリプトであり、バージョンによって引数が増減する場合がある。レッスン内で「導入しているokokNotify/okokTextUIのconfig.luaやREADME.mdも必ず確認してください」という注記を入れること。

### lb-phone 正確な構文(要順守・憶測禁止)

**カスタムアプリの登録(`lb-phone/config/config.lua`)**
```lua
Config.CustomApps = {
    ["my_custom_app"] = { -- アプリの識別子(ユーザーには表示されない)
        name = "マイアプリ",                 -- ユーザーに表示されるアプリ名
        description = "自作の連携アプリです",  -- 説明文
        developer = "自分の名前",             -- 任意
        defaultApp = true,                   -- trueならダウンロード不要で最初から入っている
        ui = "my-resource/ui/index.html",    -- カスタムUIを使う場合のパス
    },
}
```

**アプリの動的な追加・削除(Lua側エクスポート)**
```lua
-- アプリを追加する
exports['lb-phone']:AddCustomApp('my_custom_app')

-- アプリを削除する
exports['lb-phone']:RemoveCustomApp('my_custom_app')
```

**UIへのメッセージ送信(通常のNUIとは異なる点に注意)**
```lua
-- lb-phoneのアプリUIには SendNUIMessage ではなく、専用のエクスポートを使う
exports['lb-phone']:SendCustomAppMessage('my_custom_app', {
    action = 'updateData',
    payload = { balance = 1500 }
})
```
```js
// フロント側(JS)の受け取り方は通常のNUIコールバックと同じ書き方でよい
window.addEventListener('message', (event) => {
  if (event.data.action === 'updateData') {
    // event.data.payload を使って画面を更新する
  }
});
```
> ※`onOpen`コールバックのタイミングではUI(iframe)がまだ読み込み中の場合があるため、`onOpen`から直接初期データを送らないこと。UI側から「準備完了」を伝えるコールバックを送ってもらい、それを受けてからLua側がデータを送る設計にする。

### screenshot-basic 正確な構文(要順守・憶測禁止。github.com/citizenfx/screenshot-basic README で確認済み)

```lua
exports['screenshot-basic']:requestClientScreenshot(GetPlayers()[1], {
    fileName = 'cache/screenshot.jpg'
    -- encoding = 'png' | 'jpg' | 'webp' (省略時は'jpg')
    -- quality = 0.0〜1.0 (省略時は0.92)
}, function(err, data)
    print('err', err)
    print('data', data) -- fileName省略時はここに画像のdata URIが入る
end)
```
> ※`requestClientScreenshot`はサーバー側からエクスポートを呼ぶ形。第1引数はプレイヤーID。`fileName`を指定するとサーバーの`cache/`以下にファイル保存され、省略するとコールバックにdata URI文字列が渡る。

### ox_doorlock 正確な構文(要順守・憶測禁止。overextended.dev/docs/ox_doorlock/Server/functions で確認済み)

```lua
-- ドアを施錠する(state: true/1で施錠、false/0で解錠)
exports.ox_doorlock:setDoorState(doorId, true)

-- ドアのデータを取得する(id・name・座標・現在の施錠状態などを含むテーブル)
local door = exports.ox_doorlock:getDoor(doorId)
local doorByName = exports.ox_doorlock:getDoorFromName('my_door_name')

-- ドアの設定を編集する
exports.ox_doorlock:editDoor(doorId, { distance = 3.0 })
```
> ※ox_doorlockのドア自体の登録は、Lua設定ファイルではなく**ゲーム内の`/doorlock`コマンド**でその場に立って作成し、DBに保存する方式(READMEに「Doors are stored in a database for ease-of-use」と明記)。`doorId`はDB上のドアのID、`name`は任意で付けられる識別名。バージョンによって仕様が変わる場合があるため公式ドキュメントも確認すること。

### ox_fuel 正確な構文(要順守・憶測禁止。overextended.dev/ox_fuel 各ページで確認済み)

```lua
-- 支払い方法をカスタマイズする(ESXの例)
exports.ox_fuel:setPaymentMethod(function(playerId, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local bankAmount = xPlayer.getAccount('bank').money

    if bankAmount >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        return true
    end

    return false
end)

-- 現在の燃料残量を取得する(StateBag経由)
local fuel = Entity(vehicleNetId).state.fuel
```
> ※ox_fuelはox_inventoryと組み合わせて使う設計。`setMoneyCheck`で所持金チェック方法もカスタマイズできる。詳細は導入しているバージョンの公式ドキュメントを確認すること。

### cd_dispatch 正確な構文(要順守・憶測禁止。docs.codesign.pro/paid-scripts/dispatch/resource-integration で確認済み)

```lua
local data = exports['cd_dispatch']:GetPlayerInfo()

TriggerServerEvent('cd_dispatch:AddNotification', {
    job_table = { 'police' },
    coords = data.coords,
    title = '10-15 - Store Robbery',
    message = ('%sが%sで強盗をしています'):format(data.sex, data.street),
    flash = 0,
    unique_id = data.unique_id,
    sound = 1,
    blip = {
        sprite = 431,
        scale = 1.2,
        colour = 3,
        flashes = false,
        text = '911 - Store Robbery',
        time = 5,
        radius = 0,
    }
})
```
> ※`job_table`に通知先のjob名を配列で指定する。`GetPlayerInfo`エクスポートで現在地・性別・通り名などを取得できる。cd_dispatchは有償スクリプトであり、バージョンによってフィールドが増減する場合があるため公式ドキュメントを確認すること。

### illenium-appearance 正確な構文(要順守・憶測禁止。github.com/iLLeniumStudios/illenium-appearance ソースコードで確認済み)

```lua
-- キャラクリエイト画面を開く(client側)
exports['illenium-appearance']:startPlayerCustomization(function(appearance)
    if appearance then
        -- 確定された場合、appearanceに見た目データが入る
        TriggerServerEvent('myscript:saveAppearance', appearance)
    else
        -- キャンセルされた場合はnilが渡る
    end
end)
```
> ※第2引数に設定用のconfigテーブルを渡すこともできる。QBCore/ESX両対応をうたうリソースで、バージョンによってconfigの項目が変わる場合があるため公式ドキュメント(docs.illenium.dev)も確認すること。

### qb-clothing 正確な構文(要順守・憶測禁止。github.com/qbcore-framework/qb-clothing の client.lua で確認済み)

```lua
-- 服屋(見た目編集含む)メニューを開く
TriggerEvent('qb-clothing:client:openMenu')

-- 保存済みのワードローブ(アウトフィット)一覧を開く
TriggerEvent('qb-clothing:client:openOutfitMenu')
```
> ※どちらも引数なしで呼び出すclientイベント。実際にどの店舗でどちらを開くかは、Tier3の`ox_target`/`qb-target`のインタラクションと組み合わせて実装することが多い。バージョンによってイベント名が変わる場合があるため、導入しているqb-clothingのソースコード・ドキュメントも確認すること。

### Renewed-Banking 正確な構文(要順守・憶測禁止。renewed.dev/banking/exports で確認済み)

```lua
-- 口座残高を取得する(存在しない場合はfalse)
local amount = exports['Renewed-Banking']:getAccountMoney(account)

-- 入金する(成功時true)
local success = exports['Renewed-Banking']:addAccountMoney(account, 500)

-- 出金する(成功時true)
local success2 = exports['Renewed-Banking']:removeAccountMoney(account, 200)

-- 職業(job)ごとの組織口座を新規作成する
exports['Renewed-Banking']:CreateJobAccount(jobTable, initialBalance)
```
> ※`account`にはjob名や個人の識別子を指定する。okokBanking(Tier4-06)とは別の銀行スクリプトで、両方を同時に導入することは通常ない(どちらか一方を選ぶ)。バージョンによって仕様が変わる場合があるため公式ドキュメントも確認すること。

---

## Tier 5: 上級(⚫ advanced)— 安定したサーバーを作れるようになる

| ID | タイトル | カテゴリ | 前提 | 内容の要点 |
|---|---|---|---|---|
| `t5-01-performance-resmon` | パフォーマンス計測と最適化 | `performance` | t2-05 | F8コンソールの`resmon 1`でリソースごとの負荷を確認、`Wait()`の値を調整する考え方、無限ループの危険性の再確認 |
| `t5-02-async-db-patterns` | 非同期DB処理のパターン | `database`, `performance` | t3-03 | コールバック地獄を避ける設計、処理の直列化と並列化の使い分け |
| `t5-03-statebags` | StateBagsによる同期 | `events`, `performance` | t4-01 | Entity StateBag / Player StateBagを使った効率的なデータ同期(頻繁なイベント発火の代替) |
| `t5-04-security-hardening` | セキュリティ強化(チート対策) | `security` | t3-05 | サーバー権威設計の徹底、よくある改ざん手口とその対策パターン |
| `t5-05-advanced-nui` | 高度なNUI(React等の活用) | `nui` | t3-02 | ビルドツール(Vite等)を使ったNUI構築の考え方と、この学習サイトのようなビルドレス構成との違い・使い分け |
| `t5-06-metatables-oop` | メタテーブルで疑似クラスを作る | `lua-basics` | t1-06 | `setmetatable`/`__index`でLuaにクラス・インスタンスの概念を持ち込む |
| `t5-07-coroutines-basics` | コルーチンの基礎 | `lua-basics` | t2-05 | `coroutine.create`/`resume`/`yield`の仕組みと`CreateThread`との違い |
| `t5-08-routing-buckets` | ルーティングバケットでインスタンスを分ける | `performance`, `world` | t4-01 | `SetPlayerRoutingBucket`/`SetEntityRoutingBucket`でプレイヤーごとに異なるインスタンス(次元)を作る |
| `t5-09-statebags-advanced` | StateBagsの応用パターン | `performance`, `events` | t5-03 | 複雑なテーブルを持たせる設計、変更検知の絞り込み、ルーティングバケットとの併用 |
| `t5-10-streaming-culling` | エンティティのストリーミング距離・カリング調整 | `performance` | t5-01 | `SetEntityDistanceCullingRadius`等で大量エンティティ配置時の負荷を制御 |

---

## カテゴリキー一覧(`docs/ARCHITECTURE.md`と同期させること)

`environment`, `lua-basics`, `npc-entity`, `nui`, `database`, `framework`, `okok`, `lb-phone`, `events`, `performance`, `security`, `vehicle`, `animation`, `targeting`, `ui-library`, `world`, `effects`, `appearance`, `camera`, `gameplay`, `admin-tools`, `voice`, `dispatch`, `crime`, `law-enforcement`, `housing`

## 今後レッスンを追加する場合のルール

- 既存のカテゴリキーのいずれかに必ず分類する。新しいカテゴリが本当に必要な場合は、`docs/ARCHITECTURE.md`・`docs/DESIGN_SYSTEM.md`(バッジ絵文字)・このファイルの一覧表を同時に更新する。
- 新しい外部スクリプトとの連携レッスンを追加する場合、okok/lb-phone/ox_target/ox_libのセクションと同様に「正確な構文」ブロックを設け、実際のドキュメント/READMEで確認した構文のみを記載する。裏取りが不十分な場合は、Qbox/ox_coreの節のように確度の限界を明記した上で掲載するか、確認できるまで実装を止めてユーザーに確認する。
