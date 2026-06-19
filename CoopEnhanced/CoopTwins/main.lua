local mod = CoopEnhanced;
local CoopTwins = CoopEnhanced.CoopTwins;

local game = Game();
local Colors = mod.Colors;
local Utils = mod.Utils;

-- Saving and Loading
function CoopEnhanced.CoopTwins.gameStart(isCont, data)
	CoopTwins.Syncing = false;
	CoopTwins.DATA = {Joining = {}, Twins = {}};
	if isCont and data and data.CoopTwins then
		CoopTwins.DATA = data.CoopTwins;
		if CoopTwins.DATA.Twins then
			for main_id,twin_id in pairs(CoopTwins.DATA.Twins) do
				local main_twin = Utils.GetPlayerByID(main_id);
				local other_twin = Utils.GetPlayerByID(twin_id);
				if main_twin and other_twin then
					local start_functions = CoopTwins.StartFunctions[main_twin:GetPlayerType()] or CoopTwins.StartFunctions[other_twin:GetPlayerType()];
					if start_functions then
						for i,start_function in pairs(start_functions) do start_function(main_twin,other_twin); end
					end
				end
			end
		end
	end
end
function CoopEnhanced.CoopTwins.gameEnd(data)
	if data == nil then data = {CoopTwins = {}}; end
	data.CoopTwins = CoopTwins.DATA;
	return data;
end

function CoopTwins.GetTwin(twin_entity)
	if not CoopTwins.DATA.Twins then return; end
	local twin_id = Utils.GetPlayerID(twin_entity);
	for main_twin_id,other_twin_id in pairs(CoopTwins.DATA.Twins) do
		if main_twin_id == twin_id then return Utils.GetPlayerByID(other_twin_id); elseif other_twin_id == twin_id then return Utils.GetPlayerByID(main_twin_id); end
	end
end

function CoopTwins.IsTwin(player_entity)
	if not CoopTwins.DATA.Twins then return false; end
	local player_id = Utils.GetPlayerID(player_entity);
	for main_twin_id,other_twin_id in pairs(CoopTwins.DATA.Twins) do
		if main_twin_id == player_id or other_twin_id == player_id then return true; end
	end
	return false;
end

require(CoopTwins.Directory .. ".compat"); -- Load Compat data

-- Jacob & Esau
function CoopTwins.InitJacobEsau(main_twin,controller_index)
	local twin_entity = main_twin:GetOtherTwin();
	if not twin_entity then return; end
	local twin_pos = twin_entity.Position;
	local twin_type = twin_entity:GetPlayerType();
	local new_twin = PlayerManager.SpawnCoPlayer2(twin_type);
	
	local item_history = twin_entity:GetHistory();
	for i,history_item in pairs(item_history:GetCollectiblesHistory()) do
		new_twin:AddCollectible(history_item:GetItemID());
	end
	PlayerManager.RemoveCoPlayer(twin_entity);
	new_twin:SetControllerIndex(controller_index);
	
	new_twin.Position = twin_pos;
	CoopTwins.DATA.Twins[Utils.GetPlayerID(main_twin)] = Utils.GetPlayerID(new_twin);
	mod.RefreshFrameCount();
end

local bomb_cooldown = 0;
function CoopTwins.StartJacobEsau(main_twin,other_twin)
	bomb_cooldown = main_twin:GetBombPlaceDelay();
end

function CoopTwins.BirthrightJacobEsau(birth_twin,isRemoved)
	if isRemoved then return; end
	local other_twin = CoopTwins.GetTwin(birth_twin);
	local birth_history = other_twin:GetHistory();
	local total = 0;
	for i,history_item in pairs(birth_history:GetCollectiblesHistory()) do
		if total == 3 then return; end
		local collectible = Isaac.GetItemConfig():GetCollectible(history_item:GetItemID());
		if collectible.ID ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT and collectible.Type ~= ItemType.ITEM_ACTIVE and collectible.Type ~= ItemType.ITEM_TRINKET then
			total = total + 1;
			other_twin:AddCollectible(collectible.ID);
		end
	end
end

