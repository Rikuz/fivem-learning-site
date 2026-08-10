# CONTENT_OUTLINE.md — カリキュラム設計(全25レッスン)

このドキュメントが**コンテンツ制作の唯一の正とする仕様書**です。Claude Codeはレッスン本文を書く際、必ずこの一覧の説明・使用構文に従ってください。ここに書かれていない仕様を憶測で追加しないこと。

5つのtier × 各5レッスン = 計25レッスンをMVP(Phase 1実装範囲)とする。将来的にレッスンを追加する場合も、同じtier構造・カテゴリキーを使うこと。

---

## Tier 1: 入門(🟢 beginner)— 何もわからない状態からスタート

| ID | タイトル | カテゴリ | 前提 | 内容の要点 |
|---|---|---|---|---|
| `t1-01-setup-environment` | 開発環境を整える | `environment` | なし | txAdminでのローカルサーバー起動、VS Code + Lua用拡張機能の導入、resourcesフォルダの場所を理解する |
| `t1-02-lua-basics` | Lua基礎文法 | `lua-basics` | t1-01 | 変数、テーブル(連想配列)、関数、if文、for/whileループ、`print()`によるデバッグ出力 |
| `t1-03-first-script` | 最初のスクリプトを作る | `lua-basics`, `environment` | t1-02 | resourceフォルダ作成 → `fxmanifest.lua`作成 → `server.cfg`に`ensure`追加 → F8コンソールで動作確認(公式チュートリアル準拠の"Hello World") |
| `t1-04-fxmanifest` | fxmanifest.luaを理解する | `environment` | t1-03 | `fx_version`, `game`, `client_script`, `server_script`, `shared_script`, `dependency`の意味と使い分け |
| `t1-05-debug-basics` | デバッグの基本 | `lua-basics` | t1-03 | F8コンソールの開き方、エラーメッセージの読み方(ファイル名・行番号の見方)、`print()`を使った原因の切り分け方 |

---

## Tier 2: 初級(🟡 novice)— 動くものを少しずつ作れるようになる

| ID | タイトル | カテゴリ | 前提 | 内容の要点 |
|---|---|---|---|---|
| `t2-01-events-basics` | イベントの基礎(client↔server通信) | `events` | t1-05 | `RegisterNetEvent`, `TriggerServerEvent`, `TriggerClientEvent`。なぜクライアント/サーバーで処理を分けるか |
| `t2-02-spawn-npc` | NPCを配置する | `npc-entity` | t2-01 | `CreatePed`でNPCを生成、`FreezeEntityPosition`で固定、`DeletePed`で削除。座標の取得方法(`GetEntityCoords`) |
| `t2-03-blip-marker` | Blip/Markerを表示する | `npc-entity` | t2-02 | `AddBlipForCoord`でミニマップにアイコン表示、`DrawMarker`で3D空間にマーカー表示 |
| `t2-04-commands` | コマンドを登録する | `events` | t2-01 | `RegisterCommand`、権限チェックの基本(`IsPlayerAceAllowed`) |
| `t2-05-threads-loops` | スレッドとループ | `lua-basics`, `performance` | t2-01 | `CreateThread`、`Wait()`を絶対に省略してはいけない理由(1フレームごとにCPUを専有し、サーバー全体を重くする) |

---

## Tier 3: 中級(🟠 intermediate)— 画面とデータを扱えるようになる

| ID | タイトル | カテゴリ | 前提 | 内容の要点 |
|---|---|---|---|---|
| `t3-01-nui-basics` | NUIの基礎(画面UIを表示する) | `nui` | t2-05 | `fxmanifest.lua`に`ui_page`を指定、`SendNUIMessage`でLua→JS方向にデータを送る、`SetNuiFocus`でマウス操作を有効化 |
| `t3-02-nui-callback` | NUIコールバック(双方向通信) | `nui` | t3-01 | `RegisterNUICallback`でJS→Lua方向を受け取る、JS側の`fetch()`による送信パターン |
| `t3-03-database-oxmysql` | DB連携の基礎(oxmysql) | `database` | t2-01 | `oxmysql`のインストール、`MySQL.Async.fetchAll` / `MySQL.Async.execute`によるSELECT/INSERTの基本、コールバックの受け方 |
| `t3-04-items-inventory` | アイテム・インベントリの基本 | `database`, `framework` | t3-03 | シンプルなアイテム所持データの管理例(テーブル設計 + 増減処理)に加えて、下記「ox_inventory 正確な構文」を使用し実際のexportも紹介する |
| `t3-05-server-validation` | サーバー側バリデーション | `security` | t3-03 | クライアントから送られた値を無条件に信用しない設計、サーバー側での再チェックの実装例 |

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

---

## Tier 5: 上級(⚫ advanced)— 安定したサーバーを作れるようになる

| ID | タイトル | カテゴリ | 前提 | 内容の要点 |
|---|---|---|---|---|
| `t5-01-performance-resmon` | パフォーマンス計測と最適化 | `performance` | t2-05 | F8コンソールの`resmon 1`でリソースごとの負荷を確認、`Wait()`の値を調整する考え方、無限ループの危険性の再確認 |
| `t5-02-async-db-patterns` | 非同期DB処理のパターン | `database`, `performance` | t3-03 | コールバック地獄を避ける設計、処理の直列化と並列化の使い分け |
| `t5-03-statebags` | StateBagsによる同期 | `events`, `performance` | t4-01 | Entity StateBag / Player StateBagを使った効率的なデータ同期(頻繁なイベント発火の代替) |
| `t5-04-security-hardening` | セキュリティ強化(チート対策) | `security` | t3-05 | サーバー権威設計の徹底、よくある改ざん手口とその対策パターン |
| `t5-05-advanced-nui` | 高度なNUI(React等の活用) | `nui` | t3-02 | ビルドツール(Vite等)を使ったNUI構築の考え方と、この学習サイトのようなビルドレス構成との違い・使い分け |

---

## カテゴリキー一覧(`docs/ARCHITECTURE.md`と同期させること)

`environment`, `lua-basics`, `npc-entity`, `nui`, `database`, `framework`, `okok`, `lb-phone`, `events`, `performance`, `security`

## 今後レッスンを追加する場合のルール

- 既存の11カテゴリキーのいずれかに必ず分類する。新しいカテゴリが本当に必要な場合は、`docs/ARCHITECTURE.md`の一覧表とこのファイルの両方を同時に更新する。
- 新しい外部スクリプトとの連携レッスンを追加する場合、okok/lb-phoneのセクションと同様に「正確な構文」ブロックを設け、実際のドキュメント/READMEで確認した構文のみを記載する。
