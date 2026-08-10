// assets/js/code-copy.js — コードブロックのコピーボタン
// navigator.clipboard を優先使用し、非対応/失敗時は execCommand('copy') にフォールバックする。

function fallbackCopy(text) {
  const textarea = document.createElement("textarea");
  textarea.value = text;
  textarea.style.position = "fixed";
  textarea.style.opacity = "0";
  document.body.appendChild(textarea);
  textarea.select();
  try {
    document.execCommand("copy");
  } catch (e) {
    // コピーに失敗しても致命的ではないため無視する
  }
  document.body.removeChild(textarea);
}

function copyText(text) {
  if (navigator.clipboard && window.isSecureContext) {
    return navigator.clipboard.writeText(text).catch(() => fallbackCopy(text));
  }
  fallbackCopy(text);
  return Promise.resolve();
}

function initCodeCopyButtons() {
  document.querySelectorAll(".code-block").forEach((block) => {
    const codeEl = block.querySelector("pre code");
    if (!codeEl) return;

    const button = document.createElement("button");
    button.type = "button";
    button.className = "code-block__copy";
    button.textContent = "コピー";
    block.appendChild(button);

    button.addEventListener("click", () => {
      copyText(codeEl.textContent).then(() => {
        const original = button.textContent;
        button.textContent = "コピーしました";
        setTimeout(() => {
          button.textContent = original;
        }, 1500);
      });
    });
  });
}

window.addEventListener("DOMContentLoaded", initCodeCopyButtons);
