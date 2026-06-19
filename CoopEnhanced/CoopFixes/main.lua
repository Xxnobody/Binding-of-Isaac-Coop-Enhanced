local mod = CoopEnhanced;
local CoopFixes = CoopEnhanced.CoopFixes;

local game = Game();
local Utils = mod.Utils;

local json = require("json");

-- Saving and Loading
function CoopEnhanced.CoopFixes.gameStart(isCont, data)
	CoopFixes.DATA = {Players = {},Controllers = {}};
	CoopFixes.RefreshFullscreen();
	
	if isCont and data and data.CoopFixes then
		CoopFixes.DATA.Players = data.CoopFixes.players;
		--CoopFixes.BackupAllPlayers(true);
		if mod.Config.CoopFixes.rejoin then mod:AddCallback(ModCallbacks.MC_POST_RENDER, CoopFixes.Rejoin.Fix); end
	end
end
function CoopEnhanced.CoopFixes.gameEnd(data)
	if mod.Config.CoopFixes.rejoin and mod.Ended then
		CoopFixes.BackupAllPlayers();
		--CoopFixes.Rejoin.PreventStartDeath();
	end
	if data == nil then data = {CoopFixes = {}}; elseif data.CoopFixes == nil then data.CoopFixes = {}; end
	data.CoopFixes.players = CoopFixes.DATA.Players;
	return data;
end

-- Fullscreen screen position fix
function CoopFixes.RefreshFullscreen()
	if mod.Config.CoopFixes.fullscreen.enable and Options.Fullscreen then
		Options.Fullscreen = false;
		if Options.WindowPosX then 
			Options.WindowPosX = mod.Config.CoopFixes.fullscreen.pos.X or 0;
			Options.WindowPosY = mod.Config.CoopFixes.fullscreen.pos.Y or 0;
		end
		Options.Fullscreen = true;
	end
end


-- Joining Fix
-- Fixes an issue where sometimes when statring a game, players can't choose True Co-op Characters
function CoopFixes.Join.Fix(_)
	if not CoopEnhanced.Config.CoopFixes.join.enable then mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, CoopFixes.Join.Fix); return; end
	local level = game:GetLevel();
	local isStartingRoom = (level:GetStage() == LevelStage.STAGE1_1 and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex());
	local max_visits = CoopEnhanced.Config.CoopFixes.join.max;
	if max_visits == 0 then max_visits = level:GetCurrentRoomDesc().VisitedCount + 1; end
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_PRE_JOIN_EXECUTE, max_visits); -- Execute Pre Join Callbacks (max_visits(int))
	if isStartingRoom and level:GetCurrentRoomDesc().VisitedCount <= max_visits then
		game:SetStateFlag(GameStateFlag.STATE_BOSSPOOL_SWITCHED, false); -- In Rep, this instead prevents true coop from starting
	else
		game:SetStateFlag(GameStateFlag.STATE_BOSSPOOL_SWITCHED, true);
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CoopFixes.Join.Fix);


--Rejoin Fix
-- Fixes Characters changing type on rejoin when controller order changes
function CoopFixes.Rejoin.Fix() 
	if Isaac:GetFrameCount() % 10 ~= 0 then return; end -- Check only every 10 frames or 6 times a second
	if mod.Config.CoopFixes.rejoin then 
		for i = 1, game:GetNumPlayers() do
			local player_entity = Isaac.GetPlayer(i - 1);
			if not mod.Started or not player_entity or not player_entity.ControlsEnabled then --Check if Controller Index is set wildly low/high (e.g. 4294967295 instead of 1)
				--local player_id = Utils.GetPlayerID(player_entity);
				--if player_id and CoopFixes.DATA.Players[player_id] then player_entity:SetControllerIndex(CoopFixes.DATA.Players[player_id].Data.Controller or 0); end
				return;
			end
		end
		CoopFixes.Rejoin.FixPlayers();
		game:GetHUD():AssignPlayerHUDs();
	end
	mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, CoopFixes.Rejoin.Fix);
end

