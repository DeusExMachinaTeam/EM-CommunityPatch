-- ----------------------------------------------------------------------------
-- 
-- Workfile: server.lua
-- Created by: Plus
-- Copyright (C) 2000-2003 Targem Ltd. All rights reserved.
-- 
-- Global server related stuff. This script is executed on server init,
-- from CServer::Init().
-- 
-- ----------------------------------------------------------------------------
--  $Id: server.lua,v 1.53 2005/07/26 09:06:59 anton Exp $
-- ----------------------------------------------------------------------------
anticheat = 0
-- include cheats.lua
EXECUTE_SCRIPT "data\\scripts\\cheats.lua"

-- include debug.lua
EXECUTE_SCRIPT "data\\scripts\\debug.lua"

-- include AIReader.lua
EXECUTE_SCRIPT "data\\scripts\\AIReader.lua"


-- include dialoghelpers.lua
EXECUTE_SCRIPT "data\\scripts\\dialoghelpers.lua"

-- include queststates.lua
EXECUTE_SCRIPT "data\\scripts\\queststates.lua"

-- global object repository
g_ObjCont = GET_GLOBAL_OBJECT "g_ObjContainer"

if not g_ObjCont then
	LOG "Could not find global g_ObjContainer!!!"
end

-- global quest info manager
g_QuestStateManager = GET_GLOBAL_OBJECT "g_QuestStateManager"

if not g_QuestStateManager then
	LOG "Could not find global g_QuestStateManager!!!"
end

-- global quest info manager
-- g_Player = GET_GLOBAL_OBJECT "g_Player"

-- if not g_Player then
--	LOG "Could not find global g_Player!!!"
-- end


LEVEL_SIZE = 8*32.0
g_Level = GET_GLOBAL_OBJECT "CurrentLevel"
if g_Level then
	LEVEL_SIZE = g_Level:GetLandSize()*32.0
else
end


-- Initializes global player. Called from code when the map is loaded
function InitPlayer()
	g_Player = GET_GLOBAL_OBJECT "g_Player"

	if not g_Player then
 		LOG "Could not find global g_Player!!!"
        else
                GameFiltersUse()
	end
end


-- shortcut: returns Game Object via name
function GetEntityByName( name )
	return g_ObjCont:GetEntityByObjName( name )
end


-- shortcut: returns Game Object via ID
function GetEntityByID( id )
	return g_ObjCont:GetEntityByObjId( id )
end


-- shortcut: creates Game Object and all it's children, returns it's handler (ID)
local function _CreateNewObject( prototypeName, objName, parentId, belong )
	local prototypeId = g_ObjCont:GetPrototypeId( prototypeName )

	return g_ObjCont:CreateNewObject( prototypeId, objName, parentId, belong )
end


-- shortcut: object constructor
function CreateNewObject( arg )
	if not arg.parentId then 
		arg.parentId = -1 
	end
	
	if not arg.belong then 
		arg.belong = 1001 
	end
	
	return _CreateNewObject( arg.prototypeName, arg.objName, arg.parentId, arg.belong )
end


-- these ought to match those ones in Relationship.h
RS_ENEMY	= 1
RS_NEUTRAL	= 2
RS_ALLY		= 3
RS_OWN		= 4


-- safe object remove
function RemoveObject( GameObject )
	GameObject:Remove()
	GameObject = nil
end


--Activate trigger
function TActivate( TriggerName )
	local trig1 = GetEntityByName(TriggerName)
	if trig1 then 
		trig1:Activate() 
	end
end


--Deactivate trigger
function TDeactivate( TriggerName )
	local trig1 = GetEntityByName(TriggerName)
	if trig1 then 
		trig1:Deactivate() 
	end
end


function SetVar(Name, Value)
	local trig1 = GetEntityByName("GlobalVar")
	if trig1 then 
		local tmpv=Value
	 	if type(Value)=="table" then
	 		tmpv=Value[1]
	 		for i=2,getn(Value) do
	 			tmpv=tmpv.." "..Value[i]
	 		end
	 	end
		local GAIParam v = tmpv
		trig1:SetVar(Name, v ) 
	end
end


function GetVar(Name)
	local trig1 = GetEntityByName("GlobalVar")
	if trig1 then 
		return trig1:Var(Name) 
	else
		return nil
	end
end


function SetTolerance( ID1, ID2, Tol )
	g_ObjCont:SetTolerance( ID1, ID2, Tol )
end


function GetTolerance( ID1, ID2 )
	return g_ObjCont:GetTolerance( ID1, ID2 )
end


function IncTolerance( ID1, ID2, Tol )
	g_ObjCont:IncTolerance( ID1, ID2, Tol )
end


CINEMATIC_AIM_TO_ID 	= 1
CINEMATIC_AIM_TO_POINT	= 2
CINEMATIC_FROM_POS		= 3
CINEMATIC_NO_AIM		= 4

function FlyLinked( PathName, Id, PlayTime, StartFade, EndFade, LookToId, VisPanel, RelativeRotations, 
	WaitWhenStop, InterpolateFromPrevious )
	
	local cinematic = GetCinematic()
