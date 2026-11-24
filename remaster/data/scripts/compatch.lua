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