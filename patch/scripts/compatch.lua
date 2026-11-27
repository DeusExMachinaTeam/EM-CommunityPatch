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

-- split string on space, for example:
-- "5670.842 249.002 7343.720" -> table
-- where table[1] == "5670.842", table[2] == "249.002", table[3] == "7343.720" etc
function SplitStringOnSpace(string_to_split)
	local table_split = {}
	for word in string.gfind(string_to_split, "[^%s]+") do
	   table.insert(table_split, word)
	end
	return table_split
end

-- teleport to coords in format "x y z" (example: "5670.842 249.002 7343.720")
-- offset_y_passed used to hover above object
-- relative used to use ground as base instead of absolute coords, needed for "org" in world.xml for example
function tpto(coords, offset_y_passed, relative)
	local split_coords = SplitStringOnSpace(coords)
	if table.getn(split_coords) ~= 3 then
		print("Not a right number of coordinates in splited string")
		return
	end
	local x, y, z = unpack(split_coords)
    local offset_y
    if offset_y_passed then offset_y = offset_y_passed else offset_y = 0.0 end
    if relative then offset_y = offset_y + g_ObjCont:GetHeight(x, z) end
	local split_coords = CVector(tonumber(x), tonumber(y) + offset_y, tonumber(z))
	GetPlayerVehicle():SetPosition(CVector(split_coords))
end

-- use for 'org' coords from world.xml
function tptow(coords)
    tpto(tpto, 20.0, 1)
end

-- use for 'Pos' coords from dynamicscene.xml
function tptod(coords)
    tpto(tpto, 20.0)
end

-- helper to print to console and log at the same time
function printlog(str)
    println(str)
    LOG(str)
end
