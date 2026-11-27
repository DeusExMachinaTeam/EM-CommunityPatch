CP_VERSION = "1.14"


-- by zatinu322:
-- Showing first narrator's text. 
-- Moved here, because this text has different speed in patch and remaster
function ShowFirstNarratorText()
    AddCinematicMessage( 77771, 0.1)
end


-- Alias for teleport()
function tp ()
	teleport()
end


-- Helper for PassToMap()
function goto(map_name, from_loc_passed)
    local default_path = {
        ["r1m1"]="FromR1M2",
        ["r1m2"]="FromR1M1",
        ["r1m3"]="FromR1M2",
        ["r1m4"]="FromR1M3",
        ["r2m1"]="FromR1M3",
        ["r2m2"]="FromR2M1",
        ["r3m1"]="FromR1M4",
        ["r3m2"]="FromR3M1",
        ["r4m1"]="FromR1M1",
        ["r4m2"]="FromR4M1"
        }
    if default_path[map_name] then
        println(default_path[map_name])
        local from_loc
        if from_loc_passed then from_loc = from_loc_passed else from_loc = default_path[map_name] end
        PassToMap(map_name, from_loc, -1)
    else
        println("Unknown map name")
    end
end

-- paint trailer to main vehicle's skin
function PaintTrailer( vehicleName )
    local veh = getObj( vehicleName )
    if not veh then
        println("Error: attempt to index a nil value: "..vehicleName)
        LOG("Error: attempt to index a nil value: "..vehicleName)
        return
    end

	local trailer = veh:GetTrailer()
    if not trailer then
        println("Error: prototype "..vehicleName.." has no trailer.")
        LOG("Error: prototype "..vehicleName.." has no trailer.")
        return
    end

	local skinnum = veh:GetSkin()
	trailer:SetSkin(skinnum)
end

function UseRepairItem(hpAmount, armorAmount)
	local v = GetPlayerVehicle()
	if v then
		-- Тратим, если есть что чинить: здоровье ниже максимума или есть
		-- повреждённая броня.
		if v:GetHealth() < v:GetMaxHealth() or HasDamagedArmor() then
			v:AddModifier('hp', '+ ' .. hpAmount)
			SmartRepair(armorAmount)
			PlayControlSound('SOUND_REPAIR')
			return 1
		end
		return nil
	end
end

-- Топливо: fuelAmount в бак. Полный бак канистру не расходует.
function UseFuelItem(fuelAmount)
	local v = GetPlayerVehicle()
	if v then
		if v:GetFuel() < v:GetMaxFuel() then
			v:AddModifier('fuel', '+ ' .. fuelAmount)
			PlayControlSound('SOUND_REFUEL')
			return 1
		end
		return nil
	end
end

function UseScrapMetal()
	return UseRepairItem(25, 4)
end

function UseMachinery()
	return UseRepairItem(125, 8)
end

function UseElectronics()
	return UseRepairItem(400, 16)
end

function UseFuel()
	return UseFuelItem(20)
end
