// assets/js/templates-data.js — 全テンプレートの唯一の情報源(Single Source of Truth)
// テンプレートは特定の演習(exercises-data.js)に紐づかない、汎用の出発点となる最小構成resource。
// サンプルコード(samples-data.js)が演習の「答え」であるのに対し、テンプレートは
// 「自分のオリジナルのアイデアを作り始めるときの土台」という位置づけ。

const TEMPLATES = [
  {
    id: "template-minimal",
    title: "最小構成テンプレート",
    summary: "fxmanifest.lua・client.lua・server.luaだけの、あらゆるresourceの出発点となる最小構成です。",
    dependencies: [],
    path: "templates/template-minimal.html",
    resources: [{ name: "tpl-minimal", files: ["fxmanifest.lua", "client.lua", "server.lua"] }],
  },
  {
    id: "template-nui",
    title: "NUI付きリソーステンプレート",
    summary: "開く/閉じる操作とJS↔Lua間の双方向通信を備えた、NUI画面付きresourceの土台です。",
    dependencies: [],
    path: "templates/template-nui.html",
    resources: [{ name: "tpl-nui", files: ["fxmanifest.lua", "client.lua", "ui/index.html", "ui/style.css", "ui/script.js"] }],
  },
  {
    id: "template-database",
    title: "DB連携(oxmysql)リソーステンプレート",
    summary: "テーブル作成・取得・保存の基本パターンを揃えた、oxmysql連携resourceの土台です。",
    dependencies: ["oxmysql"],
    path: "templates/template-database.html",
    resources: [{ name: "tpl-database", files: ["fxmanifest.lua", "server.lua", "schema.sql"] }],
  },
  {
    id: "template-framework",
    title: "フレームワーク連携(ESX/QBCore対応)リソーステンプレート",
    summary: "ESX/QBCore/Qboxを自動検知し、所持金・識別子取得を共通関数化したresourceの土台です。",
    dependencies: ["ESX または QBCore(任意)"],
    path: "templates/template-framework.html",
    resources: [{ name: "tpl-framework", files: ["fxmanifest.lua", "server.lua"] }],
  },
  {
    id: "template-ox-target",
    title: "ox_target連携リソーステンプレート",
    summary: "座標・モデル両方のインタラクション登録パターンを揃えた、ox_target連携resourceの土台です。",
    dependencies: ["ox_target"],
    path: "templates/template-ox-target.html",
    resources: [{ name: "tpl-ox-target", files: ["fxmanifest.lua", "client.lua"] }],
  },
  {
    id: "template-statebags",
    title: "StateBags同期リソーステンプレート",
    summary: "プレイヤーの状態を全clientに同期し、変化を監視して反映するマルチプレイヤー同期resourceの土台です。",
    dependencies: [],
    path: "templates/template-statebags.html",
    resources: [{ name: "tpl-statebags", files: ["fxmanifest.lua", "client.lua", "server.lua"] }],
  },
];

window.TEMPLATES = TEMPLATES;
