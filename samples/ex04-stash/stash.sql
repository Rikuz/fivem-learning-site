CREATE TABLE IF NOT EXISTS `ex04_stash_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `stash_id` VARCHAR(50) NOT NULL,
  `item_name` VARCHAR(50) NOT NULL,
  `amount` INT NOT NULL,
  UNIQUE KEY `stash_item` (`stash_id`, `item_name`)
);

-- スタッシュID・アイテム名・個数の組(リレーショナル設計)を採用した。
-- JSON列にまとめる設計(Tier3-17参照)は、1アイテムだけを増減する更新が多いこのユースケースでは
-- 「JSON全体を読み込んで書き換えて保存し直す」処理になり非効率なため、更新頻度の高いデータは
-- 列として持つリレーショナル設計の方が適していると判断した。
