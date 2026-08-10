// assets/js/nav.js — 共通ヘッダー/パンくず/前後レッスンリンクの描画

// lessons/tierX/*.html は2階層下にあるため、ルートへの相対パスを判定する
function computeSiteRoot() {
  return /\/lessons\//.test(window.location.pathname) ? "../../" : "";
}

function findLessonById(id) {
  return (window.LESSONS || []).find((l) => l.id === id);
}

function renderSiteHeader() {
  const el = document.getElementById("site-header");
  if (!el) return;
  const root = computeSiteRoot();
  el.className = "site-header";
  el.innerHTML = `
    <div class="site-header__inner">
      <a class="site-header__title" href="${root}index.html">FiveMスクリプト学習</a>
      <nav class="site-header__links">
        <a href="${root}index.html">難易度別ロードマップ</a>
        <a href="${root}category.html">カテゴリ別一覧</a>
      </nav>
    </div>
  `;
}

function renderBreadcrumb() {
  const el = document.getElementById("breadcrumb");
  if (!el) return;
  const root = computeSiteRoot();
  const lessonId = document.body.dataset.lessonId;

  if (!lessonId) {
    el.innerHTML = "";
    return;
  }

  const lesson = findLessonById(lessonId);
  if (!lesson) {
    el.innerHTML = "";
    return;
  }

  const tierInfo = window.TIER_INFO[lesson.tier];
  el.className = "breadcrumb";
  el.innerHTML = `
    <a href="${root}index.html">トップ</a>
    <span> / </span>
    <a href="${root}index.html">${tierInfo.emoji} ${tierInfo.label}</a>
    <span> / </span>
    <span>${lesson.title}</span>
  `;
}

function renderPrevNextNav() {
  const el = document.getElementById("prev-next-nav");
  if (!el) return;
  const lessonId = document.body.dataset.lessonId;
  if (!lessonId) return;

  const lessons = window.LESSONS || [];
  const index = lessons.findIndex((l) => l.id === lessonId);
  if (index === -1) return;

  const root = computeSiteRoot();
  const prev = index > 0 ? lessons[index - 1] : null;
  const next = index < lessons.length - 1 ? lessons[index + 1] : null;

  el.className = "prev-next-nav";
  el.innerHTML = `
    ${
      prev
        ? `<a href="${root}${prev.path}"><span class="prev-next-nav__label">← 前のレッスン</span>${prev.title}</a>`
        : `<span></span>`
    }
    ${
      next
        ? `<a class="prev-next-nav__next" href="${root}${next.path}"><span class="prev-next-nav__label">次のレッスン →</span>${next.title}</a>`
        : `<span></span>`
    }
  `;
}

function renderSiteFooter() {
  const el = document.getElementById("site-footer");
  if (!el) return;
  el.className = "site-footer";
  el.innerHTML = `<p>FiveMスクリプト学習サイト — 個人学習用の非公式コンテンツです</p>`;
}

function initNav() {
  renderSiteHeader();
  renderBreadcrumb();
  renderPrevNextNav();
  renderSiteFooter();
}

window.addEventListener("DOMContentLoaded", initNav);
