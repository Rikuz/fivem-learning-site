#!/usr/bin/env node
// scripts/build-sample-zips.js
// samples/配下の各サンプルリソース一式を、サンプルごとに1つのZIPファイル(samples/downloads/<id>.zip)にまとめる。
// Node標準ライブラリ(fs/path/zlib)のみで生成し、npm依存を追加しない(CLAUDE.mdの「ビルドツールなし」方針を維持するための著者向け補助スクリプト)。
// サンプルのファイル構成を変更したら、このスクリプトを再実行してZIPを再生成すること。
// 実行方法: node scripts/build-sample-zips.js

const fs = require('fs');
const path = require('path');
const zlib = require('zlib');
const vm = require('vm');

const ROOT = path.join(__dirname, '..');
const SAMPLES_DIR = path.join(ROOT, 'samples');
const OUTPUT_DIR = path.join(SAMPLES_DIR, 'downloads');

// samples-data.js はブラウザ向けのJS配列(fetchしない方針のため)。
// vmコンテキストで実行し、window.SAMPLESを取り出す。
function loadSamples() {
  const code = fs.readFileSync(path.join(ROOT, 'assets', 'js', 'samples-data.js'), 'utf8');
  const sandbox = { window: {} };
  vm.createContext(sandbox);
  vm.runInContext(code, sandbox);
  return sandbox.window.SAMPLES;
}

// ---- CRC32(ZIP形式で必須) ----
const CRC_TABLE = (() => {
  const table = new Uint32Array(256);
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) {
      c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    }
    table[n] = c >>> 0;
  }
  return table;
})();

function crc32(buf) {
  let crc = 0xffffffff;
  for (let i = 0; i < buf.length; i++) {
    crc = CRC_TABLE[(crc ^ buf[i]) & 0xff] ^ (crc >>> 8);
  }
  return (crc ^ 0xffffffff) >>> 0;
}

// ---- 最小限のZIPライター(store方式、圧縮なし。標準ツールで問題なく展開できる) ----
function buildZip(entries) {
  const localParts = [];
  const centralParts = [];
  let offset = 0;

  for (const entry of entries) {
    const nameBuf = Buffer.from(entry.name, 'utf8');
    const data = entry.data;
    const crc = crc32(data);

    const localHeader = Buffer.alloc(30);
    localHeader.writeUInt32LE(0x04034b50, 0);
    localHeader.writeUInt16LE(20, 4); // version needed
    localHeader.writeUInt16LE(0, 6); // flags
    localHeader.writeUInt16LE(0, 8); // compression method: 0 = store
    localHeader.writeUInt16LE(0, 10); // mod time
    localHeader.writeUInt16LE(0x21, 12); // mod date (1980-01-01)
    localHeader.writeUInt32LE(crc, 14);
    localHeader.writeUInt32LE(data.length, 18); // compressed size
    localHeader.writeUInt32LE(data.length, 22); // uncompressed size
    localHeader.writeUInt16LE(nameBuf.length, 26);
    localHeader.writeUInt16LE(0, 28); // extra field length

    localParts.push(localHeader, nameBuf, data);

    const centralHeader = Buffer.alloc(46);
    centralHeader.writeUInt32LE(0x02014b50, 0);
    centralHeader.writeUInt16LE(20, 4); // version made by
    centralHeader.writeUInt16LE(20, 6); // version needed
    centralHeader.writeUInt16LE(0, 8); // flags
    centralHeader.writeUInt16LE(0, 10); // compression method
    centralHeader.writeUInt16LE(0, 12); // mod time
    centralHeader.writeUInt16LE(0x21, 14); // mod date
    centralHeader.writeUInt32LE(crc, 16);
    centralHeader.writeUInt32LE(data.length, 20);
    centralHeader.writeUInt32LE(data.length, 24);
    centralHeader.writeUInt16LE(nameBuf.length, 28);
    centralHeader.writeUInt16LE(0, 30); // extra field length
    centralHeader.writeUInt16LE(0, 32); // comment length
    centralHeader.writeUInt16LE(0, 34); // disk number start
    centralHeader.writeUInt16LE(0, 36); // internal attrs
    centralHeader.writeUInt32LE(0, 38); // external attrs
    centralHeader.writeUInt32LE(offset, 42); // offset of local header

    centralParts.push(centralHeader, nameBuf);

    offset += localHeader.length + nameBuf.length + data.length;
  }

  const centralDirStart = offset;
  const centralDirBuf = Buffer.concat(centralParts);

  const endRecord = Buffer.alloc(22);
  endRecord.writeUInt32LE(0x06054b50, 0);
  endRecord.writeUInt16LE(0, 4); // disk number
  endRecord.writeUInt16LE(0, 6); // disk with central dir
  endRecord.writeUInt16LE(entries.length, 8); // entries on this disk
  endRecord.writeUInt16LE(entries.length, 10); // total entries
  endRecord.writeUInt32LE(centralDirBuf.length, 12); // size of central dir
  endRecord.writeUInt32LE(centralDirStart, 16); // offset of central dir
  endRecord.writeUInt16LE(0, 20); // comment length

  return Buffer.concat([...localParts, centralDirBuf, endRecord]);
}

// ---- 実行 ----
const samples = loadSamples();
fs.mkdirSync(OUTPUT_DIR, { recursive: true });

let count = 0;
for (const sample of samples) {
  const entries = [];

  for (const resource of sample.resources) {
    for (const file of resource.files) {
      const filePath = path.join(SAMPLES_DIR, resource.name, file);
      if (!fs.existsSync(filePath)) {
        console.warn(`WARN: ${sample.id} - missing file ${filePath}`);
        continue;
      }
      const data = fs.readFileSync(filePath);
      const zipEntryName = `${resource.name}/${file}`.replace(/\\/g, '/');
      entries.push({ name: zipEntryName, data });
    }
  }

  if (entries.length === 0) {
    console.warn(`WARN: ${sample.id} - no files found, skipping`);
    continue;
  }

  const zipBuf = buildZip(entries);
  const outPath = path.join(OUTPUT_DIR, `${sample.id}.zip`);
  fs.writeFileSync(outPath, zipBuf);
  count++;
}

console.log(`Generated ${count} zip files in ${OUTPUT_DIR}`);
