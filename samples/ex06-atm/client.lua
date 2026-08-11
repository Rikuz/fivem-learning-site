local ATM_COORDS = vec3(150.0, -1040.0, 29.0)

exports.ox_target:addBoxZone({
    coords = ATM_COORDS,
    size = vec3(1.0, 1.0, 2.0),
    options = {
        {
            name = 'atm_deposit',
            icon = 'fa-solid fa-money-bill-transfer',
            label = '入金する($500)',
            onSelect = function()
                TriggerServerEvent('ex06atm:transaction', 'deposit', 500)
            end,
        },
        {
            name = 'atm_withdraw',
            icon = 'fa-solid fa-money-bill-wave',
            label = '出金する($500)',
            onSelect = function()
                TriggerServerEvent('ex06atm:transaction', 'withdraw', 500)
            end,
        },
    }
})
