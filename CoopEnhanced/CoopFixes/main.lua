local mod = CoopEnhanced;
local CoopFixes = CoopEnhanced.CoopFixes;

local game = Game();
local Utils = mod.Utils;

local json = require("json");

-- Saving and Loading
function CoopEnhanced.CoopFixes.gameStart(isCont, data)
	CoopFixes.DATA = {PLAYERS = {}};
	CoopFixes.RefreshFullscreen();
	
	if isCont and data and data.CoopFixes then
		CoopFixes.DATA.Players = data.CoopFixes.players;
		--CoopFixes.BackupAllPlayers(true);
		if mod.Config.CoopFixes.rejoin then mod:AddCallback(ModCallbacks.MC_POST_RENDER, CoopFixes.RejoinFix); end
	end
end
function CoopEnhanced.CoopFixes.gameEnd(data)
	if mod.Config.CoopFixes.rejoin then CoopFixes.BackupAllPlayers(); end
	if data == nil then data = {CoopFixes = {}}; elseif data.CoopFixes == nil then data.CoopFixes = {}; end
	data.CoopFixes.players = CoopFixes.DATA.Players;
	return data;
end


-- Fullscreen screen position fix
function CoopFixes.RefreshFullscreen()
	if mod.Config.CoopFixes.fullscreen.enable and Options.Fullscreen then
		Options.Fullscreen = false;
		Options.WindowPosX = mod.Config.CoopFixes.fullscreen.pos.X or 0;
		Options.WindowPosY = mod.Config.CoopFixes.fullscreen.pos.Y or 0;
		Options.Fullscreen = true;
	end
end


-- Joining Fix
-- Fixes an issue where sometimes when statring a game, players can't choose True Co-op Characters
function CoopFixes.JoinFix(_)
	if not CoopEnhanced.Config.CoopFixes.join.enable then mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, CoopFixes.CoopJoinFix); return; end
	local level = Game():GetLevel();
	local isStartingRoom = (level:GetStage() == LevelStage.STAGE1_1 and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex());
	local max_visits = CoopEnhanced.Config.CoopFixes.join.max;
	if max_visits == 0 then max_visits = level:GetCurrentRoomDesc().VisitedCount + 1; end
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_PRE_JOIN_EXECUTE, max_visits); -- Execute Pre Join Callbacks (max_visits(int))
	if isStartingRoom and level:GetCurrentRoomDesc().VisitedCount <= max_visits then
		Game():SetStateFlag(GameStateFlag.STATE_BOSSPOOL_SWITCHED, false); -- In Rep, this instead prevents true coop from starting
	else
		Game():SetStateFlag(GameStateFlag.STATE_BOSSPOOL_SWITCHED, true);
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CoopFixes.JoinFix);


--Rejoin Fix
-- Fixes Characters changing type on rejoin when controller order changes
function CoopFixes.RejoinFix() --Check if Controller Index is set wildly low/high (e.g. 4294967295 instead of 1)
	if Isaac:GetFrameCount() % 10 ~= 0 then return; end -- Check only every 10 frames or 6 times a second
	if CustomHealthAPI and mod.Config.CoopFixes.rejoin then 
		for i = 1, game:GetNumPlayers() do
			local player_entity = Isaac.GetPlayer(i - 1);
			if player_entity and (player_entity.ControllerIndex < 0 or player_entity.ControllerIndex > 5000) then
				local player_id = Utils.GetPlayerID(player_entity);
				--if player_id and CoopFixes.DATA.Players[player_id] then player_entity:SetControllerIndex(CoopFixes.DATA.Players[player_id].Data.Controller or 0); end
				return;
			end
		end
		CoopFixes.FixPlayers();
		game:GetHUD():AssignPlayerHUDs();
	end
	mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, CoopFixes.RejoinFix);
end

