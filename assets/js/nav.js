// assets/js/nav.js — 共通ヘッダー/パンくず/前後レッスンリンクの描画

// lessons/tierX/*.html・tracks/*.html・samples/*.html は2階層/1階層下、practice/*.html は1階層下にあるため、ルートへの相対パスを判定する
function computeSiteRoot() {
  const path = window.location.pathname;
  if (/\/lessons\//.test(path)) return "../../";
  if (/\/practice\//.test(path)) return "../";
  if (/\/tracks\//.test(path)) return "../";
  if (/\/samples\//.test(path)) return "../";
  return "";
}

function findLessonById(id) {
  return (window.LESSONS || []).find((l) => l.id === id);
}

function findExerciseById(id) {
  return (window.EXERCISES || []).find((e) => e.id === id);
}

function findTrackById(id) {
  return (window.TRACKS || []).find((t) => t.id === id);
}

function findSampleById(id) {
  return (window.SAMPLES || []).find((s) => s.id === id);
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
        <a href="${root}practice.html">実践演習</a>
        <a href="${root}tracks.html">プロジェクトトラック</a>
        <a href="${root}samples.html">サンプルコード</a>
      </nav>
    </div>
  `;
}

function renderBreadcrumb() {
  const el = document.getElementById("breadcrumb");
  if (!el) return;
  const root = computeSiteRoot();
  const lessonId = document.body.dataset.lessonId;
  const trackId = document.body.dataset.trackId;
  const sampleId = document.body.dataset.sampleId;

  if (sampleId) {
    const sample = findSampleById(sampleId);
    if (sample) {
      const difficultyInfo = window.TIER_INFO[sample.difficulty];
      el.className = "breadcrumb";
      el.innerHTML = `
        <a href="${root}index.html">トップ</a>
        <span> / </span>
        <a href="${root}samples.html">サンプルコード</a>
        <span> / </span>
        <span>${difficultyInfo.emoji} ${sample.title}</span>
      `;
      return;
    }
  }

  if (trackId) {
    const track = findTrackById(trackId);
    if (track) {
      el.className = "breadcrumb";
      el.innerHTML = `
        <a href="${root}index.html">トップ</a>
        <span> / </span>
        <a href="${root}tracks.html">プロジェクトトラック</a>
        <span> / </span>
        <span>${track.emoji} ${track.title}</span>
      `;
      return;
    }
  }

  if (!lessonId) {
    el.innerHTML = "";
    return;
  }

  const lesson = findLessonById(lessonId);
  if (lesson) {
    const tierInfo = window.TIER_INFO[lesson.tier];
    el.className = "breadcrumb";
    el.innerHTML = `
      <a href="${root}index.html">トップ</a>
      <span> / </span>
      <a href="${root}index.html">${tierInfo.emoji} ${tierInfo.label}</a>
      <span> / </span>
      <span>${lesson.title}</span>
    `;
    return;
  }

  const exercise = findExerciseById(lessonId);
  if (exercise) {
    const difficultyInfo = window.TIER_INFO[exercise.difficulty];
    el.className = "breadcrumb";
    el.innerHTML = `
      <a href="${root}index.html">トップ</a>
      <span> / </span>
      <a href="${root}practice.html">実践演習</a>
      <span> / </span>
      <span>${difficultyInfo.emoji} ${exercise.title}</span>
    `;
    return;
  }

  el.innerHTML = "";
}

function renderPrevNextNav() {
  const el = document.getElementById("prev-next-nav");
  if (!el) return;
  const lessonId = document.body.dataset.lessonId;
  const sampleId = document.body.dataset.sampleId;
  const root = computeSiteRoot();

  if (sampleId) {
    const samples = [...(window.SAMPLES || [])].sort((a, b) => a.difficulty - b.difficulty);
    const sampleIndex = samples.findIndex((s) => s.id === sampleId);
    if (sampleIndex === -1) return;

    const prevSample = sampleIndex > 0 ? samples[sampleIndex - 1] : null;
    const nextSample = sampleIndex < samples.length - 1 ? samples[sampleIndex + 1] : null;

    el.className = "prev-next-nav";
    el.innerHTML = `
      ${
        prevSample
          ? `<a href="${root}${prevSample.path}"><span class="prev-next-nav__label">← 前のサンプル</span>${prevSample.title}</a>`
          : `<span></span>`
      }
      ${
        nextSample
          ? `<a class="prev-next-nav__next" href="${root}${nextSample.path}"><span class="prev-next-nav__label">次のサンプル →</span>${nextSample.title}</a>`
          : `<span></span>`
      }
    `;
    return;
  }

  if (!lessonId) return;
  const lessons = window.LESSONS || [];
  const lessonIndex = lessons.findIndex((l) => l.id === lessonId);

  if (lessonIndex !== -1) {
    const prev = lessonIndex > 0 ? lessons[lessonIndex - 1] : null;
    const next = lessonIndex < lessons.length - 1 ? lessons[lessonIndex + 1] : null;

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
    return;
  }

  const exercises = window.EXERCISES || [];
  const exerciseIndex = exercises.findIndex((e) => e.id === lessonId);
  if (exerciseIndex === -1) return;

  const prevEx = exerciseIndex > 0 ? exercises[exerciseIndex - 1] : null;
  const nextEx = exerciseIndex < exercises.length - 1 ? exercises[exerciseIndex + 1] : null;

  el.className = "prev-next-nav";
  el.innerHTML = `
    ${
      prevEx
        ? `<a href="${root}${prevEx.path}"><span class="prev-next-nav__label">← 前の演習</span>${prevEx.title}</a>`
        : `<span></span>`
    }
    ${
      nextEx
        ? `<a class="prev-next-nav__next" href="${root}${nextEx.path}"><span class="prev-next-nav__label">次の演習 →</span>${nextEx.title}</a>`
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
