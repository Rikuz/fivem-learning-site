// script.js — JS側からLua側のRegisterNUICallbackへfetch()で通知するパターン

function getResourceName() {
  // FiveM本番環境ではGetParentResourceName()が使える。ブラウザ単体で開いたときは存在しないのでデモ用の名前にフォールバックする
  return typeof GetParentResourceName === "function" ? GetParentResourceName() : "nui-callback-demo";
}

async function closeNui() {
  try {
    await fetch(`https://${getResourceName()}/closeNui`, {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: JSON.stringify({}),
    });
  } catch (e) {
    // ブラウザ単体でのデモではfetch先が存在しないため失敗する。本番のFiveM環境では正常に届く
  }
  document.getElementById("app").style.display = "none";
}

document.getElementById("close-btn").addEventListener("click", closeNui);
