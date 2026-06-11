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
		CoopEnhanced[module_name] = {Directory = dir, DATA = {PLAYERS = {}}, Rejoin = {}, Join = {}, Rewind = {}};
		if not mod.Config.modules[module_name] then return; end
		CoopEnhanced.Registry:RegisterCallback("FIXES_PRE_REJOIN_EXECUTE");
		CoopEnhanced.Registry:RegisterCallback("FIXES_PRE_REJOIN_REVIVE");
		CoopEnhanced.Registry:RegisterCallback("FIXES_PRE_REJOIN_PLAYERTYPE");
		CoopEnhanced.Registry:RegisterCallback("FIXES_PRE_REJOIN_HEALTH");
		CoopEnhanced.Registry:RegisterCallback("FIXES_PRE_REJOIN_ACTIVES");
		CoopEnhanced.Registry:RegisterCallback("FIXES_PRE_REJOIN_POCKETS");
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
					if CoopEnhanced.CoopFixes.LoadBackup(player_index, level_stage) then print("Successfully found and loaded backup data for Player (" .. player_index .. ")."); else print("Incorrect arguments for command: load <player_index> <level_stage>"); end
				end,
				["save"] = function(args)
					if args[1] == nil then CoopEnhanced.CoopFixes.BackupAllPlayers(true); print("Successfully saved backup data for all Players."); return; end
					local player_index = tonumber(args[1]);
					local player_entity = Utils.GetMainPlayerByIndex(player_index);
					local players = Utils.GetPlayersByController(player_entity.ControllerIndex);
					if #players == 0 then print("Incorrect arguments for command: save <player_index>"); return; end
					for i,player in pairs(players) do CoopEnhanced.CoopFixes.BackupPlayer(player,true); end
					print("Successfully saved backup data for Player (" .. player_index .. ").");
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
		if not mod.Config.modules[module_name] then return; end
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_GREED_REVIVE");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_POST_GREED_REVIVE");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_PRICE_DATA");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_POST_PRICE_DATA");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_GHOST_CHEST");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_GHOST_PICKUP");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_GHOST_COLLISION");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_PERFECTION_HIT");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_PERFECTION_SPAWN");
		CoopEnhanced.Registry:RegisterCallback("EXTRAS_PRE_SACRIFICE_REVIVE");
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
		if not mod.Config.modules[module_name] then return; end
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
		if not REPENTOGON or not mod.Config.modules[module_name] then return; end
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
	CoopTwins = function(module_name)
		local dir = mod.Directory .. module_name .. ".";
		CoopEnhanced[module_name] = {Directory = dir,DATA = {},Syncing = false};
		if not REPENTOGON or not mod.Config.modules[module_name] then return; end
		require(dir .. "config");
		require(dir .. "main");
		require(dir .. "enums");
		mod.Registry.Commands[mod.Config[module_name].CMD] = {
			["config"] = {["reset"] = mod[module_name].ResetConfig}
		};
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD)] = "Co-op Twins commands and configuration settings";
	end,
	CoopTreasure = function(module_name)
		local dir = mod.Directory .. module_name .. ".";
		CoopEnhanced[module_name] = {Directory = dir,DATA = {}};
		if not mod.Config.modules[module_name] then return; end
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
			["config"] = {["reset"] = mod[module_name].ResetConfig},
			["clearcache"] = function(args)
				local room_data = mod[module_name].DATA[Utils.GetRoomID()]
				if room_data then
					room_data = nil;
					local only_cache = args[1] ~= "true";
					mod[module_name]:onRoom(only_cache);
					print("Successfully cleared treasure cache for this room.");
				end
			end,
		};
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD)] = "Co-op Treasure commands and configuration settings";
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD .. " clearcache <reset_room>")] = "Clears the current rooms cache which removes all owners.";
	end,
	CoopHUD = function(module_name)
		local dir = mod.Directory .. module_name .. ".";
		CoopEnhanced[module_name] = {Directory = dir,Visible = true,IsMapDown = false,IsMapToggled = false,IsPlayerMapDown = {},Refresh = false,DATA = {Players = {},Joining = {},Score = {},Timer = {},Banner = {}},Player = {},Item = {Active = {},Trinket = {},Pocket = {},ChargeBar = {},Inventory = {}},Stats = {Deals = {}, Stat = {}},Misc = {Pickups = {}, Difficulty = {[0] = {},[1] = {}}, Wave = {[0] = {}}, Extra = {[0] = {}}}};
		if not REPENTOGON or not mod.Config.modules[module_name] then return; end
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
		CoopEnhanced.Registry:RegisterCallback("HUD_PRE_SCORE_RENDER");
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
			["clearcache"] = function() mod[module_name].DATA.Players = {}; print("Successfully cleared HUD player cache."); end
		};
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD)] = "Co-op HUD commands and configuration settings";
		mod.Registry.Commands.Auto[(mod.Config[module_name].CMD .. " clearcache")] = "Clears player cache which can solve rendering issues.";
	end,
};