--	RuleConsole("FogOfWar 0")	

	SetCinematicFadeParams( StartFade, EndFade )

	ChangeMode("GS_CINEMATIC")
	--cinematic:ResetAim()
	
	if VisPanel ~= nil then
        	SetCinematicCinemaPanel( VisPanel )
	else
                SetCinematicCinemaPanel( 1 )
	end

	cinematic:Load("camera_paths.xml")
	cinematic:SetPath(PathName)	

	cinematic:SetRelativePoints(1)
	cinematic:SetRelativeRotations(0)
	cinematic:SetBaseToId(Id)

	if LookToId then
		cinematic:SetAimToID( LookToId )
		cinematic:SetLookTo( true )
	else
		cinematic:SetRelativeRotations(  RelativeRotations )
		cinematic:SetLookTo( false )
	end

	cinematic:SetWaitWhenStop( WaitWhenStop )
	cinematic:SetLerpFromPreviousItem( InterpolateFromPrevious )

	cinematic:Play( PlayTime )
end

-- ������������ �������� ������
function FlyAround( Phi, Theta, Radius, PlayTime, curPos, Id, StartFade, EndFade, PathName, VisPanel,
	WaitWhenStop, InterpolateFromPrevious )
	
	local cinematic = GetCinematic()
--	RuleConsole("FogOfWar 0")

	SetCinematicFadeParams( StartFade, EndFade )
	
	if not cinematic then
		println( "Error: couldn't get cinematic" )
		return
	end
	
	if not PathName then
		PathName = ""
	end	

	ReadyCinematic()	
--	ChangeMode("GS_CINEMATIC")
--	cinematic:ResetAim()
	cinematic:SetAimToID(Id)

	if VisPanel then
        	SetCinematicCinemaPanel( VisPanel )
	else
                SetCinematicCinemaPanel( 1 )
	end

	cinematic:SetWaitWhenStop( WaitWhenStop )
	cinematic:SetLerpFromPreviousItem( InterpolateFromPrevious )

	cinematic:FlyAround( Phi, Theta, Radius, PlayTime, curPos, PathName )
end

-- ������������ ������ ������ �� ����
function Fly( PathName, AimType, Target, Time, StartFade, EndFade, VisPanel,
	WaitWhenStop, InterpolateFromPrevious )
	
	local cinematic = GetCinematic()
--	RuleConsole("FogOfWar 0")

	if not cinematic then
		println( "Error: couldn't get cinematic" )
		return
	end

	if not StartFade then
		println( "Error: StartFade parameter missing" )
		return
	end

	if not EndFade then
		println( "Error: EndFade parameter missing" )
		return
	end
	
--	ReadyCinematic()
	cinematic:Load("camera_paths.xml")
	SetCinematicFadeParams( StartFade, EndFade )
	ChangeMode("GS_CINEMATIC")
	--cinematic:ResetAim()

	if VisPanel ~= nil then
        	SetCinematicCinemaPanel( VisPanel )
	else
                SetCinematicCinemaPanel( 1 )
	end

	--cinematic:SetPath(PathName)

	if AimType == CINEMATIC_AIM_TO_ID then 
		cinematic:SetAimToID( Target )
		cinematic:SetLookTo( true )
	end
	
	if AimType == CINEMATIC_AIM_TO_POINT then 
		cinematic:SetAim( Target )
		cinematic:SetLookTo( true )
	end	
	
	if AimType == CINEMATIC_FROM_POS or AimType == CINEMATIC_NO_AIM then 
		cinematic:SetLookTo( false )
	end
	
	if AimType == CINEMATIC_FROM_POS then 
		local pos, rot, lookAt = GetCameraPos()
		cinematic:SetPathFromPos( pos, rot, PathName )
	else
		cinematic:SetPath( PathName )
	end

	cinematic:SetRelativePoints( false )
	cinematic:SetRelativeRotations( false )

	cinematic:SetWaitWhenStop( WaitWhenStop )
	cinematic:SetLerpFromPreviousItem( InterpolateFromPrevious )
	
	cinematic:Play(Time)		
end

-- ��������� ��� ������������������ ������ �� ������������
function StartCinematic()
	local cinematic = GetCinematic()
	cinematic:StartCinematic()
	
	if g_CinemaPanel then
		g_CinemaPanel:ClearMessages()	
	end
	
	UpdateCinematic( 0 ) -- by Anton: don't touch this!
end

-- �������������� ���� � ������������ ����������� ������
function ReadyCinematic()
	local cinematic = GetCinematic()
	
	if not cinematic then
		println( "Error: couldn't get cinematic" )
		return
	end

	cinematic:Load("camera_paths.xml")
	ChangeMode("GS_CINEMATIC")
end


function FlyStandard( PathName, Time )
	Fly( PathName, CINEMATIC_NO_AIM, nil, Time, 1, 1 )
end



-- shortcut: Play Camera rout   
function FlyCamera( PathName, AimType, Target, Time, StartFade, EndFade )
	Fly( PathName, AimType, Target, Time, StartFade, EndFade )
end


function FlyCameraHoldMode( PathName, AimType, Target, Time )
	Fly( PathName, AimType, Target, Time, 1, 0 )
end


function GameCamera()
	ChangeMode("GS_GAME")
	EndCinematic()
	if (GetVar("PlayerModel").AsInt == 1) then
		ShowPlayerModel(1)
		SetVar("PlayerModel", 2)
	end                         
	local oldSpeed = GetVar("Speed").AsFloat
	if oldSpeed == 0 then
	  oldSpeed = 1 
	end
	SetGameSpeed( oldSpeed )
	local IsSetCameraPos = GetVar("IsSetCameraPos").AsInt
	if IsSetCameraPos == 1 then
		SetCameraPos(GetVar("campos").AsVector, GetVar("yaw").AsFloat, GetVar("pitch").AsFloat, GetVar("roll").AsFloat)
