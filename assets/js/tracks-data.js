// assets/js/tracks-data.js — 全プロジェクトトラックの唯一の情報源(Single Source of Truth)
// トラックを追加・変更する場合は、必ず対応するHTMLファイル(tracks/*.html)と docs/TRACK_OUTLINE.md も同時に更新すること。
// トラックは「順序付きの索引」であり、レッスン・演習そのものの内容はここには持たない(id経由でlessons-data.js/exercises-data.jsを参照する)。

const TRACKS = [
  {
    id: "track-lb-phone-app",
    title: "lb-phoneアプリ開発トラック",
    emoji: "📱",
    summary: "「アプリが存在しない」状態から、画面遷移・DB永続化・新着通知バッジまで揃った自作lb-phoneアプリを完成させるまでの通し道です。",
    goal: "配車/デリバリー依頼アプリ、またはメッセージ/掲示板アプリを1本、公開できる状態まで作りきる。",
    steps: [
      { type: "lesson", id: "t3-01-nui-basics", note: "前提: NUI(画面UI)の基礎を確認する" },
      { type: "lesson", id: "t3-02-nui-callback", note: "前提: NUIコールバック(双方向通信)の基礎を確認する" },
      { type: "lesson", id: "t3-06-exports-between-resources", note: "前提: exportsで関数を公開する方法を確認する" },
      { type: "lesson", id: "t4-04-lb-phone-custom-app", note: "lb-phoneにカスタムアプリを登録する" },
      { type: "lesson", id: "t4-21-lb-phone-starter-template", note: "コピペで動くアプリの雛形一式(fxmanifest/ui/client/config)を作る" },
      { type: "lesson", id: "t4-05-lb-phone-nui-bridge", note: "アプリのUIとLua間の通信(SendCustomAppMessage)を学ぶ" },
      { type: "lesson", id: "t4-22-lb-phone-screen-navigation", note: "リスト画面→詳細画面のような画面遷移を実装する" },
      { type: "lesson", id: "t3-38-nui-escape-key", note: "戻る/閉じる操作の標準パターンを電話アプリに応用する" },
      { type: "lesson", id: "t3-03-database-oxmysql", note: "前提: DB連携(oxmysql)の基礎を確認する" },
      { type: "lesson", id: "t3-32-oxmysql-modern-api", note: "モダンAPI(MySQL.insert/update/scalar)でのDB操作を確認する" },
      { type: "lesson", id: "t4-23-lb-phone-notification-badge", note: "アプリアイコンに新着通知バッジを表示する" },
      { type: "lesson", id: "t3-34-ox-lib-input-dialog", note: "アプリ内フォームにox_libのinputDialogを活用する" },
      { type: "lesson", id: "t3-35-ox-lib-context-menu", note: "アプリ内メニューにox_libのコンテキストメニューを活用する" },
      { type: "exercise", id: "ex-08-lb-phone-messaging-app", note: "演習: DB永続化中心のメッセージ/掲示板アプリを作る" },
      { type: "exercise", id: "ex-09-lb-phone-delivery-app", note: "演習: リアルタイムのプレイヤー間連携が中心の配車/デリバリーアプリを作る" },
      { type: "lesson", id: "t3-09-multi-resource-structure", note: "仕上げ: 複数resourceの構成を整理し、公開できる状態にする" },
    ],
  },
  {
    id: "track-crime-script",
    title: "犯罪script開発トラック(犯罪側+警察側)",
    emoji: "🚨",
    summary: "犯罪行為(窃盗・薬物・故売・洗浄)から、警察側の対応(通報・逮捕・投獄・証拠品管理)までの一連のRPエコシステムを完成させる通し道です。",
    goal: "犯罪側・警察側の両方が揃った、麻薬密売シンジケート演習(ex-11)を完成させる。",
    steps: [
      { type: "lesson", id: "t3-05-server-validation", note: "前提: サーバー権威設計(サーバー側で検証する考え方)を再確認する" },
      { type: "lesson", id: "t5-04-security-hardening", note: "前提: チート対策・改ざん対策の考え方を再確認する" },
      { type: "lesson", id: "t4-14-ox-doorlock", note: "強盗・侵入の基本(ドア解錠)を確認する" },
      { type: "lesson", id: "t4-24-wanted-level-system", note: "指名手配度(Wanted Level)システムを実装する" },
      { type: "lesson", id: "t3-23-crafting-system", note: "前提: クラフト(製作)システムの基礎を確認する" },
      { type: "lesson", id: "t3-24-fishing-mining-minigame", note: "前提: 採掘などのミニゲームループを確認する" },
      { type: "exercise", id: "ex-10-drug-production-chain", note: "演習: 栽培→精製→販売の違法薬物生産チェーンを作る" },
      { type: "lesson", id: "t4-25-fence-black-market", note: "故売/闇市場(fence NPC)システムを実装する" },
      { type: "lesson", id: "t4-26-chop-shop", note: "盗難車両の解体(チョップショップ)を実装する" },
      { type: "lesson", id: "t4-10-business-account-management", note: "前提: ビジネス/組織口座の管理を確認する" },
      { type: "lesson", id: "t4-27-money-laundering", note: "マネーロンダリング(汚れた金の洗浄)を実装する" },
      { type: "lesson", id: "t4-16-cd-dispatch", note: "cd_dispatchで警察側に無線通知を送る" },
      { type: "lesson", id: "t4-28-mdt-police-terminal", note: "警察端末(MDT)の基礎を実装する" },
      { type: "lesson", id: "t4-29-arrest-handcuff-system", note: "逮捕・拘束(handcuff)システムを実装する" },
      { type: "lesson", id: "t4-30-jail-system", note: "投獄(Jail)システムを実装する" },
      { type: "lesson", id: "t3-37-ox-inventory-stashes", note: "前提: ox_inventoryのRegisterStash(倉庫)を確認する" },
      { type: "lesson", id: "t4-31-evidence-management", note: "証拠品・押収品管理を実装する" },
      { type: "lesson", id: "t3-22-discord-webhook-log", note: "管理者監視ログ(Discord Webhook)を確認する" },
      { type: "exercise", id: "ex-11-drug-syndicate-capstone", note: "集大成演習: 犯罪側+警察側を統合した麻薬密売シンジケートを作る" },
    ],
  },
];

window.TRACKS = TRACKS;
