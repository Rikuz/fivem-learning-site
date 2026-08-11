local DEPOT_COORDS = vec3(-45.0, -1000.0, 26.0)

-- 配達先の候補地点(実際にはマップに合わせて調整する)
local DELIVERY_CANDIDATES = {
    vec3(100.0, -800.0, 29.0),
    vec3(300.0, -900.0, 29.0),
    vec3(-200.0, -700.0, 34.0),
    vec3(-500.0, -300.0, 35.0),
    vec3(200.0, 300.0, 105.0),
    vec3(-800.0, 300.0, 88.0),
}

local PAYOUT_PER_METER = 2

local onDutyPlayers = {} -- playerId -> true
local activeJobs = {} -- playerId -> { state, points, currentIndex, totalDistance, lastCoords }

local function isOnDuty(playerId)
    return onDutyPlayers[playerId] == true
end

-- 候補地点をシャッフルしてから2〜4件を選ぶ
local function pickDeliveryPoints()
    local shuffled = {}
    for i, coords in ipairs(DELIVERY_CANDIDATES) do shuffled[i] = coords end
    for i = #shuffled, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end

    local count = math.random(2, 4)
    local points = {}
    for i = 1, count do points[i] = shuffled[i] end
    return points
end

RegisterNetEvent('ex12job:toggleDuty')
AddEventHandler('ex12job:toggleDuty', function()
    local playerId = source
    local isNowOnDuty = not isOnDuty(playerId)

    onDutyPlayers[playerId] = isNowOnDuty or nil

    -- 勤務終了時、受注中の仕事があれば強制終了する(Tier4-33参照)
    if not isNowOnDuty and activeJobs[playerId] then
        activeJobs[playerId] = nil
        TriggerClientEvent('ex12job:jobEnded', playerId, '勤務終了により仕事が強制終了しました')
    end

    TriggerClientEvent('ex12job:onDutyChanged', playerId, isNowOnDuty)
end)

RegisterNetEvent('ex12job:accept')
AddEventHandler('ex12job:accept', function()
    local playerId = source

    if not isOnDuty(playerId) then
        TriggerClientEvent('ex12job:notify', playerId, '出勤してから仕事を受けてください')
        return
    end
    if activeJobs[playerId] then
        TriggerClientEvent('ex12job:notify', playerId, '既に仕事を受注中です')
        return
    end

    local points = pickDeliveryPoints()
    activeJobs[playerId] = { state = 'delivering', points = points, currentIndex = 1, totalDistance = 0.0, lastCoords = DEPOT_COORDS }

    TriggerClientEvent('ex12job:jobStarted', playerId, points)
end)

RegisterNetEvent('ex12job:arrivedAtPoint')
AddEventHandler('ex12job:arrivedAtPoint', function()
    local playerId = source
    local job = activeJobs[playerId]
    if not job or job.state ~= 'delivering' then return end

    local currentPoint = job.points[job.currentIndex]
    job.totalDistance = job.totalDistance + #(currentPoint - job.lastCoords)
    job.lastCoords = currentPoint
    job.currentIndex = job.currentIndex + 1

    if job.currentIndex > #job.points then
        -- 全ての配達先を回り終えた: 総移動距離に応じて報酬をserver側で計算する
        local payout = math.floor(job.totalDistance * PAYOUT_PER_METER)
        activeJobs[playerId] = nil
        TriggerClientEvent('ex12job:jobCompleted', playerId, payout)
    else
        TriggerClientEvent('ex12job:nextPoint', playerId, job.points[job.currentIndex])
    end
end)