-- Register Base Callbacks
CoopEnhanced.Registry:RegisterCallback("PRE_REGISTRY_EXECUTE");
CoopEnhanced.Registry:RegisterCallback("POST_REGISTRY_EXECUTE");
CoopEnhanced.Registry:RegisterCallback("PRE_UPDATE");
CoopEnhanced.Registry:RegisterCallback("POST_UPDATE");
CoopEnhanced.Registry:RegisterCallback("POST_HEAD_SPRITE");
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
			for i,player_entity in pairs(Utils.GetMainPlayers()) do
				print("Player: " .. player_entity:GetName() .. ", Controller: " .. player_entity.ControllerIndex .. ", Index: " .. i .. ", ID: " .. Utils.GetPlayerID(player_entity));
				for ii, twin_entity in pairs(Utils.GetPlayerTwins(player_entity)) do
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
		print("Successfully set name for Player (" .. player_index .. ") to " .. player_name .. ".");
	end,
	["changeplayer"] = function(args) -- Change Player type
		local player_type = tonumber(args[1]) or -1;
		local player_index = tonumber(args[2]) or 1;
		local twin_index = tonumber(args[4]) or 0;
		local player_entity = Utils.GetMainPlayerByIndex(player_index);
		if twin_index > 0 then player_entity = Utils.GetPlayerTwins(player_entity)[twin_index]; end
		if not player_entity or player_type == -1 then print("Incorrect arguments for command. ('changeplayer <player_type> <player_index> <twin_index>')"); end
		game:ShowHallucination(5,BackdropType.BACKDROP_NULL);
		if CustomHealthAPI then CustomHealthAPI.Helper.ChangePlayerType(player_entity, player_type); else player_entity:ChangePlayerType(player_type); end
	end,
	["removeplayer"] = function(args) -- Remove a Player (Crashes the game)
		local player_index = tonumber(args[1]) or 0;
		local twin_index = tonumber(args[4]) or 0;
		local player_entity = Utils.GetMainPlayerByIndex(player_index);
		if twin_index > 0 then player_entity = Utils.GetPlayerTwins(player_entity)[twin_index]; end
		if not player_entity then print("Incorrect arguments for command. ('removeplayer <player_index> <twin_index>')"); end
		if REPENTOGON then PlayerManager.RemoveCoPlayer(player_entity); else player_entity:Remove(); end
	end,
	["revive"] = function(args) -- Revive a dead player (Coop Ghost)
		local player_index = tonumber(args[1]) or 1;
		local revive_cost = tonumber(args[2]) or 0;
		local reviver_index = tonumber(args[3]) or 1;
		local player_entity = Utils.GetMainPlayerByIndex(player_index);
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
		local player_index = tonumber(args[1]) or 1;
		local health_amount = tonumber(args[3]) or 0;
		local twin_index = tonumber(args[4]) or 0;
		local player_entity = Utils.GetMainPlayerByIndex(player_index);
		if twin_index > 0 then player_entity = Utils.GetPlayerTwins(player_entity)[twin_index]; end
		local health_type = tonumber(args[2]) or 0;
		local health_types = Utils.GetHeartTypes();
		if player_entity and args[2] == "heal" then player_entity:AddHearts(health_amount); return;
		elseif not player_entity or health_type <= 0 or health_type > #health_types or health_amount == 0 then
			print("Incorrect arguments for command. ('health <player_index> <health_type> <health_amount> <twin_index>')");
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
				CustomHealthAPI.Library.AddHealth(player_entity, health_types[health_type].Name, health_amount, true, true, true, true, true, true, true, true, false);
			else
				if Utils.IsLost(player_entity:GetPlayerType()) or (Utils.IsKeeper(player_entity:GetPlayerType()) and health_type > 1) then print("Incompatable Health Type for Player."); return; end
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
		local player_index = tonumber(args[1]) or 1;
		local controller_index = tonumber(args[2]) or -1;
		local twin_index = tonumber(args[3]) or 0;
		local player_entity = Utils.GetMainPlayerByIndex(player_index);
		if twin_index > 0 then player_entity = Utils.GetPlayerTwins(player_entity)[twin_index]; end
		if not player_entity or controller_index == -1 then print("Incorrect arguments for command. ('controller <player_index> <controller_index> <twin_index>')"); return; end
		player_entity:SetControllerIndex(controller_index);
		if mod.CoopFixes.DATA and mod.CoopFixes.DATA.Controllers then 
			local player_id = Utils.GetPlayerID(player_entity);
			for id,_ in pairs(mod.CoopFixes.DATA.Controllers) do
				if player_id == id then
					mod.CoopFixes.DATA.Controllers[player_id] = controller_index;
					break;
				end
			end
		end
	end,
	["kill"] = function(args) -- Kill a player
		local player_index = tonumber(args[1]) or 1;
		local twin_index = tonumber(args[3]) or 0;
		local player_entity = Utils.GetMainPlayerByIndex(player_index);
		if twin_index > 0 then player_entity = Utils.GetPlayerTwins(player_entity)[twin_index]; end
		if not player_entity or controller_index == -1 then print("Incorrect arguments for command. ('kill <player_index> <twin_index>')"); return; end
		player_entity:Die();
	end,
	["giveitem"] = function(args) -- Give item to player index
		local item_type = args[1]:find("t") and XMLNode.TRINKET or (args[1]:find("k") and XMLNode.CARD or (args[1]:find("p") and XMLNode.PILL or XMLNode.ITEM));
		args[1],_ = string.gsub(args[1],"%a","");
		local collectible_type = tonumber(args[1]) or -1;
		local player_index = tonumber(args[2]) or 1;
		local slot = tonumber(args[3]) or 0;
		local twin_index = tonumber(args[4]) or 0;
		local player_entity = Utils.GetMainPlayerByIndex(player_index);
		if twin_index > 0 then player_entity = Utils.GetPlayerTwins(player_entity)[twin_index]; end
		if collectible_type == -1 or not player_entity then print("Incorrect arguments for command. ('" .. mod.Config.commands.CMD .. "giveitem <item_id> <player_index> <active_slot> <twin_index>')"); return; end
		if item_type == XMLNode.ITEM then -- Collectibles (c)
			local item = Isaac.GetItemConfig():GetCollectible(collectible_type);
			if item then
				if item.Type == ItemType.ITEM_ACTIVE and slot < 4 then
					if slot < 2 then player_entity:AddCollectible(collectible_type, 12, false, slot); else player_entity:SetPocketActiveItem (collectible_type, slot, true); end
				else player_entity:AddCollectible(collectible_type); end
			end
		elseif item_type == XMLNode.TRINKET then -- Trinkets (t)
			player_entity:AddTrinket(collectible_type,true);
		elseif item_type == XMLNode.CARD then -- Cards (k)
			player_entity:SetCard(slot,collectible_type);
		elseif item_type == XMLNode.PILL then -- Pills (p)
			player_entity:SetPill(slot,collectible_type);
		end
		print("Successfully added " .. XMLData.GetEntryById(item_type,collectible_type).name .. " to Player (" .. player_index ..")");
	end,
	["removeitem"] = function(args) -- Remove item from player index
		local item_type = args[1]:find("t") and 1 or (args[1]:find("k") and 2 or (args[1]:find("p") and 3 or 0));
		args[1],_ = string.gsub(args[1],"%a","");
		local collectible_type = tonumber(args[1]) or -1;
		local player_index = tonumber(args[2]) or 1;
		local slot = tonumber(args[3]) or 0;
		local twin_index = tonumber(args[5]) or 0;
		local player_entity = Utils.GetMainPlayerByIndex(player_index);
		if twin_index > 0 then player_entity = Utils.GetPlayerTwins(player_entity)[twin_index]; end
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
		print("Successfully removed " .. XMLData.GetEntryById(XMLNode.ITEM,collectible_type).name .. " from Player(" .. player_index ..")");
	end
};
mod.Registry.Commands.Auto["print"] = "Commands to print mod related debug data.";
mod.Registry.Commands.Auto["print players"] = "Prints player data used by the mod.";
mod.Registry.Commands.Auto["name"] = "Set a custom name of a player for a module. 'name <module> <player_index> <player_name>'";

 -- Special Commands. Create it this way to mimic vanilla commands.