function CoopTwins.BombJacobEsau(bomb_twin,input_hook)
	if input_hook ~= InputHook.IS_ACTION_TRIGGERED or bomb_twin:GetNumBombs() <= 0 or game:GetFrameCount() < bomb_cooldown then return; end
	local other_twin = CoopTwins.GetTwin(bomb_twin);
	if not other_twin then return; end
	bomb_cooldown = game:GetFrameCount() + bomb_twin:GetBombPlaceDelay();
	local new_bomb = other_twin:FireBomb(other_twin.Position,Vector.Zero,other_twin);
	new_bomb:AddTearFlags(other_twin:GetBombFlags());
end

function CoopTwins.SpeedJacobEsau(speed_twin)
	local other_twin = CoopTwins.GetTwin(speed_twin);
	if not other_twin then return; end
	if other_twin.MoveSpeed ~= speed_twin.MoveSpeed then
		if CoopTwins.Syncing then
			CoopTwins.Syncing = false;
			speed_twin:AddCacheFlags(CacheFlag.CACHE_SPEED,true);
			other_twin:AddCacheFlags(CacheFlag.CACHE_SPEED,true);
			local speed_mod_A = speed_twin.MoveSpeed - (1 + tonumber(XMLData.GetEntryById(XMLNode.PLAYER, speed_twin:GetPlayerType()).speedmodifier or "0"));
			local speed_mod_B = other_twin.MoveSpeed - (1 + tonumber(XMLData.GetEntryById(XMLNode.PLAYER, other_twin:GetPlayerType()).speedmodifier or "0"));
			local move_speed = ((1 + tonumber(XMLData.GetEntryById(XMLNode.PLAYER, speed_twin:GetPlayerType()).speedmodifier or "0")) + ((speed_mod_A + speed_mod_B) / 2));
			if type(move_speed) == "number" then
				speed_twin.MoveSpeed,other_twin.MoveSpeed = move_speed,move_speed;
			end
			CoopTwins.Syncing = true;
		end
	end
end

-- The Forgotten & Soul
function CoopTwins.InitForgottenSoul(main_twin,controller_index)
	local twin_type = PlayerType.PLAYER_THESOUL;
	if main_twin:GetPlayerType() == twin_type then main_twin:SwapForgottenForm(true); end
	Isaac.ExecuteCommand("addplayer " .. twin_type .. " " .. controller_index); -- Have to do it this way, otherwise chain won't spawn
	local new_twin = Utils.GetPlayerByController(controller_index);
	new_twin.Position = main_twin.Position;

	 -- Transfer all incompatible health to new twin
	if CustomHealthAPI then
		for key,info in pairs(CustomHealthAPI.PersistentData.HealthDefinitions) do
			local amount = (CustomHealthAPI.Helper.GetTotalHPOfKey(main_twin, key) or 0) + (CustomHealthAPI.Helper.GetTotalHPOfKey((main_twin:GetSubPlayer()), key) or 0);
			CustomHealthAPI.Library.AddHealth(new_twin,key,-amount); -- Clear all health from new Twin
			if amount > 0 and ((main_twin:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and info.Type == CustomHealthAPI.Enums.HealthTypes.SOUL) or (main_twin:GetPlayerType() == PlayerType.PLAYER_THESOUL and (info.Type == CustomHealthAPI.Enums.HealthTypes.RED or info.Type == CustomHealthAPI.Enums.HealthTypes.CONTAINER))) then
				CustomHealthAPI.Library.AddHealth(main_twin,key,-12);
				CustomHealthAPI.Library.AddHealth(new_twin,key,amount);
			end
		end
		CustomHealthAPI.Library.AddHealth(new_twin,"SOUL_HEART",2);
	else
		local forgottens_soul = main_twin:GetSubPlayer();
		local souls_forgotten = new_twin:GetSubPlayer();
		new_twin:AddBrokenHearts(-12);
		new_twin:AddBoneHearts(-12);
		new_twin:AddHearts(-12);
		new_twin:AddRottenHearts(-12);
		new_twin:AddGoldenHearts(-12);
		new_twin:AddEternalHearts(-12);
		new_twin:AddSoulHearts(-12);
		new_twin:AddBlackHearts(-12);
		if twin_type == PlayerType.PLAYER_THEFORGOTTEN then
			new_twin:AddBrokenHearts(souls_forgotten:GetBrokenHearts());
			main_twin:AddBrokenHearts(-12);
			new_twin:AddBoneHearts(souls_forgotten:GetBoneHearts());
			main_twin:AddBoneHearts(-12);
			new_twin:AddHearts(souls_forgotten:GetHearts());
			main_twin:AddHearts(-12);
			new_twin:AddRottenHearts(souls_forgotten:GetRottenHearts());
			main_twin:AddRottenHearts(-12);
			new_twin:AddGoldenHearts(souls_forgotten:GetGoldenHearts());
			main_twin:AddGoldenHearts(-12);
			new_twin:AddEternalHearts(souls_forgotten:GetEternalHearts());
			main_twin:AddEternalHearts(-12);
		else
			new_twin:AddSoulHearts(forgottens_soul:GetSoulHearts() + 2);
			main_twin:AddSoulHearts(-12);
			new_twin:AddBlackHearts(forgottens_soul:GetBlackHearts());
			main_twin:AddBlackHearts(-12);
			new_twin:AddGoldenHearts(forgottens_soul:GetGoldenHearts());
			main_twin:AddGoldenHearts(-12);
			new_twin:AddEternalHearts(forgottens_soul:GetEternalHearts());
			main_twin:AddEternalHearts(-12);
		end
	end
		
	local item_history = main_twin:GetHistory();
	for i,history_item in pairs(item_history:GetCollectiblesHistory()) do
		CoopTwins.ItemAddForgottenSoul(new_twin,history_item:GetItemID(),true);
	end
	
	new_twin:SwapForgottenForm(true,true); new_twin:SwapForgottenForm(true,true); -- Need to toggle Forgotten/Soul to make chain visible.
	CoopTwins.DATA.Twins[Utils.GetPlayerID(main_twin)] = Utils.GetPlayerID(new_twin);
	CoopTwins.StartForgottenSoul(main_twin,new_twin);
