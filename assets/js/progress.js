// assets/js/progress.js — localStorageでの進捗管理
// 他のファイルからは必ずこのファイルが公開する関数だけを呼ぶこと。
// localStorageを直接触るコードを他ファイルに書かない(将来サーバー同期に差し替え可能にするため)。

const PROGRESS_STORAGE_KEY = "fivem-learn-progress";

function getProgress() {
  try {
    const raw = window.localStorage.getItem(PROGRESS_STORAGE_KEY);
    if (!raw) return {};
    const parsed = JSON.parse(raw);
    return parsed && typeof parsed === "object" ? parsed : {};
  } catch (e) {
    return {};
  }
}

function saveProgress(progress) {
  try {
    window.localStorage.setItem(PROGRESS_STORAGE_KEY, JSON.stringify(progress));
  } catch (e) {
    // localStorageが使えない環境(プライベートモード等)では進捗保存を諦める
  }
}

function isComplete(lessonId) {
  const progress = getProgress();
  return progress[lessonId] === true;
}

function markComplete(lessonId) {
  const progress = getProgress();
  progress[lessonId] = true;
  saveProgress(progress);
}

function markIncomplete(lessonId) {
  const progress = getProgress();
  progress[lessonId] = false;
  saveProgress(progress);
}

function toggleComplete(lessonId) {
  if (isComplete(lessonId)) {
    markIncomplete(lessonId);
  } else {
    markComplete(lessonId);
  }
  return isComplete(lessonId);
}

// tierを省略した場合は全体、指定した場合はそのtierのみの完了率(%)を返す
function getCompletionRate(tier) {
  const lessons = window.LESSONS || [];
  const target = tier ? lessons.filter((l) => l.tier === tier) : lessons;
  if (target.length === 0) return 0;
  const progress = getProgress();
  const doneCount = target.filter((l) => progress[l.id] === true).length;
  return Math.round((doneCount / target.length) * 100);
}

// 各ページ読み込み時に呼び出し、進捗バーやカードのチェックマークをDOMに反映する
function renderProgressUI() {
  // ヘッダー内の全体進捗バー(data-progress-summary属性を持つ要素)
  document.querySelectorAll("[data-progress-summary]").forEach((el) => {
    const tierAttr = el.getAttribute("data-progress-summary-tier");
    const tier = tierAttr ? Number(tierAttr) : undefined;
    const rate = getCompletionRate(tier);
    const fill = el.querySelector(".progress-bar__fill");
    const label = el.querySelector("[data-progress-label]");
    if (fill) fill.style.width = rate + "%";
    if (label) label.textContent = rate + "% 完了";
  });

  // レッスンカードの完了チェック(data-lesson-card属性にレッスンIDを持つ要素)
  document.querySelectorAll("[data-lesson-card]").forEach((el) => {
    const id = el.getAttribute("data-lesson-card");
    const check = el.querySelector("[data-complete-check]");
    if (isComplete(id)) {
      if (check) check.textContent = "✅";
    } else {
      if (check) check.textContent = "";
    }
  });

  // レッスンページ本体の完了トグル
  const toggleInput = document.getElementById("mark-complete-checkbox");
  if (toggleInput) {
    const lessonId = document.body.dataset.lessonId;
    const label = toggleInput.closest(".complete-toggle");
    toggleInput.checked = isComplete(lessonId);
    if (label) label.classList.toggle("is-complete", toggleInput.checked);

    toggleInput.addEventListener("change", () => {
      if (toggleInput.checked) {
        markComplete(lessonId);
      } else {
        markIncomplete(lessonId);
      }
      if (label) label.classList.toggle("is-complete", toggleInput.checked);
      renderProgressUI();
    });
  }
}

window.addEventListener("DOMContentLoaded", renderProgressUI);
