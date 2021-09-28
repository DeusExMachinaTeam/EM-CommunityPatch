-- ----------------------------------------------------------------------------
-- 
-- Workfile: dialoghelpers.lua
-- Created by: Anton
-- Copyright (C) 2000-2004 Targem Ltd. All rights reserved.
-- 
-- Some helper functions for working with quests and dialogs
-- Also to inform game designers about this functionality :)
-- 
-- ----------------------------------------------------------------------------
--  $Id: dialoghelpers.lua,v 1.32 2005/07/04 06:43:04 lena Exp $
-- ----------------------------------------------------------------------------

-- Quest helpers --------------------------------------------------------------

function TakeQuest( questName )
	g_QuestStateManager:TakeQuest( questName )

	if g_QuestStateManager:IsQuestTaken( questName ) then
 		AddImportantFadingMsgId( "fm_take_quest" )
	end
end

function CompleteQuest( questName )
	g_QuestStateManager:CompleteQuest( questName )

	if g_QuestStateManager:IsQuestTaken( questName ) and g_QuestStateManager:IsQuestComplete( questName ) then
 		AddImportantFadingMsgId( "fm_complete_quest" )
	end
end

function CompleteQuestIfTaken( questName )
	g_QuestStateManager:CompleteQuestIfTaken( questName )

	if g_QuestStateManager:IsQuestComplete( questName ) then
 		AddImportantFadingMsgId( "fm_complete_quest" )
	end
end

function FailQuest( questName )
	g_QuestStateManager:FailQuest( questName )

	if g_QuestStateManager:IsQuestTaken( questName ) and g_QuestStateManager:IsQuestFailed( questName ) then
 		AddImportantFadingMsgId( "fm_fail_quest" )
	end
end

function FailQuestIfTaken( questName )
	g_QuestStateManager:FailQuestIfTaken( questName )

	if g_QuestStateManager:IsQuestFailed( questName ) then
 		AddImportantFadingMsgId( "fm_fail_quest" )
	end
end

function IsQuestTaken( questName )
	return g_QuestStateManager:IsQuestTaken( questName )
end

function IsQuestComplete( questName )
	return g_QuestStateManager:IsQuestComplete( questName )
end

function IsQuestFailed( questName )
	return g_QuestStateManager:IsQuestFailed( questName )
end

function CanQuestBeGiven( questName )
	return g_QuestStateManager:CanQuestBeGiven( questName )
end

function IsQuestTakenAndNotComplete( questName )
	return IsQuestTaken( questName ) and not IsQuestComplete( questName )
end

-- Dialog helpers -------------------------------------------------------------

-- Начать диалог с NPC. Если диалога разговора не было на экране, то он отображается,
-- если диалог уже был, то переключается на нового NPC
function StartConversation( npcName )
	npc = g_ObjCont:GetEntityByObjName( npcName )
	if npc then
		TalkWithNpcDlg:Show( npc:GetId() )
	end
end


-- Закончить диалог с NPC
function EndConversation()
	ConversationWnd:EndConversation()
end


-- Закончит диалог с NPC и покинуть город
-- Если параметр bQuick = true то не проигрываем ролик выезда и города,
-- вместо этого просто сразу ставим машину в конечную точку пути выезда

function LeaveTown( bQuick )
	if not bQuick then
		MotherPanel:LeaveTown( false )	
	else
		MotherPanel:LeaveTown( bQuick )
	end
end



-- Player helpers -------------------------------------------------------------

-- Возвращает машину игрока
function GetPlayerVehicle()
	return g_Player:GetVehicle()
end

-- Возвращает id машины игрока
function GetPlayerVehicleId()
	return g_Player:GetVehicle():GetId()
end

function GetPlayerMoney()
	return g_Player:GetMoney()
end

