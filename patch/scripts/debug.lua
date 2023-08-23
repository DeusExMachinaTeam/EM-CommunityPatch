-- Debug shit
-- $Id: debug.lua,v 1.40 2005/07/06 12:55:55 anton Exp $

-------------------------------------------------
-- some debug shit, remove it before release
-------------------------------------------------

function testLoadSave()
	RuleConsole "save test1"
	RuleConsole "load test1"
	RuleConsole "save test2"
end

-- Just for bugfixing
function SetPositionNull()
	GetPlayerVehicle():SetPosition(nil)
end

-------------------------------
-- some function for camera log
function p()
    local pos, rot, lookAt = GetCameraPos()
    LOG(' <Point  coord="' .. strsub( tostring(pos), 2, strlen( tostring(pos) ) - 1 ) .. '" rotation="'.. strsub( tostring(rot), 2, strlen( tostring(rot) ) - 1 ) .. '"/>')
end


function c()
    logCameraPos()
end


------------------------------
--Player pos to log
function plp()
LOG("SetPosition( CVector"..tostring(GetPlayerVehicle():GetPosition())..")")
LOG(' SetRotation(Quaternion'..tostring(GetPlayerVehicle():GetRotation(Quaternion()))..')')
end


-- writes current camera position and angles to log
function logPoint()
	local pos, rot, lookAt = GetCameraPos()
	local sPos = tostring(pos)
	sPos = strsub( sPos, 2, strlen(sPos) - 1 )
	local sRot = tostring(rot)
	sRot = strsub( sRot, 2, strlen(sRot) - 1 )
	LOG( "		<Point")
	LOG( '			coord="'.. sPos ..'"' )
	LOG( '			rotation="'.. sRot .. '"/>' )
end

-- writes current camera position and angles to log
function logPointS()
	local pos, rot, lookAt = GetCameraPos()
	local sPos = tostring(pos)
	sPos = strsub( sPos, 2, strlen(sPos) - 1 )
	local sRot = tostring(rot)
	sRot = strsub( sRot, 2, strlen(sRot) - 1 )
	writeln( "		<Point")
	writeln( '			coord="'.. sPos ..'"' )
	writeln( '			rotation="'.. sRot .. '"/>' )
end

-----------------------
-- create army (cheat!)

-- debug creation of objects in Player position
function DebugCreate( PrototypeName, Belong )
	local id = CreateNewObject{
		prototypeName = PrototypeName,
		objName = "debug_object"..tostring(random(9999)),
		belong = Belong
	}

	local obj = GetEntityByID( id )

	println( "Object created. id = "..tostring(id) )
end


function CreateVehicleEx( PrototypeName, Name, pos, belong )
	local bel

	if belong then
		bel = belong
	else
		bel = 1100
	end

	local id = CreateNewObject {
		prototypeName = PrototypeName,
		objName = Name,
		belong = bel
	}

	local vehicle = GetEntityByID( id )
	
	if not vehicle then
		println( "Error: vehicle ".. PrototypeName .. " not created" )
		return nil
	end

--	by Anton: это не нужно, т.к. вызываем SetGamePositionOnGround()
--	local hover = 1.5 * vehicle:GetSize().y
--	pos.y = g_ObjCont:GetHeight( pos.x, pos.z ) + hover


	vehicle:SetGamePositionOnGround( pos )

	return vehicle
end




-- Moves player's vehicle to position
function MovePlayer( x, y, z )
	GetPlayerVehicle():SetPosition( CVector( x, y, z ) )
end


-- Moves player's vehicle to camera position
function MovePlayerToCamera()
	local pos, rot, lookAt = GetCameraPos()
	GetPlayerVehicle():SetPosition( pos )
end


function sss()
	local p = CreateDummy{ modelName ="StoneBridge",objName = "Bridge", pos = CVector( 2000, 2000, 255 ) }
end

function move( x, z )
	GetEntityByName("Team17"):SetDestination( CVector( x, 100, z ) )
end	

function die( x )
	GetEntityByName(x):AddModifier( "hp", "- 1000000" )
end	

function caravan()
	GetEntityByName("TheTown"):SpawnCaravanToLocation("TheEnd")
--	GetEntityByName("TheTown"):SpawnCaravanToLocation("TheTown_defend")
end


function save()
	g_ObjCont:SaveToFileFull( "aaa.xml" )
end

function load()
	g_ObjCont:LoadFromFileFull( "aaa.xml" )	
end

function addgold( amount )
	g_Player:AddMoney( amount )
end

function getgold()
	return g_Player:GetMoney()
end

function ff()
	Fly("testq", 0, 0, 30, 1, 1 )
end

function ffc()
	Fly("circle", 0, 0, 10, 1, 1 )
end

function ffb()
	Fly("big", 0, 0, 35, 1, 1 )
end

function ffr()
	Fly("real", 0, 0, 15, 1, 1 )
end

function fff()
	Fly("test", 0, 0, 4, 1, 1 )
	AddCinematicMessage( 8000, 3 )
	AddCinematicMessage( 1, 0.1 )
end


function testpath()
	GetEntityByName("enemy"):SetPathByName("testVehicle")
	GetEntityByName("enemy"):PlaceToEndOfPath()
end

