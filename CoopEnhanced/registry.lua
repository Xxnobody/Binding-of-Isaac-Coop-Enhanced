local mod = CoopEnhanced;

local game = Game();

local Utils = mod.Utils;

-- Co-op Enhanced Registry
-- Registers Callback functions using a key and index value. Indexes can change depending on whats enabled, and so when registering callbacks you should use the Key value found in CoopEnhanced.Callbacks instead.
-- Registers Commands and command functions.
-- Registers Modules using a key and function. Keys must also match folder structure or errors will happen.

local function GetConfigs(cmd)
	if cmd == "config" or cmd == "global" or cmd == "main" then return mod.Config, mod.DefaultConfig; end
	for key,value in pairs(mod.Registry.Modules) do
		if mod.Config[key].CMD == cmd then return mod.Config[key], mod[key].DefaultConfig; end
	end
	return nil,nil;
end

local ModuleRegistry = {
	CoopFixes = function(module_name)
		local dir = mod.Directory .. module_name .. ".";
		CoopEnhanced[module_name] = {Directory = dir, DATA = {PLAYERS = {}}};
		CoopEnhanced.Registry:RegisterCallback("FIXES_PRE_REJOIN_EXECUTE");
		CoopEnhanced.Registry:RegisterCallback("FIXES_POST_REJOIN_EXECUTE");
		CoopEnhanced.Registry:RegisterCallback("FIXES_POST_REJOIN_BACKUP_LOAD");
		CoopEnhanced.Registry:RegisterCallback("FIXES_POST_REJOIN_BACKUP_SAVE");
		require(dir .. "enums");
		require(dir .. "config");
		require(dir .. "main");
		mod.Registry.Commands[mod.Config[module_name].CMD] = {
			["config"] = {["reset"] = mod[module_name].ResetConfig},
			["backup"] = {
				["load"] = function(args)
					local player_index, level_stage = tonumber(args[1]), tonumber(args[2]) or 0;
					if CoopEnhanced.CoopFixes.LoadBackup(player_index, level_stage) then print('Successfully found and loaded backup data for Player (' .. player_index .. ').'); else print('Incorrect arguments for command: load <player_index> <level_stage>'); end
				end,
				["save"] = function(args)
					if args[1] == nil then CoopEnhanced.CoopFixes.BackupAllPlayers(true); print('Successfully saved backup data for all Players.'); return; end
					local player_index = tonumber(args[1]);
					local player_entity = Isaac.GetPlayer(player_index - 1);
					local players = Utils.getPlayersByController(player_entity.ControllerIndex);
					if #players == 0 then print('Incorrect arguments for command: save <player_index>'); return; end
					for i,player_entity in pairs(players) do CoopEnhanced.CoopFixes.BackupPlayer(player_entity,true); end
					print('Successfully saved backup data for Player (' .. player_index .. ').');
				end
			}
		};
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD)] = "Co-op Fixes commands and configuration settings";
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD .. " backup load")] = mod.Config[module_name].CMD .. " load <player_index> <search_depth>";
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD .. " backup save")] = mod.Config[module_name].CMD .. " save <player_index>";
	end,
	CoopExtras = function(module_name)
		local dir = mod.Directory .. module_name .. ".";
		CoopEnhanced[module_name] = {Directory = dir, DATA = {Pickups = {}}};
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_GREED_REVIVE");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_POST_GREED_REVIVE");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_PRICE_DATA");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_POST_PRICE_DATA");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_GHOST_CHEST");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_GHOST_PICKUP");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_GHOST_COLLISION");
		require(dir .. "enums");
		require(dir .. "config");
		require(dir .. "main");
		mod.Registry.Commands[mod.Config[module_name].CMD] = {
			["config"] = {["reset"] = mod[module_name].ResetConfig},
		};
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD)] = "Co-op Extras commands and configuration settings";
	end,
	CoopLabels = function(module_name)
		local dir = mod.Directory .. module_name .. ".";
		CoopEnhanced[module_name] = {Directory = dir, DATA = {}};
		CoopEnhanced.Registry:RegisterCallback("LABELS_POST_DATA");
		CoopEnhanced.Registry:RegisterCallback("LABELS_PRE_RENDER");
		require(dir .. "enums");
		require(dir .. "config");
		require(dir .. "main");
		mod.Registry.Commands[mod.Config[module_name].CMD] = {
			["config"] = {["reset"] = mod[module_name].ResetConfig}
		};
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD)] = "Co-op Labels commands and configuration settings";
	end,
	CoopMarks = function(module_name)
		local dir = mod.Directory .. module_name .. ".";
		CoopEnhanced[module_name] = {Directory = dir,DATA = {}};
		CoopEnhanced.Registry:RegisterCallback("MARKS_POST_DATA");
		CoopEnhanced.Registry:RegisterCallback("MARKS_PRE_RENDER");
		require(dir .. "enums");
		require(dir .. "config");
		require(dir .. "main");
		mod.Registry.Commands[mod.Config[module_name].CMD] = {
			["config"] = {["reset"] = mod[module_name].ResetConfig}
		};
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD)] = "Co-op Marks commands and configuration settings";
	end,
	CoopTreasure = function(module_name)
		local dir = mod.Directory .. module_name .. ".";
		CoopEnhanced[module_name] = {Directory = dir,DATA = {}};
		CoopEnhanced.Registry:RegisterCallback("TREASURE_POST_COMPAT");
		CoopEnhanced.Registry:RegisterCallback("TREASURE_PRE_ROOM_DATA");
		CoopEnhanced.Registry:RegisterCallback("TREASURE_POST_ROOM_DATA");
		CoopEnhanced.Registry:RegisterCallback("TREASURE_PRE_PEDESTAL");
		CoopEnhanced.Registry:RegisterCallback("TREASURE_POST_PEDESTAL");
		CoopEnhanced.Registry:RegisterCallback("TREASURE_POST_ROOM_SETUP");
		CoopEnhanced.Registry:RegisterCallback("TREASURE_PRE_RENDER");
		require(dir .. "enums");
		require(dir .. "config");
		require(dir .. "main");
		mod.Registry.Commands[mod.Config[module_name].CMD] = {
			["config"] = {["reset"] = mod[module_name].ResetConfig}
		};
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD)] = "Co-op Treasure commands and configuration settings";
	end,
	CoopHUD = function(module_name)
		local dir = mod.Directory .. module_name .. ".";
		CoopEnhanced[module_name] = {Directory = dir,IsVisible = true,Refresh = false,DATA = {Players = {},Joining = {},Timer = {},Banner = {}},Player = {},Item = {Active = {},Trinket = {},Pocket = {},ChargeBar = {},Inventory = {}},Stats = {Deals = {}, Stat = {}},Misc = {Pickups = {}, Difficulty = {[0] = {},[1] = {}}, Wave = {[0] = {}}, Extra = {[0] = {}}}};
		CoopEnhanced.Registry:RegisterCallback("HUD_PLAYER_INIT");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_COOP_MENU_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_PLAYER_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_PLAYER_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_STATS_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_ACTIVE_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_POCKET_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_TRINKET_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_INVENTORY_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_PASSIVE_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_LABEL_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_HEALTH_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_MISC_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_BANNER_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_TIMER_RENDER");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_STATS_UPDATE");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_ACTIVE_UPDATE");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_POCKET_UPDATE");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_TRINKET_UPDATE");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_INVENTORY_UPDATE");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_PASSIVE_UPDATE");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_LABEL_UPDATE");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_HEALTH_UPDATE");
		CoopEnhanced.Registry:RegisterCallback("HUD_POST_MISC_UPDATE");
		require(dir .. "enums");
		require(dir .. "config");
		require(dir .. "compat");
		require(dir .. "main");
		mod.Registry.Commands[mod.Config[module_name].CMD] = {
			["config"] = {["reset"] = mod[module_name].ResetConfig},
			["cache"] = function() mod[module_name].DATA.Players = {}; print('Successfully cleared HUD player cache.'); end
		};
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD .. " cache")] = "Clears player cache which can solve rendering issues.";
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD)] = "Co-op HUD commands and configuration settings";
	end,
};