end

function CoopTwins.StartForgottenSoul(main_twin,other_twin)
	local forgotten_twin = main_twin:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and main_twin or other_twin;
	local soul_twin = forgotten_twin == main_twin and other_twin or main_twin;
	local forgotten_id = Utils.GetPlayerID(forgotten_twin);
	local soul_id = Utils.GetPlayerID(soul_twin);
	
	local function dragForggoten(_,familiar)
		if forgotten_twin and forgotten_twin.Exists and Utils.GetPlayerID(familiar.Player) == forgotten_id then
			if forgotten_twin:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then 
				familiar:Remove();
			else
				familiar.Position = forgotten_twin.Position;
				familiar:FollowPosition(forgotten_twin.Position);
				familiar.Friction = 0;
				familiar.SpriteScale = forgotten_twin.SpriteScale;
				familiar:SetColor(Color(1,1,1,0,1,1,1),0,0,false,false);
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, dragForggoten, FamiliarVariant.FORGOTTEN_BODY);
		
	local function onHeartPickup(_, pickup_entity, entity)
		if not entity.ToPlayer then return; end
		local player_id = Utils.GetPlayerID(entity:ToPlayer());
		if player_id == forgotten_id or player_id == soul_id then CoopTwins.HealthForgottenSoul(forgotten_twin, soul_twin); end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, onHeartPickup, PickupVariant.PICKUP_HEART);

	local function addCollectibleHealth(_, collectible_type, _, _, _, _, player_entity)
		local player_id = Utils.GetPlayerID(player_entity);
		if player_id == forgotten_id or player_id == soul_id then CoopTwins.HealthForgottenSoul(forgotten_twin, soul_twin); end
	end
	mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, addCollectibleHealth);
	
	if mod.Config.modules.CoopFixes and CustomHealthAPI then
		mod.Registry:RemoveCallback(mod.Callbacks.FIXES_PRE_REJOIN_HEALTH, RejoinForgottenSoul);
		local function RejoinForgottenSoul(_, player_entity, player_data, health_backup)
			local player_id = Utils.GetPlayerID(player_entity);
			if (player_id ~= forgotten_id and player_id ~= soul_id) or not player_entity:GetSubPlayer() or not health_backup.SubPlayers or (player_entity:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and player_data.Type ~= PlayerType.PLAYER_THESOUL) or (player_entity:GetPlayerType() == PlayerType.PLAYER_THESOUL and player_data.Type ~= PlayerType.PLAYER_THEFORGOTTEN) then return; end
			local other_player_id = player_id == forgotten_id and soul_id or forgotten_id;
			local other_health_backup = Utils.Clone(CoopFixes.DATA.Players[other_player_id].Health);
			health_backup.Mainplayers = other_health_backup.MainPlayers;
			health_backup.Subplayers = other_health_backup.SubPlayers;
		end
		mod.Registry:AddCallback(mod.Callbacks.FIXES_PRE_REJOIN_HEALTH, RejoinForgottenSoul);
	end
