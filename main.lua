CoopEnhanced = RegisterMod("XxNobody Co-Op", 1);
CoopEnhanced.Version = 1.1;

-- TO-DO
-- - Animated Pickups Support ?
-- - Stat Multipliers

-- Ititialize Mod Variables
CoopEnhanced.FrameCount = 0;
CoopEnhanced.Challenge = {ID = 0};
CoopEnhanced.Config = {};
CoopEnhanced.Fonts = {};
CoopEnhanced.Utils = {};
CoopEnhanced.Directory = "CoopEnhanced.";
CoopEnhanced.Players = {Alive = 0,Total = 0,Joining = {},Types = {},Twins = {},Unlocked = {}};
CoopEnhanced.Registry = {Callbacks = {}, Commands = {}};
CoopEnhanced.Callbacks = {NUM_CALLBACKS = 0};

-- Functions
function CoopEnhanced.Debug(msg,module);
	if not CoopEnhanced.Config.debug or not msg then return; end
	module = module or "Co-op Enhanced";
	if type(msg) == "table" then
		print(module .. " Debug: ");
		CoopEnhanced.Utils.PrintTable(msg);
	else
		print(module .. " Debug: " .. msg);
	end
end

 -- Add Modded Character data (Name, Type, Unlock Achievement ID (ID if one exists, nil for none, 0 to represent not unlocked, -ID for non existent achievments), Sprite Data (Can be a Sprite or a table))
 -- - Sprite data can include Spritesheet data, so if you wish to change a spritesheet add it to Sheets as [sheet_id] = "path/to/png" (i.e. Sheets = {[0] = "Blank.png"})
function CoopEnhanced.AddCharacter(name,type,achievement,sprite)
	local sprite_data = sprite;
	if sprite.GetAnimation then sprite_data = {Anm2 = sprite:GetFilename(), Frame = sprite:GetFrame(), Animation = sprite:GetAnimation(), Sheets = {}};	end
	local character_entry = {Name = name, Type = type, Achievement = achievement,Sprite = sprite_data};
	table.insert(CoopEnhanced.CharactersModded,character_entry);
	table.sort(CoopEnhanced.CharactersModded,function (a,b) return a.Type < b.Type end);
end

-- Initialize Variables & Utilities
require(CoopEnhanced.Directory .. "enums");
require(CoopEnhanced.Directory .. "utils");
require(CoopEnhanced.Directory .. "config");
require(CoopEnhanced.Directory .. "callbacks");
-- Initialize Registry
require(CoopEnhanced.Directory .. "registry");

-- Main variable updates
local function onUpdate()
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.PRE_UPDATE);
	-- Functions ran every second
	if CoopEnhanced.FrameCount == 1 then
		CoopEnhanced.Players.Alive = 0;
		CoopEnhanced.Players.Total = 0;
		CoopEnhanced.Players.Twins = {};
		if Game():GetNumPlayers() < 1 then return; end
		local players = {}
		local num_twins = 0;
		for i = 1, Game():GetNumPlayers(), 1 do
			local player_entity = Isaac.GetPlayer(i - 1);
			local controller_index = player_entity.ControllerIndex;
			CoopEnhanced.Players.Types[i] = player_entity:GetPlayerType();
			if players[controller_index] then
				num_twins = num_twins + 1;
				CoopEnhanced.Players.Twins[i] = players[controller_index];
			else
				players[controller_index] = i - num_twins;
				CoopEnhanced.Players.Twins[i] = false;
				CoopEnhanced.Players.Total = CoopEnhanced.Players.Total + 1; -- Total MAIN characters, excluding Twins/Strawmen
				if not player_entity:IsDead() and not player_entity:IsCoopGhost()  then CoopEnhanced.Players.Alive = CoopEnhanced.Players.Alive + 1; end -- Total ALIVE main characters
			end
			
		end
		CoopEnhanced.Players.Unlocked = CoopEnhanced.Utils.GetUnlockedCharacters();
	end
	CoopEnhanced.FrameCount = CoopEnhanced.FrameCount > 60 and 1 or CoopEnhanced.FrameCount + 1;
	
	if not Game():IsPaused() and Isaac:CanStartTrueCoop() and CoopEnhanced.Challenge.ID == Challenge.CHALLENGE_NULL then
		local joining_total = CoopEnhanced.GetJoiningTotal();
		for i = 1, CoopEnhanced.MaxControllers, 1 do
			local controller_index = (i - 1);
			if joining_total < 4 and CoopEnhanced.Players.Joining[i] == nil and CoopEnhanced.Utils.GetMainPlayerByController(controller_index) == nil and Input.IsActionPressed(ButtonAction.ACTION_JOINMULTIPLAYER, controller_index) then
				local screen_dimensions = CoopEnhanced.Utils.GetScreenDimensions();
				local player_index = CoopEnhanced.Players.Total + 1;
				for i, joining in pairs(CoopEnhanced.Players.Joining) do if joining.Index == player_index then player_index = player_index + 1; else break; end end
				local joining = {Index = player_index, Controller = controller_index, Selected = 1};
				local menu_pos = Vector(100, 10);
				
				joining.Pos = Vector((joining.Index % 2) == 0 and (screen_dimensions.Max.X - menu_pos.X) or menu_pos.X, joining.Index > 2 and (screen_dimensions.Max.Y - menu_pos.Y) or menu_pos.Y);
				CoopEnhanced.Players.Joining[i] = joining;
			end
		end
		for i,joining in pairs(CoopEnhanced.Players.Joining) do
			local controller_index = joining.Controller;
			if Input.IsActionTriggered(ButtonAction.ACTION_MENUBACK, controller_index) or Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, controller_index) then
				CoopEnhanced.Players.Joining[i] = nil;
			else
				if Input.IsActionTriggered(ButtonAction.ACTION_MENULEFT, controller_index) then joining.Selected = joining.Selected - 1; --joining.Move = joining.Move + 24;
				elseif Input.IsActionTriggered(ButtonAction.ACTION_MENURIGHT, controller_index) then joining.Selected = joining.Selected + 1; end --joining.Move = joining.Move - 24;
				joining.Selected = CoopEnhanced.Utils.ClampFlow(1, #CoopEnhanced.Players.Unlocked, joining.Selected);
			end
		end
	end
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.POST_UPDATE);
end
CoopEnhanced:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.EARLY, onUpdate);