-- Register Base Callbacks
CoopEnhanced.Registry:RegisterCallback("PRE_REGISTRY_EXECUTE");
CoopEnhanced.Registry:RegisterCallback("POST_REGISTRY_EXECUTE");
CoopEnhanced.Registry:RegisterCallback("LOAD_GAME_DATA");
CoopEnhanced.Registry:RegisterCallback("SAVE_GAME_DATA");

-- Execute Pre Registry Callbacks
CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.PRE_REGISTRY_EXECUTE,ModuleRegistry);

CoopEnhanced.Registry.Modules = ModuleRegistry;

-- Registers command autocompletes for all config values
-- Todo: Give descriptions for each config option (ughh)
local function AutoConfig(cfg,params)
	params = params ~= nil and (params .. " ") or "";
	for key,value in pairs(cfg) do
		local new_params = (params .. key);
		if type(value) == "table" then AutoConfig(value,new_params);
		elseif type(value) == "userdata" and value.X then mod.Registry.Commands.Auto.Config[new_params] = "Vector - Enter an X and Y number value";
		elseif type(value) == "number" then mod.Registry.Commands.Auto.Config[new_params] = "Number - Enter a (1, 0.1, -1) value";
		elseif type(value) == "string" then mod.Registry.Commands.Auto.Config[new_params] = "String - Enter a ('string') value";
		elseif type(value) == "boolean" then mod.Registry.Commands.Auto.Config[new_params] = "Boolean - Enter a (true/false) value";
		else mod.Registry.Commands.Auto[new_params] = type(value); end
	end