end

function CoopTwins.UpdateForgottenSoul(forgotten_twin, soul_twin)
	if not forgotten_twin or not soul_twin then return; end
	if forgotten_twin:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN then forgotten_twin:SwapForgottenForm(true); end
	if soul_twin:GetPlayerType() ~= PlayerType.PLAYER_THESOUL then soul_twin:SwapForgottenForm(true); end
	CoopTwins.HealthForgottenSoul(forgotten_twin, soul_twin);
	CoopTwins.HealthForgottenSoul(soul_twin, forgotten_twin);
end

function CoopTwins.ItemAddForgottenSoul(item_twin,collectible_type,preventSync)
	local collectible = Isaac.GetItemConfig():GetCollectible(collectible_type);
	if not mod.Config.CoopTwins.forgottensoul.share_items or not CoopTwins.Syncing or collectible.Type == ItemType.ITEM_ACTIVE or collectible.Type == ItemType.ITEM_TRINKET then return; end
	local other_twin = CoopTwins.GetTwin(item_twin);
	if not other_twin then return; end
	if not preventSync then
		CoopTwins.Syncing = false;
		other_twin:AddCollectible(collectible_type, 0, false);
		CoopTwins.Syncing = true;
	end
end

function CoopTwins.ItemRemoveForgottenSoul(item_twin,collectible_type,preventSync)
	local collectible = Isaac.GetItemConfig():GetCollectible(collectible_type);
	if not mod.Config.CoopTwins.forgottensoul.share_items or not CoopTwins.Syncing or collectible.Type == ItemType.ITEM_ACTIVE or collectible.Type == ItemType.ITEM_TRINKET then return; end
	local other_twin = CoopTwins.GetTwin(item_twin);
	if not other_twin then return; end
	if not preventSync then
		CoopTwins.Syncing = false;
		other_twin:RemoveCollectible(collectible_type, true);
		CoopTwins.Syncing = true;
	end
end

function CoopTwins.HealthForgottenSoul(health_twin, other_twin)
	if not health_twin then return; end
	other_twin = other_twin or CoopTwins.GetTwin(health_twin);
	if not other_twin then return; end
	if CustomHealthAPI then
		local bone_health = CustomHealthAPI.Helper.GetTotalBoneHP(health_twin:GetSubPlayer());
		local soul_health = CustomHealthAPI.Helper.GetTotalSoulHP(health_twin:GetSubPlayer(), true);
		if not soul_health or not bone_health then return; end
		if (health_twin:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and soul_health > 0) or (health_twin:GetPlayerType() == PlayerType.PLAYER_THESOUL and bone_health > 0) then
			local remove_keys = health_twin:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and CustomHealthAPI.Constants.Health.SOUL or CustomHealthAPI.Constants.Health.CONTAINER;
			for i,key in pairs(remove_keys) do
				local total = CustomHealthAPI.Library.GetHPOfKey(health_twin:GetSubPlayer(), key);
				if total > 0 then
					CustomHealthAPI.Library.AddHealth(health_twin, key, -12);
					CustomHealthAPI.Library.AddHealth(other_twin, key, total);
				end
			end
		end
	else
		if health_twin:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
			if health_twin:GetSubPlayer():GetSoulHearts() > 0 then other_twin:AddSoulHearts(health_twin:GetSoulHearts()); health_twin:AddSoulHearts(-12);
			elseif health_twin:GetSubPlayer():GetBlackHearts() > 0 then other_twin:AddSoulHearts(health_twin:GetBlackHearts()); health_twin:AddBlackHearts(-12);
			end
		elseif health_twin:GetSubPlayer():GetBoneHearts() > 0 then
			other_twin:AddBoneHearts(health_twin:GetBoneHearts());
			other_twin:AddHearts(health_twin:GetHearts());
			health_twin:AddBoneHearts(-12);
		end
	end