-- 		println("IsSetCameraPos")
	end
	SetVar("IsSetCameraPos",0)
-- �������� �������			
	local DA = getObj("Destroy_Actors")
	if not(DA) then	
		RemoveAPlayer()	
	else
		DA:SetVar( "NPCID", 0 )
		DA:Activate()
	end
-- 	������ � ����-��� ����� npc_fly
	local NPCID = GetVar( "NPCID" ).AsInt
--	println(NPCID)	
	if ( NPCID > 0 ) then
		SetVar( "NPCID", 0 )
		if GetEntityByID( NPCID ) then
			GetEntityByID( NPCID ):AddModifier( "Belong", "= "..tostring( GetVar( "NPCBelong" ).AsInt ) )
			if GetVar( "NPCH" ).AsInt == 1 then 
				if DA then
					DA:SetVar( "NPCID", NPCID )
				else
					GetEntityByID( NPCID ):Hide() 
				end
			end
		end
	end
end


-- Constants for units animations
AT_STAND1		=	0
AT_STAND2		=	1
AT_MOVE1		=	2
AT_MOVE2		=	3
AT_ATTACK1		=	4
AT_ATTACK2		=	5
AT_PAIN1		=	6
AT_PAIN2		=	7
AT_DEATH1		=	8
AT_DEATH2		=	9
AT_BLOCK1		=	10
AT_BLOCK2		=	11
AT_RESERVED1	=	12
AT_RESERVED2	=	13
AT_RESERVED3	=	14
AT_RESERVED4	=	15

function getObj( name )
	local obj = nil
	if type(name) == "string" then
		obj = GetEntityByName( name )
	else if type(name) == "number" then 
			obj = GetEntityByID( name )
		else
			obj = name
	    end
	end
	return obj
end


function GetCurNpc()
	return GET_GLOBAL_OBJECT "g_CurrentNpc"
end

Q_UNKNOWN		=	0
Q_CANBEGIVEN	=	1
Q_TAKEN			=	2
Q_COMPLETED		=	3
Q_FAILED		=	4

function QuestStatus(name)
-- ���������� ������ ������ � ������ name
-- 0 - ����� �� ���� � �� ����� ���� ���
-- 1 - ����� ����� ���� ���
-- 2 - ����� ��� (�� �� �������� � �� ��������)
-- 3 - ����� ��������
-- 4 - ����� ��������
	local Stat=Q_UNKNOWN
	if		CanQuestBeGiven(name)	then Stat=Q_CANBEGIVEN
	elseif	IsQuestFailed(name)		then Stat=Q_FAILED
	elseif	IsQuestComplete(name)	then Stat=Q_COMPLETED
	elseif	IsQuestTaken(name)		then Stat=Q_TAKEN
	end
	return Stat
end

function TeamCreate(Name, Belong, CreatePos, ListOfVehicle, WalkPos, IsWares, Rotate)
	return CreateTeam(Name, Belong, CreatePos, ListOfVehicle, WalkPos, IsWares, Rotate)
end

function CreateTeam(Name, Belong, CreatePos, ListOfVehicle, WalkPos, IsWares, Rotate)
-- ������� ������� ����� �� ������ ListOfVehicle, � ������ Name � �������� Belong, � ������� CreatePos.
-- E��� ���� ������ �����, �� ���� ������� WalkPos
-- ���������� ��������� �� ��������� �������(���� ��� ��), ���� 0 - ���� ������
-- IsWares - 1 ������������ � ������ ��������� �����
-- Rotate - ��������� ���� ���������� �����
-- ������:
-- TeamCreate("ExtrGuardTeam",1012,CVector(985.260, 306.000, 2541.873),{"Revolutioner1","Revolutioner2","Bug01","Bug01","Revolutioner2"})
-- ����� ������� ������� �� 5 �����. � ������� ����� ��� ExtrGuardTeam, � � �����
-- ExtrGuardTeam_vehicle_0, ExtrGuardTeam_vehicle_1, .. ExtrGuardTeam_vehicle_4.
-- ������ ��������� � ��� �� ��� Z (���� �� ������). 
	local teamID = CreateNewObject{
			prototypeName = "team",
			objName = Name,
			belong = Belong
		}
	local team=GetEntityByID(teamID)
	if team then