--[[
function CoopFixes.Rejoin.PreventStartDeath(doAll) -- Adds health to prevent instant death upon loading a save with a character that has 0 HP
	for i = 1, game:GetNumPlayers(), 1 do
		local player_entity = Isaac.GetPlayer(i - 1);
		local sub_player = player_entity:GetSubPlayer()
		if doAll or sub_player then
			if not Utils.IsLost(player_entity) then
				player_entity:AddMaxHearts(1);
				if sub_player then sub_player:AddMaxHearts(1); sub_player:SwapForgottenForm(true); end
			end
		end
	end
end

function CoopFixes.Rejoin.PreventDeath(_,player_entity) -- Adds health to prevent instant death upon loading a save with a character that has 0 HP
	player_entity:AddCollectible(CollectibleType.COLLECTIBLE_1UP);
	player_entity:TryPreventDeath();
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_REVIVE, CoopFixes.Rejoin.PreventDeath);
]]--

function CoopFixes.Rejoin.FixPlayers()
	if CoopFixes.DATA.Players == nil then return; end
	for i = 1, game:GetNumPlayers(), 1 do
		local player_entity = Isaac.GetPlayer(i - 1);
		local player_id = Utils.GetPlayerID(player_entity);
		if not CoopFixes.DATA.Players[player_id] or not CoopFixes.DATA.Players[player_id].Data then mod.Debug("Player (" .. i .. ") ID: " .. player_id .. " doesn't exist! Cannot load their rejoin data.",CoopFixes.Name); goto continue; end
		local player_data = CoopFixes.DATA.Players[player_id].Data;
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_PRE_REJOIN_EXECUTE, i, player_data, player_entity); -- Execute Pre Fix Player data Callbacks (player_index, player_data(table), player_entity(EntityPlayer))

		-- Character type
		if player_data.Type and player_entity:GetPlayerType() ~= player_data.Type then
			mod.Debug("Player (" .. i .. ") has changed character(s) to " .. player_entity:GetName() .. " since last load, reseting to original character type " .. (Utils.GetCharacterByType(player_data.Type).Name or "nil"),CoopFixes.Name);
			CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_PRE_REJOIN_PLAYERTYPE, i, player_entity, player_data); -- Execute re Fix Player type Callbacks (player_index,  player_entity(EntityPlayer), player_data(Table))
			if CustomHealthAPI then CustomHealthAPI.Helper.ChangePlayerType(player_entity, player_data.Type); else player_entity:ChangePlayerType(player_data.Type); end
		end
		-- Character Health
		if player_data.Health and CustomHealthAPI then
			CustomHealthAPI.Helper.CheckIfHealthOrderSet();
				
			local savetable = json.decode(player_data.Health)
			CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_PRE_REJOIN_HEALTH, i, player_entity, player_data, savetable); -- Execute Pre Fix Player health Callbacks (player_index,  player_entity(EntityPlayer), player_data(Table), health_data(HealthBackup))

			local healthData = savetable.Mainplayers[CustomHealthAPI.Helper.GetPlayerIndex(player_entity)];
			if healthData ~= nil then CustomHealthAPI.Helper.LoadHealthOfPlayerFromBackup(player_entity, healthData); end
					
			local subplayer = player_entity:GetSubPlayer();
			if subplayer ~= nil then
				local subHealthData = savetable.Subplayers[CustomHealthAPI.Helper.GetPlayerIndex(player_entity)];
				if subHealthData ~= nil then
					CustomHealthAPI.Helper.LoadHealthOfPlayerFromBackup(subplayer, subHealthData);
				end
			end
					
			CustomHealthAPI.PersistentData.HiddenPlayerHealthBackup = savetable.Hidden or CustomHealthAPI.PersistentData.HiddenPlayerHealthBackup;
			CustomHealthAPI.PersistentData.HiddenSubplayerHealthBackup = savetable.HiddenSub or CustomHealthAPI.PersistentData.HiddenSubplayerHealthBackup;
			CustomHealthAPI.PersistentData.RestockInfo = savetable.RestockInfo or CustomHealthAPI.PersistentData.RestockInfo;
		end
		-- Active slots
		for slot,active in pairs(player_data.Actives) do
			if player_entity:GetActiveItem(slot) ~= active.Item then
				mod.Debug("Player (" .. i .. ") has changed active item in slot " .. slot .. " since last load, reseting to original item.",CoopFixes.Name);
				CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_PRE_REJOIN_ACTIVE, i, player_entity, player_data, slot, active); -- Execute Pre Fix Player Actives Callbacks (player_index,  player_entity(EntityPlayer), player_data(Table), slot(ActiveSlot), active_data(Table))
				if active.Item == CollectibleType.COLLECTIBLE_NULL then
					player_entity:RemoveCollectible(player_entity:GetActiveItem(slot), true, slot, true);
				else
					player_entity:AddCollectible(active.Item, active.Charge, false, slot, active.VarData);
				end
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
				CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_PRE_REJOIN_POCKETS, i, player_entity, player_data, slot, active); -- Execute Pre Fix Player Actives Callbacks (player_index,  player_entity(EntityPlayer), player_data(Table), slot(PocketSlot), pocket_data(Table))
				if pocket.Type <= PocketItemType.PILL then player_entity:SetPill(slot,pocket.Slot);
				elseif pocket.Type <= PocketItemType.CARD then player_entity:SetCard(slot,pocket.Slot);
				else
					local active_slot = slot >= ActiveSlot.SLOT_POCKET and slot or (slot + 2);
					player_entity:SetPocketActiveItem(pocket.Slot.Item, active_slot, true);
					player_entity:SetActiveCharge(pocket.Slot.Charge,active_slot);
				end
			end
		end
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.FIXES_POST_REJOIN_EXECUTE, i, player_entity); -- Execute Post Fix Player data Callbacks (player_index,  player_entity(EntityPlayer))
		::continue::
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
			player_data.Data = Utils.Clone(player_data.Backup[level_stage]);
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
	
	CoopFixes.Rejoin.FixPlayers();
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
		actives[slot] = {Item = player_entity:GetActiveItem(slot), Charge = player_entity:GetActiveCharge(slot) or 0, VarData = 0};
		if not actives[slot] or actives[slot].Item == CollectibleType.COLLECTIBLE_NULL then break; end
	end
	
	local pockets = {}
	if REPENTOGON then 
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
	if Utils.CanStartTrueCoop() then CoopFixes.BackupPlayer(0,player_entity); else mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_INIT, onNewPlayer); end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, onNewPlayer);

