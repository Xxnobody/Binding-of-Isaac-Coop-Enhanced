CoopEnhanced = RegisterMod("XxNobody Co-Op", 1);
CoopEnhanced.Version = 1.0;

-- TO-DO
-- - Animated Pickups Support ?
-- - Stat Multipliers

-- Ititialize Mod Variables
CoopEnhanced.FrameCount = 0;
CoopEnhanced.Challenge = {};
CoopEnhanced.Config = {};
CoopEnhanced.Fonts = {};
CoopEnhanced.Utils = {};
CoopEnhanced.Twins = {};
CoopEnhanced.Directory = "CoopEnhanced.";
CoopEnhanced.Players = {Alive = 0,Total = 0,Types = {},Unlocked = {}}; -- Alive/Total only tracks main players (not twins like Esau) 
CoopEnhanced.Registry = {Callbacks = {}, Commands = {}};
CoopEnhanced.Callbacks = {NUM_CALLBACKS = 0};

-- Functions
function CoopEnhanced.Debug(msg,module);
	if not CoopEnhanced.Config.debug or not msg then return; end
	module = module or "Co-op Enhanced";
	if type(msg) == "table" then
		print(module .. " Debug: ");
		CoopEnhanced.Utils.printTable(msg);
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
	-- Functions ran every second
	if CoopEnhanced.FrameCount == 1 then
		CoopEnhanced.Twins = {};
		CoopEnhanced.Players = {Alive = 0, Total = 0, Types = {},Unlocked = {}};
		if Game():GetNumPlayers() < 1 then return; end
		local players = {}
		for i = 1, Game():GetNumPlayers(), 1 do
			local player_entity = Isaac.GetPlayer(i - 1);
			local player_index = player_entity.ControllerIndex + 1;
			CoopEnhanced.Players.Types[i] = player_entity:GetPlayerType();
			if players[player_index] then
				CoopEnhanced.Twins[i] = players[player_index];
			else
				players[player_index] = i;
				CoopEnhanced.Twins[i] = false;
				CoopEnhanced.Players.Total = CoopEnhanced.Players.Total + 1; -- Total MAIN characters, excluding Twins/Strawmen
				if not player_entity:IsDead() and not player_entity:IsCoopGhost()  then CoopEnhanced.Players.Alive = CoopEnhanced.Players.Alive + 1; end -- Total ALIVE main characters
			end
			
		end
		CoopEnhanced.Players.Unlocked = CoopEnhanced.Utils.getUnlockedCharacters();
	end
	CoopEnhanced.FrameCount = CoopEnhanced.FrameCount > 60 and 1 or CoopEnhanced.FrameCount + 1;
end
CoopEnhanced:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.IMPORTANT, onUpdate);

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

	if CoopEnhanced.Config.modules.CoopFixes and CoopEnhanced.CoopFixes.gameStart then CoopEnhanced.CoopFixes.gameStart(isCont,data); end
	if CoopEnhanced.Config.modules.CoopExtras and CoopEnhanced.CoopExtras.gameStart then CoopEnhanced.CoopExtras.gameStart(isCont,data); end
	if CoopEnhanced.Config.modules.CoopMarks and CoopEnhanced.CoopMarks.gameStart then CoopEnhanced.CoopMarks.gameStart(isCont,data); end
	if CoopEnhanced.Config.modules.CoopTreasure and CoopEnhanced.CoopTreasure.gameStart then CoopEnhanced.CoopTreasure.gameStart(isCont,data); end
	if CoopEnhanced.Config.modules.CoopHUD and CoopEnhanced.CoopHUD.gameStart then CoopEnhanced.CoopHUD.gameStart(isCont,data); end
end
CoopEnhanced:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onGameStart);

local function saveGame(doSave)
	local data = {};

	if doSave then
		if CoopEnhanced.Config.modules.CoopFixes and CoopEnhanced.CoopFixes.gameEnd then data = CoopEnhanced.CoopFixes.gameEnd(data); end
		if CoopEnhanced.Config.modules.CoopExtras and CoopEnhanced.CoopExtras.gameEnd then data = CoopEnhanced.CoopExtras.gameEnd(data); end
		if CoopEnhanced.Config.modules.CoopMarks and CoopEnhanced.CoopMarks.gameEnd then CoopEnhanced.CoopMarks.gameEnd(data); end
		if CoopEnhanced.Config.modules.CoopTreasure and CoopEnhanced.CoopTreasure.gameEnd then data = CoopEnhanced.CoopTreasure.gameEnd(data); end
		if CoopEnhanced.Config.modules.CoopHUD and CoopEnhanced.CoopHUD.gameEnd then data = CoopEnhanced.CoopHUD.gameEnd(data); end
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