--	   println("team created")
	   local i=1
	   local id=0
	   while ListOfVehicle[i] do
		 local id = CreateNewObject{
						prototypeName = ListOfVehicle[i],
						objName = Name.."_vehicle_"..i-1,
						belong = Belong
					}
		 local vehicle = GetEntityByID(id)
		 if vehicle then
			vehicle:SetRandomSkin()
		 	if IsWares==1 then
				local mapNum = 0
				local mapName = GET_GLOBAL_OBJECT( "CurrentLevel" ):GetLevelName()
				if mapName == "r1m1" then mapNum = 0 end
				if mapName == "r1m2" then mapNum = 1 end
				if mapName == "r1m3" then mapNum = 1 end
				if mapName == "r1m4" then mapNum = 2 end
				if mapName == "r2m1" then mapNum = 3 end
				if mapName == "r2m2" then mapNum = 4 end
				if mapName == "r3m1" then mapNum = 5 end
				if mapName == "r3m2" then mapNum = 6 end
				if mapName == "r4m1" then mapNum = 7 end
				if mapName == "r4m2" then mapNum = 8 end

				local RandWarez = {"potato","firewood","scrap_metal","oil","fuel","machinery","bottle","tobacco","book","electronics"}
    				local r = random(2) + mapNum

				vehicle:AddItemsToRepository(RandWarez[r], 1)
			end
			
			-- by Anton: ��� �� �����, �.�. �������� SetGamePositionOnGround()
			-- CreatePos.y = g_ObjCont:GetHeight(CreatePos.x, CreatePos.z) + 1.3 * vehicle:GetSize().y
				if Rotate then
				-- by Anton: ������������� �������� ����� ��� ��� ��������� ������� �� �����, ��� ��� ���������
					vehicle:SetRotation(Quaternion(Rotate))
				end
			vehicle:SetGamePositionOnGround(CreatePos)
			
			 team:AddChild(vehicle)
		 local vh_length=1.7 * vehicle:GetSize().z
		 CreatePos.z=CreatePos.z+vh_length
		 end
		 i = i + 1
	   end
	else
	   println("Error: Can't create team !!!")
--	   team:Remove()
	   return 0
	end
		if WalkPos then
			team:SetDestination(WalkPos)
		end
	return team
end

-- ���������� ����� ����� ���������
function Dist(obj1, obj2)
	local L = 0

	if not(obj1) or not(obj2) then
		println ("ERROR! Zero-Object...")
	end

	if obj1 and obj2 then 
		L = (obj1:GetPosition() - obj2:GetPosition()):length()
	end

	return L
end

function getPos(name)
	local obj=getObj(name)
	if obj then
	   local pos=obj:GetPosition()
	   return pos
	else
		return nil
	end
end

function GetPos(name)
	return getPos(name)
end

function setPos(name, position)
	local obj = getObj( name )
	if obj then 
		if obj:GetClassName()=="Vehicle" then
			obj:SetGamePositionOnGround(position)
		else
			obj:SetPosition(position)
		end
		return position
	else
		return nil
	end
end

function SetPos(name, position)
	return setPos(name, position)
end


function setRot(name, rotation)
	local obj = getObj( name )
	if obj then 
		obj:SetRotation(rotation)
		return rotation
	else
		return nil
	end
end


-- �������� �������� � ������� ������
function GameFiltersUse()
--			g_EnableBloom (true, 0.75, 0.25)

--                      g_EnableBloom (false)
--                      g_EnableMotionBlur (false)

--                      g_EnableBloom( GetProfileBloom() )
--                      g_EnableMotionBlur( GetProfileMotionBlur(), GetProfileMotionBlurAlpha() )
end

-- �������� �������� � ������������������� ������
function CinemaFiltersUse()
--			g_EnableBloom (true, 0.75, 0.55)
--			g_EnableMotionBlur (true, 0.25)
end

-- special function for creating vehicle
function CreateVehicle( PrototypeName, Belong, pos, NameVehicle)

	-- Create name of vehicle
	local nameVeh

	if NameVehicle then
		nameVeh = NameVehicle
	else
		nameVeh = "Vehicle"..tostring(random(9999))
	end

	-- Create vehicle
	local id = CreateNewObject{
		prototypeName = PrototypeName,
		objName = nameVeh,
		belong = Belong
	}

	local vehicle = GetEntityByID( id )
	println(vehicle:GetName())

	-- by Anton: ��� �� �����, �.�. �������� SetGamePositionOnGround()
	-- local hover = 1.5 * vehicle:GetSize().y
	-- pos.y = g_ObjCont:GetHeight( pos.x, pos.z ) + hover

	vehicle:SetGamePositionOnGround( pos )


	-- Add vehicle to some team
	local teamId = CreateNewObject{
		prototypeName = "team",
		objName = "Team"..tostring(random(9999)),
		belong = Belong
	}

	local team = GetEntityByID( teamId )

	if not team then
		println( "Error: coundn't create team" )
		return nil
	end

	team:AddChild( vehicle )

	println( "Vehicle created. id = "..tostring(id) )

	return team
end

-- special function for creating humans
function CreateHuman( PrototypeName, Belong, Pos, HumanName, PathName )

	-- Create name of Human
	local nameHuman

	if HumanName then
		nameHuman = HumanName
	else
		nameHuman = "Human"..tostring(random(9999))
	end

	-- Create human belong	
   	local bel

	if belong then
		bel = belong
	else
		bel = 1100
	end

	-- Create human
	local id = CreateNewObject{
		prototypeName = PrototypeName,
		objName = nameHuman,
		belong = bel
	}

	local human = GetEntityByID( id )
	
	if not human then
		println( "Error: human ".. PrototypeName .. " is not created" )
		return nil
	end

	Pos.y = g_ObjCont:GetHeight( Pos.x, Pos.z )

	human:SetPosition( Pos )

	if PathName then
	if not human:AddWalkPathByName( PathName  ) then
		println( "Error: path ".. PathName .." for human ".. nameHuman .. " is not added" )
		return nil
	end
	
	if not human:SetWalkPathByName( PathName  ) then
		println( "Error: path ".. PathName .." for human ".. nameHuman .. " is not set" )
		return nil
	end
	end

	return human
