local mod = CoopEnhanced;
local CoopTreasure = CoopEnhanced.CoopTreasure;

CoopTreasure.RoomConfigs = {
	[RoomType.ROOM_TREASURE] = {
		[2] = function(room,room_data) -- pits split the room
			if room_data.Config.StageID == mod.StageTypes["Mausoleum"] or room_data.Config.StageID == mod.StageTypes["Gehenna"] then
				room_data.Positions[1] = room:GetGridPosition(31);
				room_data.Positions[2] = room:GetGridPosition(28);
				room_data.Positions[3] = room:GetGridPosition(106);
				room_data.Positions[4] = room:GetGridPosition(103);
			end
		end,
		[4] = function(room,room_data) -- rocks/blocks on north/south walls
			if room_data.Config.StageID == mod.StageTypes["Mausoleum"] or room_data.Config.StageID == mod.StageTypes["Gehenna"] then
				room_data.Positions[1] = room:GetGridPosition(33);
				room_data.Positions[2] = room:GetGridPosition(41);
				room_data.Positions[3] = room:GetGridPosition(93);
				room_data.Positions[4] = room:GetGridPosition(101);
			end
		end,
		[5] = function(room,room_data) -- special button puzzle
			if room_data.Config.StageID == mod.StageTypes["Mines"] then
				room_data.Positions[1] = room:GetGridPosition(64);
				room_data.Positions[2] = room:GetGridPosition(70);
				room_data.Positions[3] = room:GetGridPosition(109);
				room_data.Positions[4] = room:GetGridPosition(115);
			elseif room_data.Config.StageID == mod.StageTypes["Ashpit"] then
				room_data.Positions[1] = room:GetGridPosition(51);
				room_data.Positions[2] = room:GetGridPosition(53);
				room_data.Positions[3] = room:GetGridPosition(91);
				room_data.Positions[4] = room:GetGridPosition(103);
			end
			room_data.Safe.Enabled = false;
			room_data.Spawn.Radius = 0;
		end,
		[6] = function(room,room_data) -- special button puzzle
			if room_data.Config.StageID == mod.StageTypes["Mausoleum"] or room_data.Config.StageID == mod.StageTypes["Gehenna"] then
				room_data.Positions[1] = room:GetGridPosition(66);
				room_data.Positions[2] = room:GetGridPosition(28);
				room_data.Positions[3] = room:GetGridPosition(106);
				room_data.Positions[4] = room:GetGridPosition(115);
				room_data.Safe.Enabled = false;
				room_data.Spawn.Radius = 0;
			end
		end,
		[7] = function(room,room_data) -- mostly pits, got creative
			if room_data.Config.StageID == mod.StageTypes["Mausoleum"] then
				room:RemoveGridEntityImmediate(51,-1,false);
				room:RemoveGridEntityImmediate(53,-1,false);
				room:RemoveGridEntityImmediate(58,-1,false);
				room:RemoveGridEntityImmediate(81,-1,false);
				room:RemoveGridEntityImmediate(83,-1,false);
				room:RemoveGridEntityImmediate(88,-1,false);
				room_data.Positions[1] = room:GetGridPosition(46);
				room_data.Positions[2] = room:GetGridPosition(58);
				room_data.Positions[3] = room:GetGridPosition(51);
				room_data.Positions[4] = room:GetGridPosition(53);
				room_data.Safe.Enabled = false;
				room_data.Spawn.Vertical = true;
				room_data.Spawn.Radius = 0;
				room_data.MoreOptions.Offset = Vector(0,2 * mod.GridSize);
			end
		end,
		[8] = function(room,room_data) -- spikes in corner
			if room_data.Config.StageID < mod.StageTypes["Downpour"] then
				room_data.Positions[1] = room:GetGridPosition(48);
				room_data.Positions[4] = room:GetGridPosition(86);
			end
		end,
		[9] = function(room,room_data) -- teleporters
			if room_data.Config.StageID == mod.StageTypes["Gehenna"] then
				room_data.Positions[1] = room:GetGridPosition(18);
				room_data.Positions[2] = room:GetGridPosition(26);
				room_data.Positions[3] = room:GetGridPosition(106);
				room_data.Positions[4] = room:GetGridPosition(116);
				room_data.Spawn.Radius = 0;
			end
		end,
		[10] = function(room,room_data) -- buttons in the way
			if room_data.Config.StageID == mod.StageTypes["Mines"] then -- Rocks everywhere
				room_data.Positions[1] = room:GetGridPosition(35);
				room_data.Positions[2] = room:GetGridPosition(39);
				room_data.Positions[3] = room:GetGridPosition(111);
				room_data.Positions[4] = room:GetGridPosition(113);
				room_data.Spawn.Radius = 0;
				room_data.MoreOptions.Offset = Vector(-mod.GridSize,mod.GridSize);
			elseif room_data.Config.StageID == mod.StageTypes["Mausoleum"] then
				room_data.Positions[1] = room:GetGridPosition(18);
				room_data.Positions[4] = room:GetGridPosition(116);
			end
		end,
		[13] = function(room,room_data) -- small room with big hole
			if room_data.Config.StageID == mod.StageTypes["Mausoleum"] then
				room_data.Positions[1] = room:GetGridPosition(21);
				room_data.Positions[2] = room:GetGridPosition(23);
				room_data.Positions[3] = room:GetGridPosition(111);
				room_data.Positions[4] = room:GetGridPosition(113);
				room_data.MoreOptions.Offset = Vector(-mod.GridSize,mod.GridSize);
				room_data.Spawn.Radius = 0;
			end
		end,
		[14] = function(room,room_data) -- rocks and statue in the way
			if room_data.Config.StageID == mod.StageTypes["Ashpit"] then
				room_data.Positions[1] = room:GetGridPosition(16);
				room_data.Positions[2] = room:GetGridPosition(28);
				room_data.Positions[3] = room:GetGridPosition(106);
				room_data.Positions[4] = room:GetGridPosition(118);
				room_data.Safe.Enabled = false;
			end
		end,
		[16] = function(room,room_data) -- teleporters
			if room_data.Config.StageID == mod.StageTypes["Gehenna"] then
				room_data.Positions[1] = room:GetGridPosition(18);
				room_data.Positions[2] = room:GetGridPosition(26);
				room_data.Positions[3] = room:GetGridPosition(106);
				room_data.Positions[4] = room:GetGridPosition(116);
				room_data.Spawn.Radius = 0;
			end
		end,
		[17] = function(room,room_data) -- buttons in the way
			if room_data.Config.StageID == mod.StageTypes["Mausoleum"] then
				room_data.Positions[1] = room:GetGridPosition(17);
				room_data.Positions[2] = room:GetGridPosition(26);
				room_data.Positions[3] = room:GetGridPosition(106);
				room_data.Positions[4] = room:GetGridPosition(117);
			end
		end,
		[19] = function(room,room_data) -- wide pitted off area (safe spawn or flight needed)
			if room_data.Config.StageID == mod.StageTypes["Dross"] or room_data.Config.StageID == mod.StageTypes["Mausoleum"] then -- small room with fires
				room_data.Positions[1] = room:GetGridPosition(21);
				room_data.Positions[2] = room:GetGridPosition(23);
				room_data.Positions[3] = room:GetGridPosition(111);
				room_data.Positions[4] = room:GetGridPosition(113);
				room_data.MoreOptions.Offset = Vector(-mod.GridSize,mod.GridSize);
			else
				room_data.Positions[1] = room:GetGridPosition(48);
				room_data.Positions[2] = room:GetGridPosition(56);
				room_data.Positions[3] = room:GetGridPosition(78);
				room_data.Positions[4] = room:GetGridPosition(86);
			end
		end,
		[23] = function(room,room_data) -- lets you take both
			room_data.MoreOptions.Enabled = false;
		end,
		[24] = function(room,room_data) -- rocks in each corner
			if room_data.Config.StageID == mod.StageTypes["Mausoleum"] or room_data.Config.StageID == mod.StageTypes["Gehenna"] then -- small room with fires
				room_data.Positions[1] = room:GetGridPosition(46);
				room_data.Positions[2] = room:GetGridPosition(58);
				room_data.Positions[3] = room:GetGridPosition(76);
				room_data.Positions[4] = room:GetGridPosition(88);
			else
				room_data.Positions[1] = room:GetGridPosition(48);
				room_data.Positions[2] = room:GetGridPosition(56);
				room_data.Positions[3] = room:GetGridPosition(78);
				room_data.Positions[4] = room:GetGridPosition(86);
				room_data.Spawn.Vertical = true;
			end
		end,
		[28] = function(room,room_data) -- smaller area to the side
			if room_data.Config.StageID < mod.StageTypes["Downpour"] then
				room_data.Positions[1] = room:GetGridPosition(26);
				room_data.Positions[2] = room:GetGridPosition(28);
				room_data.Positions[3] = room:GetGridPosition(116);
				room_data.Positions[4] = room:GetGridPosition(118);
				room_data.Spawn.Vertical = true;
				room:DestroyGrid(43,true);
				room:DestroyGrid(103,true);
			end
		end,
		[31] = function(room,room_data) -- Small room with inner rock area, Disable safe pos
			if room_data.Config.StageID < mod.StageTypes["Downpour"] then
				room_data.Positions[1] = room:GetGridPosition(20);
				room_data.Positions[2] = room:GetGridPosition(24);
				room_data.Safe.Enable = false;
			end
		end,
		[35] = function(room,room_data) -- Jars/rocks in pedestal area, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Positions[3] = room:GetGridPosition(78);
			room_data.Positions[4] = room:GetGridPosition(86);
			room_data.Safe.Enable = false;
		end,
		[38] = function(_,room_data) -- lets you take both
			room_data.MoreOptions.Enabled = false;
		end,
		[39] = function(room,room_data) -- Small room with inner rock area, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(108);
			room_data.Positions[3] = room:GetGridPosition(26);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end,
		[57] = function(room,room_data) -- rock sections, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end,
		[60] = function(room,room_data) -- jar area, swaps p1 and 2, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(28);
			room_data.Positions[2] = room:GetGridPosition(16);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Safe.Enable = false;
		end,
		[240040] = function(room,room_data) -- extra Pededstals spawn on chests, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(41);
			room_data.Safe.Enable = false;
		end,
	},
	[RoomType.ROOM_DEVIL] = {
		[15] = function(room,room_data) -- skinny room makes items block the door
			room_data.Positions[1] = room:GetGridPosition(80);
			room_data.Positions[2] = room:GetGridPosition(84);
		end,
		[22] = function(room,room_data) -- Pit causes items to overlap
			room_data.Positions[1] = room:GetGridPosition(47);
			room_data.Positions[2] = room:GetGridPosition(57);
		end,
		[52] = function(room,room_data) -- skinny room makes items block the door
			room_data.Positions[1] = room:GetGridPosition(35);
			room_data.Positions[2] = room:GetGridPosition(39);
		end,
		[57] = function(room,room_data) -- Fireplaces in each corner, set vertical
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(56);
			room_data.Spawn.Vertical = true;
		end,
		[59] = function(room,room_data) -- Forcegrab, Pit causes items to overlap, button overlapped, set vertical
			room_data.Positions[1] = room:GetGridPosition(31);
			room_data.Positions[2] = room:GetGridPosition(43);
			room_data.Positions[3] = room:GetGridPosition(106);
			room_data.Positions[4] = room:GetGridPosition(118);
			room_data.Spawn.Vertical = true;
		end,
	},
	[RoomType.ROOM_ANGEL] = {
		[7] = function(room,room_data) -- pedestals in each corner behind key blocks, set vertical, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			if (mod.Config.CoopTreasure.dead and mod.Players.Total or mod.Players.Alive) > 2 then 
				room_data.Positions[3] = room:GetGridPosition(106);
				room_data.Positions[4] = room:GetGridPosition(118);
				room_data.Spawn.Maximum = 1;
			else
				room_data.MoreOptions.Offset = Vector(0,mod.GridSize * 6);
			end
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = true;
		end,
		[16] = function(room,room_data) -- statue wings in the way
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(56);
		end,
		[19] = function(room,room_data) -- is triangular
			room_data.Positions[1] = room:GetGridPosition(50);
			room_data.Positions[2] = room:GetGridPosition(54);
		end,
		[20] = function(room,room_data) -- pillars in the way
			room_data.Positions[1] = room:GetGridPosition(48);
			room_data.Positions[2] = room:GetGridPosition(56);
		end,
		[21] = function(room,room_data) -- hearts in the way
			room_data.Positions[1] = room:GetGridPosition(33);
			room_data.Positions[2] = room:GetGridPosition(41);
		end,
	},
	[RoomType.ROOM_LIBRARY] = {
		[5] = function(room,room_data) -- pedestals in each corner behind key blocks, set vertical, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(32);
			room_data.Positions[2] = room:GetGridPosition(42);
			if (mod.Config.CoopTreasure.dead and mod.Players.Total or mod.Players.Alive) > 2 then 
				room_data.Positions[3] = room:GetGridPosition(92);
				room_data.Positions[4] = room:GetGridPosition(102);
				room_data.Spawn.Maximum = 1;
			else
				room_data.MoreOptions.Offset = Vector(0,mod.GridSize * 4);
			end
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = true;
		end,
		[7] = function(room,room_data) -- pedestals in each corner behind spikes, set vertical, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			room_data.Positions[2] = room:GetGridPosition(28);
			if (mod.Config.CoopTreasure.dead and mod.Players.Total or mod.Players.Alive) > 2 then 
				room_data.Positions[3] = room:GetGridPosition(106);
				room_data.Positions[4] = room:GetGridPosition(118);
				room_data.Spawn.Maximum = 1
			else
				room_data.MoreOptions.Offset = Vector(0,mod.GridSize * 6);
			end
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = true;
		end,
		[10] = function(room,room_data) -- pedestals in each corner behind key blocks, set horizontal, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(16);
			if (mod.Config.CoopTreasure.dead and mod.Players.Total or mod.Players.Alive) > 2 then 
				room_data.Positions[2] = room:GetGridPosition(19);
				room_data.Positions[3] = room:GetGridPosition(25);
				room_data.Positions[4] = room:GetGridPosition(28);
				room_data.Spawn.Maximum = 1
			else
				room_data.Positions[2] = room:GetGridPosition(25);
				room_data.MoreOptions.Offset = Vector(mod.GridSize * 3,0);
			end
			room:SpawnGridEntity(22,GridEntityType.GRID_ROCKB,0,1,0);
			room:DestroyGrid(37,true);
			room:SpawnGridEntity(37,GridEntityType.GRID_ROCKB,0,1,0);
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = false;
		end,
		[14] = function(room,room_data) -- rock barricade, set horizontal, Disable safe pos
			room_data.Positions[1] = room:GetGridPosition(58);
			room_data.Positions[2] = room:GetGridPosition(88);
			room_data.Positions[3] = room:GetGridPosition(27);
			room_data.Positions[4] = room:GetGridPosition(117);
			room_data.Safe.Enable = false;
			room_data.Spawn.Vertical = false;
		end,
	},
};
CoopTreasure.RemovableGridEntities = {
	[EntityType.ENTITY_MOVABLE_TNT] = true,
	[EntityType.ENTITY_FIREPLACE] = true,
	[EntityType.ENTITY_EFFECT] = true,
};
CoopTreasure.AssignmentTypes = {
	[0] = "Disabled",
	[1] = "Free",
	[2] = "Auto",
	[3] = "Self",
	[4] = "Global",
	Disabled = 0,
	Free = 1,
	Auto = 2,
	Self = 3,
	Global = 4
};
CoopTreasure.RoomTypes = {
	Treasure = {Assign = 2, Type = RoomType.ROOM_TREASURE, Function = nil},
	Silver = {Assign = 0, Type = RoomType.ROOM_TREASURE, Function = function() return (Game():IsGreedMode() and Game():GetLevel():GetCurrentRoomDesc().GridIndex == (Game():GetLevel():GetStartingRoomIndex() + 14)); end},
	Library = {Assign = 0, Type = RoomType.ROOM_LIBRARY, Function = nil},
	Planetarium = {Assign = 0, Type = RoomType.ROOM_PLANETARIUM, Function = nil},
	Angel = {Assign = 0, Type = RoomType.ROOM_ANGEL, Function = nil},
	Devil = {Assign = 0, Type = RoomType.ROOM_DEVIL, Function = nil},
	Secret = {Assign = 0, Type = RoomType.ROOM_SECRET, Function = nil},
	SuperSecret = {Assign = 0, Type = RoomType.ROOM_SUPERSECRET, Function = nil},
	UltraSecret = {Assign = 0, Type = RoomType.ROOM_ULTRASECRET, Function = nil},
};