if REPENTOGON then
	Console.RegisterCommand((mod.Config.commands.CMD .. "giveitem"),"Give an item to a player","giveitem <item_id> <player_index> <active_slot> <twin_index>",false,AutocompleteType.ITEM);
	Console.RegisterCommand((mod.Config.commands.CMD .. "removeitem"),"Remove an item from a player","removeitem <item_id> <player_index> <active_slot> <drop_item> <twin_index>",false,AutocompleteType.ITEM);
	Console.RegisterCommand("changeplayer","Change a player to another character","changeplayer <player_type> <player_index>",true,AutocompleteType.PLAYER);
	Console.RegisterCommand("removeplayer","Remove an existing player","removeplayer <player_index> <remove_twins>",true,AutocompleteType.NONE);
	Console.RegisterCommand("health","Modify the health of a player","health <player_index> <health_type> <health_amount> <twin_index>",true,AutocompleteType.NONE); 
	Console.RegisterCommand("revive","Revives a dead/ghost player","revive <player_index> <cost>",true,AutocompleteType.NONE); 
	Console.RegisterCommand("kill","Kill a player","kill <player_index> <twin_index>",true,AutocompleteType.NONE);
	Console.RegisterCommand("controller","Change the controller index of a player","controller <player_index> <controller_index>",true,AutocompleteType.NONE);
	Console.RegisterCommand(mod.Config.commands.CMD,"Coop Enhanced Commands","",true,AutocompleteType.CUSTOM);
