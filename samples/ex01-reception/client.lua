local RECEPTION_COORDS = vec3(100.0, 200.0, 30.0)
local RECEPTION_HEADING = 90.0
local INTERACT_DISTANCE = 3.0

local receptionPed = nil
local receptionBlip = nil

local function spawnReception()
    local model = `a_m_m_business_01`

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    receptionPed = CreatePed(4, model, RECEPTION_COORDS.x, RECEPTION_COORDS.y, RECEPTION_COORDS.z, RECEPTION_HEADING, false, false)

    FreezeEntityPosition(receptionPed, true)
    SetEntityInvincible(receptionPed, true)
    SetBlockingOfNonTemporaryEvents(receptionPed, true)

    SetModelAsNoLongerNeeded(model)

    receptionBlip = AddBlipForCoord(RECEPTION_COORDS.x, RECEPTION_COORDS.y, RECEPTION_COORDS.z)
    SetBlipSprite(receptionBlip, 280)
    SetBlipColour(receptionBlip, 2)
    SetBlipScale(receptionBlip, 0.8)
    SetBlipAsShortRange(receptionBlip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('受付')
    EndTextCommandSetBlipName(receptionBlip)
end

-- resource起動時に1度だけ生成する(restartしても重複生成されないよう、生成処理はここだけに置く)
CreateThread(function()
    spawnReception()
end)

RegisterCommand('reception', function()
    if not receptionPed or not DoesEntityExist(receptionPed) then return end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - RECEPTION_COORDS)

    if distance <= INTERACT_DISTANCE then
        TriggerEvent('chat:addMessage', { args = { '[受付]', 'いらっしゃいませ!ご用件はチャットでお知らせください。' } })
    else
        TriggerEvent('chat:addMessage', { args = { '[受付]', '受付に近づいてください。' } })
    end
end, false)

-- resource停止時にNPC・Blipを確実に削除する
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    if receptionPed and DoesEntityExist(receptionPed) then
        SetEntityAsMissionEntity(receptionPed, true, true)
        DeletePed(receptionPed)
    end

    if receptionBlip then
        RemoveBlip(receptionBlip)
    end
end)
