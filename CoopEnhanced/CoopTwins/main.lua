local mod = CoopEnhanced;
local CoopTwins = CoopEnhanced.CoopTwins;

local game = Game();
local Colors = mod.Colors;
local Utils = mod.Utils;

-- Saving and Loading
function CoopEnhanced.CoopTwins.gameStart(isCont, data)
	CoopTwins.DATA = {Joining = {}, Twins = {}};
	if isCont and data and data.CoopTwins then
		CoopTwins.DATA = data.CoopTwins;
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

function CoopTwins.BirthrightJacobEsau(birth_twin)
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
	print(input_hook)
	if input_hook ~= InputHook.IS_ACTION_TRIGGERED then return; end
	local other_twin = CoopTwins.GetTwin(bomb_twin);
	other_twin:FireBomb(other_twin.Position,Vector.Zero);
end

function CoopTwins.SpeedJacobEsau(speed_twin)
	local other_twin = nil;--CoopTwins.GetTwin(speed_twin);
	if not other_twin then return; end
	if other_twin.MoveSpeed ~= speed_twin.MoveSpeed then
		if other_twin.ControllerIndex < 0 or other_twin.ControllerIndex > 500 then
			local move_speed = 1 + ((other_twin.MoveSpeed - 1) + (speed_twin.MoveSpeed - 1));
			speed_twin.MoveSpeed,other_twin.MoveSpeed = move_speed,move_speed;
		else
			other_twin.MoveSpeed = speed_twin.MoveSpeed;
		end
	end
end

function CoopTwins.onRender(_)
	if not CoopTwins.DATA.Joining or type(CoopTwins.DATA.Joining) ~= "table" then CoopTwins.DATA.Joining = {}; end
	if not CoopTwins.DATA.Twins or type(CoopTwins.DATA.Twins) ~= "table" then CoopTwins.DATA.Twins = {}; end
	if Utils.CanStartTrueCoop() then
		local joinable_twins = {};
		local joinable_twin = nil;
		for i = 1, Game():GetNumPlayers(), 1 do
			local player_entity = Isaac.GetPlayer(i - 1);
			if mod.TwinTypes[player_entity:GetPlayerType()] and player_entity:GetOtherTwin() ~= nil and CoopTwins.SetTwin[player_entity:GetPlayerType()] ~= nil then
				table.insert(joinable_twins,player_entity);
				if not joinable_twin and Input.IsActionPressed(ButtonAction.ACTION_DROP, player_entity.ControllerIndex) then joinable_twin = player_entity; end
			end
		end
		if not mod.GetJoiningByController then return; end
		for i = 1, CoopEnhanced.MaxControllers, 1 do
			local controller_index = (i - 1);
			local player_entity = Utils.GetPlayerByController(controller_index);
			local twin_joining = CoopTwins.DATA.Joining[i];
			if player_entity == nil and mod.GetJoiningByController(controller_index) == nil then 
				if joinable_twin ~= nil and Input.IsActionPressed(ButtonAction.ACTION_JOINMULTIPLAYER, controller_index) then
					CoopTwins.SetTwin[joinable_twin:GetPlayerType()](joinable_twin,controller_index);
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
							CoopTwins.SetTwin[joinable_twin:GetPlayerType()](joinable_twins[twin_joining.Selected],controller_index);
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
	for main_id,twin_id in pairs(CoopTwins.DATA.Twins) do
		local main_twin = Utils.GetPlayerByID(main_id);
		local other_twin = Utils.GetPlayerByID(twin_id);
		if main_twin and other_twin then
			if (main_twin:IsCoopGhost() or Utils.IsPlayerDying(main_twin)) and not other_twin:IsCoopGhost() then other_twin:Die(); elseif (other_twin:IsCoopGhost() or  Utils.IsPlayerDying(other_twin)) and not main_twin:IsCoopGhost() then main_twin:Die(); end
			if (Input.IsActionPressed(ButtonAction.ACTION_DROP,other_twin.ControllerIndex) and Input.IsActionTriggered(ButtonAction.ACTION_MAP,other_twin.ControllerIndex)) and other_twin.Position:Distance(main_twin.Position) > (mod.Config.CoopTwins.tp_distance * mod.GridSize) then
				if REPENTOGON then other_twin:Teleport(main_twin.Position,true,true); else other_twin.Position = main_twin.Position + Vector.Zero; end
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.IMPORTANT, CoopTwins.onRender);

function CoopTwins.onRoom()
	if not CoopTwins.DATA.Twins then return; end
	for main_id,twin_id in pairs(CoopTwins.DATA.Twins) do
		local main_twin = Utils.GetPlayerByID(main_id);
		local other_twin = Utils.GetPlayerByID(twin_id);
		if main_twin and other_twin then
			other_twin.Position = main_twin.Position + Vector.Zero; -- Teleport Second twin to main twin because other twin just stays in random area of room
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.Priorities[5], CoopTwins.onRoom);

-- Cache stats functions
local function onInput(_, entity, input_hook, button_action)
	if not Utils.IsPauseMenuOpen() and entity ~= nil then
		local player_entity = entity:ToPlayer();
		if not player_entity then return; end
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
	local stat_functions = CoopTwins.StatFunctions[cache_flag];
	if not stat_functions then return; end
	local player_functions = stat_functions[player_entity:GetPlayerType()];
	if player_functions then
		for i,stat_function in pairs(player_functions) do stat_function(player_entity); end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache);

if not REPENTOGON then return; end
-- Add item functions
local function addCollectible(_, collectible_type, _, _, _, _, player_entity)
	local item_functions = CoopTwins.ItemFunctions[collectible_type];
	if not item_functions then return; end
	local player_functions = item_functions[player_entity:GetPlayerType()];
	if player_functions then
		for i,item_function in pairs(player_functions) do item_function(player_entity); end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, addCollectible);