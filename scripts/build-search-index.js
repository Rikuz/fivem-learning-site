#!/usr/bin/env node
// scripts/build-search-index.js
// レッスンHTMLから本文テキストを抽出し、assets/js/search-index.js を生成する。
// レッスンを追加/編集したら、このスクリプトを再実行してsearch-index.jsを更新すること。
// 実行方法: node scripts/build-search-index.js

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const LESSONS_DIR = path.join(ROOT, 'lessons');
const OUTPUT_FILE = path.join(ROOT, 'assets', 'js', 'search-index.js');

function walk(dir, results) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      // samples/ サブディレクトリ(レッスンに同梱された実サンプル一式)はインデックス対象外にする
      if (entry.name === 'samples') continue;
      walk(full, results);
    } else if (entry.name.endsWith('.html')) {
      results.push(full);
    }
  }
}

function extractText(html) {
  const mainMatch = html.match(/<main>([\s\S]*?)<\/main>/);
  const mainHtml = mainMatch ? mainMatch[1] : html;

  return mainHtml
    .replace(/<script[\s\S]*?<\/script>/gi, ' ')
    .replace(/<style[\s\S]*?<\/style>/gi, ' ')
    .replace(/<[^>]+>/g, ' ')
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/\s+/g, ' ')
    .trim();
}

const files = [];
walk(LESSONS_DIR, files);

const entries = [];
for (const file of files) {
  const html = fs.readFileSync(file, 'utf8');
  const idMatch = html.match(/data-lesson-id="([^"]+)"/);
  if (!idMatch) continue;

  const text = extractText(html);
  entries.push({ id: idMatch[1], text });
}

entries.sort((a, b) => a.id.localeCompare(b.id));

const output = `// assets/js/search-index.js — 全レッスン本文の全文検索インデックス(自動生成ファイル)
// scripts/build-search-index.js から生成されます。レッスンを追加/編集したら、
// このファイルを手で直接編集せず、必ず「node scripts/build-search-index.js」を再実行してください。

const SEARCH_INDEX = ${JSON.stringify(entries)};

window.SEARCH_INDEX = SEARCH_INDEX;
`;

fs.writeFileSync(OUTPUT_FILE, output, 'utf8');
console.log(`Generated ${OUTPUT_FILE} with ${entries.length} entries.`);