function CoopEnhanced.GetJoiningTotal()
	local total = 0;
	for i,joining in pairs(CoopEnhanced.Players.Joining) do total = total + 1; end
	return total;
end
function CoopEnhanced.IsPlayerJoining()
	for i,joining in pairs(CoopEnhanced.Players.Joining) do return true; end
	return false;
end
function CoopEnhanced.GetJoiningByController(controller_index)
	for i,joining in pairs(CoopEnhanced.Players.Joining) do
		if joining.Controller == controller_index then
			return joining, i;
		end
	end
	return nil,0;
end
function CoopEnhanced.RemoveJoiningByController(controller_index)
	for i,joining in pairs(CoopEnhanced.Players.Joining) do
		if joining.Controller == controller_index then
			CoopEnhanced.Players.Joining[i] = nil;
		end
	end
end

function CoopEnhanced.RefreshFrameCount();
	CoopEnhanced.FrameCount = 0;
	onUpdate();
end

-- Loading and Saving Callbacks
local json = require("json");
local function onGameStart(_, isCont)
	if not CoopEnhanced:HasData() then return; end
	local savedData = json.decode(CoopEnhanced:LoadData());
	local data = CoopEnhanced.Utils.decodeData(savedData);

	if data.Config and data.Version ~= nil then
		CoopEnhanced.Config = CoopEnhanced.Utils.ensureCompatibility(CoopEnhanced.Config, data.Config);
	end

	CoopEnhanced.Utils.LoadFonts();
	
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.LOAD_GAME_DATA,data);

	CoopEnhanced.UnlocksAllowed = not Game():AchievementUnlocksDisallowed();
	CoopEnhanced.Challenge = {ID = Isaac:GetChallenge(), IsDaily = (Game():GetChallengeParams():GetName() == DailyChallenge.GetChallengeParams():GetName()), Params = Game():GetChallengeParams()};

	for name,registry_func in pairs(CoopEnhanced.Registry.Modules) do
		if CoopEnhanced.Config.modules[name] and CoopEnhanced[name].gameStart then CoopEnhanced[name].gameStart(isCont,data); end
	end
end
CoopEnhanced:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onGameStart);

local function saveGame(doSave)
	local data = {};

	if doSave then
		for name,registry_func in pairs(CoopEnhanced.Registry.Modules) do
			if CoopEnhanced.Config.modules[name] and CoopEnhanced[name].gameEnd then CoopEnhanced[name].gameEnd(data); end
		end
	end
	
	data.Version = CoopEnhanced.Version;
	data.Config = CoopEnhanced.Config;
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.SAVE_GAME_DATA,data);
	
	data = CoopEnhanced.Utils.encodeData(data);
	local jsonString = json.encode(data);
	CoopEnhanced:SaveData(jsonString);
end

local function onGameExit(_, doSave)
	saveGame(doSave);
	CoopEnhanced.Utils.UnloadFonts();
end
CoopEnhanced:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, onGameExit);

local function onNewFloor(_)
	local level = Game():GetLevel();
	CoopEnhanced.Floor = {Name = level:GetName(), Curse = level:GetCurseName(), Stage = level:GetStage()};

	if level:GetStage() ~= LevelStage.STAGE1_1 then
		saveGame(true);
	end
end
CoopEnhanced:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, onNewFloor)

print("Co-Op Enhanced Mod - v"..CoopEnhanced.Version);