-- Repentogon Fixes
if REPENTOGON then
	-- Trapdoor Fix
	-- Fixes an issue where sometimes when entering a trapdoor, other players get stuck in a looping walk animation and the floor cannot finish.
	function CoopFixes.TrapdoorFix(_,trapdoor_entity)
		if not mod.Config.CoopFixes.trapdoor then return; end
		local players = Isaac.FindInRadius(trapdoor_entity.Position, (mod.GridSize / 2),EntityPartition.PLAYER);
		for i,player_entity in pairs(players) do
			local sprite = player_entity:GetSprite();
			sprite:SetFrame(sprite:GetDefaultAnimation(),0);
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_TRAPDOOR_RENDER, CoopFixes.TrapdoorFix);

	-- Rewind Fix
	-- Fixes players 2+ losing control of their characters after a rewind command or similar
	function CoopFixes.Rewind.Fix()
		if not mod.Config.CoopFixes.rewind then CoopFixes.DATA.Controllers = {}; return; end
		if CoopFixes.DATA.Controllers then
			for player_id,controller_index in pairs(CoopFixes.DATA.Controllers) do
				local player_entity = Utils.GetPlayerByID(player_id);
				if player_entity and controller_index >= 0 and controller_index <= mod.Config.MaxControllers then player_entity:SetControllerIndex(controller_index); end
			end
		else
			CoopFixes.DATA.Controllers = {};
		end
		for i,player_entity in pairs(Utils.GetPlayers()) do
			local player_id = Utils.GetPlayerID(player_entity);
			CoopFixes.DATA.Controllers[player_id] = player_entity.ControllerIndex;
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CoopFixes.Rewind.Fix);
end