end

AutoConfig(mod.Config, ("config"));
-- Register each module
for key,registry_func in pairs(mod.Registry.Modules) do
	registry_func(key);
	if CoopEnhanced[key] then
		CoopEnhanced[key].Name = key;
		if mod.Config.commands.config and mod.Config[key] then AutoConfig(mod.Config[key], (mod.Config[key].CMD .. " config")); end
	end
end

-- Register Fonts
CoopEnhanced.Utils.LoadFonts();

-- Register Command Autocomplete (REPENTOGON Required)
if REPENTOGON then
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
end

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
	local args = {};
	for arg in string.gmatch(params, "([^ ]+)") do
		table.insert(args,arg);
	end
	
	if #args == 0 then return;
	elseif cmd:len() > mod.Config.commands.CMD:len() and cmd:sub(1,mod.Config.commands.CMD:len()) == mod.Config.commands.CMD then
		table.insert(args,1,(cmd:sub((mod.Config.commands.CMD:len() + 1))));
		cmd = cmd:sub(1,mod.Config.commands.CMD:len());
	elseif cmd == "changeplayer" or cmd == "removeplayer" or cmd == "revive" or cmd == "controller" or cmd == "health" or cmd == "kill" then
		table.insert(args,1,cmd); -- Shift args over by 1 with cmd as arg
	elseif cmd ~= mod.Config.commands.CMD then return; end
	
	if args[1] == "config" then table.insert(args,1,args[1]); end-- Shift args over by 1 
	
	if args[2] == "config" then
		local config, default_config = GetConfigs(args[1]);
		for i = 3, #args, 1 do
			if config == nil then print("Config value for '" .. (args[(i - 1)] or "nil") .. "' not found!"); return;
			elseif type(config) == "userdata" and config.X then
				config.X = args[i] == "reset" and default_config.X or (tonumber(args[i]) or config.X);
				config.Y = args[i] == "reset" and default_config.Y or (tonumber(args[(i + 1)]) or config.Y);
				print(params:sub(1,(params:find(args[i]) - 2)) .. " changed to " .. "Vector (" .. config.X .. ", " .. config.Y .. ")");
				break;
			elseif i == #args then 
				if config[args[i]] ~= nil then print(params .. " = " .. tostring(config[args[i]])); end
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
					print(params:sub(1,(params:find(args[(i + 1)]) - 2)) .. " changed to " .. tostring(config[args[i]]));
					break;
				end
			end
			config = config[(tonumber(args[i]) or args[i])];
			default_config = default_config[(tonumber(args[i]) or args[i])];
		end
	else
		local command = mod.Registry.Commands;
		local variable_args = Utils.Clone(args);
		for i = 1, #args, 1 do
			command = command[args[i]];
			table.remove(variable_args,1); -- Remove non variable args for command functions
			if type(command) == "function" then command(variable_args); return;
			elseif type(command) == "nil" or i == #args then print("Incorrect arguments for command. (" .. (args[i] or "nil") .. ")"); return; end
		end
	end
