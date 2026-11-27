CP_VERSION = "1.14 HD"

-- by zatinu322:
-- showing first narrator's text
-- moved here, becouse this text has different speed in patch and remaster
function ShowFirstNarratorText()
    AddCinematicMessage( 77772, 0.1)
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