end

function CoopTwins.PickupForgottenSoul(health_twin, pickup_entity)
	local other_twin = CoopTwins.GetTwin(health_twin);
	if not other_twin then return; end
	local pickup_target = nil;
	local heart_type = Utils.GetHealthType(pickup_entity);
	if health_twin:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and heart_type == mod.HealthTypes.SOUL then
		if CustomHealthAPI then
			local heart_key, _ = CustomHealthAPI.Library.GetHealthOfPickup(pickup_entity);
			if heart_key and CustomHealthAPI.Helper.CanPickKey(other_twin, heart_key) then 
				pickup_target = other_twin;
			else
				return false;
			end
		elseif (other_twin:CanPickBlackHearts() or other_twin:CanPickSoulHearts()) then
			pickup_target = other_twin;
		else
			return false;
		end
	elseif health_twin:GetPlayerType() == PlayerType.PLAYER_THESOUL and (heart_type == mod.HealthTypes.RED or heart_type == mod.HealthTypes.CONTAINER) then
		if CustomHealthAPI then
			local heart_key, _ = CustomHealthAPI.Library.GetHealthOfPickup(pickup_entity);
			if heart_key and CustomHealthAPI.Helper.CanPickKey(other_twin, heart_key) then 
				pickup_target = other_twin;
			end
		elseif (pickup_entity.SubType == HeartSubType.HEART_ROTTEN and other_twin:CanPickRottenHearts()) or ((pickup_entity.SubType == HeartSubType.HEART_BONE and other_twin:CanPickBoneHearts()) or (other_twin:CanPickRedHearts())) then
			pickup_target = other_twin;
		else
			return false;
		end
	end
	if pickup_target then
		pickup_entity.Velocity = Vector.Zero;
		pickup_entity.Position = pickup_target.Position;
		return true;
	end
end


-- Callbacks
function CoopTwins.onRender(_)
	if not mod.Config.modules.CoopTwins or mod.Ended then return; end
	if not CoopTwins.Syncing and mod.Started then CoopTwins.Syncing = true; end
	if not CoopTwins.DATA.Joining or type(CoopTwins.DATA.Joining) ~= "table" then CoopTwins.DATA.Joining = {}; end
	if not CoopTwins.DATA.Twins or type(CoopTwins.DATA.Twins) ~= "table" then CoopTwins.DATA.Twins = {}; end
	if Utils.CanStartTrueCoop() then
		local joinable_twins = {};
		local joinable_twin = nil;
		for i = 1, Game():GetNumPlayers(), 1 do
			local player_entity = Isaac.GetPlayer(i - 1);
			if CoopTwins.InitFunctions[player_entity:GetPlayerType()] ~= nil and CoopTwins.DATA.Twins[Utils.GetPlayerID(player_entity)] == nil then
				table.insert(joinable_twins,player_entity);
				if not joinable_twin and Input.IsActionPressed(ButtonAction.ACTION_DROP, player_entity.ControllerIndex) then joinable_twin = player_entity; end
			end
		end
		if not mod.GetJoiningByController then return; end
		for i = 1, CoopEnhanced.Config.MaxControllers, 1 do
			local controller_index = (i - 1);
			local player_entity = Utils.GetPlayerByController(controller_index);
			local twin_joining = CoopTwins.DATA.Joining[i];
			if player_entity == nil and mod.GetJoiningByController(controller_index) == nil then 
				if joinable_twin ~= nil and Input.IsActionPressed(ButtonAction.ACTION_JOINMULTIPLAYER, controller_index) then
					CoopTwins.InitFunctions[joinable_twin:GetPlayerType()](joinable_twin,controller_index);
				elseif Input.IsActionPressed(ButtonAction.ACTION_DROP,controller_index) then
					if twin_joining == nil then
						local player_index = CoopEnhanced.Players.Total + 1;
						for i, joining in pairs(CoopTwins.DATA.Joining) do
							if twin_joining.Index == player_index then player_index = player_index + 1; else break; end
						end
						twin_joining = {Index = player_index, Controller = controller_index, Selected = 1};
						CoopTwins.DATA.Joining[i] = twin_joining;
					else
						if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, controller_index) and joinable_twins[twin_joining.Selected] then
							CoopTwins.InitFunctions[joinable_twin:GetPlayerType()](joinable_twins[twin_joining.Selected],controller_index);
						elseif Input.IsActionTriggered(ButtonAction.ACTION_MENULEFT, controller_index) then
							twin_joining.Selected = twin_joining.Selected - 1; --joining.Move = joining.Move + 24;
						elseif Input.IsActionTriggered(ButtonAction.ACTION_MENURIGHT, controller_index) then
							twin_joining.Selected = twin_joining.Selected + 1; --joining.Move = joining.Move - 24;
						end
						twin_joining.Selected = CoopEnhanced.Utils.ClampFlow(1, #joinable_twins, twin_joining.Selected);
					end
				else
					CoopTwins.DATA.Joining[i] = nil;
				end
			elseif player_entity then
				if mod.RemoveJoiningByController then mod.RemoveJoiningByController(controller_index); end
			end
		end
	end
	if not mod.Started then return; end
	for main_id,twin_id in pairs(CoopTwins.DATA.Twins) do
		local main_twin = Utils.GetPlayerByID(main_id);
		local other_twin = Utils.GetPlayerByID(twin_id);
		if main_twin and other_twin then
			if mod.Config.CoopTwins.twin_death then
				if main_twin:IsCoopGhost() then
					other_twin:Die();
				elseif other_twin:IsCoopGhost() then
					main_twin:Die();
				end
			end
			if (Input.IsActionPressed(ButtonAction.ACTION_DROP,other_twin.ControllerIndex) and Input.IsActionTriggered(ButtonAction.ACTION_MAP,other_twin.ControllerIndex)) and other_twin.Position:Distance(main_twin.Position) > (mod.Config.CoopTwins.tp_distance * mod.GridSize) then
				if REPENTOGON then other_twin:Teleport(main_twin.Position,true,true); else other_twin.Position = main_twin.Position + Vector.Zero; end
			end
			if (mod.FrameCount % 30) == 0 then
				local twin_functions = CoopTwins.TwinFunctions[main_twin:GetPlayerType()];
				if twin_functions then 
					for i,func in pairs(twin_functions) do func(main_twin,other_twin); end
				end
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.IMPORTANT, CoopTwins.onRender);