function AddPlayerVehicle(modelname)
-- добавляет игроку машину (если только у него ее нет)
-- можно использовать, когда убъют или типа того.
-- modelname - модель машины, которую надо. По умолчанию дается Урал
    if not modelname then
		modelname="Ural01"
	end
	if GetPlayerVehicle() then
		local teamID = CreateNewObject{
				prototypeName = "team",
				objName = "TempTeam",
				belong = "1100"
			}
	  	local team=GetEntityByID(teamID)
		if team then team:AddChild(GetPlayerVehicle()) end
		team:Remove()
	end
	local id = CreateNewObject{
		prototypeName = modelname,
--	 by Anton: name is set automatically in code --	objName = "PlayerVehicle"..tostring(random(9999)),
		objName = "",
		belong = 1100
	}
	local vehicle = GetEntityByID(id)
	local pl=g_Player
	if vehicle and pl then
	    println("Car name: "..vehicle:GetName())
		local hover = 1.5 * vehicle:GetSize().y
    	local pos, yaw, pitch, roll, lookAt = GetCameraPos()
		println(pos)
		vehicle:SetPosition(pos)
		pl:AddChild(vehicle)
    end
end

function AddPlayerNewVehicle(modelname)
-- добавляет игроку машину вместо текущей
-- modelname - модель машины, которую надо. По умолчанию дается Урал

    if not modelname then
		modelname="Ural01"
	end

	local realpos
	local Plf = GetPlayerVehicle()

	if Plf then
		realpos = Plf:GetPosition()
		local teamID = CreateNewObject{
				prototypeName = "team",
				objName = "TempTeam",
				belong = "1100"
			}
	  	local team=GetEntityByID(teamID)
		if team then team:AddChild(GetPlayerVehicle()) end
		team:Remove()
	end

	local id = CreateNewObject{
		prototypeName = modelname,
--	 by Anton: name is set automatically in code --			objName = "PlayerVehicle"..tostring(random(9999)),
		objName = "",
		belong = 1100
	}

	local vehicle = GetEntityByID(id)

	local pl = g_Player

	if vehicle and pl then
		local hover = 1.5 * vehicle:GetSize().y
		vehicle:SetPosition(realpos)
		pl:AddChild(vehicle)
    end
end

function fa()
	FlyAround( 2, -0.5, 30, 5, CVector(60, 300, 60), GetPlayerVehicleId(), 1, 1 )
end

function fl()
	GetPlayerVehicle():SetCustomControlEnabled(1)
	GetPlayerVehicle():SetThrottle(1.0)
	FlyLinked("relative", GetPlayerVehicleId(), 10, 1, 1)
end

function fl2()
	GetPlayerVehicle():SetCustomControlEnabled(1)
	GetPlayerVehicle():SetThrottle(1.0)
	FlyLinked("relative", GetPlayerVehicleId(), 10, 1, 1)
end


function dsc()
	GetPlayerVehicle():SetCustomControlEnabled(0)
end

function tec()
	CreateEffect("ET_PS_BIGWHEELGRASSSPLASH", CVector(60, 250, 60), Quaternion(0, 0, 0, 1), 100, 0 )
	CreateEffect("ET_PS_BIGWHEELGRASSSPLASH", CVector(70, 250, 70), Quaternion(0, 0, 0, 1), 0, 1 )
end 

function tgr()
	local Workshop = GetEntityByName("TheTown_Workshop")
	local Repository = Workshop:GetRepositoryByTypename("CabinsAndBaskets")
	Repository:AddItems("belazCab01", 2)
end

function trailer( enable )
	if enable ~= 0 then
		GetPlayerVehicle():AttachTrailer("MolokovozTrailer")
	else
		GetPlayerVehicle():DetachTrailer()
	end
end


function CreateDummy( prototype, modelName, mass, pos )
	println(prototype)

	local objId = CreateNewObject{ prototypeName = prototype, objName="ddd" }
	local obj = GetEntityByID( objId )

	obj:SetModelName( modelName )
	obj:SetMass( mass )
	obj:SetPosition( pos )
end

function PlayerDie()
	GetPlayerVehicle():AddModifier("hp", "- 1000000" )
end

function  bbb()
	getObj("boss"):StartMoving(CVector(200,300,200),CVector(1,0,0))
end

function  bbb1()
	getObj("boss"):StartMoving(CVector(100,270,100),CVector(0,0,1))
end

function relCoord(name)
	local veh=GetPlayerVehicle()
	if name then 
		local vehtmp = GetEntityByName(name)
		if vehtmp then
		   veh = vehtmp
		else
			println("Object with name "..name.." not exists")
		end
	end

	local campos, camrot = GetCameraPos()
	local vehpos = veh:GetPosition()
	local pos=campos-vehpos
	local rot=camrot
    LOG(' <Point  ')
    LOG('    coord="' .. strsub( tostring(pos), 2, strlen( tostring(pos) ) - 1 ) .. '"')
    LOG('    rotation="'.. strsub( tostring(rot), 2, strlen( tostring(rot) ) - 1 ) .. '"/>')
end


function CreateEnemy(modelname)
-- создает врага в позиции камеры
    if not modelname then
		modelname="Ural01"
	end

	local enemyname = "EnemyTeam"..tostring(random(9999))

	local teamID = CreateNewObject{
			prototypeName = "team",
			objName = enemyname,
			belong = "1002"
		}
  	local team=GetEntityByID(teamID)

	local id = CreateNewObject{
		prototypeName = modelname,
		objName = "PlayerVehicle"..tostring(random(9999)),
		belong = "1002"
	}
	local vehicle = GetEntityByID(id)

	if vehicle and team then
		local hover = 1.5 * vehicle:GetSize().y
    	local pos = GetCameraPos()
		vehicle:SetPosition(pos)
		vehicle:SetRandomSkin()
		team:AddChild(vehicle)
    end

    println(enemyname)
end

function SetGameTime( h, m )

	if g_ObjCont ~= nil then
		local CurrentDate = g_ObjCont:GetGameTime().AsNumList

		g_ObjCont:SetGameTime( h, m, CurrentDate[2], CurrentDate[3], CurrentDate[4] )
		UpdateWeather()
	end

end