// script.js — lb-phoneアプリのスターターテンプレート
// lb-phone本体からは SendCustomAppMessage 経由でデータが送られてくる想定

function handleAppMessage(data) {
  if (data.action !== "open") return;

  document.getElementById("app").style.display = "flex";
  document.getElementById("app-title").textContent = data.title || "マイアプリ";

  const body = document.getElementById("app-body");
  body.innerHTML = ""; // 前回の表示をクリアする

  if (!data.items || data.items.length === 0) {
    body.innerHTML = '<p id="placeholder">表示するデータがありません</p>';
    return;
  }

  data.items.forEach((item) => {
    const el = document.createElement("p");
    el.textContent = item;
    body.appendChild(el);
  });
}

// lb-phone本番環境: lb-phone側のSendCustomAppMessageがこのイベントを発火させる
window.addEventListener("message", (event) => {
  handleAppMessage(event.data);
});

// ここから下はブラウザで直接開いて動作確認するためのデモ用コードです(本番のlb-phone環境には不要)
document.getElementById("demo-trigger").addEventListener("click", () => {
  handleAppMessage({
    action: "open",
    title: "マイアプリ",
    items: ["1件目のデータ", "2件目のデータ", "3件目のデータ"],
  });
});