end

mod.Registry.Commands = {
	Auto = {Config = {}},
	["print"] = {
		["players"] = function()
			for i,player_entity in pairs(Utils.getMainPlayers()) do
				print("Player: " .. player_entity:GetName() .. ", Controller: " .. player_entity.ControllerIndex .. ", Index: " .. i .. ", ID: " .. Utils.GetPlayerID(player_entity));
				for ii, twin_entity in pairs(Utils.getPlayerTwins(player_entity)) do
					print("\t Twin: " .. twin_entity:GetName() .. ", Index: " .. ii .. ", ID: " .. Utils.GetPlayerID(twin_entity));
				end
			end
		end,
	},
	["name"] = function(args) -- Change Player Name
		local config_type = args[1] or "";
		local player_index = tonumber(args[2]) or nil;
		local player_name = args[3] or "";
		if #args > 3 then 
			for i = 4, #args, 1 do player_name = (player_name .. " " .. args[i]); end
		end
		local config = GetConfigs(config_type);
		
		if not config or not player_index or player_index < 1 or player_index > 4 then print("Incorrect arguments for command. ('name <module> <player_index> <player_name>')"); return; end
		config.players[player_index].name = player_name;
		print('Successfully set name for Player (' .. player_index .. ') to ' .. player_name .. ".");
	end,
	["changeplayer"] = function(args) -- Change Player type
		local player_type = args[1] and tonumber(args[1]) or -1;
		local player_index = args[2] and tonumber(args[2]) or 1;
		if player_type == -1 then print("Incorrect arguments for command. ('changeplayer <player_type> <player_index>')"); end
		local player_entity = Isaac.GetPlayer(player_index - 1);
		if player_entity then
			game:ShowHallucination(5,BackdropType.BACKDROP_NULL);
			if CustomHealthAPI then CustomHealthAPI.Helper.ChangePlayerType(player_entity, player_type); else player_entity:ChangePlayerType(player_type); end
		end
	end,
	["removeplayer"] = function(args) -- Remove a Player (Crashes the game)
		local player_index = args[1] and tonumber(args[1]) or 0;
		if player_index == -1 then print("Incorrect arguments for command. ('removeplayer <player_index> <remove_twins>')"); end
		local player_entity = Isaac.GetPlayer(player_index - 1);
		if player_entity then
			if args[1] == "true" then
				if player_entity:GetMainTwin():GetName() ~= player_entity:GetName() then PlayerManager.RemoveCoPlayer(player_entity:GetMainTwin());
				elseif player_entity:GetOtherTwin() then PlayerManager.RemoveCoPlayer(player_entity:GetOtherTwin()); end
			end
			PlayerManager.RemoveCoPlayer(player_entity);
		end
	end,
	["revive"] = function(args) -- Revive a dead player (Coop Ghost)
		local player_index = args[1] and tonumber(args[1]) or 1;
		local revive_cost = args[2] and tonumber(args[2]) or 0;
		local reviver_index = args[3] and tonumber(args[3]) or 1;
		local player_entity = Isaac.GetPlayer(player_index - 1);
		if not player_entity then print("Incorrect arguments for command. ('revive <player_index> <cost>')"); return; end
		if player_entity and player_entity:IsCoopGhost() then
			if revive_cost > 0 then -- Cost in coins
				if Isaac.GetPlayer(reviver_index):GetNumCoins() >= revive_cost then
					Isaac.GetPlayer(reviver_index):AddCoins(-revive_cost);
					player_entity:ReviveCoopGhost();
				else
					print("Not enough money to revive!");
				end
			elseif revive_cost < 0 then -- Cost in health
				if not args[3] or args[3]:len() == 0 then 
					for i = 1, game:GetNumPlayers(), 1 do
						local reviver_entity = Isaac.GetPlayer(i - 1);
						local red_health = CustomHealthAPI.Helper.GetTotalRedHP(reviver_entity) / 2;
						if red_health >= revive_cost then
							reviver_entity:AddMaxHearts(-revive_cost * 2);
							player_entity:ReviveCoopGhost();
							return;
						end
					end
					print("No one has enough red health to revive!");
				else
					local reviver_entity = Isaac.GetPlayer(reviver_index - 1);
					local red_health = CustomHealthAPI.Helper.GetTotalRedHP(reviver_entity) / 2;
					if red_health >= revive_cost then
						reviver_entity:AddMaxHearts(-revive_cost * 2);
						player_entity:ReviveCoopGhost();
						return;
					else
						print("Player (" .. reviver_index .. ") does not have enough red health to revive!");
					end
				end
			else
				player_entity:ReviveCoopGhost();
			end
		end
	end,
	["health"] = function(args) -- Modify a players health
		local player_index = args[1] and tonumber(args[1]) or 1;
		local health_amount = args[3] and tonumber(args[3]) or 0;
		local player_entity = Isaac.GetPlayer(player_index - 1);
		if player_entity and args[2] and args[2] == "heal" then player_entity:AddHearts(health_amount); return; end
		local health_type = args[2] and tonumber(args[2]) or 0;
		local health_types = Utils.getHealthTypes();
		if not player_entity or health_type <= 0 or health_type > #health_types or health_amount == 0 then
			print("Incorrect arguments for command. ('health <player_index> <health_type> <health_amount>')");
			mod.Debug("Player Index: " .. player_index .. ", Type: " .. health_type .. ", Amount: " .. health_amount);
			print("Current Health Types: ");
			for i,health_info in pairs(health_types) do
				print("\t[" .. i .. "]: " .. Utils.CleanupName(health_info.Name));
			end
			return;
		end
		health_amount = health_amount * health_types[health_type].Total;
		if player_entity and not player_entity:IsCoopGhost() then
			if CustomHealthAPI then
				CustomHealthAPI.Library.AddHealth(player, health_types[health_type].Name, health_amount, true, true, true, true, true, true, true, true, false);
			else
				if Utils.IsLost(player_entity) or (Utils.IsKeeper(player_entity) and health_type > 1) then print("Incompatable Health Type for Player."); return; end
				local health_functions = {
					[1] = player_entity.AddMaxHearts,
					[2] = player_entity.AddMaxHearts,
					[3] = player_entity.AddSoulHearts,
					[4] = player_entity.AddBlackHearts,
					[5] = player_entity.AddBoneHearts,
					[6] = player_entity.AddRottenHearts,
					[7] = player_entity.AddEternalHearts,
					[8] = player_entity.AddGoldenHearts,
					[9] = player_entity.AddBrokenHearts,
				};
				local health_function = health_functions[health_type];
				if not health_function then return; end
				health_function(player_entity,health_amount);
				if health_type == 1 then player_entity:AddHearts(health_amount); end
			end
			mod.Debug("Player Index: " .. player_index .. ", Type: " .. health_type .. ", Amount: " .. health_amount);
			mod.Debug(health_types[health_type]);
		end
	end,
	["controller"] = function(args) -- Change controller indexes
		local player_index = args[1] and tonumber(args[1]) or -1;
		local controller_index = args[2] and tonumber(args[2]) or -1;
		local player_entity = Isaac.GetPlayer(player_index - 1);
		if player_index == -1 or controller_index == -1 or not player_entity then print("Incorrect arguments for command. ('controller <player_index> <controller_index>')"); return; end
		player_entity:SetControllerIndex(controller_index);
	end,
	["giveitem"] = function(args) -- Give item to player index
		local item_type = args[1]:find("t") and 1 or (args[1]:find("k") and 2 or (args[1]:find("p") and 3 or 0));
		args[1],_ = string.gsub(args[1],"%a","");
		local collectible_type = tonumber(args[1]) or -1;
		local player_index = tonumber(args[2]) or 1;
		local slot = tonumber(args[3]) or 0;
		local twin_index = tonumber(args[4]) or 0;
		local player_entity = Isaac.GetPlayer(player_index - 1);
		if twin_index > 0 then player_entity = Utils.getPlayerTwins(player_entity)[twin_index]; end
		if collectible_type == -1 or not player_entity then print("Incorrect arguments for command. ('" .. mod.Config.commands.CMD .. "giveitem <item_id> <player_index> <active_slot> <twin_index>')"); return; end
		if item_type == 0 then -- Collectibles (c)
			local item = Isaac.GetItemConfig():GetCollectible(collectible_type);
			if item then
				if item.Type == ItemType.ITEM_ACTIVE and slot < 4 then
					if slot < 2 then player_entity:AddCollectible(collectible_type, 12, false, slot); else player_entity:SetPocketActiveItem (collectible_type, slot, true); end
				else player_entity:AddCollectible(collectible_type); end
			end
		elseif item_type == 1 then -- Trinkets (t)
			player_entity:AddTrinket(collectible_type,true);
		elseif item_type == 2 then -- Cards (k)
			player_entity:SetCard(slot,collectible_type);
		elseif item_type == 3 then -- Pills (p)
			player_entity:SetPill(slot,collectible_type);
		end
		print("Successfully added " .. XMLData.GetEntryById(XMLNode.ITEM,collectible_type).name .. " to Player (" .. player_index ..").");
	end,
	["removeitem"] = function(args) -- Remove item from player index
		local item_type = args[1]:find("t") and 1 or (args[1]:find("k") and 2 or (args[1]:find("p") and 3 or 0));
		args[1],_ = string.gsub(args[1],"%a","");
		local collectible_type = tonumber(args[1]) or -1;
		local player_index = tonumber(args[2]) or 1;
		local slot = tonumber(args[3]) or 0;
		local twin_index = tonumber(args[5]) or 0;
		local player_entity = Isaac.GetPlayer(player_index - 1);
		if twin_index > 0 then player_entity = Utils.getPlayerTwins(player_entity)[twin_index]; end
		if collectible_type == -1 or not player_entity then print("Incorrect arguments for command. ('" .. mod.Config.commands.CMD .. "removeitem <item_id> <player_index> <active_slot> <drop_item> <twin_index>')"); return; end
		local position = Utils.GetSafeSpawnPosition(player_entity.Position, (player_entity.Position - Vector(0,mod.GridSize)), {1,1,2});
		if item_type == 0 then -- Collectibles (c)
			local has_item = player_entity:HasCollectible(collectible_type,true);
			player_entity:RemoveCollectible(collectible_type,true,slot,true);
			if has_item and args[4] == "true" then
				game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, position, Vector.Zero, nil, collectible_type, 1):ToPickup();
			end
		elseif item_type == 1 then -- Trinkets (t)
			local has_item = removed player_entity:TryRemoveTrinket(collectible_type);
			if has_item and args[4] == "true" then
				game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, position, Vector.Zero, nil, collectible_type, 1):ToPickup();
			end
		elseif item_type == 2 then -- Cards (k)
			local has_item = false;
			for slot = PillCardSlot.PRIMARY, PillCardSlot.SECONDARY do
				if player_entity:GetCard(slot) == collectible_type then 
					has_item = true;
					player_entity:SetCard(slot,Card.CARD_NULL);
					break;
				end
			end
			if has_item and args[4] == "true" then
				game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, position, Vector.Zero, nil, collectible_type, 1):ToPickup();
			end
		elseif item_type == 3 then -- Pills (p)
			local has_item = false;
			for slot = PillCardSlot.PRIMARY, PillCardSlot.SECONDARY do
				if player_entity:GetPill(slot) == collectible_type then 
					has_item = true;
					player_entity:SetPill(slot,PillColor.PILL_NULL);
					break;
				end
			end
			if has_item and args[4] == "true" then
				game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, position, Vector.Zero, nil, collectible_type, 1):ToPickup();
			end
		end
		print("Successfully removed " .. XMLData.GetEntryById(XMLNode.ITEM,collectible_type).name .. " from Player(" .. player_index ..").");
	end
};
mod.Registry.Commands.Auto["print"] = "Commands to print mod related debug data.";
mod.Registry.Commands.Auto["print players"] = "Prints player data used by the mod.";
mod.Registry.Commands.Auto["name"] = "Set a custom name of a player for a module. 'name <module> <player_index> <player_name>'";

 -- Special Commands. Create it this way to mimic vanilla commands.
