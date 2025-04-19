
local siphonInProgress = false
local siphonedVehicles = {}

RegisterNetEvent("siphon:clientStart", function()
    if siphonInProgress then return end
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords, 3.0, 0, 70)

    if not DoesEntityExist(vehicle) or not IsEntityAVehicle(vehicle) then
        lib.notify({ type = 'error', description = "Aucun véhicule détecté." })
        return
    end

    local vehPlate = GetVehicleNumberPlateText(vehicle)
    if siphonedVehicles[vehPlate] then
        lib.notify({ type = 'error', description = "Tu as déjà siphonné ce véhicule." })
        return
    end

    -- Chance de réussite : 1 sur 10
    if math.random(1, 10) ~= 1 then
        lib.notify({ type = 'error', description = "Tu as échoué à siphonner le réservoir." })
        return
    end

    siphonInProgress = true

    -- Animation
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    lib.progressCircle({
        duration = 20000,
        label = "Siphonnage en cours...",
        position = "bottom",
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, car = true, mouse = false, combat = true }
    })

    ClearPedTasks(playerPed)
    siphonInProgress = false

    -- Enregistre le véhicule comme déjà siphonné
    siphonedVehicles[vehPlate] = true

    -- Baisse complète du carburant (ox_fuel)
    Entity(vehicle).state.fuel = 0

    -- Donne l'item via serveur
    TriggerServerEvent("siphon:giveCan")

    -- Correction jerrican plein
    Wait(500)
    local weaponHash = GetHashKey("WEAPON_PETROLCAN")
    if HasPedGotWeapon(playerPed, weaponHash, false) then
        SetPedAmmo(playerPed, weaponHash, 4500)
    end
end)

RegisterNetEvent("siphon:notifySuccess", function()
    lib.notify({ type = 'success', description = "Tu as siphonné tout le réservoir." })
end)

-- ox_target interaction
CreateThread(function()
    exports.ox_target:addGlobalVehicle({
        {
            name = "siphon_fuel",
            icon = "fa-solid fa-gas-pump",
            label = "Siphonner le réservoir",
            distance = 2.5,
            onSelect = function(data)
                TriggerEvent("siphon:clientStart")
            end
        }
    })
end)
