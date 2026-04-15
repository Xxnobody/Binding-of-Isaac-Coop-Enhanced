local mod = CoopEnhanced;
local CoopTreasure = CoopEnhanced.CoopTreasure;

local Utils = mod.Utils;
local game = Game();

local function ModCompat()
	if XMLData.GetEntryByName(XMLNode.MOD,"Angel Beggar") then
		CoopEnhanced.CoopTreasure.AngelBeggar = {Variants = {}};
		local set = RoomConfig.GetStage(StbType.SPECIAL_ROOMS):GetRoomSet(0);
		for i = 1, set.Size, 1 do
			local room_config = set:Get(i);
			if room_config and room_config.Name:sub(1,12) == "Angel Beggar" then
				table.insert(CoopEnhanced.CoopTreasure.AngelBeggar.Variants,room_config.Variant);
			end
		end
		
		local roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_ANGEL];
		local ABV = CoopEnhanced.CoopTreasure.AngelBeggar.Variants;
		
		roomConfigs[ABV[1]] = function(room,room_data) -- move P1 + 2 up
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(42);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[ABV[2]] = function(room,room_data) -- move P1 + 2 down for beggar
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[ABV[3]] = function(room,room_data) -- move P1 + 2 down for beggar
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[ABV[4]] = function(room,room_data) -- move P1 + 2 down for beggar
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[ABV[5]] = function(room,room_data) -- move P1 + 2 down for beggar
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Safe.Enable = false;
		end;
	end
	if LibraryExpanded then
		CoopEnhanced.CoopTreasure.LibraryExpanded = {Variants = {}};
		local set = RoomConfig.GetStage(StbType.SPECIAL_ROOMS):GetRoomSet(0);
		for i = 1, set.Size, 1 do
			local room_config = set:Get(i);
			if room_config and room_config.Name:sub(1,4) == "(LE)" then
				table.insert(CoopEnhanced.CoopTreasure.LibraryExpanded.Variants,room_config.Variant);
			end
		end
	
		local roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_LIBRARY];
		local LEV = CoopEnhanced.CoopTreasure.LibraryExpanded.Variants;

		roomConfigs[LEV[3]] = function(room,room_data) -- move P1 + 2, set horizontal, reduce book amount, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(21);
			room_data.Positions[2] = room:GetGridPosition(23);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
			room_data.Spawn.Vertical = false;
		end;
		roomConfigs[LEV[6]] = function(room,room_data) -- pit and button puzzle, set horizontal, reduce book amount, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(117);
			room_data.Positions[3] = room:GetGridPosition(31);
			room_data.Positions[4] = room:GetGridPosition(103);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
			room_data.Spawn.Vertical = false;
		end;
		roomConfigs[LEV[8]] = function(room,room_data) -- moving spike puzzle, set horizontal, reduce book amount, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(106);
			room_data.Positions[3] = room:GetGridPosition(27);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
			room_data.Spawn.Vertical = false;
		end;
		roomConfigs[LEV[9]] = function(room,room_data) -- pit splits sides, set vertical, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(42);
			if room_data.Spawn.Total > 2 then
				room_data.Positions[3] = room:GetGridPosition(25);
				room_data.Positions[4] = room:GetGridPosition(28);
				room_data.Spawn.Maximum = 1;
			else
				room_data.MoreOptions.Offset = Vector(0,mod.GridSize * 4);
			end
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = true;
		end;
		roomConfigs[LEV[10]] = function(room,room_data) -- shop version, ignore
			room_data = nil;
		end;
		roomConfigs[LEV[11]] = function(room,room_data) -- rocks blocking corner, set vertical, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(20);
			if room_data.Spawn.Total > 2 then
				room_data.Positions[3] = room:GetGridPosition(46);
				room_data.Positions[4] = room:GetGridPosition(50);
				room_data.Spawn.Maximum = 1;
			end
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = true;
		end;
		roomConfigs[LEV[12]] = function(room,room_data) -- disable safe pos
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[14]] = function(room,room_data) -- smaller area, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[15]] = function(room,room_data) -- move 3+4 up, disable safe pos
			room_data.Positions[3] = room:GetGridPosition(95);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[16]] = function(room,room_data) -- move behind / create keyblocks, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[2] = room:GetGridPosition(84);
			if room_data.Spawn.Total > 2 then
				room_data.Positions[3] = room:GetGridPosition(50);
				room_data.Positions[4] = room:GetGridPosition(114);
				room_data.Spawn.Maximum = 1;
			end
			room:SpawnGridEntity(21,GridEntityType.GRID_LOCK,0,1,0);
			room:SpawnGridEntity(113,GridEntityType.GRID_LOCK,0,1,0);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[17]] = function(room,room_data) -- pillars in the way, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(35);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[18]] = function(room,room_data) -- flip sides, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(110);
			room_data.Positions[2] = room:GetGridPosition(114);
			room_data.Positions[3] = room:GetGridPosition(20);
			room_data.Positions[4] = room:GetGridPosition(24);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[18]] = function(room,room_data) -- flip sides, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(110);
			room_data.Positions[2] = room:GetGridPosition(114);
			room_data.Positions[3] = room:GetGridPosition(20);
			room_data.Positions[4] = room:GetGridPosition(24);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[19]] = function(room,room_data) -- pillars/flames in the way, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(35);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(95);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[20]] = function(room,room_data) -- pillars, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(35);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(80);
			room_data.Positions[4] = room:GetGridPosition(84);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[21]] = function(room,room_data) -- smaller area, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[22]] = function(room,room_data) -- disable safe pos
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[23]] = function(room,room_data) -- reduce book amounts
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[24]] = function(room,room_data) -- reduce book amounts
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[25]] = function(room,room_data) -- reduce book amounts, set safe pos
			room_data.Safe.Mode = 1;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[27]] = function(room,room_data) -- reduce book amounts, set safe pos
			room_data.Safe.Mode = 1;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[29]] = function(room,room_data) -- reduce book amounts, disable safe pos
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[30]] = function(room,room_data) -- pillars and cards in corner
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Positions[3] = room:GetGridPosition(80);
			room_data.Positions[4] = room:GetGridPosition(84);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[31]] = function(room,room_data) -- reduce book amounts, set safe pos
			room_data.Safe.Mode = 1;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[32]] = function(room,room_data) -- pits cause overlap, reduce book amounts, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Positions[3] = room:GetGridPosition(80);
			room_data.Positions[4] = room:GetGridPosition(84);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[33]] = function(room,room_data) -- reduce book amounts, pits cause overlap, disable safe pos
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[35]] = function(room,room_data) -- reduce book amounts, pits cause overlap, disable safe pos, move donation machine
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
			local machines = Isaac.FindByType(EntityType.ENTITY_SLOT, -1, -1);
			for _,machine in pairs(machines) do machine.Position = room:GetGridPosition(22); end
		end;
		roomConfigs[LEV[36]] = function(room,room_data) -- reduce book amounts
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[37]] = function(room,room_data) -- reduce book amounts
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[38]] = function(room,room_data) -- reduce book amounts
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[42]] = function(room,room_data) -- rework room blocks, reduce book amounts, disable safe pos
			room:RemoveGridEntityImmediate(52,1,false);
			room:RemoveGridEntityImmediate(66,1,false);
			room:RemoveGridEntityImmediate(68,1,false);
			room:RemoveGridEntityImmediate(82,1,false);
			
			room:SpawnGridEntity(17,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(31,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(32,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(27,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(42,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(43,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(91,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(92,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(107,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(102,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(103,GridEntityType.GRID_ROCKB,0,1,0);
			room:SpawnGridEntity(117,GridEntityType.GRID_ROCKB,0,1,0);
			
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[44]] = function(room,room_data) -- reduce book amounts
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[45]] = function(room,room_data) -- rework room pots, reduce book amounts, disable safe pos
			room:SpawnGridEntity(17,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(31,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(32,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(27,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(42,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(43,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(91,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(92,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(107,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(102,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(103,GridEntityType.GRID_ROCK_ALT,0,1,0);
			room:SpawnGridEntity(117,GridEntityType.GRID_ROCK_ALT,0,1,0);
			
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[47]] = function(room,room_data) -- spike/block areas, reduce book amounts
			room_data.Positions[1] = room:GetGridPosition(64);
			room_data.Positions[2] = room:GetGridPosition(70);
			room_data.Positions[3] = room:GetGridPosition(62);
			room_data.Positions[4] = room:GetGridPosition(72);
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[64]] = function(room,room_data) -- pit causes overlap, reduce book amounts
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(55);
			room_data.Positions[3] = room:GetGridPosition(79);
			room_data.Positions[4] = room:GetGridPosition(86);
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[68]] = function(room,room_data) -- pit causes overlap, reduce book amounts
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(106);
			room_data.Positions[3] = room:GetGridPosition(28);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[69]] = function(room,room_data) -- pit causes overlap, reduce book amounts, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[70]] = function(room,room_data) -- no space, disable
			room_data = nil;
		end;
		roomConfigs[LEV[85]] = function(room,room_data) -- pit causes overlap
			room_data.Positions[2] = room:GetGridPosition(78);
			room_data.Positions[3] = room:GetGridPosition(56);
		end;
		roomConfigs[LEV[86]] = function(room,room_data) -- rework room blocks, reduce book amounts, disable safe pos
			room:SpawnGridEntity(73,GridEntityType.GRID_ROCK,0,1,0);
			if room_data.Spawn.Total > 2 then
				room:SpawnGridEntity(57,GridEntityType.GRID_LOCK,0,1,0);
				if room_data.Spawn.Total > 3 then room:SpawnGridEntity(87,GridEntityType.GRID_LOCK,0,1,0); end
			end
			room_data.Positions[1] = room:GetGridPosition(80);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Positions[3] = room:GetGridPosition(88);
			room_data.Positions[4] = room:GetGridPosition(58);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[96]] = function(room,room_data) -- set safe pos
			room_data.Safe.Enable = true;
			room_data.Safe.Mode = 2;
		end;
		roomConfigs[LEV[98]] = function(room,room_data) -- move restock box
			local machines = Isaac.FindByType(EntityType.ENTITY_SLOT, -1, -1);
			for _,machine in pairs(machines) do machine.Position = room:GetGridPosition(82); end
		end;
		roomConfigs[LEV[99]] = function(room,room_data) -- set safe pos
			room_data.Safe.Enable = true;
			room_data.Safe.Mode = 2;
		end;
		roomConfigs[LEV[100]] = function(room,room_data) -- set safe pos
			room_data.Safe.Enable = true;
			room_data.Safe.Mode = 2;
		end;
		roomConfigs[LEV[101]] = function(room,room_data) -- move p2 + 4 behind key block, disable safe pos
			room_data.Positions[2] = room:GetGridPosition(51);
			room_data.Positions[4] = room:GetGridPosition(81);
			room_data.Safe.Enable = false;
		end;
	end
	if CCO and CCO.ZodiacPlanetariums then
		local function PlanetariumZodiaks(room_data)
			if not room_data or game:GetRoom():GetType() ~= RoomType.ROOM_PLANETARIUM then return; end
			local item_config = Isaac.GetItemConfig();
			local rng = RNG(game:GetRoom():GetSpawnSeed());
			local zodiac_items = {};
			
			for i,item in pairs(CCO.ZodiacPlanetariums.Items) do table.insert(zodiac_items,item.ID); end
			for ii,player_items in pairs(room_data.Treasure.Items) do
				if player_items[2] then
					local pedestal_entity = player_items[2].Pointer and player_items[2].Pointer.Ref and player_items[2].Pointer.Ref:ToPickup() or nil;
					if pedestal_entity then
						player_items[2].SubType = zodiac_items[rng:RandomInt(1, #zodiac_items)];
						pedestal_entity.SubType = player_items[2].SubType;
						pedestal_entity.OptionsPickupIndex = ii;
						pedestal_entity:ReloadGraphics();
					end
				end
			end
		end
		mod.Registry:AddCallback(mod.Callbacks.TREASURE_POST_ROOM_SETUP, PlanetariumZodiaks);
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ModCompat);