end


function GetItemsAmount(name)
-- ������� ���������� ���-�� ������ ������ name � ������ ������
--	local pl=GetPlayerVehicle():GetParent()
	local pl=GetPlayerVehicle()
	if pl then
--	   println("Player live")
	   local i=0
	   while pl:HasAmountOfItemsInRepository( name,i+1 ) == 1 do
	   		i = i + 1
	   end
	   println( "Get result = "..tostring(i) )
	   return i
	end
	return nil
end

function AddPlayerItems(name, count)
-- ��������� ������ count ������ ������ name.
-- ���������� ���-�� ��������� ������ ������
-- ���� � ������ �� ������� ����� ��� ��������� ���-��, �� �������� ������� ������
	if count==nil or 0>count then count=1 end
--	local pl=GetPlayerVehicle():GetParent()
	local pl=GetPlayerVehicle()
	if pl then
		local i = count
		while (pl:AddItemsToRepository(name,i) == nil) and (i>=1) do
			i = i - 1
		end
--		println( "Add result = "..tostring(i))
		if 0>=i then
			return nil
		else
			return i
		end
	end
end

function AddPlayerItemsWithBox(name, count, boxtype, pos)
-- ��������� ������ count ������ ������ name.
-- ���� ���� ����� �� ������, �� ������� ��������� �  pos, � ���� ����������� �� ������� � ������
-- boxtype - ��� ����� (���������������� �������)
	local WasAdd=AddPlayerItems(name, count)
	if WasAdd==nil then WasAdd=0 end
	if count==nil or 0>count then count=1 end
--	println("WasAdd = "..WasAdd.." Count = "..count)
	if count>WasAdd then
--		println("count>WasAdd")
		local chestID = CreateNewObject{	prototypeName = "someChest",
											objName = "ItemsChest"..random(1000)
								  	   }	
		local MyChest=GetEntityByID(chestID)
		if pos==nil then
			pos = CVector(GetPlayerVehicle():GetPosition())
			pos.z = pos.z + GetPlayerVehicle():GetSize().z + 1
		end
		MyChest:SetPosition(pos)
--		println("pos = "..pos)
		for i=WasAdd+1, count do
--			println(" i = "..i)
			local itemID = CreateNewObject{	prototypeName = name,
												objName = name..random(1000)
									  	   }
			local MyItem = GetEntityByID(itemID)
			if MyChest and MyItem then
			   MyChest:AddChild(MyItem)
            end
		end
   end
end

function RemovePlayerItem(name, count)
-- ������� ������� count ������ ������ name �� ������ ������
    if count==nil or 0>count then count=1 end
--	local pl=GetPlayerVehicle():GetParent()
	local pl=GetPlayerVehicle()
	if pl then
--	   println("Player live")
	   local res=pl:RemoveItemsFromRepository(name, count)
	   return res
	else
		return nil
	end
end

function AddChildByPrototype( obj, protName)
    local myobj = getObj(obj)
    if myobj then
		if type(protName) == "string" then
			local pr_id = CreateNewObject{
											prototypeName = protName,
											objName = protName..random(10000)
								  	   }	
			local mych = GetEntityByID( pr_id )
			if mych then
				if myobj then 
					myobj:AddChild( mych )
				end
			end
		elseif type(protName) == "table" then
			local i = 1
			while protName[i] do
				local id = CreateNewObject{
												prototypeName = protName[i],
												objName = protName[i]..random(10000)
									  	   }	
				local child = GetEntityByID( id )
				if myobj then 
					myobj:AddChild( child )
				end
				i = i+1
			end			
		end
	end
end

-- ������� ������� ����� ������ � �������� �������
function CreateNewDummyObject(modelName, objName, parentId, belong, pos, rot,skin)
	local prototypeName 	=  	"someDummyObject"
	local dObj		=	_CreateNewObject( prototypeName, objName, parentId, belong )
	local obj		=	GetEntityByID (dObj)

	if skin == nil then skin = 0 end

	obj:SetModelName( modelName )
	obj:SetRotation ( rot )
	obj:SetPosition ( pos )
	obj:SetSkin ( skin )
end

-- ������� ������� Breakable ������ � �������� �������
function CreateNewBreakableObject(prototypeName, objName, belong, pos, rot,skin)
	local parentId = -1
	local dObj		=	_CreateNewObject( prototypeName, objName, parentId, belong )
	local obj		=	GetEntityByID (dObj)

	if skin == nil then skin = 0 end
	
	obj:SetRotation ( rot )
	obj:SetPosition ( pos )
	obj:SetSkin ( skin )
end


-- ������� ������� SgNodeObject � �������� �������
function CreateNewSgNodeObject( modelName, objName, parentId, belong, pos, rot , scale)
	local prototypeName =  	"SgNodeObject"
	local dObj			=	_CreateNewObject( prototypeName, objName, parentId, belong )
	local obj			=	GetEntityByID (dObj)

	obj:SetSgNode( modelName )
	if rot then
		obj:SetRotation ( rot )
	else
		obj:SetRotation (Quaternion(0.0000, 0.0000, 0.0000, 1.0000))
	end

	if scale then
		obj:SetScale ( scale )
	end

	obj:SetPosition ( pos )
	return obj
