local HEIST_DOOR_ID = 'ex07_heist_vault_door' -- ox_doorlockの/doorlockコマンドで事前に登録しておく前提(Tier4-14参照)
local HEIST_DOOR_COORDS = vec3(260.0, -900.0, 30.0)

exports.ox_target:addBoxZone({
    coords = HEIST_DOOR_COORDS,
    size = vec3(1.5, 1.5, 2.5),
    options = {
        {
            name = 'breach_door',
            icon = 'fa-solid fa-screwdriver-wrench',
            label = 'ドアをこじ開ける',
            onSelect = function()
                -- 一定の条件(プログレスバーの完了)を満たしたら解錠する
                local success = lib.progressBar({
                    duration = 8000,
                    label = 'ドアをこじ開けています...',
                    canCancel = true,
                    disable = { move = true, car = true },
                })

                if not success then return end

                exports.ox_doorlock:setDoorState(HEIST_DOOR_ID, false)

                -- ex07-heist-coreのStateBags(Tier5-03)経由で他の参加者にも状態を伝える
                local bucketId = LocalPlayer.state.heistBucket
                if bucketId then
                    TriggerServerEvent('ex07heistcore:doorBreached', bucketId)
                end
            end,
        },
    }
})
