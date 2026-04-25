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

function CoopTwins.onRender(_)
	if Isaac:CanStartTrueCoop() then
		local joinable_twins = {};
		local joinable_twin = nil;
		for i,player_entity in pairs(PlayerManager.GetPlayers()) do
			if mod.TwinTypes[player_entity:GetPlayerType()] and player_entity:GetOtherTwin() ~= nil and CoopTwins.SetTwin[player_entity:GetPlayerType()] ~= nil then
				table.insert(joinable_twins,player_entity);
				if not joinable_twin and Input.IsActionPressed(ButtonAction.ACTION_DROP, player_entity.ControllerIndex) then joinable_twin = player_entity; end
			end
		end
		if not CoopTwins.DATA.Joining or type(CoopTwins.DATA.Twins) ~= "table" then CoopTwins.DATA.Joining = {}; end
		if not CoopTwins.DATA.Twins then CoopTwins.DATA.Twins = {}; end
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
				mod.RemoveJoiningByController(controller_index);
			end
		end
	end
	for main_id,twin_id in pairs(CoopTwins.DATA.Twins) do
		local main_twin = Utils.GetPlayerByID(main_id);
		local other_twin = Utils.GetPlayerByID(twin_id);
		if main_twin and other_twin then
			if (main_twin:IsCoopGhost() or Utils.IsPlayerDying(main_twin)) and not other_twin:IsCoopGhost() then other_twin:Die(); elseif (other_twin:IsCoopGhost() or  Utils.IsPlayerDying(other_twin)) and not main_twin:IsCoopGhost() then main_twin:Die(); end
			if (Input.IsActionPressed(ButtonAction.ACTION_DROP,other_twin.ControllerIndex) and Input.IsActionTriggered(ButtonAction.ACTION_MAP,other_twin.ControllerIndex)) and other_twin.Position:Distance(main_twin.Position) > (mod.Config.CoopTwins.tp_distance * mod.GridSize) then
				other_twin:Teleport(main_twin.Position,true,true);
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.IMPORTANT, CoopTwins.onRender);

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