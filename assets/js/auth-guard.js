// assets/js/auth-guard.js — 簡易ログインゲート(クライアント側のみ・実際のアクセス制御にはならない)
// 各HTMLの<head>の先頭(CSS読み込みより前)に配置し、未ログイン時はlogin.htmlへ即リダイレクトする。
// login.html自体にはこのスクリプトを含めないこと(無限リダイレクトになる)。

(function () {
  if (localStorage.getItem("fivemSiteAuthed") === "true") return;

  var path = window.location.pathname;
  var root = "";
  if (/\/lessons\//.test(path)) root = "../../";
  else if (/\/(practice|tracks|samples|reference|templates|recipes)\//.test(path)) root = "../";

  var target = window.location.pathname + window.location.search + window.location.hash;
  window.location.replace(root + "login.html?redirect=" + encodeURIComponent(target));
})();
