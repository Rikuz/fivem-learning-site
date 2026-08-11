local INVENTORY = {
    { model = 'sultan', label = 'Sultan', price = 15000 },
    { model = 'blista', label = 'Blista', price = 9000 },
    { model = 'sentinel', label = 'Sentinel', price = 22000 },
}

local DOWN_PAYMENT_RATE = 0.2
local INSTALLMENT_COUNT_MAX = 24

local playerMoney = {} -- playerId -> 所持金(デモ用の簡易管理)
local loans = {} -- id -> { owner, remaining, installmentAmount }
local nextLoanId = 1

local function getMoney(playerId)
    playerMoney[playerId] = playerMoney[playerId] or 5000
    return playerMoney[playerId]
end

local function findVehicle(model)
    for _, v in ipairs(INVENTORY) do
        if v.model == model then return v end
    end
    return nil
end

RegisterNetEvent('ex16dealership:requestInventory')
AddEventHandler('ex16dealership:requestInventory', function()
    TriggerClientEvent('ex16dealership:showInventory', source, INVENTORY)
end)

RegisterNetEvent('ex16dealership:purchaseFull')
AddEventHandler('ex16dealership:purchaseFull', function(model)
    local playerId = source
    local vehicle = findVehicle(model)
    if not vehicle then return end

    if getMoney(playerId) < vehicle.price then
        TriggerClientEvent('ex16dealership:notify', playerId, '所持金が足りません')
        return
    end

    playerMoney[playerId] = getMoney(playerId) - vehicle.price
    TriggerClientEvent('ex16dealership:deliverVehicle', playerId, model)
    TriggerClientEvent('ex16dealership:notify', playerId, ('%sを一括購入しました'):format(vehicle.label))
end)

RegisterNetEvent('ex16dealership:purchaseLoan')
AddEventHandler('ex16dealership:purchaseLoan', function(model, installmentCount)
    local playerId = source
    local vehicle = findVehicle(model)

    if not vehicle or not installmentCount or installmentCount < 2 or installmentCount > INSTALLMENT_COUNT_MAX then
        TriggerClientEvent('ex16dealership:notify', playerId, '分割回数は2〜24回で指定してください')
        return
    end

    local downPayment = math.floor(vehicle.price * DOWN_PAYMENT_RATE)
    if getMoney(playerId) < downPayment then
        TriggerClientEvent('ex16dealership:notify', playerId, '頭金分の所持金が足りません')
        return
    end

    playerMoney[playerId] = getMoney(playerId) - downPayment

    local remaining = vehicle.price - downPayment
    local installmentAmount = math.ceil(remaining / installmentCount)

    loans[nextLoanId] = { owner = playerId, remaining = remaining, installmentAmount = installmentAmount }
    nextLoanId = nextLoanId + 1

    TriggerClientEvent('ex16dealership:deliverVehicle', playerId, model)
    TriggerClientEvent('ex16dealership:notify', playerId, ('頭金$%sで購入しました(残り$%sを%d回で分割払い)'):format(downPayment, remaining, installmentCount))
end)

-- 定期的に分割金を引き落とす(デモのため短い間隔にしている。実運用はTier4-38の24時間間隔を参照)
CreateThread(function()
    while true do
        Wait(60000)

        for id, loan in pairs(loans) do
            if loan.remaining > 0 then
                local amount = math.min(loan.installmentAmount, loan.remaining)
                local money = getMoney(loan.owner)

                if money >= amount then
                    playerMoney[loan.owner] = money - amount
                    loan.remaining = loan.remaining - amount
                    TriggerClientEvent('ex16dealership:notify', loan.owner, ('ローンの分割金$%sが引き落とされました(残り$%s)'):format(amount, loan.remaining))
                else
                    TriggerClientEvent('ex16dealership:notify', loan.owner, '分割金の支払いに失敗しました(所持金不足)')
                end
            end
        end
    end
end)