function AddPlayerMoney( amount )
	if amount>0 then
	AddFadingMsgByStrIdFormatted( "fm_player_add_money", amount )
	elseif 0> amount then
		AddFadingMsgByStrIdFormatted( "fm_player_give_money", abs(amount ))
	end
	g_Player:AddMoney( amount )
end

function GetPlayerHealth()
	return g_Player:GetHealth()
end

function GetPlayerMaxHealth()
	return g_Player:GetMaxHealth()
end

function GetPlayerFuel()
	return g_Player:GetFuel()
end

function GetPlayerMaxFuel()
	return g_Player:GetMaxFuel()
end

-- Есть ли у игрока свободное место для вещей
function HasPlayerFreePlaceForItems( prototypeName, amount )
	if not amount then
		amount = 1
	end

	return g_Player:CanPlaceItemsToRepository( prototypeName, amount )
end


-- Добавляет amount штук новых объектов с прототипом prototypeName в репозиторий игрока
-- Если amount не указан, то он равен 1
-- Возвращает 1, если операция удалась
function AddItemsToPlayerRepository( prototypeName, amount )
	if not amount then
		amount = 1
	end

	return g_Player:AddItemsToRepository( prototypeName, amount )
end


-- Удаляет amount штук объектов с прототипом prototypeName из репозитория игрока (первые попавшиеся)
-- Если amount не указан, то он равен 1
-- Возвращает 1, если операция удалась
function RemoveItemsFromPlayerRepository( prototypeName, amount )
	if not amount then
		amount = 1
	end

	return g_Player:RemoveItemsFromRepository( prototypeName, amount )
end


-- Проверка, имеет ли игрок нужное количество предметов
-- Если amount не указан, то он равен 1
-- Возвращает 1, если операция удалась
function HasPlayerAmountOfItems( prototypeName, amount )
	if not amount then
		amount = 1
	end

	if not g_Player then
		println("error: no g_Player")
	end

	return g_Player:HasAmountOfItemsInRepository( prototypeName, amount )
end


-- Cinematic helpers ----------------------------------------------------------

-- Добавить в текущую синематику сообщение с идентификатором msgId
-- delay  - это задержка после окончания показа предыдущего сообщения,
-- либо после начала синематики, если это сообщение первое
function AddCinematicMessage( msgId, delay )
	if not msgId then
		LOG( "Error adding message to cinematic" )
		return
	end

	if not delay then
		delay = 0
	end

	g_CinemaPanel:AddMessage( msgId, delay )
end


-- Функции добавления записей в журнал -----------------------------------------

-- Добавляет историю в журнал, параметр - строковый идентификатор (сам текст д.б. в одном из строковых файлов)
function AddHistory( strHistoryId )
	Journal:AddHistory( strHistoryId, g_ObjCont:GetGameTime())
end


-- Добавляем книгу в журнал; параметр - строковый идентификатор названия книги
-- (само название д.б. в строковом файле; текст книги также д.б. в строковом файле,
-- при этом его идентификатор д.б. <Id названия> + "_diz" )
function AddBook( strBookNameId , strBookTextId)
    if strBookTextId==nil then
	strBookTextId = strBookNameId.."_diz"
	end
	if not BookExists( strBookNameId ) then Journal:AddBook( strBookNameId, strBookTextId ) end	
end


-- Проверка, была ли уже книга с таким названием добавлена ранее
function BookExists( strBookNameId )
	return Journal:BookExists( strBookNameId )
end



-- Добавляет прототипы в энциклопедию; параметр - список имен прототипов (тип параметра - table lua)
-- Пример вызова: AddToEncyclopaedia( {"Belaz01", "Molokovoz01"} )
function AddToEncyclopaedia( prototypeNamesTable )
	for i = 1, getn( prototypeNamesTable ) do
		Journal:AddPrototypeToEncyclopaedia( prototypeNamesTable[ i ] )
	end 
end


-- Добавляет группировку в энциклопедию; параметр - белонг

function AddBelongToEncyclopaedia( belong )
	Journal:AddClanToEncyclopaedia( belong )