Console.RegisterCommand((mod.Config.commands.CMD .. "giveitem"),"Give an item to a player","giveitem <item_id> <player_index> <active_slot> <twin_index>",false,AutocompleteType.ITEM);
Console.RegisterCommand((mod.Config.commands.CMD .. "removeitem"),"Remove an item from a player","removeitem <item_id> <player_index> <active_slot> <drop_item> <twin_index>",false,AutocompleteType.ITEM);
Console.RegisterCommand("changeplayer","Change a player to another character","changeplayer <player_type> <player_index>",true,AutocompleteType.PLAYER);
Console.RegisterCommand("removeplayer","Remove an existing player","removeplayer <player_index> <remove_twins>",true,AutocompleteType.NONE);
Console.RegisterCommand("health","Modify the health of a player","health <player_index> <health_type> <health_amount>",true,AutocompleteType.NONE); 
Console.RegisterCommand("revive","Revives a dead/ghost player","revive <player_index> <cost>",true,AutocompleteType.NONE); 
Console.RegisterCommand("controller","Change the controller index of a player","controller <player_index> <controller_index>",true,AutocompleteType.NONE);

AutoConfig(mod.Config, ("config"));
-- Register each module
for key,registry_func in pairs(mod.Registry.Modules) do
	registry_func(key);
	CoopEnhanced[key].Name = key;
	if mod.Config.commands.config then AutoConfig(mod.Config[key], (mod.Config[key].CMD .. " config")); end