function CoopFixes.FixPlayers()
	if CoopFixes.DATA.Players == nil then return; end
	for i = 1, game:GetNumPlayers(), 1 do
		local player_entity = Isaac.GetPlayer(i - 1);
		local player_id = Utils.GetPlayerID(player_entity);
		if not CoopFixes.DATA.Players[player_id] or not CoopFixes.DATA.Players[player_id].Data then mod.Debug("Player (" .. i .. ") ID: " .. player_id .. " doesn't exist! Cannot load their rejoin data.",CoopFixes.Name); return; end
		local player_data = CoopFixes.DATA.Players[player_id].Data;
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_PRE_REJOIN_EXECUTE, i, player_data, player_entity); -- Execute Pre Fix Player data Callbacks (player_index, player_data(table), player_entity(EntityPlayer))
		-- Character type
		if player_data.Type and player_entity:GetPlayerType() ~= player_data.Type then
			mod.Debug("Player (" .. i .. ") has changed character(s) to " .. player_entity:GetName() .. " since last load, reseting to original character type " .. (Utils.GetCharacterByType(player_data.Type).Name or "nil"),CoopFixes.Name);
			if CustomHealthAPI then CustomHealthAPI.Helper.ChangePlayerType(player_entity, player_data.Type); else player_entity:ChangePlayerType(player_data.Type); end
		end
		-- Character Health
		if player_data.Health and CustomHealthAPI then
			if CustomHealthAPI.Helper.LoadPlayerHealthFromBackup then
				CustomHealthAPI.Helper.LoadPlayerHealthFromBackup(player_entity, player_data.Health);
			else
				CustomHealthAPI.Helper.CheckIfHealthOrderSet();
				
				local savetable = json.decode(player_data.Health)
				local healthData = savetable.Mainplayers[CustomHealthAPI.Helper.GetPlayerIndex(player_entity)];
				if healthData ~= nil then CustomHealthAPI.Helper.LoadHealthOfPlayerFromBackup(player_entity, healthData); end
				
				CustomHealthAPI.PersistentData.HiddenPlayerHealthBackup = savetable.Hidden or CustomHealthAPI.PersistentData.HiddenPlayerHealthBackup;
				CustomHealthAPI.PersistentData.HiddenSubplayerHealthBackup = savetable.HiddenSub or CustomHealthAPI.PersistentData.HiddenSubplayerHealthBackup;
				CustomHealthAPI.PersistentData.RestockInfo = savetable.RestockInfo or CustomHealthAPI.PersistentData.RestockInfo;
			end
		end
		-- Active slots
		for slot,active in pairs(player_data.Actives) do
			if player_entity:GetActiveItem(slot) ~= active.Item then
				mod.Debug("Player (" .. i .. ") has changed active item in slot " .. slot .. " since last load, reseting to original item.",CoopFixes.Name);
				if active.Item == CollectibleType.COLLECTIBLE_NULL then
					player_entity:RemoveCollectible(player_entity:GetActiveItem(slot), true, slot, true)
					break;
				end
				player_entity:AddCollectible(active.Item, active.Charge, false, slot, active.VarData)
			end
		end
		-- Charges
		if player_data.Charge then
			if player_data.Charge.Blood > 0 then player_entity:SetBloodCharge(player_data.Charge.Blood); end
			if player_data.Charge.Soul > 0 then player_entity:SetSoulCharge(player_data.Charge.Soul); end
			if player_data.Charge.Poop > 0 and player_entity:GetPoopMana() ~= player_data.Charge.Poop then player_entity:AddPoopMana(player_data.Charge.Poop - player_entity:GetPoopMana()); end
		end
		--Pocket slots
		for slot,pocket in ipairs(player_data.Pockets) do
			local pocket_item = player_entity:GetPocketItem(slot);
			local pocket_item_slot = pocket_item:GetType() == PocketItemType.ACTIVE_ITEM and player_entity:GetActiveItemDesc((pocket_item:GetSlot() - 1)) or pocket_item:GetSlot();
			local pocket_item_type = (pocket_item_slot == 0 and -1 or pocket_item:GetType());
			if pocket and pocket.Slot and (pocket_item_type ~= pocket.Type or pocket_item_slot ~= pocket.Slot) then
				mod.Debug("Player (" .. i .. ") has changed pocket item in slot " .. slot .. " since last load, reseting to original item.",CoopFixes.Name);
				if pocket.Type <= PocketItemType.PILL then player_entity:SetPill(slot,pocket.Slot);
				elseif pocket.Type <= PocketItemType.CARD then player_entity:SetCard(slot,pocket.Slot);
				else
					local active_slot = slot >= ActiveSlot.SLOT_POCKET and slot or (slot + 2)
					player_entity:SetPocketActiveItem(pocket.Slot.Item, active_slot, true);
					player_entity:SetActiveCharge(pocket.Slot.Charge,active_slot);
				end
			end
		end
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_POST_REJOIN_EXECUTE, i, player_entity); -- Execute Post Fix Player data Callbacks (player_index,  player_entity(EntityPlayer))
	end
end

