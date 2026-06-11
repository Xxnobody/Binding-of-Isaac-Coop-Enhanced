local mod = CoopEnhanced;
local CoopTreasure = CoopEnhanced.CoopTreasure;

local Utils = mod.Utils;
local game = Game();

if not REPENTOGON then return; end

local function ModCompat()
	local AngelBeggar = XMLData.GetModById("1832381849") ~= nil and XMLData.GetModById("1832381849").enabled == "true";
	if AngelBeggar then
		CoopEnhanced.CoopTreasure.AngelBeggar = {Variants = {}};
		local set = RoomConfig.GetStage(StbType.SPECIAL_ROOMS):GetRoomSet(0);
		for i = 1, set.Size, 1 do
			local room_config = set:Get(i);
			if room_config and room_config.Name:sub(1,12) == "Angel Beggar" then
				table.insert(CoopEnhanced.CoopTreasure.AngelBeggar.Variants,room_config.Variant);
			end
		end
		
		local ABV = CoopEnhanced.CoopTreasure.AngelBeggar.Variants;
		local roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_ANGEL];
		
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
	if FiendFolio then
		CoopEnhanced.CoopTreasure.FiendFolio = {Angel = {},Devil = {},Library = {},Planetarium = {},Secret = {},Super = {},Treasure = {}};
		local set = RoomConfig.GetStage(StbType.SPECIAL_ROOMS):GetRoomSet(0);
		for i = 1, set.Size, 1 do
			local room_config = set:Get(i);
			if room_config and room_config.Variant > 17000 and room_config.Variant < 18000 then
				if room_config.Type == RoomType.ROOM_ANGEL then
					table.insert(CoopEnhanced.CoopTreasure.FiendFolio.Angel,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_DEVIL then
					table.insert(CoopEnhanced.CoopTreasure.FiendFolio.Devil,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_LIBRARY then
					table.insert(CoopEnhanced.CoopTreasure.FiendFolio.Library,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_PLANETARIUM then
					table.insert(CoopEnhanced.CoopTreasure.FiendFolio.Planetarium,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_SECRET then
					table.insert(CoopEnhanced.CoopTreasure.FiendFolio.Secret,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_SUPERSECRET then
					table.insert(CoopEnhanced.CoopTreasure.FiendFolio.Super,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_TREASURE then
					table.insert(CoopEnhanced.CoopTreasure.FiendFolio.Treasure,room_config.Variant);
				end
			end
		end

		local FFV = CoopEnhanced.CoopTreasure.FiendFolio;

		-- Angel Rooms
		local roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_ANGEL];
		roomConfigs[FFV.Angel[7]] = function(room,room_data) -- pits, change second ped offset, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.MoreOptions.Offset = Vector(mod.GridSize,mod.GridSize);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Angel[8]] = function(room,room_data) -- pits, change second ped offset, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.MoreOptions.Offset = Vector(mod.GridSize,mod.GridSize);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Angel[9]] = function(room,room_data) -- pits, change second ped offset, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.MoreOptions.Offset = Vector(mod.GridSize,mod.GridSize * -1);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Angel[15]] = function(room,room_data) -- change positions, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(19);
			room_data.Positions[2] = room:GetGridPosition(25);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.Safe.Enable = false;
		end;

		-- Devil Rooms
		roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_DEVIL];
		roomConfigs[FFV.Devil[1]] = function(room,room_data) -- move for the shop look, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(37);
			room_data.Positions[2] = room:GetGridPosition(42);
			room_data.Positions[3] = room:GetGridPosition(97);
			room_data.Positions[4] = room:GetGridPosition(102);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Devil[4]] = function(room,room_data) -- move out of the way of statues
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[4] = room:GetGridPosition(82);
		end;
		roomConfigs[FFV.Devil[5]] = function(room,room_data) -- move to corners, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Devil[8]] = function(room,room_data) -- move to allow access for everyone, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(81);
			room_data.Positions[2] = room:GetGridPosition(48);
			room_data.Positions[3] = room:GetGridPosition(56);
			room_data.Positions[4] = room:GetGridPosition(113);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Devil[9]] = function(room,room_data) -- move top players due to pillars
			room_data.Positions[1] = room:GetGridPosition(18);
			room_data.Positions[2] = room:GetGridPosition(26);
		end;
		roomConfigs[FFV.Devil[10]] = function(room,room_data) -- move all players due to pillars, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(31);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(91);
			room_data.Positions[4] = room:GetGridPosition(103);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Devil[12]] = function(room,room_data) -- reposition all players due to pits, block P2 off in the corner, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(19);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Devil[13]] = function(room,room_data) -- disable safe spawn, change second ped offset, move starting positions
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.MoreOptions.Offset = Vector((mod.GridSize * -1),mod.GridSize);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Devil[14]] = function(room,room_data) -- disable safe spawn, change second ped offset, move starting positions, move chests
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			Isaac.FindByType(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_REDCHEST)[1].Position = room:GetGridPosition(63);
			Isaac.FindByType(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_REDCHEST)[2].Position = room:GetGridPosition(71);
			room_data.MoreOptions.Offset = Vector((mod.GridSize * -1),mod.GridSize);
			room_data.Safe.Enable = false;
		end;

		-- Library Rooms
		roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_LIBRARY];
		roomConfigs[FFV.Library[5]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(40);
			room_data.Positions[3] = room:GetGridPosition(94);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[6]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(82);
			room_data.Positions[2] = room:GetGridPosition(49);
			room_data.Positions[3] = room:GetGridPosition(55);
			room_data.Positions[4] = room:GetGridPosition(37);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[7]] = function(room,room_data) -- move for cards/rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(40);
			room_data.Positions[3] = room:GetGridPosition(94);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[8]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[9]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(67);
			room_data.Positions[2] = room:GetGridPosition(65);
			room_data.Positions[3] = room:GetGridPosition(69);
			room_data.Positions[4] = room:GetGridPosition(37);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[11]] = function(room,room_data) -- move for blocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(66);
			room_data.Positions[2] = room:GetGridPosition(68);
			room_data.Positions[3] = room:GetGridPosition(95);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[12]] = function(room,room_data) -- move for rocks/pits, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(109);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[13]] = function(room,room_data) -- move to corner, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(107);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[16]] = function(room,room_data) -- add ignore center, move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(18);
			room_data.Positions[2] = room:GetGridPosition(26);
			room_data.Positions[3] = room:GetGridPosition(108);
			room_data.Positions[4] = room:GetGridPosition(116);
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(67));
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[17]] = function(room,room_data) -- move for pit, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(19);
			room_data.Positions[3] = room:GetGridPosition(92);
			room_data.Positions[4] = room:GetGridPosition(109);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[18]] = function(room,room_data) -- move for pit, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(47);
			room_data.Positions[2] = room:GetGridPosition(57);
			room_data.Positions[3] = room:GetGridPosition(77);
			room_data.Positions[4] = room:GetGridPosition(87);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[21]] = function(room,room_data) -- add ignore center, move for pit, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(78);
			room_data.Positions[2] = room:GetGridPosition(86);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(67));
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[22]] = function(room,room_data) -- move for pit, move chests, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(40);
			room_data.Positions[3] = room:GetGridPosition(94);
			room_data.Positions[4] = room:GetGridPosition(100);
			Isaac.FindByType(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_SPIKEDCHEST)[1].Position = room:GetGridPosition(66);
			Isaac.FindByType(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_SPIKEDCHEST)[2].Position = room:GetGridPosition(68);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[23]] = function(room,room_data) -- add ignore center, move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(40);
			room_data.Positions[3] = room:GetGridPosition(92);
			room_data.Positions[4] = room:GetGridPosition(100);
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(66));
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[24]] = function(room,room_data) -- move for rocks/spikes, disable safe spawn, disable grid clear
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(21);
			room_data.Positions[3] = room:GetGridPosition(23);
			room_data.Positions[4] = room:GetGridPosition(27);
			room_data.Safe.Enable = false;
			room_data.Spawn.Radius = 0;
		end;
		roomConfigs[FFV.Library[25]] = function(room,room_data) -- add ignore center, move for pit, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(18);
			room_data.Positions[2] = room:GetGridPosition(26);
			room_data.Positions[3] = room:GetGridPosition(108);
			room_data.Positions[4] = room:GetGridPosition(116);
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(67));
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[30]] = function(room,room_data) -- add ignore, move for rocks, disable safe spawn, disable grid clear
			room_data.Positions[1] = room:GetGridPosition(35);
			room_data.Positions[2] = room:GetGridPosition(41);
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(37));
			room_data.Safe.Enable = false;
			room_data.Spawn.Radius = 0;
		end;
		roomConfigs[FFV.Library[34]] = function(room,room_data) -- move for rocks/blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(36);
			room_data.Positions[2] = room:GetGridPosition(38);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[35]] = function(room,room_data) -- move for rocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(46);
			room_data.Positions[3] = room:GetGridPosition(76);
			room_data.Positions[4] = room:GetGridPosition(106);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[38]] = function(room,room_data) -- move for rocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(19);
			room_data.Positions[2] = room:GetGridPosition(21);
			room_data.Positions[3] = room:GetGridPosition(23);
			room_data.Positions[4] = room:GetGridPosition(25);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[42]] = function(room,room_data) -- add ignore, move for rocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(31);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(22));
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[44]] = function(room,room_data) -- move for cards, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(26);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(116);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[45]] = function(room,room_data) -- add ignore, move for rocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(39);
			room_data.Positions[2] = room:GetGridPosition(57);
			room_data.Positions[3] = room:GetGridPosition(99);
			room_data.Positions[4] = room:GetGridPosition(87);
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(64));
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[46]] = function(room,room_data) -- move for pits, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(35);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(95);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[46]] = function(room,room_data) -- move for rocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(49);
			room_data.Positions[2] = room:GetGridPosition(55);
			room_data.Positions[3] = room:GetGridPosition(109);
			room_data.Positions[4] = room:GetGridPosition(115);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[51]] = function(room,room_data) -- move for event, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Positions[3] = room:GetGridPosition(107);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[52]] = function(room,room_data) -- move for pits/rocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(24);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(114);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[53]] = function(room,room_data) -- move for blocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(28);
			room_data.Positions[2] = room:GetGridPosition(42);
			room_data.Positions[3] = room:GetGridPosition(91);
			room_data.Positions[4] = room:GetGridPosition(107);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[54]] = function(room,room_data) -- add ignore, move for blocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(19);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(109);
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(67));
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[55]] = function(room,room_data) -- add ignore, disable spawning, disable safe spawn
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(49));
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(85));
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Library[57]] = function(room,room_data) -- add ignore, move for rocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(20);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(111);
			table.insert(room_data.Treasure.Ignored,room:GetGridPosition(27));
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[60]] = function(room,room_data) -- move for spikes, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[61]] = function(room,room_data) -- move for machines, disable safe spawn, small grid clear
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(108);
			room_data.Positions[4] = room:GetGridPosition(116);
			room_data.Safe.Enable = false;
			room_data.Spawn.Radius = 0.5;
		end;
		roomConfigs[FFV.Library[74]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(31);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(79);
			room_data.Positions[4] = room:GetGridPosition(85);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Library[82]] = function(room,room_data) -- move for blocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(25);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(114);
			room_data.Positions[4] = room:GetGridPosition(116);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Library[83]] = function(room,room_data) -- move for blocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(31);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(102);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;

		-- Planetarium Rooms
		roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_PLANETARIUM];
		roomConfigs[FFV.Planetarium[6]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(57);
			room_data.Positions[3] = room:GetGridPosition(77);
			room_data.Positions[4] = room:GetGridPosition(98);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[7]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(36);
			room_data.Positions[2] = room:GetGridPosition(83);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[8]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(23);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(101);
			room_data.Positions[4] = room:GetGridPosition(115);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[9]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Planetarium[11]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(83);
			room_data.Positions[3] = room:GetGridPosition(16);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[12]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Planetarium[13]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(107);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[21]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(57);
			room_data.Positions[3] = room:GetGridPosition(65);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[26]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(83);
			room_data.Positions[3] = room:GetGridPosition(77);
			room_data.Positions[4] = room:GetGridPosition(87);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[27]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(34);
			room_data.Positions[3] = room:GetGridPosition(73);
			room_data.Positions[4] = room:GetGridPosition(64);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[28]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(76);
			room_data.Positions[2] = room:GetGridPosition(67);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(96);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[31]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(84);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[37]] = function(room,room_data) -- move for pits, set vertical, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(21);
			room_data.Positions[2] = room:GetGridPosition(23);
			room_data.Positions[3] = room:GetGridPosition(111);
			room_data.Positions[4] = room:GetGridPosition(113);
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = true;
		end;
		roomConfigs[FFV.Planetarium[49]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(66);
			room_data.Positions[2] = room:GetGridPosition(26);
			room_data.Positions[3] = room:GetGridPosition(108);
			room_data.Positions[4] = room:GetGridPosition(79);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[56]] = function(room,room_data) -- move for chests, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(36);
			room_data.Positions[2] = room:GetGridPosition(98);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[58]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(41);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Positions[3] = room:GetGridPosition(86);
			room_data.Positions[4] = room:GetGridPosition(103);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[67]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(47);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Positions[3] = room:GetGridPosition(77);
			room_data.Positions[4] = room:GetGridPosition(87);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[68]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Planetarium[70]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(46);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Positions[3] = room:GetGridPosition(76);
			room_data.Positions[4] = room:GetGridPosition(88);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[71]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(19);
			room_data.Positions[2] = room:GetGridPosition(25);
			room_data.Positions[3] = room:GetGridPosition(109);
			room_data.Positions[4] = room:GetGridPosition(115);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[72]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(63);
			room_data.Positions[2] = room:GetGridPosition(72);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[73]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(107);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[74]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(25);
			room_data.Positions[3] = room:GetGridPosition(109);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[76]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Planetarium[79]] = function(room,room_data) -- move for fires
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
		end;
		roomConfigs[FFV.Planetarium[81]] = function(room,room_data) -- move for pits
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(91);
		end;
		roomConfigs[FFV.Planetarium[84]] = function(room,room_data) -- move for fires/pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[89]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(107);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[91]] = function(room,room_data) -- move for beggar, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[93]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(46);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[99]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Planetarium[103]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Planetarium[105]] = function(room,room_data) -- move for fires, change second ped offset, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(21);
			room_data.Positions[2] = room:GetGridPosition(23);
			room_data.Positions[3] = room:GetGridPosition(96);
			room_data.Positions[4] = room:GetGridPosition(98);
			room_data.MoreOptions.Offset = Vector((mod.GridSize * -1),mod.GridSize);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[110]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Planetarium[111]] = function(room,room_data) -- move for pits, change second ped offset, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(94);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.MoreOptions.Offset = Vector((mod.GridSize * -1),mod.GridSize);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Planetarium[112]] = function(room,room_data) -- move for beggar
			Isaac.FindByType(EntityType.ENTITY_SLOT,FiendFolio.FF.ZodiacBeggar.Var)[1].Position = room:GetGridPosition(52);
		end;

		-- Treasure Rooms
		roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_TREASURE];
		roomConfigs[FFV.Treasure[43]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[48]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(49);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(116);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[49]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(19);
			room_data.Positions[2] = room:GetGridPosition(25);
			room_data.Positions[3] = room:GetGridPosition(109);
			room_data.Positions[4] = room:GetGridPosition(115);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[54]] = function(room,room_data) -- move for pits/rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(80);
			room_data.Positions[2] = room:GetGridPosition(84);
			room_data.Positions[3] = room:GetGridPosition(110);
			room_data.Positions[4] = room:GetGridPosition(114);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[55]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(72);
			room_data.Positions[3] = room:GetGridPosition(92);
			room_data.Positions[4] = room:GetGridPosition(116);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[56]] = function(room,room_data) -- move for pits, total 2 players, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(63);
			room_data.Positions[2] = room:GetGridPosition(71);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
			room_data.Spawn.Total = 2;
		end;
		roomConfigs[FFV.Treasure[57]] = function(room,room_data) -- move for pits, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(25);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[58]] = function(room,room_data) -- remove rock
			room:DestroyGrid(63,true);
		end;
		roomConfigs[FFV.Treasure[60]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[62]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(102);
			room_data.Positions[3] = room:GetGridPosition(37);
			room_data.Positions[4] = room:GetGridPosition(97);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[67]] = function(room,room_data) -- disable safe spawn
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[62]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(40);
			room_data.Positions[3] = room:GetGridPosition(94);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[69]] = function(room,room_data) -- move for rocks, remove blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(21);
			room_data.Positions[2] = room:GetGridPosition(23);
			room_data.Positions[3] = room:GetGridPosition(51);
			room_data.Positions[4] = room:GetGridPosition(53);
			room:RemoveGridEntity(21,0);
			room:RemoveGridEntity(23,0);
			room:Update();
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[70]] = function(room,room_data) -- move for rocks, remove blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(31);
			room_data.Positions[2] = room:GetGridPosition(33);
			room_data.Positions[3] = room:GetGridPosition(91);
			room_data.Positions[4] = room:GetGridPosition(93);
			room:RemoveGridEntity(33,0);
			room:RemoveGridEntity(93,0);
			room:Update();
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[71]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(62);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(107);
			room_data.Positions[4] = room:GetGridPosition(72);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[72]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(56);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Positions[3] = room:GetGridPosition(86);
			room_data.Positions[4] = room:GetGridPosition(88);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[80]] = function(room,room_data) -- remove blocks, disable safe spawn
			room:RemoveGridEntity(40,0);
			room:RemoveGridEntity(41,0);
			room:RemoveGridEntity(42,0);
			room:RemoveGridEntity(55,0);
			room:RemoveGridEntity(57,0);
			room:RemoveGridEntity(70,0);
			room:RemoveGridEntity(71,0);
			room:RemoveGridEntity(72,0);
			room:Update();
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[81]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[83]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(41);
			room_data.Positions[2] = room:GetGridPosition(57);
			room_data.Positions[3] = room:GetGridPosition(87);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[85]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[2] = room:GetGridPosition(36);
			room_data.Positions[4] = room:GetGridPosition(96);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[86]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(25);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(55);
			room_data.Positions[4] = room:GetGridPosition(57);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[89]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(18);
			room_data.Positions[3] = room:GetGridPosition(31);
			room_data.Positions[4] = room:GetGridPosition(33);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[90]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(96);
			room_data.Positions[2] = room:GetGridPosition(98);
			room_data.Positions[3] = room:GetGridPosition(111);
			room_data.Positions[4] = room:GetGridPosition(113);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[94]] = function(room,room_data) -- don't move restock
			room_data.Spawn.Restock = false;
		end;
		roomConfigs[FFV.Treasure[105]] = function(room,room_data) -- move for blocks, reduce maximum, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(19);
			room_data.Positions[3] = room:GetGridPosition(25);
			room_data.Positions[4] = room:GetGridPosition(28);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
			room_data.Spawn.Restock = false;
		end;
		roomConfigs[FFV.Treasure[111]] = function(room,room_data) -- move for blocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(19);
			room_data.Positions[3] = room:GetGridPosition(25);
			room_data.Positions[4] = room:GetGridPosition(27);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[115]] = function(room,room_data) -- reduce maximum, disable safe spawn
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[116]] = function(room,room_data) -- move for pits, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(26);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Positions[3] = room:GetGridPosition(88);
			room_data.Positions[4] = room:GetGridPosition(116);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[117]] = function(room,room_data) -- move for pits, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(46);
			room_data.Positions[2] = room:GetGridPosition(49);
			room_data.Positions[3] = room:GetGridPosition(55);
			room_data.Positions[4] = room:GetGridPosition(58);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[122]] = function(room,room_data) -- move for pits
			room_data.Positions[3] = room:GetGridPosition(50);
			room_data.Positions[4] = room:GetGridPosition(69);
		end;
		roomConfigs[FFV.Treasure[127]] = function(room,room_data) -- move for pits, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[2] = room:GetGridPosition(36);
			room_data.Positions[3] = room:GetGridPosition(38);
			room_data.Positions[4] = room:GetGridPosition(24);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[129]] = function(room,room_data) -- reduce maximum
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[133]] = function(room,room_data) -- move for pits, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(55);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Positions[3] = room:GetGridPosition(85);
			room_data.Positions[4] = room:GetGridPosition(88);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[139]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[2] = room:GetGridPosition(57);
			room_data.Positions[3] = room:GetGridPosition(77);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[141]] = function(room,room_data) -- reduce maximum
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[144]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(65);
			room_data.Positions[2] = room:GetGridPosition(69);
			room_data.Positions[3] = room:GetGridPosition(110);
			room_data.Positions[4] = room:GetGridPosition(114);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[145]] = function(room,room_data) -- move for pits, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(64);
			room_data.Positions[2] = room:GetGridPosition(70);
			room_data.Positions[3] = room:GetGridPosition(66);
			room_data.Positions[4] = room:GetGridPosition(68);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[145]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[2] = room:GetGridPosition(24);
			room_data.Positions[3] = room:GetGridPosition(110);
			room_data.Positions[4] = room:GetGridPosition(114);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[151]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[154]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[156]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(55);
			room_data.Positions[3] = room:GetGridPosition(95);
			room_data.Positions[4] = room:GetGridPosition(98);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[158]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(95);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[161]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(63);
			room_data.Positions[2] = room:GetGridPosition(66);
			room_data.Positions[3] = room:GetGridPosition(68);
			room_data.Positions[4] = room:GetGridPosition(71);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[165]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[166]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[170]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(23);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(111);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[175]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(40);
			room_data.Positions[2] = room:GetGridPosition(42);
			room_data.Positions[3] = room:GetGridPosition(100);
			room_data.Positions[4] = room:GetGridPosition(102);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[182]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(77);
			room_data.Positions[2] = room:GetGridPosition(87);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(102);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[185]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[3] = room:GetGridPosition(80);
			room_data.Positions[4] = room:GetGridPosition(84);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[192]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(40);
			room_data.Positions[2] = room:GetGridPosition(42);
			room_data.Positions[3] = room:GetGridPosition(100);
			room_data.Positions[4] = room:GetGridPosition(102);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[195]] = function(room,room_data) -- move for rocks/pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(26);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(56);
			room_data.Positions[4] = room:GetGridPosition(58);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[196]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(42);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(102);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[198]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(27);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(32);
			room_data.Positions[4] = room:GetGridPosition(102);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[199]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(93);
			room_data.Positions[2] = room:GetGridPosition(95);
			room_data.Positions[3] = room:GetGridPosition(99);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[200]] = function(room,room_data) -- move for pits, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(38);
			room_data.Positions[2] = room:GetGridPosition(42);
			room_data.Positions[3] = room:GetGridPosition(98);
			room_data.Positions[4] = room:GetGridPosition(102);
			room_data.Safe.Enable = false;
			room_data.Spawn.Restock = false;
		end;
		roomConfigs[FFV.Treasure[201]] = function(room,room_data) -- move for blocks, reduce maximum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(27);
			room_data.Positions[2] = room:GetGridPosition(91);
			room_data.Positions[3] = room:GetGridPosition(43);
			room_data.Positions[4] = room:GetGridPosition(107);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[FFV.Treasure[202]] = function(room,room_data) -- don't move restock
			room_data.Spawn.Restock = false;
		end;
		roomConfigs[FFV.Treasure[203]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[206]] = function(room,room_data) -- move for pits/rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Positions[3] = room:GetGridPosition(66);
			room_data.Positions[4] = room:GetGridPosition(114);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[209]] = function(room,room_data) -- don't move restock
			room_data.Spawn.Restock = false;
		end;
		roomConfigs[FFV.Treasure[210]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(36);
			room_data.Positions[2] = room:GetGridPosition(38);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[212]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[213]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Positions[3] = room:GetGridPosition(80);
			room_data.Positions[4] = room:GetGridPosition(84);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[214]] = function(room,room_data) -- move for blocks, edit extra blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(115);
			room_data.Positions[2] = room:GetGridPosition(116);
			room_data.Positions[3] = room:GetGridPosition(117);
			room_data.Positions[4] = room:GetGridPosition(118);
			room:RemoveGridEntity(117,0);
			FiendFolio.ChainBlockGrid.Blue:Spawn(99,true);
			FiendFolio.ChainBlockGrid.Blue:Spawn(100,true);
			FiendFolio.ChainBlockGrid.Blue:Spawn(101,true);
			FiendFolio.ChainBlockGrid.Blue:Spawn(114,true);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[216]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(23);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(113);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[217]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(76);
			room_data.Positions[2] = room:GetGridPosition(78);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(108);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[224]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(35);
			room_data.Positions[3] = room:GetGridPosition(92);
			room_data.Positions[4] = room:GetGridPosition(95);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[225]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[226]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(19);
			room_data.Positions[3] = room:GetGridPosition(32);
			room_data.Positions[4] = room:GetGridPosition(34);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[229]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(26);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(116);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[230]] = function(room,room_data) -- move for blocks, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(39);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(99);
			room_data.Positions[4] = room:GetGridPosition(103);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[231]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(47);
			room_data.Positions[2] = room:GetGridPosition(77);
			room_data.Positions[3] = room:GetGridPosition(49);
			room_data.Positions[4] = room:GetGridPosition(79);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[235]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(46);
			room_data.Positions[2] = room:GetGridPosition(47);
			room_data.Positions[3] = room:GetGridPosition(76);
			room_data.Positions[4] = room:GetGridPosition(77);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[236]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(92);
			room_data.Positions[2] = room:GetGridPosition(94);
			room_data.Positions[3] = room:GetGridPosition(107);
			room_data.Positions[4] = room:GetGridPosition(109);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[237]] = function(room,room_data) -- move for blocks, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(46);
			room_data.Positions[3] = room:GetGridPosition(76);
			room_data.Positions[4] = room:GetGridPosition(106);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[246]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(95);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[247]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[2] = room:GetGridPosition(38);
			room_data.Positions[4] = room:GetGridPosition(98);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[249]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(25);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(115);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[250]] = function(room,room_data) -- move for rocks, reduce maximum, disable safe spawn
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.Spawn.Maximum = 1;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[290]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[291]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[293]] = function(room,room_data) -- move for blocks/rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[294]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(21);
			room_data.Positions[2] = room:GetGridPosition(23);
			room_data.Positions[3] = room:GetGridPosition(51);
			room_data.Positions[4] = room:GetGridPosition(53);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[295]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(81);
			room_data.Positions[2] = room:GetGridPosition(83);
			room_data.Positions[3] = room:GetGridPosition(111);
			room_data.Positions[4] = room:GetGridPosition(113);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[296]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(40);
			room_data.Positions[3] = room:GetGridPosition(94);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[297]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(40);
			room_data.Positions[3] = room:GetGridPosition(94);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[298]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(37);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Positions[3] = room:GetGridPosition(63);
			room_data.Positions[4] = room:GetGridPosition(94);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[299]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(36);
			room_data.Positions[3] = room:GetGridPosition(62);
			room_data.Positions[4] = room:GetGridPosition(66);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[300]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(36);
			room_data.Positions[2] = room:GetGridPosition(52);
			room_data.Positions[3] = room:GetGridPosition(84);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[301]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(31);
			room_data.Positions[2] = room:GetGridPosition(50);
			room_data.Positions[3] = room:GetGridPosition(82);
			room_data.Positions[4] = room:GetGridPosition(113);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[302]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[303]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(108);
			room_data.Positions[2] = room:GetGridPosition(110);
			room_data.Positions[3] = room:GetGridPosition(164);
			room_data.Positions[4] = room:GetGridPosition(166);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[304]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(53);
			room_data.Positions[2] = room:GetGridPosition(55);
			room_data.Positions[3] = room:GetGridPosition(83);
			room_data.Positions[4] = room:GetGridPosition(85);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[305]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(49);
			room_data.Positions[2] = room:GetGridPosition(51);
			room_data.Positions[3] = room:GetGridPosition(79);
			room_data.Positions[4] = room:GetGridPosition(81);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[306]] = function(room,room_data) -- move for blocks/pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[307]] = function(room,room_data) -- move for blocks/pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[308]] = function(room,room_data) -- move for blocks/pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[309]] = function(room,room_data) -- move for blocks/pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[310]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[311]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(35);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(95);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[312]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(56);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Positions[3] = room:GetGridPosition(86);
			room_data.Positions[4] = room:GetGridPosition(88);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[321]] = function(room,room_data) -- move for shop
			room_data.Positions[2] = room:GetGridPosition(40);
		end;
		roomConfigs[FFV.Treasure[322]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[325]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(52);
			room_data.Positions[3] = room:GetGridPosition(82);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[326]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[327]] = function(room,room_data) -- remove block
			room:RemoveGridEntity(38,0);
		end;
		roomConfigs[FFV.Treasure[332]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(86);
			room_data.Positions[2] = room:GetGridPosition(88);
			room_data.Positions[3] = room:GetGridPosition(116);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[336]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(36);
			room_data.Positions[3] = room:GetGridPosition(96);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[340]] = function(room,room_data) -- disable safe spawn
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[342]] = function(room,room_data) -- move for pits, set vertical, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[2] = room:GetGridPosition(110);
			room_data.Positions[3] = room:GetGridPosition(24);
			room_data.Positions[4] = room:GetGridPosition(114);
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = true;
		end;
		roomConfigs[FFV.Treasure[345]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(61);
			room_data.Positions[2] = room:GetGridPosition(63);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(108);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[346]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(56);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Positions[3] = room:GetGridPosition(86);
			room_data.Positions[4] = room:GetGridPosition(88);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[352]] = function(room,room_data) -- move for blocks, change more options offset, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(19);
			room_data.Positions[3] = room:GetGridPosition(115);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.MoreOptions.Offset = Vector(0,mod.GridSize * 6);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[354]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(48);
			room_data.Positions[3] = room:GetGridPosition(66);
			room_data.Positions[4] = room:GetGridPosition(81);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[365]] = function(room,room_data) -- move for pillars, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(36);
			room_data.Positions[3] = room:GetGridPosition(96);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[366]] = function(room,room_data) -- disable safe spawn
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[374]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[376]] = function(room,room_data) -- move for rocks, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[377]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[378]] = function(room,room_data) -- disable safe spawn
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[379]] = function(room,room_data) -- move for rocks, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(40);
			room_data.Positions[3] = room:GetGridPosition(100);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[380]] = function(room,room_data) -- disabled, no space
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[FFV.Treasure[382]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[384]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(65);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(69);
			room_data.Positions[4] = room:GetGridPosition(98);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[385]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(51);
			room_data.Positions[3] = room:GetGridPosition(83);
			room_data.Positions[4] = room:GetGridPosition(84);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[390]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(18);
			room_data.Positions[2] = room:GetGridPosition(26);
			room_data.Positions[3] = room:GetGridPosition(108);
			room_data.Positions[4] = room:GetGridPosition(116);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[393]] = function(room,room_data) -- move for blocks, edit blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(18);
			room_data.Positions[3] = room:GetGridPosition(31);
			room_data.Positions[4] = room:GetGridPosition(33);
			room:RemoveGridEntity(18,0);
			room:RemoveGridEntity(33,0);
			FiendFolio.ChainBlockGrid.Red:Spawn(19,true);
			FiendFolio.ChainBlockGrid.Red:Spawn(34,true);
			FiendFolio.ChainBlockGrid.Red:Spawn(49,true);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[395]] = function(room,room_data) -- move for rocks/pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(21);
			room_data.Positions[2] = room:GetGridPosition(23);
			room_data.Positions[3] = room:GetGridPosition(51);
			room_data.Positions[4] = room:GetGridPosition(53);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[396]] = function(room,room_data) -- move for rocks/blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(27);
			room_data.Positions[3] = room:GetGridPosition(91);
			room_data.Positions[4] = room:GetGridPosition(103);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[397]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(95);
			room_data.Positions[2] = room:GetGridPosition(111);
			room_data.Positions[3] = room:GetGridPosition(113);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[399]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(31);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(41);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[401]] = function(room,room_data) -- move for blocks, set vertical, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = true;
		end;
		roomConfigs[FFV.Treasure[402]] = function(room,room_data) -- move for pills, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[403]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(53);
			room_data.Positions[2] = room:GetGridPosition(55);
			room_data.Positions[3] = room:GetGridPosition(83);
			room_data.Positions[4] = room:GetGridPosition(85);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[419]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(57);
			room_data.Positions[2] = room:GetGridPosition(58);
			room_data.Positions[3] = room:GetGridPosition(87);
			room_data.Positions[4] = room:GetGridPosition(88);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[423]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Positions[3] = room:GetGridPosition(80);
			room_data.Positions[4] = room:GetGridPosition(84);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[424]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[2] = room:GetGridPosition(24);
			room_data.Positions[3] = room:GetGridPosition(65);
			room_data.Positions[4] = room:GetGridPosition(69);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[425]] = function(room,room_data) -- move for rocks/blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(94);
			room_data.Positions[3] = room:GetGridPosition(46);
			room_data.Positions[4] = room:GetGridPosition(76);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[431]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(21);
			room_data.Positions[2] = room:GetGridPosition(23);
			room_data.Positions[3] = room:GetGridPosition(36);
			room_data.Positions[4] = room:GetGridPosition(38);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[432]] = function(room,room_data) -- don't move restock
			room_data.Spawn.Restock = false;
		end;
		roomConfigs[FFV.Treasure[433]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(52);
			room_data.Positions[2] = room:GetGridPosition(68);
			room_data.Positions[3] = room:GetGridPosition(82);
			room_data.Positions[4] = room:GetGridPosition(66);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[434]] = function(room,room_data) -- don't move restock
			room_data.Spawn.Restock = false;
		end;
		roomConfigs[FFV.Treasure[435]] = function(room,room_data) -- move for blocks, don't move restock, disable safe spawn
			room_data.Positions[2] = room:GetGridPosition(38);
			room_data.Positions[4] = room:GetGridPosition(98);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[436]] = function(room,room_data) -- move for blocks, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(93);
			room_data.Positions[2] = room:GetGridPosition(95);
			room_data.Positions[3] = room:GetGridPosition(108);
			room_data.Positions[4] = room:GetGridPosition(110);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[437]] = function(room,room_data) -- move for blocks, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[2] = room:GetGridPosition(24);
			room_data.Positions[3] = room:GetGridPosition(93);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[438]] = function(room,room_data) -- don't move restock
			room_data.Spawn.Restock = false;
		end;
		roomConfigs[FFV.Treasure[439]] = function(room,room_data) -- move for blocks, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(39);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Positions[3] = room:GetGridPosition(99);
			room_data.Positions[4] = room:GetGridPosition(101);
			room_data.Spawn.Restock = false;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[440]] = function(room,room_data) -- don't move restock
			room_data.Spawn.Restock = false;
		end;
		roomConfigs[FFV.Treasure[447]] = function(room,room_data) -- move for blocks, don't move restock, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[450]] = function(room,room_data) -- move for blocks, remove blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(110);
			room_data.Positions[2] = room:GetGridPosition(111);
			room_data.Positions[3] = room:GetGridPosition(113);
			room_data.Positions[4] = room:GetGridPosition(114);
			room:RemoveGridEntity(110,0);
			room:RemoveGridEntity(114,0);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[451]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Positions[3] = room:GetGridPosition(110);
			room_data.Positions[4] = room:GetGridPosition(86);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[453]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(18);
			room_data.Positions[2] = room:GetGridPosition(102);
			room_data.Positions[3] = room:GetGridPosition(109);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[460]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(41);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(101);
			room_data.Positions[4] = room:GetGridPosition(103);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[461]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(35);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(99);
			room_data.Positions[4] = room:GetGridPosition(95);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[463]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(20);
			room_data.Positions[2] = room:GetGridPosition(24);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[464]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(35);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(110);
			room_data.Positions[4] = room:GetGridPosition(114);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[465]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(41);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(101);
			room_data.Positions[4] = room:GetGridPosition(103);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[467]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(18);
			room_data.Positions[3] = room:GetGridPosition(31);
			room_data.Positions[4] = room:GetGridPosition(33);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[469]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(36);
			room_data.Positions[2] = room:GetGridPosition(38);
			room_data.Positions[3] = room:GetGridPosition(66);
			room_data.Positions[4] = room:GetGridPosition(68);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[471]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(51);
			room_data.Positions[2] = room:GetGridPosition(53);
			room_data.Positions[3] = room:GetGridPosition(81);
			room_data.Positions[4] = room:GetGridPosition(83);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[472]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(62);
			room_data.Positions[2] = room:GetGridPosition(64);
			room_data.Positions[3] = room:GetGridPosition(91);
			room_data.Positions[4] = room:GetGridPosition(93);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[474]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(54);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Positions[3] = room:GetGridPosition(84);
			room_data.Positions[4] = room:GetGridPosition(86);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[477]] = function(room,room_data) -- move for pits/rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(41);
			room_data.Positions[2] = room:GetGridPosition(67);
			room_data.Positions[3] = room:GetGridPosition(80);
			room_data.Positions[4] = room:GetGridPosition(108);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[482]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(39);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(99);
			room_data.Positions[4] = room:GetGridPosition(103);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[483]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(94);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[484]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(34);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(94);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[485]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(17);
			room_data.Positions[2] = room:GetGridPosition(19);
			room_data.Positions[3] = room:GetGridPosition(46);
			room_data.Positions[4] = room:GetGridPosition(50);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[489]] = function(room,room_data) -- move for pits, disable safe spawn
			room_data.Positions[2] = room:GetGridPosition(40);
			room_data.Positions[4] = room:GetGridPosition(100);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[497]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(38);
			room_data.Positions[3] = room:GetGridPosition(98);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[500]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(91);
			room_data.Positions[2] = room:GetGridPosition(93);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(108);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[511]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(24);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[512]] = function(room,room_data) -- move for blocks, disable safe spawn
			room_data.Positions[3] = room:GetGridPosition(51);
			room_data.Positions[4] = room:GetGridPosition(98);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[FFV.Treasure[536]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[4] = room:GetGridPosition(86);
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
	
		local LEV = CoopEnhanced.CoopTreasure.LibraryExpanded.Variants;
		local roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_LIBRARY];

		roomConfigs[LEV[2]] = function(room,room_data) -- move P2 + 4, disable safe pos
			room_data.Positions[2] = room:GetGridPosition(24);
			room_data.Positions[4] = room:GetGridPosition(114);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
			room_data.Spawn.Vertical = false;
		end;
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
			if room_data.Spawn.Total > 2 then
				room_data.Spawn.Maximum = 1;
			else
				room_data.MoreOptions.Offset = Vector(0,mod.GridSize * 4);
			end
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = true;
		end;
		roomConfigs[LEV[10]] = function(room,room_data) -- move for rocks, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(22);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(112);
			room_data.Safe.Enable = false;
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
		roomConfigs[LEV[18]] = function(room,room_data) -- reduce maximum, disable safe pos
			room_data.Spawn.Maximum = 1;
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[19]] = function(room,room_data) -- pillars/flames, reduce maximum, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(35);
			room_data.Positions[2] = room:GetGridPosition(39);
			room_data.Positions[3] = room:GetGridPosition(95);
			room_data.Positions[4] = room:GetGridPosition(99);
			room_data.Spawn.Maximum = 1;
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
		roomConfigs[LEV[23]] = function(room,room_data) -- move for pits, reduce maximum, disable safe pos
			room_data.Spawn.Maximum = 1;
			room_data.Positions[3] = room:GetGridPosition(80);
			room_data.Positions[4] = room:GetGridPosition(84);
		end;
		roomConfigs[LEV[24]] = function(room,room_data) -- reduce maximum, disable safe pos
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[25]] = function(room,room_data) -- reduce maximum, disable safe pos
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[27]] = function(room,room_data) -- reduce maximum, set safe pos
			room_data.Safe.Mode = 1;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[29]] = function(room,room_data) -- reduce maximum, disable safe pos
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
		roomConfigs[LEV[31]] = function(room,room_data) -- reduce maximum, set safe pos
			room_data.Safe.Mode = 1;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[32]] = function(room,room_data) -- pits cause overlap, reduce maximum, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Positions[3] = room:GetGridPosition(80);
			room_data.Positions[4] = room:GetGridPosition(84);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[33]] = function(room,room_data) -- reduce maximum, pits cause overlap, disable safe pos
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[35]] = function(room,room_data) -- reduce maximum, pits cause overlap, disable safe pos, move donation machine
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
			local machines = Isaac.FindByType(EntityType.ENTITY_SLOT, -1, -1);
			for _,machine in pairs(machines) do machine.Position = room:GetGridPosition(22); end
		end;
		roomConfigs[LEV[36]] = function(room,room_data) -- reduce maximum
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[37]] = function(room,room_data) -- reduce maximum
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[38]] = function(room,room_data) -- reduce maximum
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[39]] = function(room,room_data) -- reduce maximum, disable safe pos
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[40]] = function(room,room_data) -- reduce maximum, disable safe pos
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[42]] = function(room,room_data) -- rework room blocks, reduce maximum, disable safe pos
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
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[44]] = function(room,room_data) -- reduce maximum
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[45]] = function(room,room_data) -- rework room pots, reduce maximum, disable safe pos
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
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[47]] = function(room,room_data) -- spike/block areas, reduce maximum, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(64);
			room_data.Positions[2] = room:GetGridPosition(70);
			room_data.Positions[3] = room:GetGridPosition(62);
			room_data.Positions[4] = room:GetGridPosition(72);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[64]] = function(room,room_data) -- pit causes overlap, reduce maximum
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(55);
			room_data.Positions[3] = room:GetGridPosition(79);
			room_data.Positions[4] = room:GetGridPosition(86);
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[68]] = function(room,room_data) -- pit causes overlap, reduce maximum
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(106);
			room_data.Positions[3] = room:GetGridPosition(28);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[69]] = function(room,room_data) -- pit causes overlap, reduce maximum, disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[LEV[70]] = function(room,room_data) -- no space, disable
			room_data.Spawn.Maximum = 0;
		end;
		roomConfigs[LEV[76]] = function(room,room_data) -- disable safe pos
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[77]] = function(room,room_data) -- disable safe pos
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[78]] = function(room,room_data) -- disable safe pos
			room_data.Safe.Enable = false;
		end;
		roomConfigs[LEV[85]] = function(room,room_data) -- pit causes overlap
			room_data.Positions[2] = room:GetGridPosition(78);
			room_data.Positions[3] = room:GetGridPosition(56);
		end;
		roomConfigs[LEV[86]] = function(room,room_data) -- rework room blocks, reduce maximum, disable safe pos
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
	if RepentancePlusMod then
		CoopEnhanced.CoopTreasure.RepentancePlusMod = {Angel = {},Devil = {},Library = {},Planetarium = {},Secret = {},Super = {},Ultra = {},Treasure = {}};
		local set = RoomConfig.GetStage(StbType.SPECIAL_ROOMS):GetRoomSet(0);
		for i = 1, set.Size, 1 do
			local room_config = set:Get(i);
			if room_config and room_config.Name:sub(1,7) == "[Rep+] " then
				if room_config.Type == RoomType.ROOM_ANGEL then
					table.insert(CoopEnhanced.CoopTreasure.RepentancePlusMod.Angel,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_DEVIL then
					table.insert(CoopEnhanced.CoopTreasure.RepentancePlusMod.Devil,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_LIBRARY then
					table.insert(CoopEnhanced.CoopTreasure.RepentancePlusMod.Library,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_PLANETARIUM then
					table.insert(CoopEnhanced.CoopTreasure.RepentancePlusMod.Planetarium,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_SECRET then
					table.insert(CoopEnhanced.CoopTreasure.RepentancePlusMod.Secret,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_SUPERSECRET then
					table.insert(CoopEnhanced.CoopTreasure.RepentancePlusMod.Super,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_ULTRASECRET then
					table.insert(CoopEnhanced.CoopTreasure.RepentancePlusMod.Ultra,room_config.Variant);
				elseif room_config.Type == RoomType.ROOM_TREASURE then
					table.insert(CoopEnhanced.CoopTreasure.RepentancePlusMod.Treasure,room_config.Variant);
				end
			end
		end
		
		local RPV = CoopEnhanced.CoopTreasure.RepentancePlusMod;
		
		local roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_DEVIL];
		roomConfigs[RPV.Devil[5]] = function(room,room_data) -- move for fire, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(65);
			room_data.Positions[2] = room:GetGridPosition(69);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[RPV.Devil[6]] = function(room,room_data) -- move for fire, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(63);
			room_data.Positions[2] = room:GetGridPosition(71);
			room_data.Safe.Enable = false;
		end;
		
		roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_LIBRARY];
		roomConfigs[RPV.Library[3]] = function(room,room_data) -- move for blocks, reduce maxiumum, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(18);
			room_data.Positions[2] = room:GetGridPosition(26);
			room_data.Positions[3] = room:GetGridPosition(108);
			room_data.Positions[4] = room:GetGridPosition(116);
			room_data.Safe.Enable = false;
			room_data.Spawn.Maximum = 1;
		end;
		roomConfigs[RPV.Library[6]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(19);
			room_data.Positions[3] = room:GetGridPosition(109);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[RPV.Library[7]] = function(room,room_data) -- move for rocks, disable safe spawn
			room_data.Positions[1] = room:GetGridPosition(19);
			room_data.Positions[3] = room:GetGridPosition(109);
			room_data.Safe.Enable = false;
		end;
		
		roomConfigs = mod.CoopTreasure.RoomConfigs[RoomType.ROOM_PLANETARIUM];
		roomConfigs[RPV.Planetarium[1]] = function(room,room_data) -- move beggar, disable safe spawn
			Isaac.FindByType(EntityType.ENTITY_SLOT)[1].Position = room:GetGridPosition(67);
			room_data.Safe.Enable = false;
		end;
		roomConfigs[RPV.Planetarium[2]] = function(room,room_data) -- move beggar, disable safe spawn
			Isaac.FindByType(EntityType.ENTITY_SLOT)[1].Position = room:GetGridPosition(52);
			room_data.Safe.Enable = false;
		end;
		
	end
	if CCO and CCO.ZodiacPlanetariums then
		mod.CoopTreasure.ZodiacPlanetariums = {};
		for i,item in pairs(CCO.ZodiacPlanetariums.Items) do table.insert(mod.CoopTreasure.ZodiacPlanetariums,item.ID); end
		local function PlanetariumZodiaks(room_data)
			if not room_data or game:GetRoom():GetType() ~= RoomType.ROOM_PLANETARIUM then return; end
			local rng = RNG(game:GetRoom():GetSpawnSeed());
			local item_pool = game:GetItemPool();
			local room_seed = math.max(1,game:GetRoom():GetSpawnSeed());
			local room_pool = REPENTOGON and game:GetRoom():GetItemPool(room_seed) or item_pool:GetPoolForRoom(room_type, room_seed);
			for ii,player_items in pairs(room_data.Treasure.Items) do
				if player_items[2] then
					local pedestal_entity = player_items[2].Pointer and player_items[2].Pointer.Ref and player_items[2].Pointer.Ref:ToPickup() or nil;
					if pedestal_entity then
						local extra_type = 0;
						if #mod.CoopTreasure.ZodiacPlanetariums > 0 then
							local zodiac_index = rng:RandomInt(1, #mod.CoopTreasure.ZodiacPlanetariums);
							extra_type = mod.CoopTreasure.ZodiacPlanetariums[zodiac_index];
							table.remove(mod.CoopTreasure.ZodiacPlanetariums,zodiac_index);
							item_pool:RemoveCollectible(extra_type);
						else
							extra_type = item_pool:GetCollectible(room_pool, true, room_seed);
						end
						pedestal_entity.SubType = extra_type;
						player_items[2].SubType = extra_type;
						pedestal_entity.OptionsPickupIndex = ii;
						pedestal_entity:ReloadGraphics();
					end
				end
			end
			local remove_pedestals = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1);
			for i,pedestal in pairs(remove_pedestals) do
				local index,_ = CoopTreasure.GetPedestalIndex(pedestal);
				if index == 0 then pedestal:Remove(); end
			end
		end
		mod.Registry:AddCallback(mod.Callbacks.TREASURE_POST_ROOM_SETUP, PlanetariumZodiaks);
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ModCompat);