end

-- Register Fonts
CoopEnhanced.Utils.LoadFonts();

-- Register Commands (Repentagon Required)
mod:AddCallback(ModCallbacks.MC_CONSOLE_AUTOCOMPLETE, function(_, cmd, params)
	local auto_tbl = {};
	for comA,comB in pairs(mod.Registry.Commands.Auto) do
		if comA ~= "Config" then table.insert(auto_tbl,{comA,comB}); end
	end
	for comA,comB in pairs(mod.Registry.Commands.Auto.Config) do
		table.insert(auto_tbl,{comA,comB});
	end
	return auto_tbl;
end);

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
	local args = {};
	for arg in string.gmatch(params, "([^ ]+)") do
		table.insert(args,arg);
	end
	
	if #args == 0 then return;
	elseif cmd:len() > mod.Config.commands.CMD:len() and cmd:sub(1,mod.Config.commands.CMD:len()) == mod.Config.commands.CMD then
		table.insert(args,1,(cmd:sub((mod.Config.commands.CMD:len() + 1))));
		cmd = cmd:sub(1,mod.Config.commands.CMD:len());
	elseif cmd == "changeplayer" or cmd == "removeplayer" or cmd == "revive" or cmd == "controller" or cmd == "health" then
		table.insert(args,1,cmd); -- Shift args over by 1 with cmd as arg
	elseif cmd ~= mod.Config.commands.CMD then return; end
	
	if args[1] == "config" then table.insert(args,1,args[1]); end-- Shift args over by 1 
	
	if args[2] == "config" then
		local config, default_config = GetConfigs(args[1]);
		for i = 3, #args, 1 do
			if config == nil then print("Config value for '" .. (args[(i - 1)] or "nil") .. "' not found!"); return;
			elseif type(config) == "userdata" and config.X then
				local x = tonumber(args[i]);
				local y = tonumber(args[(i + 1)]);
				config = Vector((x or config.X),(y or config.Y));
				break;
			elseif i == #args then 
				if config[args[i]] ~= nil then	print(params .. " = " .. tostring(config[args[i]])); end
				break;
			elseif (i + 1) == #args and args[(i + 1)] ~= nil then
				local config_type = type(config[(tonumber(args[i]) or args[i])]);
				local new_value = args[(i + 1)];
				local value = nil;
				if new_value == "reset" then value = default_config[args[i]];
				elseif config_type == "number" then value = tonumber(new_value);
				elseif config_type == "boolean" then if new_value == "true" then value = true; elseif new_value == "false" then value = false; end
				elseif config_type == "string" then value = new_value; end
				
				if value ~= nil then
					config[(tonumber(args[i]) or args[i])] = value;
					print(params .. " changed to " .. tostring(config[args[i]]));
					break;
				end
			end
			config = config[(tonumber(args[i]) or args[i])];
			default_config = default_config[(tonumber(args[i]) or args[i])];
		end
	else
		local command = mod.Registry.Commands;
		local variable_args = Utils.cloneTable(args);
		for i = 1, #args, 1 do
			command = command[args[i]];
			table.remove(variable_args,1); -- Remove non variable args for command functions
			if type(command) == "function" then command(variable_args); return;
			elseif type(command) == "nil" or i == #args then print("Incorrect arguments for command. (" .. (args[i] or "nil") .. ")"); return; end
		end
	end
