local ORES = {
    { name = '石', weight = 60 },
    { name = '鉄鉱石', weight = 30 },
    { name = 'レア鉱石', weight = 10 }, -- スキルレベルに応じて重みを補正する
}

local RARE_ORE_BONUS_PER_LEVEL = 3 -- スキルレベル1につきレア鉱石の重みを+3する
local XP_PER_MINE = 10
local XP_PER_LEVEL = 100

local playerXp = {} -- playerId -> 経験値
local playerLevel = {} -- playerId -> スキルレベル

local function getLevel(playerId)
    return playerLevel[playerId] or 1
end

local function addXp(playerId, amount)
    playerXp[playerId] = (playerXp[playerId] or 0) + amount

    local currentLevel = getLevel(playerId)
    local requiredXp = currentLevel * XP_PER_LEVEL

    if playerXp[playerId] >= requiredXp then
        playerXp[playerId] = playerXp[playerId] - requiredXp
        playerLevel[playerId] = currentLevel + 1
        TriggerClientEvent('ex03mining:result', playerId, ('採掘スキルがレベル%dに上がりました!'):format(currentLevel + 1))
    end
end

-- 重み付き抽選: プレイヤーのスキルレベルが高いほどレア鉱石が出やすくなる
local function drawOre(playerId)
    local level = getLevel(playerId)
    local totalWeight = 0
    local weights = {}

    for _, ore in ipairs(ORES) do
        local weight = ore.weight
        if ore.name == 'レア鉱石' then
            weight = weight + (level - 1) * RARE_ORE_BONUS_PER_LEVEL
        end
        weights[#weights + 1] = weight
        totalWeight = totalWeight + weight
    end

    local roll = math.random() * totalWeight
    local cumulative = 0

    for i, ore in ipairs(ORES) do
        cumulative = cumulative + weights[i]
        if roll <= cumulative then
            return ore.name
        end
    end

    return ORES[1].name
end

RegisterNetEvent('ex03mining:requestResult')
AddEventHandler('ex03mining:requestResult', function()
    local playerId = source
    local oreName = drawOre(playerId)

    addXp(playerId, XP_PER_MINE)
    TriggerClientEvent('ex03mining:result', playerId, ('%sを入手しました(採掘スキルLv.%d)'):format(oreName, getLevel(playerId)))
end)
