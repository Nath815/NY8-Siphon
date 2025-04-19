
RegisterNetEvent("siphon:start", function()
    local src = source
    TriggerClientEvent("siphon:clientStart", src)
end)

RegisterNetEvent("siphon:giveCan", function()
    local src = source
    print("[Siphon] Ajout via ox_inventory uniquement")
    exports.ox_inventory:AddItem(src, "WEAPON_PETROLCAN", 1, { ammo = 2500 })
    TriggerClientEvent("siphon:notifySuccess", src)
end)
