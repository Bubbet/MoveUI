Scrapyard.updateServerOld = Scrapyard.updateServer

require('mods.MoveUI.scripts.lib.serialize')

function Scrapyard.updateServer(timeStep)

    Data = Scrapyard.secure()
    licenses = Data["licenses"]
    --local licenses = {}

    local x,y = Sector():getCoordinates()
    for playerIndex,duration in pairs(licenses) do
        local faction = Faction(playerIndex)

        if faction.isPlayer or faction.isAlliance then
            -- read current or init new
            local pLicenses = Scrapyard.GetPlayerLicense(playerIndex)
            local time = round(duration - timeStep)
            if time <= 0 then
              time = nil
            end
            pLicenses[x][y] = time

            faction:setValue("MoveUI#Licenses", serialize(pLicenses))
        end
    end

    Scrapyard.updateServerOld(timeStep)
end

function Scrapyard.GetPlayerLicense(playerIndex)

    local x,y = Sector():getCoordinates()
    local faction = Faction(playerIndex)

    local licenses
    local PlayerLicenses = faction:getValue("MoveUI#Licenses") or false
    if faction and (faction.isPlayer or faction.isAlliance) and PlayerLicenses then
        licenses = loadstring(PlayerLicenses)()
    else
        licenses = {}
    end

    -- Sanity checks / init new
    if (type(licenses) ~= "table") then
        licenses = {}
    end
    if (type(licenses[x]) ~= "table") then
        licenses[x] = {}
    end
    if (type(licenses[x][y]) ~= "table") then
        licenses[x][y] = {}
    end

    return licenses
end