end);
Console.RegisterCommand(mod.Config.commands.CMD,"Coop Enhanced Commands","",true,AutocompleteType.CUSTOM);

-- Mod Compat Registry
local function modCompats()
	local anim2 = "gfx/ui/coop_menu.anm2";
	if Epiphany then
		local epiphany_anm2 = "gfx/ui/coop/tr_coop_menu.anm2";
		CoopEnhanced.AddCharacter("Tarnished Isaac",Epiphany.PlayerType.ISAAC,(Epiphany:checkCharacter("ISAAC") and nil or -1),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 1});
		CoopEnhanced.AddCharacter("Tarnished Magdelene",Epiphany.PlayerType.MAGDALENE,(Epiphany:checkCharacter("MAGDALENE") and nil or -2),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 2});
		CoopEnhanced.AddCharacter("Tarnished Cain",Epiphany.PlayerType.CAIN,(Epiphany:checkCharacter("CAIN") and nil or -3),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 3});
		CoopEnhanced.AddCharacter("Tarnished Judas",Epiphany.PlayerType.JUDAS,(Epiphany:checkCharacter("JUDAS") and nil or -4),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 4});
		CoopEnhanced.AddCharacter("Tarnished ???",Epiphany.PlayerType.BLUEBABY,(Epiphany:checkCharacter("BLUEBABY") and nil or -5),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 5});
		CoopEnhanced.AddCharacter("Tarnished Eve",Epiphany.PlayerType.EVE,(Epiphany:checkCharacter("EVE") and nil or -6),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 6});
		CoopEnhanced.AddCharacter("Tarnished Samson",Epiphany.PlayerType.SAMSON,(Epiphany:checkCharacter("SAMSON") and nil or -7),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 7});
		CoopEnhanced.AddCharacter("Tarnished Azazel",Epiphany.PlayerType.AZAZEL,(Epiphany:checkCharacter("AZAZEL") and nil or -8),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 8});
		CoopEnhanced.AddCharacter("Tarnished Lazarus",Epiphany.PlayerType.LAZARUS,(Epiphany:checkCharacter("LAZARUS") and nil or -9),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 9});
		CoopEnhanced.AddCharacter("Tarnished Eden",Epiphany.PlayerType.EDEN,(Epiphany:checkCharacter("EDEN") and nil or -10),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 10});
		CoopEnhanced.AddCharacter("Tarnished Lost",Epiphany.PlayerType.LOST,(Epiphany:checkCharacter("LOST") and nil or -11),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 11});
		CoopEnhanced.AddCharacter("Tarnished Lilith",Epiphany.PlayerType.LILITH,(Epiphany:checkCharacter("LILITH") and nil or -12),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 12});
		CoopEnhanced.AddCharacter("Tarnished Keeper",Epiphany.PlayerType.KEEPER,(Epiphany:checkCharacter("KEEPER") and nil or -13),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 13});
		CoopEnhanced.AddCharacter("Tarnished Apollyon",Epiphany.PlayerType.APOLLYON,(Epiphany:checkCharacter("APOLLYON") and nil or -14),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 14});
		CoopEnhanced.AddCharacter("Tarnished Forgotten",Epiphany.PlayerType.FORGOTTEN,(Epiphany:checkCharacter("FORGOTTEN") and nil or -15),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 15});
		CoopEnhanced.AddCharacter("Tarnished Bethany",Epiphany.PlayerType.BETHANY,(Epiphany:checkCharacter("BETHANY") and nil or -16),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 16});
		CoopEnhanced.AddCharacter("Tarnished Jacob",Epiphany.PlayerType.JACOB,(Epiphany:checkCharacter("JACOB") and nil or -17),{Anm2 = epiphany_anm2,Animation = "Main",Frame = 17});
	end
	if EdithRestored then
		CoopEnhanced.AddCharacter("Edith",EdithRestored.Enums.PlayerType.EDITH,EdithRestored.Enums.Achievements.Characters.EDITH,{Anm2 = anim2,Animation = "Edith",Frame = 0});
		CoopEnhanced.AddCharacter("The Restored",EdithRestored.Enums.PlayerType.EDITH_B,EdithRestored.Enums.Achievements.Characters.TAINTED,{Anm2 = anim2,Animation = "Edith",Frame = 1});
	end
	if FiendFolio then
		CoopEnhanced.AddCharacter("Fiend",FiendFolio.PLAYER.FIEND,nil,{Anm2 = anim2,Animation = "Fiend",Frame = 0});
		CoopEnhanced.AddCharacter("The Bastard",FiendFolio.PLAYER.BIEND,(FiendFolio.GetAchievementsWithTag("BiendUnlock")[1]:IsUnlocked(true) and nil or 0),{Anm2 = anim2,Animation = "Fiend",Frame = 1});
		CoopEnhanced.AddCharacter("Golem",mod.PLAYER.GOLEM,nil,{Anm2 = anim2,Animation = "Fiend",Frame = 2});
		--CoopEnhanced.AddCharacter("The Cracked",mod.PLAYER.BOLEM,nil,{Anm2 = anim2,Animation = "Fiend",Frame = 2});
		CoopEnhanced.AddCharacter("Slippy",mod.PLAYER.SLIPPY,-1,{Anm2 = anim2,Animation = "Fiend",Frame = 3});
		CoopEnhanced.AddCharacter("China",mod.PLAYER.CHINA,-1,{Anm2 = anim2,Animation = "Fiend",Frame = 4});
		--CoopEnhanced.AddCharacter("Fient",mod.PLAYER.FIENT,-1,{Anm2 = anim2,Animation = "Fiend",Frame = 5});
		--CoopEnhanced.AddCharacter("Fend",mod.PLAYER.FEND,-1,{Anm2 = anim2,Animation = "Fiend",Frame = 6});
		--CoopEnhanced.AddCharacter("Peat",mod.PLAYER.PEAT,-1,{Anm2 = anim2,Animation = "Fiend",Frame = 7});
	end
	if _JERICHO_MOD then
		CoopEnhanced.AddCharacter("Jericho",_JERICHO_MOD.Character.JERICHO,nil,{Anm2 = anim2,Animation = "Jericho",Frame = 0});
		CoopEnhanced.AddCharacter("Tainted Jericho",_JERICHO_MOD.Character.JERICHO_ALT,nil,{Anm2 = anim2,Animation = "Jericho",Frame = 1});
	end
	if Martha then
		CoopEnhanced.AddCharacter("Martha",Martha.Players.Martha.ID,nil,{Anm2 = anim2,Animation = "Martha",Frame = 0});
		CoopEnhanced.AddCharacter("The Restrained",Martha.Players.MarthaB.ID,nil,{Anm2 = anim2,Animation = "Martha",Frame = 1});
	end
	if MeiMod then
		CoopEnhanced.AddCharacter("Mei",Isaac.GetPlayerTypeByName("Mei"),nil,{Anm2 = anim2,Animation = "Mei",Frame = 0});
		CoopEnhanced.AddCharacter("The Asomatous",Isaac.GetPlayerTypeByName("Tainted Mei",true),nil,{Anm2 = anim2,Animation = "Mei",Frame = 1});
	end
	if XMLData.GetEntryByName(XMLNode.MOD,"Nemesis [for REP]") then
		CoopEnhanced.AddCharacter("Nemesis",Isaac.GetPlayerTypeByName("Nemesis"),nil,{Anm2 = anim2,Animation = "Nemesis",Frame = 0});
		CoopEnhanced.AddCharacter("The Ensorcelled",Isaac.GetPlayerTypeByName("Tainted Nemesis",true),nil,{Anm2 = anim2,Animation = "Nemesis",Frame = 1});
	end
	if SamaelMod then
		CoopEnhanced.AddCharacter("Samael",SamaelMod.Lib.SamaelId,nil,{Anm2 = anim2,Animation = "Samael",Frame = 0});
		CoopEnhanced.AddCharacter("The Inevitable",SamaelMod.Lib.TaintedSamaelId,nil,{Anm2 = anim2,Animation = "Samael",Frame = 1});
	end
	if REVEL then
		CoopEnhanced.AddCharacter("Sarah",REVEL.CHAR.SARAH.Type,nil,{Anm2 = anim2,Animation = "Revelations",Frame = 0});
		CoopEnhanced.AddCharacter("Dante",REVEL.CHAR.DANTE.Type,nil,{Anm2 = anim2,Animation = "Revelations",Frame = 1});
	end
end
CoopEnhanced:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, modCompats);

-- Cleanup Normal Character Sprite Data
for i,character in pairs(mod.Characters) do
	character.Sprite = character.Sprite or {};
	character.Sprite.Anm2 = character.Sprite.Anm2 or mod.Animations.Coop;
	character.Sprite.Animation = character.Sprite.Animation or "Main";
	character.Sprite.Frame = character.Sprite.Frame or (character.Type + 1);
	character.Sprite.Sheets = character.Sprite.Sheets or {[1] = mod.Images.Blank};
end

-- Execute Post Registry Callbacks
CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.POST_REGISTRY_EXECUTE);