end


-- ������� ������� ����� �� ������ ListOfVehicle, � ������ Name � �������� Belong, � ������� CreatePos � ���� �� ��������� �����.
function TeamCreateWithWarez(Name, Belong, CreatePos, ListOfVehicle, WalkPos)
	return CreateTeam(Name, Belong, CreatePos, ListOfVehicle, WalkPos, 1)
end

function CapturePlayerVehicle(NeedRemove, TeamName, WalkPos)
	if GetPlayerVehicle() then
		GetPlayerVehicle():setGodMode(1)
		local tm
		if TeamName then
			tm=TeamName
		else
			tm="PlayerTeam"..random(1000)
		end

	local teamID = CreateNewObject{
			prototypeName = "team",
				objName = tm,
				belong = "1100"
		}
	local team=GetEntityByID(teamID)
	if team then
			GetPlayerVehicle():SetCustomControlEnabled(1)
			team:AddChild(GetPlayerVehicle())
			if WalkPos then
--				println("Walk !!!")
				team:SetDestination(WalkPos)
			end

			if NeedRemove==1 then
				team:Remove()
				return nil
			else
				return team
		end
	   end
	end
end

function ShowCircleOnMinimapByName(objName, mapname, radius)
  local obj=getObj(objName)
  if not obj then
  	return -1
  end

  local map = GET_GLOBAL_OBJECT( "CurrentLevel" ):GetLevelName()
  if mapname then
     map = mapname
  end

  local rad = 100
  if radius then
     rad = radius
  end

  local coord = obj:GetPosition()
  ShowCircleOnMinimap( map, CVector(coord), rad )

end

function PlayerDead ( ppp )
--	LOG("Player DEAD")
--	println("Player DEAD")
--    local ppp, rrr = GetCameraPos()
    local pos = CVector(ppp)
	CreateNewDummyObject("cub", "yashik", -1, 1100, pos, Quaternion(0.0, 0.0, 0.0, 1.0), 0)
    local obj = getObj("yashik")
    if obj==nil then
    	return 
    end
    local objid = obj:GetId()
	pos.y = pos.y + 20
	pos.z = pos.z + 15
	FlyAround(5, 0.5, 15, 10, pos, objid, 0, 0, "" ,0 )
	StartCinematic()
end

--helper function for generating enemies in zone player is currently in
function GenerateEnemiesInPlayerZone()
	for i = 0, g_ObjCont:size() - 1 do
		local obj = g_ObjCont:GetEntityByObjId( i )
		if obj then
			if obj:IsKindOf( "InfectionZone" ) then
				if obj:IsPlayerInside() then
					obj:ResetTimeOut()
					println( "Generated enemies in zone ".. obj:GetName() )
				end
			end
		end
	end
end

function ASSERT( expr , mess)
	LOG("----------------- TRIGGER ASSERT ------------------------------------------------")
	if mess then
		LOG(mess)
		LOG("---------------------------------------------------------------------------------")
	end
	if expr then
		Assert( expr )
	else
		Assert( 0 )
	end
end




function GenerateRandomAffixList(CountAffixes, ClassAffixes)
	local listaff1 = {"useless_gun","rusty_gun","excellent_gun","advanced_gun"}
	local listaff2 = {{"slow_gun","assault_gun","rapid_firing_gun"},{"weak_gun","deadly_gun","destructive_gun"}}
	local listaff3 = {{"with_truncated_barrel_gun","with_enlarged_barrel_gun","with_long_barrel_gun"},{"without_sight_gun","with_laser_sight_gun","with_electric_sight_gun"},{"without_cooling_gun","with_water_cooling_gun","with_nitro_cooling_gun"}}

	local listaff = {0}
	local canused = {1, 1, 1}

	local TotalClass = 0
	local claff = 0

  	local affcount=1

  	if CountAffixes~=nil then
		if CountAffixes>3 then
			affcount=3
    	elseif 0>CountAffixes then
		    affcount=1
		else
			affcount=CountAffixes
		end
	end

	if ClassAffixes~=nil then
    	claff = ClassAffixes
		if affcount>claff then
			claff=affcount
		end
	end

	for i=1,affcount do
		local sub = affcount-i

        local rndgr
        repeat 
			rndgr = random (3)
	    until canused [rndgr] == 1
	 
		canused [rndgr] = 0

		if rndgr == 1 then
			local rndnum = random(4)
			if claff>0 then
				rndnum=4
				while sub>(claff-rndnum) do      --false!!!
					rndnum=rndnum-1
				end
				claff=claff-rndnum
			end

			listaff[i] = listaff1 [rndnum]
			TotalClass = TotalClass + rndnum
		elseif rndgr == 2 then
			local rndsubgr = random(2)
			local rndnum = random(3)
			if claff>0 then
				rndnum=3
				while sub>(claff-rndnum) do      --false!!!
					rndnum=rndnum-1
				end
				claff=claff-rndnum
			end

			listaff[i] = listaff2 [rndsubgr][rndnum]
			TotalClass = TotalClass + rndnum
		elseif rndgr == 3 then
			local rndsubgr = random(3)
			local rndnum = random(3)

			if claff>0 then
				rndnum=3
				while sub>(claff-rndnum) do      --false!!!
					rndnum=rndnum-1
				end
				claff=claff-rndnum
			end

			listaff[i] = listaff3 [rndsubgr][rndnum]
			TotalClass = TotalClass + rndnum
		else
			LOG("TRIGGER ERROR: Create Affixes - internal error. Out of range")	
		end
	end

	return listaff
