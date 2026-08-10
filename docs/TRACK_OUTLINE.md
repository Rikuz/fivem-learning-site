# TRACK_OUTLINE.md — プロジェクトトラック設計(目次確定版・実装は未着手)

このドキュメントは、`docs/CONTENT_OUTLINE.md`(レッスン)・`docs/EXERCISE_OUTLINE.md`(演習)と同格の、**プロジェクトトラックの唯一の正**となる設計書です。2026-08-10時点では**目次(ロードマップ)のみ確定済みで、`tracks.html`/`tracks/*.html`・新規レッスン・新規演習の実装はまだ行っていません**。着手する際は、このファイルの内容に従い、外部スクリプトに依存するステップ(MDT等)は実装前に必ず公式ドキュメントで構文を確認すること(`CONTENT_OUTLINE.md`の「コンテンツの正確性について」と同じ方針)。

## プロジェクトトラックとは

これまでのサイトには「Tier別ロードマップ(難易度順)」「カテゴリ別逆引き検索(概念別)」という2つの入口があったが、「lb-phoneアプリを1本作りきる」「犯罪(ゲーム内)scriptを1本作りきる」のような**目的ベースの通し道**がなかった。プロジェクトトラックは、既存レッスン・新規レッスン・演習を1つの完成物に向けて順序付けした、3つ目の入口となる。

- トラック自体は新しいレッスンの寄せ集めではなく、**既存コンテンツへの導線を中心に、本当に足りない部分だけ新規レッスン/演習を追加する**という考え方で設計する。
- レッスン本体の執筆ルール(結論→説明→コード例→注意点→補足、コード省略禁止、外部スクリプトは公式ドキュメントで裏取り)は`CLAUDE.md`の既存ルールをそのまま適用する。トラックページ自体は「順路の索引」に徹し、独自の内容は持たない。

## データ構造(実装時の指針)

`assets/js/tracks-data.js`に`TRACKS`配列を持たせる想定。

```js
const TRACKS = [
  {
    id: "track-lb-phone-app",
    title: "lb-phoneアプリ開発トラック",
    summary: "...",
    steps: [
      { type: "lesson", id: "t3-01-nui-basics", note: "前提: NUIの基礎" },
      { type: "lesson", id: "t4-lbphone-starter-template", note: "新規: スターターテンプレート" },
      { type: "exercise", id: "ex-lbphone-messaging-app", note: "新規演習: 簡易メッセージアプリ" },
      // ...
    ],
  },
  // track-crime-script
];
window.TRACKS = TRACKS;
```

`tracks.html`は`practice.html`と同様の一覧ページ、`tracks/*.html`は各トラックの詳細(ステップを順番に並べたチェックリスト。演習ページと同じ完了トグルの仕組みを再利用する)を想定する。

---

## トラック1: lb-phoneアプリ開発トラック(全12ステップ)

**目的**: 「アプリが存在しない」状態から、DB永続化・通知バッジ・画面遷移まで揃った自作lb-phoneアプリを完成させる。

| # | ステップ | 種別 | 内容 |
|---|---|---|---|
| 1 | NUIの基礎/コールバック/exportsの復習 | 既存レッスン | `t3-01-nui-basics`, `t3-02-nui-callback`, `t3-06-exports-between-resources`(前提確認) |
| 2 | lb-phoneにカスタムアプリを追加する | 既存レッスン | `t4-04-lb-phone-custom-app`(`Config.CustomApps`登録) |
| 3 | **lb-phoneアプリのスターターテンプレート** | 🆕新規レッスン | コピペで動く完成雛形一式(fxmanifest.lua、ui/index.html、client.lua、config登録)を初めてひとまとめに提示する |
| 4 | lb-phoneアプリのUIとLua間通信 | 既存レッスン | `t4-05-lb-phone-nui-bridge`(`SendCustomAppMessage`) |
| 5 | **アプリ内の画面遷移パターン** | 🆕新規レッスン | リスト画面→詳細画面のようなSPA的なJSルーティングの基礎 |
| 6 | **戻る/閉じるの標準操作** | 🆕新規レッスン | `t3-38-nui-escape-key`の考え方を電話の「戻るボタン」に応用 |
| 7 | DB連携(基礎+モダンAPI) | 既存レッスン | `t3-03-database-oxmysql`, `t3-32-oxmysql-modern-api`(データ永続化の前提) |
| 8 | **アプリの新着通知バッジ** | 🆕新規レッスン | `SendCustomAppMessage`の応用でアプリアイコンに未読件数を表示する |
| 9 | ox_lib入力ダイアログ/コンテキストメニューの応用 | 既存レッスン | `t3-34-ox-lib-input-dialog`, `t3-35-ox-lib-context-menu`(アプリ内フォームへの活用) |
| 10 | **演習: 簡易メッセージ/掲示板アプリ** | 🆕新規演習 | `ex-02-simple-shop`(NUI+DB)のパターンをlb-phone文脈に適用する |
| 11 | **演習: 配車/デリバリー依頼アプリ** | 🆕新規演習 | アプリからのNPCイベント発火・Blip表示(`t2-03-blip-marker`)と連携させる |
| 12 | 複数resourceの構成整理 | 既存レッスン | `t3-09-multi-resource-structure`(仕上げ・公開準備) |