function CoopTwins.onDeath(_,entity)
	if not CoopTwins.DATA.Twins then return; end
	local dead_twin = entity:ToPlayer();
	if not mod.Config.CoopTwins.twin_death or not CoopTwins.IsTwin(dead_twin) then return; end
	local other_twin = CoopTwins.GetTwin(dead_twin);
	if not other_twin or other_twin:IsCoopGhost() or Utils.IsPlayerDying(other_twin) or dead_twin:WillPlayerRevive() then return; end
	other_twin:Die();
	mod.Debug("Twin died, killing the other twin.",CoopTwins.Name);
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.Priorities[5], CoopTwins.onDeath, EntityType.ENTITY_PLAYER);

function CoopTwins.onRoom()
	if not CoopTwins.DATA.Twins then return; end
	for main_id,twin_id in pairs(CoopTwins.DATA.Twins) do
		local main_twin = Utils.GetPlayerByID(main_id);
		local other_twin = Utils.GetPlayerByID(twin_id);
		if main_twin and other_twin then
			other_twin.Position = main_twin.Position + Vector.Zero; -- Teleport Second twin to main twin because other twin just stays in random area of room
			
			local room_functions = CoopTwins.RoomFunctions[main_twin:GetPlayerType()] or CoopTwins.RoomFunctions[other_twin:GetPlayerType()];
			if room_functions then
				for i,room_function in pairs(room_functions) do room_function(main_twin,other_twin); end
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.Priorities[5], CoopTwins.onRoom);

-- Input functions
local function onInput(_, entity, input_hook, button_action)
	if not Utils.IsPauseMenuOpen() and entity ~= nil then
		local player_entity = entity:ToPlayer();
		if not player_entity or not CoopTwins.IsTwin(player_entity) then return; end
		local input_action = input_hook == InputHook.IS_ACTION_TRIGGERED and Input.IsActionTriggered(button_action,player_entity.ControllerIndex) or (input_hook == InputHook.IS_ACTION_PRESSED and Input.IsActionPressed(button_action,player_entity.ControllerIndex) or false);
		if not input_action then return; end
		local button_functions = CoopTwins.ButtonFunctions[button_action];
		if not button_functions then return; end
		local player_functions = button_functions[player_entity:GetPlayerType()];
		if player_functions then
			for i,button_function in pairs(player_functions) do button_function(player_entity,input_hook); end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, onInput);