end

function CreateRandomAffixesForGun(CountAffixes)
	local affixList = { }
	if CountAffixes ~= nil and CountAffixes > 0 then
		if CountAffixes > 2 then
			CountAffixes = 2
		end
		local affixes = {{{ "useless_gun", "rusty_gun" },
						{ "excellent_gun", "advanced_gun" }},
						{{ "slow_gun", "weak_gun" },
						{ "assault_gun", "rapid_firing_gun", "deadly_gun", "destructive_gun" }},
						{{ "with_truncated_barrel_gun", "without_sight_gun", "without_cooling_gun" },
						{ "with_enlarged_barrel_gun", "with_long_barrel_gun", "with_laser_sight_gun","with_electric_sight_gun", "with_water_cooling_gun", "with_nitro_cooling_gun" }}}
		affixTypes = { random(1, 3), random(1, 3) }
		if affixTypes[1] == affixTypes[2] then
			otherTypes = {}
			for i = 1, 3 do
				if i ~= affixTypes[1] then
					table.insert(otherTypes, i)
					affixTypes[2] = otherTypes[random(getn(otherTypes))]
				end
			end
		end
		quality = random(1, 2)
		for i = 1, CountAffixes do
			affixList[i] = affixes[affixTypes[i]][quality][random(getn(affixes[affixTypes[i]][quality]))]
		end
	end
	return affixList
end

function CreateBoxWithAffixGun(pos, GunPrototype, CountAffixes, ClassAffixes, BoxName)
-- ������� ���� � ������ name � ������� pos
-- 
-- 
	local name = BoxName
	if name==nil then 
		name = "ItemsChest"..random(10000)
	end
	if pos==nil or GunPrototype==nil then
		LOG("TRIGGER ERROR: Can't create box or gun. Not positiun ot gun prototype")			
		return nil
	end
	--local afflist = GenerateRandomAffixList ( CountAffixes, ClassAffixes )
	local afflist = CreateRandomAffixesForGun ( CountAffixes )
	local chestID = CreateNewObject{	prototypeName = "someChest",
										objName = name
							  	   }	

	local MyChest=GetEntityByID(chestID)
	if MyChest==nil then
		LOG("TRIGGER ERROR: Can't create box ")
		return nil
	end
		
	MyChest:SetPosition(pos)
	local id = CreateNewObject{ prototypeName = GunPrototype, objName = "RandomGuns"..random(10000), belong = 1100 }
    local gun = GetEntityByID( id )

    if gun==nil then
       LOG("TRIGGER ERROR: Create Affixes - Can't create gun")
       return nil
    end

	if afflist ~= nil then
    	for i=1,getn(afflist) do
			gun:ApplyAffixByName(afflist[i])
    	end
	end
	MyChest:AddChild(gun)
end


function AddVehicleGunsWithAffix( ObjName, GunPrototype, ListOfAffixes, GunName)
-- ������� ���������� ������ � ���������� ��������� � ������ ��� � ��������� ������ ������
--	ASSERT ( ObjPrototype~=nil, "Create Affix Assert: No Object Prototype ")
--	ASSERT ( GetPlayerVehicle~=nil, "Create Affix Assert: Player Vehicle Not Exists")
	local veh = getObj(ObjName)
    if GunPrototype==nil or veh==nil then 
       LOG("TRIGGER ERROR: Create Affixes - No Object Prototype or Object not exists")
       return nil
    end


	local name = GunName

	if name==nil then 
		name = "RandomGuns"..random(10000)
	end

	local id = CreateNewObject{ prototypeName = GunPrototype, objName = name, belong = 1100 }
    local gun = GetEntityByID( id )


    if gun==nil then
       LOG("TRIGGER ERROR: Create Affixes - Can't create gun")
       return nil
    end

    if ListOfAffixes~=nil then
	    if type(ListOfAffixes)=="table" then
			local l=getn(ListOfAffixes)
			for i=1,l do
				if ListOfAffixes[i] then
					gun:ApplyAffixByName( ListOfAffixes[i] )
				end
			end
		elseif type(ListOfAffixes)=="string" then
			gun:ApplyAffixByName( ListOfAffixes )
		end
    end
    local poloj = veh:AddObjectToRepository(gun)
    return gun
end



function AddVehicleGunsWithRandomAffix( ObjName, GunPrototype, CountAffixes, ClassAffixes, GunName )
-- ������� ��� ��������� ������ � ����������  ���������
-- � CountAffixes - ������������ ���������� �������� (�� 1 �� 3�)
-- ClassAffixes - ������� (�����) �������. ���� �� ������, �� ������������ ��������� ��������� �������
-- ���� �� ������ (������� ����� ���� �� 3 �� 10), �� ������������� ������� � ������������ � ��������� �������
-- ��� ���� ���������� ������ �������������� ������������ �������, ���������� ��������������� �� ��� ������� =)
-- �.�. ���� ����� ������������� ������ � 3�� ��������� � ������� 6, �� ������ ������ ����� ������ ������������ �������
-- 3 (��� 4 ��� 1�� ������), ���������� 3 (2) ������ ����������� 2 ������� ������ 2(1) � 1 ��������������

	local res = AddVehicleGunsWithAffix( ObjName, GunPrototype, GenerateRandomAffixList(CountAffixes, ClassAffixes), GunName)
	return res