end);

-- Execute Post Registry Callbacks
CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.POST_REGISTRY_EXECUTE);

if not REPENTOGON then return; end

-- Mod Compat Registry
local function modCompats()
	-- CustomHealthAPI
	if CustomHealthAPI then
		if not CustomHealthAPI.Constants.Health then -- Build a data table to seperate which keys are what types.
			CustomHealthAPI.Constants.Health = {RED = {},SOUL = {},CONTAINER = {},OVERLAY = {}};
			for key, info in pairs(CustomHealthAPI.PersistentData.HealthDefinitions) do
				if info.Type == CustomHealthAPI.Enums.HealthTypes.RED then table.insert(CustomHealthAPI.Constants.Health.RED,key);
				elseif info.Type == CustomHealthAPI.Enums.HealthTypes.SOUL then table.insert(CustomHealthAPI.Constants.Health.SOUL,key);
				elseif info.Type == CustomHealthAPI.Enums.HealthTypes.CONTAINER then table.insert(CustomHealthAPI.Constants.Health.CONTAINER,key);
				elseif info.Type == CustomHealthAPI.Enums.HealthTypes.OVERLAY then table.insert(CustomHealthAPI.Constants.Health.OVERLAY,key);
				end
			end
		end
	end
	
	-- Character Adds
	local anim2 = "gfx/ui/coop_menu.anm2";
	if EdithRestored then
		Utils.AddCharacter("Edith",EdithRestored.Enums.PlayerType.EDITH,EdithRestored.Enums.Achievements.Characters.EDITH,false,false,nil,{Anm2 = anim2,Animation = "Edith",Frame = 0});
		Utils.AddCharacter("The Restored",EdithRestored.Enums.PlayerType.EDITH_B,EdithRestored.Enums.Achievements.Characters.TAINTED,false,true,EdithRestored.Enums.PlayerType.EDITH,{Anm2 = anim2,Animation = "Edith",Frame = 1});
	elseif EdithMod then
		Utils.AddCharacter("Edith",EdithMod.Enums.PlayerType.EDITH,EdithMod.Enums.Achievements.Characters.EDITH,false,false,nil,{Anm2 = anim2,Animation = "Edith",Frame = 0});
		Utils.AddCharacter("The Restored",EdithMod.Enums.PlayerType.EDITH_B,EdithMod.Enums.Achievements.Characters.TAINTED,false,true,EdithMod.Enums.PlayerType.EDITH,{Anm2 = anim2,Animation = "Edith",Frame = 1});
	end
	if XMLData.GetModById("2501339433") and XMLData.GetModById("2501339433").enabled == "true" then
		Utils.AddCharacter("Nemesis",Isaac.GetPlayerTypeByName("Nemesis"),nil,false,false,nil,{Anm2 = anim2,Animation = "Nemesis",Frame = 0});
		Utils.AddCharacter("The Ensorcelled",Isaac.GetPlayerTypeByName("Tainted Nemesis",true),nil,false,true,Isaac.GetPlayerTypeByName("Nemesis"),{Anm2 = anim2,Animation = "Nemesis",Frame = 1});
	end
	if VTRemaster then
		Utils.AddCharacter("Vitiated Characters",Isaac.GetPlayerTypeByName("Selector"),nil,false,false,nil,{Anm2 = anim2,Animation = "Door",Frame = 0});
	end
	
	for i = (PlayerType.NUM_PLAYER_TYPES + 1), XMLData.GetNumEntries(XMLNode.PLAYER), 1 do
		local xml = XMLData.GetEntryByOrder(XMLNode.PLAYER,i);
		local isTainted = xml.bskinparent ~= nil and xml.bskinparent:len() > 0;
		local player_type = Isaac.GetPlayerTypeByName(xml.name,isTainted);
		if not Utils.GetCharacterByType(player_type) then
			local mod_sprite = Utils.GetHeadSprite(nil,nil,player_type);
			local achievment = xml.achievement ~= nil and Isaac.GetAchievementIdByName(xml.achievement) or (xml.hideachievement and Isaac.GetAchievementIdByName(xml.hideachievement) or nil);
			local hidden = xml.hidden == "true" and true or false;
			local parent = isTainted and Isaac.GetPlayerTypeByName(xml.bskinparent,true) or nil;
			local sprite_data = {Anm2 = mod_sprite:GetFilename(),Animation = xml.name,Frame = 0};
			
			Utils.AddCharacter(xml.name,player_type,achievment,hidden,isTainted,parent,sprite_data);
		end
	end
	
	-- Character Edits
	if ANDROMEDA then
		Utils.EditCharacter(Isaac.GetPlayerTypeByName("AndromedaB",true),{Name = "The Abandoned"});
	end
	if ArachnaMod then
		Utils.EditCharacter(ArachnaMod.PlayerType.ARACHNA_B,{Name = "The Wretched"});
	end
	if BaelMOD then
		Utils.EditCharacter(PlayerType.PLAYER_BAEL_B,{Name = "The Humane"});
	end
	if Elijah then
		Utils.EditCharacter(Elijah.Player.ELIJAH_B,{Name = "The Servant"});
	end
	if ENAmod then
		Utils.EditCharacter(Isaac.GetPlayerTypeByName("ENA",true),{Name = "The Worker"});
	end
	if FiendFolio then
		Utils.EditCharacter(FiendFolio.PLAYER.BIEND,{Name = "The Bastard"});
		Utils.EditCharacter(FiendFolio.PLAYER.BOLEM,{Name = "The Cracked"});
	end
	if Furtherance then
		Utils.EditCharacter(Furtherance.PlayerType.LEAH_B,{Name = "The Unloved"});
		Utils.EditCharacter(Furtherance.PlayerType.MIRIAM_B,{Name = "The Condemned"});
		Utils.EditCharacter(Furtherance.PlayerType.PETER_B,{Name = "The Martyr"});
	end
	if LNF then
		Utils.EditCharacter(LNF.PlayerType.TaintedJoseph,{Name = "The Tormented"});
		Utils.EditCharacter(LNF.PlayerType.TaintedRobot,{Name = "The Discarded"});
	end
	if Martha then
		Utils.EditCharacter(Martha.Players.MarthaB.ID,{Name = "The Restrained"});
	end
	if MeiMod then
		Utils.EditCharacter(Isaac.GetPlayerTypeByName("Tainted Mei",true),{Name = "The Asomatous"});
	end
	if XMLData.GetModById("2501339433") and XMLData.GetModById("2501339433").enabled == "true" then
		Utils.EditCharacter(Isaac.GetPlayerTypeByName("Tainted Nemesis",true),{Name = "The Ensorcelled"});
	end
	if NoahMod then
		Utils.EditCharacter(Isaac.GetPlayerTypeByName("Noah",true),{Name = "The Drowned"});
	end
	if REVEL then
		Utils.EditCharacter(Isaac.GetPlayerTypeByName("Sarah",true),{Name = "The Crestfallen"});
		Utils.EditCharacter(Isaac.GetPlayerTypeByName("Dante",true),{Name = "The Ferryman"});
	end
	if SacredDreams then
		Utils.EditCharacter(SDMod.PlayerType.PLAYER_GUARD_B,{Name = "The Nightmare"});
	end
	if Sheriff then
		Utils.EditCharacter(Sheriff.Characters.TaintedSheriff.CHARACTER_ID,{Name = "The Ruthless"});
	end
	if SamaelMod then
		Utils.EditCharacter(SamaelMod.Lib.TaintedSamaelId,{Name = "The Inevitable"});
	end
	if TheSerpent then
		Utils.EditCharacter(TheSerpent.Player.SerpentB.ID,{Name = "The Banished"});
	end
	if XMLData.GetModById("2785553778") and XMLData.GetModById("2785553778").enabled == "true" then
		Utils.EditCharacter(Isaac.GetPlayerTypeByName("Zach",true),{Name = "The Unlucky"});
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