**新規に必要なもの**: レッスン3件(スターターテンプレート/画面遷移/通知バッジ)、演習2件(メッセージアプリ/配車アプリ)。外部スクリプトはlb-phone(既存Tier4-04/05で構文確認済み)の範囲内で収まる見込み。

---

## トラック2: 犯罪script開発トラック(犯罪側+警察側、全14ステップ)

**目的**: 犯罪行為(窃盗・薬物・故売・資金洗浄)から、警察側の対応(通報受理・逮捕・投獄・証拠管理)までの一連のRPエコシステムを完成させる。

新カテゴリ2種を追加する想定: `crime`🚨(犯罪行為)、`law-enforcement`👮(警察業務)。

### 犯罪側(#1〜8)

| # | ステップ | 種別 | 内容 |
|---|---|---|---|
| 1 | サーバー権威設計の再確認 | 既存レッスン | `t3-05-server-validation`, `t5-04-security-hardening`(前提確認) |
| 2 | 強盗・侵入の基本(ドア解錠) | 既存レッスン+既存演習 | `t4-14-ox-doorlock`、演習`ex-07-heist-mission`の考え方を一般化 |
| 3 | **指名手配度(Wanted Level)システム** | 🆕新規レッスン | 犯罪行為でスターが上昇し、警察側(トラック後半のMDT)に可視化される仕組み |
| 4 | **演習: 違法薬物の生産チェーン** | 🆕新規演習 | 栽培→精製→販売。`t3-23-crafting-system`・`t3-24-fishing-mining-minigame`の応用 |
| 5 | **故売/闇市場(fence NPC)システム** | 🆕新規レッスン | 盗品をNPCに売却して現金化する(ox_target応用) |
| 6 | **盗難車両の解体(チョップショップ)** | 🆕新規レッスン | `t2-06-spawn-vehicle`の車両操作を応用した解体処理 |
| 7 | **マネーロンダリング** | 🆕新規レッスン | `t4-10-business-account-management`(組織口座)と接続し、汚れた金を正規化する流れ |
| 8 | 警察への通報連携 | 既存レッスン | `t4-16-cd-dispatch` |

### 警察側(#9〜14)

| # | ステップ | 種別 | 内容 |
|---|---|---|---|
| 9 | **MDT(警察端末)の基礎** | 🆕新規レッスン | 犯罪履歴・指名手配情報を確認するNUI画面。要外部スクリプト裏取り(ps-mdt等、実装時に公式ドキュメント確認) |
| 10 | **逮捕・拘束(handcuff)システム** | 🆕新規レッスン | 対象プレイヤーを拘束・護送する基本(アニメーション同期含む) |
| 11 | **投獄(Jail)システム** | 🆕新規レッスン | 行動制限+時間経過での自動釈放 |
| 12 | **証拠品・押収品管理** | 🆕新規レッスン | `t3-37-ox-inventory-stashes`(RegisterStash)の応用でevidence bagを実装 |
| 13 | 管理者監視ログ | 既存レッスン | `t3-22-discord-webhook-log` |
| 14 | **演習: 麻薬密売シンジケート(集大成)** | 🆕新規演習 | 犯罪側+警察側の両要素を統合する、演習`ex-07`に続く8件目の演習(`ex-08`相当) |

**新規に必要なもの**: レッスン9件、演習2件、新カテゴリ2種。ステップ9(MDT)は外部スクリプトへの依存が濃厚なため、実装着手時に最優先で構文の裏取りを行うこと。

---

## 実装時のチェックリスト(着手時に参照)

**2026-08-11時点で実装完了。** 以下は実施済みの記録として残す。

- [x] `assets/js/tracks-data.js`を新設し、`TRACKS`配列を定義する
- [x] `tracks.html`(一覧)・`tracks/*.html`(2本)を作成する。`nav.js`の`computeSiteRoot()`・ヘッダーリンクに`tracks.html`を追加する(`practice.html`追加時と同じ手順)
- [x] 新規レッスン12件(lb-phone 3件 + 犯罪script 9件、実際にはMDT/handcuff/jail/evidence等を含め計11件)を`lessons/tierX/`に追加し、`lessons-data.js`にエントリを追加する
- [x] 新規演習4件を`practice/`に追加し、`exercises-data.js`にエントリを追加する
- [x] 新カテゴリ`crime`🚨・`law-enforcement`👮を`ARCHITECTURE.md`・`DESIGN_SYSTEM.md`・`CONTENT_OUTLINE.md`・`lessons-data.js`の`CATEGORY_INFO`/`CATEGORY_SUMMARY`に追加する
- [x] MDT等、外部スクリプトに依存するステップは自作(NUI+oxmysql+ox_target)で構成し、未検証の外部依存を導入しない設計にした(`28-mdt-police-terminal.html`のversion-note参照)
- [x] 全体検証(ファイル存在・ID重複・前提参照・ルート絶対パス)を実施してからコミット・デプロイする