end                              



-- Функции для апгрейда радара -------------------------------------------------

-- Изменяет параметры радара.
-- Содержание этой функции предлагается менять самим гейм-дизайнерам,
-- используя настраиваемые параметры радара.
-- Параметры радара:
--	разрешить/запретить показ машин - Radar:AllowVehicles( allow )
--	разрешить/запретить показ навпойнтов - Radar:AllowNavPoints( allow )
--	разрешить/запретить показ расстояния - Radar:AllowDistances( allow )
--	изменить радиус - Radar:SetScanRadius( <радиус в метрах> )
-- (Параметр функции upgradeStatus - произвольное число, нигде кроме этой функции не используемое)
function SetRadarUpgrade( upgradeStatus )
	if( upgradeStatus == 0 ) then
		Radar:AllowNavPoints( true )
		Radar:AllowVehicles( false )
		Radar:AllowTurrets( false )
		Radar:AllowDistances( false )
	elseif( upgradeStatus == 1 ) then 
		Radar:AllowNavPoints( true )
		Radar:AllowVehicles( true )
		Radar:AllowTurrets( true )
		Radar:AllowDistances( true )
		Radar:SetScanRadius( 300 )
	else
		LOG( "SetRadarUpgrade error - invalid upgrade status ("..upgradeStatus..")" )

	end
end


-- Функции для работы с миникартой -------------------------------------------------
-- Круг имя уровня центр круга и радиус для уровня который посещен
function ShowCircleOnMinimap( levelName, origin, radius )
	local rad = 100
	if radius then
		rad = radius
	end

	return LevelInfoManager:AddVisibilityCircleForLevel( levelName, origin, rad )
end

-- прямоугольни имя уровня центр Рект
function ShowRectOnMinimap( levelName, x0, y0, w, h )
	return LevelInfoManager:AddVisibilityRectForLevel( levelName, x0, y0, w, h )
end

-- квадрат имя уровня центр и полсторона	
function ShowSquareOnMinimap( levelName, origin, halfside )
	return LevelInfoManager:AddVisibilityRectForLevel( levelName, origin.x - halfside, origin.z - halfside, halfside * 2, halfside * 2 )
end

-- добавляет иконку уровня на глобальной карте
function AddKnownLevel( levelName )
	return LevelInfoManager:AddKnownLevel( levelName )
end

-- есть ли на глобальной карте
function IsLevelKnown( levelName )
	return LevelInfoManager:IsLevelKnown( levelName )
end

-- посешает или нет, можно посмотреть минимап или нет
function IsLevelVisited( levelName )
	return LevelInfoManager:IsLevelVisited( levelName )
end



-- Сохранение ------------------------------------------------------------------------

-- Сохранить игру (старое автосохранение будет перезаписано)
function AutoSave()
	SavesManager:AutoSave( "" );
end



-- Исчезающие сообщения------------------------------------------------------------------------

-- Добавить сообщение, параметр - текст сообщения.
-- Не рекомендуется использовать в связи с проблемой локализации.
-- Вместо этого лучше исользовать функцию AddFadingMsgId
function AddFadingMsg( msg )
	AddFadingMsgFormatted( msg )
end


-- Добавить всплывающее сообщение в список "важных" сообщений
-- параметр - аналогичен предыдущей функции
function AddImportantFadingMsg( msg )
	AddImportantFadingMsgFormatted( msg )
end



-- Добавить сообщение, параметр - строковый идентификатор сообщения (сам текст д.б. в файле строк)
function AddFadingMsgId( msgId )
	AddFadingMsgByStrIdFormatted( msgId )
end


-- Добавить всплывающее сообщение в список "важных" сообщений
-- параметр - аналогичен предыдущей функции
function AddImportantFadingMsgId( msgId )
	AddImportantFadingMsgByStrIdFormatted( msgId )
end                                        


-- Мэсседж боксы -----------------------------------------------------------------------------------

