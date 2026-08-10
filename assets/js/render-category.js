// assets/js/render-category.js — カテゴリ別一覧ページ(category.html)の描画・フィルタ処理

function parseFilterFromURL() {
  const params = new URLSearchParams(window.location.search);
  const cat = params.get("cat");
  const tier = params.get("tier");
  const q = params.get("q");
  return {
    categories: cat ? cat.split(",").filter(Boolean) : [],
    tiers: tier ? tier.split(",").filter(Boolean).map(Number) : [],
    query: q || "",
  };
}

function updateURL(state) {
  const params = new URLSearchParams();
  if (state.categories.length) params.set("cat", state.categories.join(","));
  if (state.tiers.length) params.set("tier", state.tiers.join(","));
  if (state.query) params.set("q", state.query);
  const query = params.toString();
  const newURL = window.location.pathname + (query ? "?" + query : "");
  window.history.replaceState(null, "", newURL);
}

// 「したいこと」から探す逆引き検索: タイトル/サマリー/keywordsに部分一致するか判定する
function matchesQuery(lesson, query) {
  if (!query) return true;
  const normalized = query.trim().toLowerCase();
  if (!normalized) return true;

  const haystack = [lesson.title, lesson.summary, ...(lesson.keywords || [])]
    .join(" ")
    .toLowerCase();

  return haystack.includes(normalized);
}

function renderSearchBox(state, onChange) {
  const el = document.getElementById("keyword-search");
  if (!el) return;
  el.className = "keyword-search";
  el.innerHTML = `
    <label class="keyword-search__label" for="keyword-search-input">したいことから探す(逆引き検索)</label>
    <input
      type="search"
      id="keyword-search-input"
      class="keyword-search__input"
      placeholder="例: NPCを配置したい / 通知を出したい / 銀行と連携したい"
      value="${state.query.replace(/"/g, "&quot;")}"
    >
  `;

  const input = document.getElementById("keyword-search-input");
  input.addEventListener("input", () => {
    state.query = input.value;
    onChange(state);
  });
}

function renderFilterUI(state, onChange) {
  const el = document.getElementById("category-filter");
  if (!el) return;
  el.className = "category-filter";

  const categoryOptions = Object.entries(window.CATEGORY_INFO)
    .map(([key, info]) => {
      const checked = state.categories.includes(key) ? "checked" : "";
      return `
        <label class="category-filter__option">
          <input type="checkbox" data-filter="category" value="${key}" ${checked}>
          ${info.emoji} ${info.label}
        </label>
      `;
    })
    .join("");

  const tierOptions = [1, 2, 3, 4, 5]
    .map((tier) => {
      const info = window.TIER_INFO[tier];
      const checked = state.tiers.includes(tier) ? "checked" : "";
      return `
        <label class="category-filter__option">
          <input type="checkbox" data-filter="tier" value="${tier}" ${checked}>
          ${info.emoji} ${info.label}
        </label>
      `;
    })
    .join("");

  el.innerHTML = `
    <div class="category-filter__group">
      <span class="category-filter__group-title">カテゴリで絞り込み</span>
      ${categoryOptions}
    </div>
    <div class="category-filter__group">
      <span class="category-filter__group-title">難易度で絞り込み</span>
      ${tierOptions}
    </div>
  `;

  el.querySelectorAll("input[data-filter]").forEach((input) => {
    input.addEventListener("change", () => {
      const type = input.getAttribute("data-filter");
      const value = type === "tier" ? Number(input.value) : input.value;
      const list = type === "tier" ? state.tiers : state.categories;
      const idx = list.indexOf(value);
      if (input.checked && idx === -1) list.push(value);
      if (!input.checked && idx !== -1) list.splice(idx, 1);
      onChange(state);
    });
  });
}

function lessonCardHTML(lesson) {
  const tierInfo = window.TIER_INFO[lesson.tier];
  const categoryBadges = lesson.categories
    .map((key) => {
      const info = window.CATEGORY_INFO[key];
      return `<span class="badge category-badge">${info.emoji} ${info.label}</span>`;
    })
    .join("");

  return `
    <a class="lesson-card" data-lesson-card="${lesson.id}" href="${lesson.path}">
      <div class="lesson-card__badges">
        <span class="badge tier-badge" data-tier="${lesson.tier}">${tierInfo.emoji} ${tierInfo.label}</span>
        ${categoryBadges}
      </div>
      <p class="lesson-card__title">${lesson.title} <span data-complete-check></span></p>
      <p class="lesson-card__summary">${lesson.summary}</p>
      <div class="lesson-card__meta">
        <span>所要時間目安: ${lesson.estimatedMinutes}分</span>
      </div>
    </a>
  `;
}

function filterLessons(lessons, state) {
  return lessons.filter((lesson) => {
    const tierOK = state.tiers.length === 0 || state.tiers.includes(lesson.tier);
    const catOK =
      state.categories.length === 0 ||
      lesson.categories.some((c) => state.categories.includes(c));
    const queryOK = matchesQuery(lesson, state.query);
    return tierOK && catOK && queryOK;
  });
}

function renderResults(state) {
  const el = document.getElementById("category-results");
  if (!el) return;
  const lessons = window.LESSONS || [];
  const filtered = filterLessons(lessons, state);

  if (filtered.length === 0) {
    el.innerHTML = `<p class="category-summary">該当するレッスンが見つかりませんでした。検索語や絞り込み条件を変えてみてください。</p>`;
    renderProgressUI();
    return;
  }

  if (state.categories.length === 0) {
    // カテゴリ未選択時はフラットな一覧を表示
    el.innerHTML = `<div class="tier-section__cards">${filtered.map(lessonCardHTML).join("")}</div>`;
  } else {
    // カテゴリ選択時は選択カテゴリごとにグループ化し、サマリー見出しを表示
    el.innerHTML = state.categories
      .map((catKey) => {
        const info = window.CATEGORY_INFO[catKey];
        const summary = window.CATEGORY_SUMMARY[catKey];
        const catLessons = filtered.filter((l) => l.categories.includes(catKey));
        if (catLessons.length === 0) return "";
        return `
          <section class="tier-section" style="--tier-main: var(--color-border)">
            <div class="tier-section__header">
              <h2 class="tier-section__title">${info.emoji} ${info.label}</h2>
            </div>
            <p class="category-summary">${summary}</p>
            <div class="tier-section__cards">${catLessons.map(lessonCardHTML).join("")}</div>
          </section>
        `;
      })
      .join("");
  }

  renderProgressUI();
}

function initCategoryPage() {
  const state = parseFilterFromURL();

  const rerender = (newState) => {
    updateURL(newState);
    renderResults(newState);
  };

  renderSearchBox(state, rerender);
  renderFilterUI(state, rerender);
  renderResults(state);
}

window.addEventListener("DOMContentLoaded", initCategoryPage);
