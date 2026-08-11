// assets/js/recipes-data.js — 全レシピの唯一の情報源(Single Source of Truth)
// レシピは1レッスンより大きく、プロジェクトトラックより小さい粒度で、
// 「既に基礎を知っている人向けに、2つ以上の技術の組み合わせ方だけを短く示す」ページ。

const RECIPES = [
  {
    id: "recipe-target-lb-phone",
    title: "ox_target × lb-phone: インタラクションをスマホ通知に連携する",
    summary: "ox_targetでの操作をきっかけに、lb-phoneアプリの新着通知バッジを更新する。",
    combines: ["t3-07-ox-target", "t4-23-lb-phone-notification-badge"],
    path: "recipes/recipe-target-lb-phone.html",
  },
  {
    id: "recipe-nui-statebags",
    title: "NUI × StateBags: 複数プレイヤーで共有されるUI状態を同期する",
    summary: "共有オブジェクトのStateBagsが変化したら、それを見ている全員のNUI表示を更新する。",
    combines: ["t3-01-nui-basics", "t5-03-statebags"],
    path: "recipes/recipe-nui-statebags.html",
  },
  {
    id: "recipe-dispatch-webhook",
    title: "cd_dispatch × Discord Webhook: 通報を警察とDiscordの両方に送る",
    summary: "1つの通報処理から、ゲーム内の警察通知とDiscordログを同時に発火する。",
    combines: ["t4-16-cd-dispatch", "t3-22-discord-webhook-log"],
    path: "recipes/recipe-dispatch-webhook.html",
  },
  {
    id: "recipe-inventory-banking",
    title: "ox_inventory × okokBanking: 所持アイテムで銀行手数料を割り引く",
    summary: "VIPカード等のアイテム所持数を確認し、銀行の出金手数料率を動的に変える。",
    combines: ["t3-30-ox-inventory-item-registry", "t4-06-okok-banking-integration"],
    path: "recipes/recipe-inventory-banking.html",
  },
  {
    id: "recipe-doorlock-job",
    title: "ox_doorlock × Job確認: 職業によって開閉できるドアを制限する",
    summary: "フレームワークのJob情報を確認してから、ox_doorlockのドアを解錠する。",
    combines: ["t4-14-ox-doorlock", "t4-02-framework-jobs"],
    path: "recipes/recipe-doorlock-job.html",
  },
  {
    id: "recipe-context-menu-db",
    title: "ox_libコンテキストメニュー × oxmysql: DBの内容から動的にメニューを作る",
    summary: "固定の選択肢ではなく、DBに保存された商品一覧からコンテキストメニューを組み立てる。",
    combines: ["t3-35-ox-lib-context-menu", "t3-32-oxmysql-modern-api"],
    path: "recipes/recipe-context-menu-db.html",
  },
  {
    id: "recipe-statebags-admin",
    title: "StateBags × 管理者ツール: プレイヤー一覧に拘束状態を表示する",
    summary: "Tier4-29の拘束状態(StateBags)を、管理者向けのプレイヤー一覧に反映する。",
    combines: ["t5-03-statebags", "t3-43-admin-player-list-spectate"],
    path: "recipes/recipe-statebags-admin.html",
  },
];

window.RECIPES = RECIPES;