-- Показать окно сообщения с кнопками выбора ответа.
-- Параметр - идентификатор сообщения (само сообщение д.б. в "data\maps\<ИмяКарты>\strings.xml")
-- В структуре сообщения в параметре numButtons указывается количество кнопок (1-OK; 2-OK+cancel, 3-OK+NO+cancel).
-- Возвращаемое значение - номер кнопки.

function SpawnMessageBox( msgId, pause )
	if not pause then
		pause = true
	end
	
	return MsgManager:ShowMsgBox( msgId, pause )
end



-- Условное закрытие окна города ---------------------------------------------------------------------------

-- Данная функция позволяет отметить некий город, для которого окно города будет закрываться только из скрипта.
-- При попытке пользователя закрыть окно города будет сгенерировано сообщение GE_TOWN_CONDITIONAL_CLOSING от имени города
-- Параметры: 
-- 	townName		- имя города
-- 	levelName		- уровень, на котором город находится
-- 	bConditionalClosing	- булевский параметр, установить/сбросить флаг условной закрываемости

function SetConditionalClosingForTown( townName, levelName, bConditionalClosing )
	TownDlg:SetConditionalClosingForTown( townName, levelName, bConditionalClosing )
end


-- Узнать, является ли окно для данного города условно закрываемым

function IsTownWithConditionalClosing( townName, levelName )
	return TownDlg:IsTownWithConditionalClosing( townName, levelName )
end




-- Квестовые предметы ----------------------------------------------------------------------


-- Дать квестовый предмет игроку. Параметр - имя прототипа предмета

function AddQuestItem( itemPrototypeName )
	g_Player:AddQuestItem( itemPrototypeName )
end


-- Забрать квестовый предмет у игрока. Параметр - имя прототипа предмета

function RemoveQuestItem( itemPrototypeName )
	g_Player:RemoveQuestItem( itemPrototypeName )
end


-- Проверить, есть ли у игрока квестовый предмет с заданным прототипом.

function IsQuestItemPresent( itemPrototypeName )
	return g_Player:IsQuestItemPresent( itemPrototypeName )
end



-- Группы оружия - сохранение и восстановление ------------------------------------------------

-- Сохранение текущих групп оружия.
-- (Необходимо вызывать ДО того как у игрока отобрали машину)

function SaveWeaponGroups()
	WeaponGroupManager:SaveWeaponGroups()
end



-- Восстановление сохраненных групп оружия
-- (Необходимо вызывать ПОСЛЕ того как игроку вернули машину)

function RestoreWeaponGroups()
	WeaponGroupManager:RestoreWeaponGroups()
end


-- Разрешить/запретить сохранение игры
function AllowSave( allow )
	if allow == nil then
		allow = true
	end
	
	g_ObjCont:AllowSave( allow )
end



-- Помощь ---------------------------------------------------------------------------------------

-- Разрешить/запретить автоматический показ помощи для профиля

function EnableAutoHelp( bEnable )
	HelpManager:EnableAutoHelp( bEnable )
end


-- Узнать, отказался ли пользователь от автоматической помощи

function IsAutoHelpEnabled()
	return HelpManager:IsAutoHelpEnabled()
end


-- Показать окно помощи. Параметр - идентификатор строки помощи*. 
-- * В случае, если необходимо показать некое специальное окно (например, помощь для главного интерфейса),
-- то параметр - это идентификатор самого окна.
-- 	Список идентификаторов специальных окон помощи:
-- 	HELP_ID_MAIN_GAME_INTERFACE		- помощь для главного интерфейса

function ShowHelp( helpId )
	HelpManager:ShowHelp( helpId, true )
end



-- Индикатор жизни босса ----------------------------------------------------------------------------

function ShowBossIndicator( bossId )
	MainGameInterface:SetupForBoss( bossId )
end


function HideBossIndicator()
	MainGameInterface:SetupForBoss( -1 )	
end