function CoopFixes.LoadBackup(player_index, level_stage)
	local player_entity = Isaac.GetPlayer(player_index - 1);
	if player_index == nil or player_entity == nil then 
		print("There is no player data with an index of " .. (player_index or "nil") .. ". Current player indexes are:");
		for i = 1, game:GetNumPlayers(), 1 do
			local player_entity = Isaac.GetPlayer(i - 1);
			print("Player (" .. i .."): " .. player_entity:GetName() .. ", Index: " .. i .. (mod.Players.Twins[i] and ", Subplayer of Player(" .. mod.Players.Twins[i] .. ") (" .. Isaac.GetPlayer(mod.Players.Twins[i]):GetName() or ""));
		end
		return false;
	end
	local player_id = Utils.GetPlayerID(player_entity);
	local player_data = CoopFixes.DATA.Players[player_id];
	level_stage = level_stage or game:GetLevel():GetStage();
	
	if player_data == nil then
		print("There is no backup for player index: " .. player_index);
		return false;
	end
	if level_stage > 0 then
		if player_data.Backups and #player_data.Backups > 0 and player_data.Backups[level_stage] ~= nil then
			player_data.Data = Utils.CloneObject(player_data.Backup[level_stage]);
		else
			print("There is no backup at the specified depth. Possible level stage backups include: ");
			print("Initial: 0");
			for i,backup in pairs(player_data.Backups) do
				print(backup.Floor .. ": " .. i);
			end
			return false;
		end
	end
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_POST_REJOIN_BACKUP_LOAD, player_index, player_data, player_entity); -- Execute Post Backup data loading Callbacks (player_index, player_data(table), player_entity(EntityPlayer))
	
	CoopFixes.FixPlayers();
	return true;
end

function CoopFixes.BackupAllPlayers(save_floor)
	for i = 1, game:GetNumPlayers(), 1 do
		CoopFixes.BackupPlayer(i,Isaac.GetPlayer(i - 1),save_floor);
	end
end
function CoopFixes.BackupPlayer(player_index,player_entity,save_floor)
	if not player_entity or not mod.Config.CoopFixes.rejoin then return; end
	
	local player_id = Utils.GetPlayerID(player_entity);
	if CoopFixes.DATA.Players == nil then CoopFixes.DATA.Players = {}; end
	if CoopFixes.DATA.Players[player_id] == nil then CoopFixes.DATA.Players[player_id] = {}; end
		
	local actives = {};
	for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_SECONDARY, 1 do
		local item_desc = player_entity:GetActiveItemDesc(slot);
		actives[slot] = {Item = item_desc.Item or 0, Charge = item_desc.Charge or 0, VarData = item_desc.VarData or 0};
		if not actives[slot] or actives[slot].Item == CollectibleType.COLLECTIBLE_NULL then break; end
	end
	
	local pockets = {}
	for slot = PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY, 1 do
		local pocket_item = player_entity:GetPocketItem(slot);

		pockets[slot] = {Type = (pocket_item:GetSlot() == 0 and -1 or pocket_item:GetType())};
		if pocket_item:GetType() == PocketItemType.ACTIVE_ITEM then
			local item_desc = player_entity:GetActiveItemDesc(pocket_item:GetSlot() - 1);
			pockets[slot].Slot = {Item = item_desc.Item or 0, Charge = item_desc.Charge or 0, VarData = item_desc.VarData or 0};
		else
			pockets[slot].Slot = pocket_item:GetSlot();
		end
	end
	
	local health = CustomHealthAPI and CustomHealthAPI.Library.GetHealthBackup(player_entity) or nil;
	local controller_index = (player_entity.ControllerIndex >= 0 and player_entity.ControllerIndex < 5000) and player_entity.ControllerIndex or (CoopFixes.DATA.Players[player_id].Data.Controller or 0);
	
	local player_backups = CoopFixes.DATA.Players[player_id].Backups or {};
	local player_data = {Floor = game:GetLevel():GetName(), Actives = actives, Pockets = pockets, Type = player_entity:GetPlayerType(), Charge = {Blood = player_entity:GetBloodCharge(), Poop = player_entity:GetPoopMana(), Soul = player_entity:GetSoulCharge()}, Controller = controller_index, Health = health};

	if save_floor then player_backups[game:GetLevel():GetStage()] = player_data; end
	
	CoopFixes.DATA.Players[player_id] = {Backups = player_backups, Data = player_data};
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_POST_REJOIN_BACKUP_SAVE, player_index, player_data, player_entity); -- Execute Post Backup data saving Callbacks (player_index, player_data(table), player_entity(EntityPlayer))
	mod.Debug("Player (" .. player_index .. ") has been backed up:",CoopFixes.Name);
	mod.Debug("[" .. player_id .. "]",CoopFixes.Name);
	mod.Debug(CoopFixes.DATA.Players[player_id],"");
end

local function onNewFloor(_) -- Backup every Floor start
	CoopFixes.BackupAllPlayers(true);
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, onNewFloor);
local function onNewPlayer(_) -- Backup New Players
	if Isaac:CanStartTrueCoop() then CoopFixes.BackupPlayer(0,player_entity); else mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_INIT, onNewPlayer); end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, onNewPlayer);