end


function AddPlayerGunsWithAffix( GunPrototype, ListOfAffixes, GunName)
-- ������� ���������� ������ � ���������� ��������� � ������ ��� � ��������� ������ ������
--	ASSERT ( ObjPrototype~=nil, "Create Affix Assert: No Object Prototype ")
--	ASSERT ( GetPlayerVehicle~=nil, "Create Affix Assert: Player Vehicle Not Exists")

    local res = AddVehicleGunsWithAffix (GetPlayerVehicle(), GunPrototype, ListOfAffixes, GunName)
	return res
end



function AddPlayerGunsWithRandomAffix( GunPrototype, CountAffixes, ClassAffixes, GunName )
-- ������� ��� ��������� ������ � ����������  ���������
-- � CountAffixes - ������������ ���������� �������� (�� 1 �� 3�)
-- ClassAffixes - ������� (�����) �������. ���� �� ������, �� ������������ ��������� ��������� �������
-- ���� �� ������ (������� ����� ���� �� 3 �� 10), �� ������������� ������� � ������������ � ��������� �������
-- ��� ���� ���������� ������ �������������� ������������ �������, ���������� ��������������� �� ��� ������� =)
-- �.�. ���� ����� ������������� ������ � 3�� ��������� � ������� 6, �� ������ ������ ����� ������ ������������ �������
-- 3 (��� 4 ��� 1�� ������), ���������� 3 (2) ������ ����������� 2 ������� ������ 2(1) � 1 ��������������
	AddVehicleGunsWithRandomAffix( GetPlayerVehicle(), GunPrototype, CountAffixes, ClassAffixes, GunName)
--	AddPlayerGunsWithAffix( GunPrototype, GenerateRandomAffixList(CountAffixes, ClassAffixes), ObjName)
end

function AddPlayerGunsWithAffixOrMoney( Money, GunPrototype, ListOfAffixes, GunName)
-- ������� ���������� ������ � ���������� ��������� � ������ ��� � ��������� ������ ������
--	ASSERT ( ObjPrototype~=nil, "Create Affix Assert: No Object Prototype ")
--	ASSERT ( GetPlayerVehicle~=nil, "Create Affix Assert: Player Vehicle Not Exists")
	if GetPlayerVehicle():CanPlaceItemsToRepository( GunPrototype, 1 )~=nil then
		local gun = AddVehicleGunsWithAffix (GetPlayerVehicle(), GunPrototype, ListOfAffixes, GunName)
		if gun then 
			AddFadingMsgByStrIdFormatted( "fm_player_add_thing", GunPrototype)
		else
			AddPlayerMoney(Money)
		end
	else
		AddPlayerMoney(Money)
	end

end

function AddPlayerGunsWithRandomAffixOrMoney( Money, GunPrototype, CountAffixes, ClassAffixes, GunName)
-- ������� ���������� ������ � ���������� ��������� � ������ ��� � ��������� ������ ������
--	ASSERT ( ObjPrototype~=nil, "Create Affix Assert: No Object Prototype ")
--	ASSERT ( GetPlayerVehicle~=nil, "Create Affix Assert: Player Vehicle Not Exists")
	if GetPlayerVehicle():CanPlaceItemsToRepository( GunPrototype, 1 )~=nil then
		local gun = AddVehicleGunsWithRandomAffix( GetPlayerVehicle(), GunPrototype, CountAffixes, ClassAffixes, GunName)
		if gun then 
			AddFadingMsgByStrIdFormatted( "fm_player_add_thing", GunPrototype)
		else
			AddPlayerMoney(Money)
		end

	else
		AddPlayerMoney(Money)
	end

end

function exrandom( N )
    local N2 = N * 2
--    local aaa=floor(abs( ( random( N2 ) + random( N2 ) + random( N2 ) + random( N2 ) + random( N2 )  ) / 5.0 - N )+1)
    local aaa=floor(abs( (random( N2 ) + random( N2 ) + random( N2 ) + random( N2 ) + random( N2 )  ) / 5.0 - N )+1)
    return aaa
end

function RAD( angle )
	return angle/180*3.14159
end

function EnableGodMode()
	GetPlayerVehicle():setGodMode(true)
end

function DisableGodMode()
	GetPlayerVehicle():setGodMode(false)
end

function RotationPlayerByPoints(point2, point1)
	local player = GetPlayerVehicle()
	local dir = point1 - point2
	dir.y = 0
	player:SetDirection(dir:normalize())
end


function SaveAllToleranceStatus(SetStatus)
	GL_ToleranceStatus = {}
	for i=1,100 do
		GL_ToleranceStatus[i] = {}
		for j=1,100 do
			GL_ToleranceStatus[i][j] = GetTolerance(i+1000, j+1000)
			
	    end
  	end
  	if SetStatus then 
		for i=1,100 do
			for j=1,100 do
				SetTolerance(i+1000, j+1000, SetStatus)
		    end
  		end

  	end
end                     

function RestoreAllToleranceStatus()
	for i=1,100 do
		for j=1,100 do
		   SetTolerance(i+1000, j+1000, GL_ToleranceStatus[i][j])
    	end
    end
end


