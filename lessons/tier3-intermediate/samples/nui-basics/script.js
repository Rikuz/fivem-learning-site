// script.js — Lua側のSendNUIMessageから送られてきたデータを画面に反映する

function handleMessage(data) {
  if (data.action === "open") {
    document.getElementById("app").style.display = "block";
    document.getElementById("message").textContent = data.message;
  }
}

// FiveM本番環境: Lua側のSendNUIMessageがこのイベントを発火させる
window.addEventListener("message", (event) => {
  handleMessage(event.data);
});

// ここから下はブラウザで直接開いて動作確認するためのデモ用コードです(本番のFiveM環境には不要)
document.getElementById("demo-trigger").addEventListener("click", () => {
  handleMessage({ action: "open", message: "ようこそ!(デモ表示)" });
});
