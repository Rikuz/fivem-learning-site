-- resource起動時にテーブルを作成する(Tier3-03参照)
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `my_resource_data` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `identifier` VARCHAR(64) NOT NULL,
            `value` VARCHAR(255) NOT NULL,
            `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ]])
end)

-- 保存する(Tier3-32のモダンAPI)
local function saveValue(identifier, value)
    return MySQL.insert('INSERT INTO my_resource_data (identifier, value) VALUES (?, ?)', { identifier, value })
end

-- 最新の1件を取得する
local function getLatestValue(identifier)
    return MySQL.single.await('SELECT * FROM my_resource_data WHERE identifier = ? ORDER BY created_at DESC LIMIT 1', { identifier })
end

-- 複数件取得する
local function getAllValues(identifier)
    return MySQL.query.await('SELECT * FROM my_resource_data WHERE identifier = ? ORDER BY created_at DESC', { identifier })
end

-- 使用例
RegisterCommand('savetest', function(source, args)
    local playerId = source
    local identifier = GetPlayerIdentifierByType(playerId, 'license')
    saveValue(identifier, args[1] or 'テスト値')
end, false)

RegisterCommand('loadtest', function(source)
    local playerId = source
    local identifier = GetPlayerIdentifierByType(playerId, 'license')
    local rows = getAllValues(identifier)

    for _, row in ipairs(rows or {}) do
        print(row.id, row.value, row.created_at)
    end
end, false)