-- Cache stats functions
local function evalCache(_, player_entity, cache_flag)
	if not player_entity or not CoopTwins.IsTwin(player_entity) then return; end
	local all_functions = CoopTwins.StatFunctions.All[player_entity:GetPlayerType()];
	if all_functions then
		for i,func in pairs(all_functions) do func(player_entity,cache_flag); end
	end
	local stat_functions = CoopTwins.StatFunctions[cache_flag];
	if not stat_functions then return; end
	local player_functions = stat_functions[player_entity:GetPlayerType()];
	if player_functions then
		for i,stat_function in pairs(player_functions) do stat_function(player_entity); end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Priorities[5], evalCache);

-- Pickup functions
local function onPickup(_, pickup_entity, entity)
	local player_entity = entity:ToPlayer();
	if not player_entity or not CoopTwins.IsTwin(player_entity) then return; end
	local all_functions = CoopTwins.PickupFunctions.Add[player_entity:GetPlayerType()];
	if all_functions then
		for i,func in pairs(all_functions) do 
			local pickup_return = func(player_entity,pickup_entity);
			if pickup_return ~= nil then return pickup_return; end
		end
	end
	local pickup_functions = CoopTwins.PickupFunctions[pickup_entity.Variant];
	if not pickup_functions then return; end
	local player_functions = pickup_functions[player_entity:GetPlayerType()];
	if player_functions then
		for i,pickup_function in pairs(player_functions) do
			local pickup_return = pickup_function(player_entity,pickup_entity);
			if pickup_return ~= nil then return pickup_return; end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, onPickup);

-- Item functions
local function addCollectible(_, collectible_type, _, _, _, _, player_entity)
	if not player_entity or not CoopTwins.IsTwin(player_entity) then return; end
	local all_functions = CoopTwins.ItemFunctions.Add[player_entity:GetPlayerType()];
	if all_functions then
		for i,func in pairs(all_functions) do func(player_entity,collectible_type); end
	end
	local item_functions = CoopTwins.ItemFunctions[collectible_type];
	if not item_functions then return; end
	local player_functions = item_functions[player_entity:GetPlayerType()];
	if player_functions then
		for i,item_function in pairs(player_functions) do item_function(player_entity,true); end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, addCollectible);

local function removeCollectible(_, player_entity, collectible_type)
	if not player_entity or not CoopTwins.IsTwin(player_entity) then return; end
	local all_functions = CoopTwins.ItemFunctions.Remove[player_entity:GetPlayerType()];
	if all_functions then
		for i,func in pairs(all_functions) do func(player_entity,collectible_type); end
	end
	local item_functions = CoopTwins.ItemFunctions[collectible_type];
	if not item_functions then return; end
	local player_functions = item_functions[player_entity:GetPlayerType()];
	if player_functions then
		for i,item_function in pairs(player_functions) do item_function(player_entity,false); end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, removeCollectible);

-- Health functions
local function addHealth(_, player_entity, amount, health_types)
	if not player_entity or not CoopTwins.IsTwin(player_entity) then return; end
	local health_functions = CoopTwins.HealthFunctions[player_entity:GetPlayerType()];
	if not health_functions then return; end
	for i,health_function in pairs(player_functions) do
		local health_amount = health_function(player_entity,amount,health_types);
		if health_amount then return health_amount; end
	end
end
local function addHealthCHAPI(player_entity, health, amount)
	if not player_entity or not CoopTwins.IsTwin(player_entity) then return; end
	local health_functions = CoopTwins.HealthFunctions[player_entity:GetPlayerType()];
	if not health_functions then return; end
	for i,health_function in pairs(health_functions) do 
		local health_return, health_amount = health_function(player_entity,amount,health);
		if health_return and health_amount then return health_return, health_amount; end
	end
end
if CustomHealthAPI then
	CustomHealthAPI.Library:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ADD_HEALTH, mod.Priorities[5], addHealthCHAPI);
else
	mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, addHealth);
end