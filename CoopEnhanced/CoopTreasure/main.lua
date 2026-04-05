local mod = CoopEnhanced;
local CoopTreasure = CoopEnhanced.CoopTreasure;

local Colors = mod.Colors;
local Utils = mod.Utils;

local game = Game();
local hud = game:GetHUD();

-- Saving and Loading
function CoopEnhanced.CoopTreasure.gameStart(isCont, data)
	CoopTreasure.DATA = {};
	if isCont and data and data.CoopTreasure then
		CoopTreasure.DATA = data.CoopTreasure;
	end
end
function CoopEnhanced.CoopTreasure.gameEnd(data)
	if data == nil then data = {CoopTreasure = {}}; end
	data.CoopTreasure = CoopTreasure.DATA;
	return data;
end

function CoopTreasure.AddRoomType(name, room_type, default, func) -- Add additional rooms that generate Coop Treasure. (name (string), room_type (number), default (number) [0 - 4], func (function)). If default is null it does not add the config setting.
	local config_name = name:gsub(" ","");
	CoopTreasure.RoomTypes[config_name] = {Assign = default, Type = room_type, Function = func};
	if default ~= nil then
		if not mod.Config.CoopTreasure.assign.rooms[config_name] then mod.Config.CoopTreasure.assign.rooms[config_name] = default or 0; end
		ModConfigMenu.AddSetting(
			CoopTreasure.MCM.title,
			CoopTreasure.MCM.categories.rooms,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 0,
				Maximum = 4,
				CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms[config_name]; end,
				Display = function() return name .. ': ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms[config_name]]; end,
				OnChange = function(n) mod.Config.CoopTreasure.assign.rooms[config_name] = n; end,
				Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice. - GLOBAL: Use Global setting.'},
			}
		);
	end
end

require(mod.Directory .. 'CoopTreasure.compat');
CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.TREASURE_POST_COMPAT); -- Execute Post Compat Setup Callbacks

function CoopTreasure.ClearGridSpace(position,radius) -- Clear Grid entities around pedestals
	local room = game:GetRoom();
	radius = radius or mod.Config.CoopTreasure.radius;
	local room_entities = Isaac.GetRoomEntities();
	for i,entity in pairs(room_entities) do
		if CoopTreasure.RemovableGridEntities[entity.Type] and entity.Position:Distance(position) <= (mod.GridSize * (radius / 2)) then
			entity:Remove();
		end
	end
	local grid_entities = Utils.FindGridsInRadius(position, radius);
	for i,grid_entity in pairs(grid_entities) do
		local grid_type = grid_entity:GetType();
		if Utils.IsGridTypeRemovable(grid_type) then
			grid_entity:Destroy(true);
			room:RemoveGridEntityImmediate(room:GetGridIndex(position),1,false);
		end
	end
end

function CoopTreasure.IsOwner(player_index,pedestal_entity)
	local assigned_index = CoopTreasure.GetAssignedIndex(player_index);
	local pedestal_index,_ = CoopTreasure.GetPedestalIndex(pedestal_entity);
	--print((tostring(pedestal_index) .. tostring(assigned_index == pedestal_index)));
	return (assigned_index == pedestal_index);
end

function CoopTreasure.GetAssignedIndex(player_index,ignore_owned)
	local room_data = CoopTreasure.DATA[Utils.GetRoomID()];
	if not room_data then return 0; end
	local assignments = room_data.Treasure.Assignments;
	for i = 1, #assignments, 1 do
		if assignments[i] == math.abs(player_index) and (not ignore_owned or CoopTreasure.DATA[CoopTreasure.GetRoomID()].Treasure.Owned[i] ~= player_index) then return i; end
	end
	return 0;
end

function CoopTreasure.GetPedestalIndex(pedestal_entity)
	local room_data = CoopTreasure.DATA[Utils.GetRoomID()]
	if not room_data then return 0; end
	for i,items in ipairs(room_data.Treasure.Items) do
		for ii,item in ipairs(items) do
			if pedestal_entity.Position:Distance(item.Position) <= 10 then return i, ii; end -- Corner, More Options
		end
	end
	return 0;
end

function CoopTreasure.GetOwnedIndexes(player_index)
	local owned = CoopTreasure.DATA[Utils.GetRoomID()].Treasure.Owned;
	local owned_indexes = {};
	for i = 1, #owned, 1 do
		if owned[i] == math.abs(player_index) then table.insert(owned_indexes,i); end
	end
	return owned_indexes;
end

function CoopTreasure.CheckComplete()
	for i,player_entity in ipairs(Utils.getMainPlayers()) do
		local player_index = player_entity.ControllerIndex + 1;
		if CoopTreasure.GetOwnedAmount(player_index) < mod.Config.CoopTreasure.max then return false; end
	end
	return true;
end

function CoopTreasure.GetOwnedAmount(player_index)
	local owned = CoopTreasure.DATA[Utils.GetRoomID()].Treasure.Owned;
	local total = 0;
	for i = 1, #owned, 1 do
		if owned[i] == math.abs(player_index) then total = total + 1; end
	end
	return total;
end

function CoopTreasure.GetRoomAssignment(room_type)
	local assignment = -1;
	local room_ID = Utils.GetRoomID();
	if CoopTreasure.DATA[room_ID] and CoopTreasure.DATA[room_ID].Assign then return CoopTreasure.DATA[room_ID].Assign; end
	for name,data in pairs(CoopTreasure.RoomTypes) do
		if room_type == data.Type and mod.Config.CoopTreasure.assign.rooms[name:gsub(" ","")] and (not data.Function or data.Function()) then
			assignment = mod.Config.CoopTreasure.assign.rooms[name:gsub(" ","")];
			break;
		end
	end
	return assignment ~= 2 and assignment or mod.Config.CoopTreasure.assign.global;
end

function CoopTreasure.CheckMode()
	local modes = mod.Config.CoopTreasure.modes;
	local difficulty = game.Difficulty;
	if difficulty < Difficulty.DIFFICULTY_GREED and (modes.normal == (difficulty + 1) or modes.normal == (Difficulty.DIFFICULTY_NORMAL + Difficulty.DIFFICULTY_HARD) + 2) or difficulty >= Difficulty.DIFFICULTY_GREED and (modes.greed == (difficulty - 1) or modes.greed == (Difficulty.DIFFICULTY_GREED + Difficulty.DIFFICULTY_GREEDIER) - 2) then return true; end
	return false;
end

function CoopTreasure:onPedestal(pedestal_entity, entity)
	local room_ID = Utils.GetRoomID();
	local room_data = CoopTreasure.DATA[room_ID];
	local player_entity = entity:ToPlayer();
	
	if not CoopEnhanced.Config.modules.CoopTreasure or not room_data or room_data.Assign < 2 or not player_entity or not pedestal_entity or room_data.Spawn.Total == 1 then return nil; end
	
	local pedestal_corner,pedestal_index = CoopTreasure.GetPedestalIndex(pedestal_entity);
	if pedestal_corner == 0 then return nil; end
	
	local player_index = player_entity.ControllerIndex + 1;
	if room_data.Treasure.Assignments[pedestal_corner] == 0 and CoopTreasure.GetOwnedAmount(player_index) < mod.Config.CoopTreasure.max then 
		if (CoopTreasure.GetOwnedAmount(player_index) + 1) >= mod.Config.CoopTreasure.max then room_data.Treasure.Assignments[CoopTreasure.GetAssignedIndex(player_index,true)] = 0; end
		room_data.Treasure.Assignments[pedestal_corner] = player_index;
	elseif room_data.Treasure.Assignments[pedestal_corner] ~= math.abs(player_index) then return false; end
	
	if (pedestal_entity.Price < 0 and not Utils.CanPayDevilPrice(player_entity,pedestal_entity.Price)) or (pedestal_entity.Price > 0 and player_entity:GetNumCoins() < pedestal_entity.Price) then return true; end
	
	room_data.Treasure.Owned[pedestal_corner] = player_index;
	if room_data.MoreOptions.Enabled and #room_data.Treasure.Items[pedestal_corner] > 1 then
		local remove_index = pedestal_index == 1 and 2 or 1;
		table.remove(room_data.Treasure.Items[pedestal_corner],remove_index);
	end
	if mod.Config.CoopTreasure.clean and room_data.Assign > 1 and CoopTreasure.CheckComplete() then
		for i = 1, #room_data.Treasure.Assignments, 1 do
			if room_data.Treasure.Assignments[i] == 0 and CoopTreasure.DATA[room_ID].Treasure.Items[i][1] then
				local remove_pedestal = Isaac.FindInRadius(CoopTreasure.DATA[room_ID].Treasure.Items[i][1].Position, (mod.GridSize / 2), EntityPartition.PICKUP)[1];
				if remove_pedestal then 
					remove_pedestal:ToPickup():TriggerTheresOptionsPickup();
					remove_pedestal:Remove();
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, CoopTreasure.DATA[room_ID].Treasure.Items[i][1].Position, Vector.Zero, nil);
					CoopTreasure.DATA[room_ID].Treasure.Items[i] = {}
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CoopTreasure.onPedestal,  PickupVariant.PICKUP_COLLECTIBLE);

function CoopTreasure:onRender()
	local room = game:GetRoom();
	local room_ID = Utils.GetRoomID();
	local room_data = CoopTreasure.DATA[room_ID];
	
	if not CoopEnhanced.Config.modules.CoopTreasure or (mod.Config.CoopTreasure.dead and mod.Players.Total <= 1 or mod.Players.Alive <= 1) or Utils.IsPauseMenuOpen() or not room_data or room:IsMirrorWorld() or room:GetFrameCount() < 5 or not Isaac.GetPlayer().ControlsEnabled or (not game:GetHUD():IsVisible() and not CoopEnhanced.CoopHUD.IsVisible) then return; end
		
	local display = mod.Config.CoopTreasure.assign.display;
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.TREASURE_PRE_RENDER, room_data, display); -- Execute Pre Owner Label Render Callbacks (room_data(table),display(boolean))
	-- Display Pedestal Owner Markers
	if room_data.Assign > 1 and display > 0 and #room_data.Treasure.Items > 1 then
		local player_sync = mod.Config.CoopTreasure.player_sync;
		local scale = mod.Config.CoopTreasure.assign.scale;
		for i,player_index in ipairs(room_data.Treasure.Assignments) do
			player_index = math.abs(player_index);
			if player_index > 0 and room_data.Treasure.Items[i][1] and #Isaac.FindInRadius(room_data.Treasure.Items[i][1].Position, (mod.GridSize / 2), EntityPartition.PICKUP) > 0 then
				if game:GetFrameCount() % 15 == 0 then -- Update Data twice each second
					local player_entity = Utils.getMainPlayerByController(player_index - 1);
					if not player_entity then return; end
						
					local player_config = player_sync == "Global" and mod.Config.players[player_index] or (mod.Config[player_sync] and mod.Config[player_sync].players[player_index] or mod.Config.CoopTreasure.players[player_index]);
					local player_name = display > 1 and Utils.getPlayerName(player_entity, player_index, player_config.type, player_config.name, mod.Config.CoopLabels.tainted) or nil;
					local player_color = Colors[player_config.color].Value;
					
					local edge_multipliers = Vector((i % 2 == 0) and -1 or 1, i > 2 and -1 or 1);
					local display_offset = (mod.Config.CoopTreasure.assign.offset + (#room_data.Treasure.Items[i] == 1 and Vector.Zero or Vector(room_data.MoreOptions.Offset.X / 2 - room_data.MoreOptions.Offset.Y / 2, room_data.MoreOptions.Offset.Y / 2))) * edge_multipliers;
					local display_pos = Isaac.WorldToRenderPosition(room_data.Treasure.Items[i][1].Position + display_offset);
					
					local player_sprite = (display == 1 or display == 3) and Utils.getHeadSprite(nil,player_entity) or nil;
					local player_sprite_pos = player_sprite and (display_pos + Vector(-1 * player_sprite.Scale.X,0) + mod.Config.CoopTreasure.assign.head.offset) or Vector.Zero;
					
					local name_pos = player_name and (mod.Config.CoopTreasure.assign.text.offset + Vector(display_pos.X - ((mod.Fonts.CoopTreasure.treasure:GetStringWidth(player_name) / 2) * (scale.X * mod.Config.CoopTreasure.assign.text.scale.X)),display_pos.Y)) or Vector.Zero;
					room_data.Render[i] = {Sprite = player_sprite, Pos = player_sprite_pos, Text = {Value = player_name, Pos = name_pos}, Color = Utils.ConvertColorToFont(player_color, mod.Config.CoopTreasure.assign.text.opacity)};
				end
				if room_data.Render[i] then
					if room_data.Render[i].Sprite ~= nil then
						room_data.Render[i].Sprite.Color = Color(1,1,1,mod.Config.CoopTreasure.assign.head.opacity);
						room_data.Render[i].Sprite.Scale = scale * mod.Config.CoopTreasure.assign.head.scale;
						room_data.Render[i].Sprite:Render(room_data.Render[i].Pos);
					end
					if room_data.Render[i].Text.Value ~= nil then
						mod.Fonts.CoopTreasure.treasure:DrawStringScaled(
							room_data.Render[i].Text.Value,
							room_data.Render[i].Text.Pos.X or 0, room_data.Render[i].Text.Pos.Y or 0,
							scale.X * mod.Config.CoopTreasure.assign.text.scale.X, scale.Y * mod.Config.CoopTreasure.assign.text.scale.Y,
							room_data.Render[i].Color or Color.Default, room_data.Render[i].Text.Width or 0, room_data.Render[i].Text.Center or true
						);
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, CoopTreasure.onRender);

function CoopTreasure:onRoom()
	if CoopEnhanced.RefreshFrameCount then CoopEnhanced.RefreshFrameCount(); end -- Refreshes Player counts
	local room = game:GetRoom();
	local room_type = room:GetType();
	local room_assign = CoopTreasure.GetRoomAssignment(room_type);
	local room_desc = game:GetLevel():GetCurrentRoomDesc();
	local spawn_total = math.min(4, (mod.Config.CoopTreasure.dead and mod.Players.Total or mod.Players.Alive) + mod.Config.CoopTreasure.extras);
	
	if mod.Debug and room_desc.Data then 
		mod.Debug("Room Type is " .. room_type);
		mod.Debug("Room Variant is " .. room_desc.Data.Variant);
		mod.Debug("Room SubType is " .. room_desc.Data.Subtype);
		mod.Debug("Room Stage is " .. room_desc.Data.StageID);
	end
	
	if not CoopEnhanced.Config.modules.CoopTreasure or (not room_desc or room_desc.Data == nil) or (not mod.Config.CoopTreasure.single and mod.Players.Total <= 1) or (mod.Config.CoopTreasure.single and spawn_total <= 1) or room_assign < 1 or not CoopTreasure.CheckMode() or room_desc.VisitedCount > 1 or room:IsMirrorWorld() then return; end
	
	local room_data = {Assign = room_assign, Config = room_desc.Data, Positions = {}, Safe = {}, Spawn = {}, MoreOptions = {}, Treasure = {Assignments = {0,0,0,0}, Owned = {0,0,0,0}, Prices = {0,0,0,0}, Items = {[1] = {},[2] = {},[3] = {},[4] = {}}}, Render = {}};
	local room_ID = Utils.GetRoomID();
	local room_variant = room_desc.Data.Variant;
	local item_pool = game:GetItemPool();
	
	if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then room:SetItemPool(item_pool:GetRandomPool(RNG(room:GetSpawnSeed()))); end
	
	local orig_peds = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1);
	if not orig_peds or #orig_peds == 0 then return; end
	
	local isSkinny = room:GetRoomShape() == RoomShape.ROOMSHAPE_IV or room:GetRoomShape() == RoomShape.ROOMSHAPE_IH or room:GetRoomShape() == RoomShape.ROOMSHAPE_IIV or room:GetRoomShape() == RoomShape.ROOMSHAPE_IIH;
	local pedestal_offset = Utils.VectorFrom((mod.GridSize * (isSkinny and 1 or 3)) / 2);
	
	
	room_data.Positions[1] = room:GetTopLeftPos() + pedestal_offset;
	room_data.Positions[4] = room:GetBottomRightPos() - pedestal_offset;
	room_data.Positions[2] = Vector(room_data.Positions[4].X,room_data.Positions[1].Y);
	room_data.Positions[3] = Vector(room_data.Positions[1].X,room_data.Positions[4].Y);
	
	room_data.Spawn = {Maximum = 2, Total = spawn_total, Vertical = (room:GetRoomShape() == RoomShape.ROOMSHAPE_IV or room:GetRoomShape() == RoomShape.ROOMSHAPE_IIV or room:GetRoomShape() == RoomShape.ROOMSHAPE_1x2), Radius = mod.Config.CoopTreasure.radius};
	room_data.Safe = {Enable = Utils.CheckSafeSpawnPosition(game:GetPlayer().Position, orig_peds[1].Position), Mode = (not isSkinny and mod.Config.CoopTreasure.safe or 0)};
	room_data.MoreOptions = {Enabled = (#orig_peds > 1), Offset = (room_data.Spawn.Vertical and Vector(0,2 * mod.GridSize) or Vector(2 * mod.GridSize,0))};
	
	-- Get Room Specific Data, Run Room Specific Methods
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.TREASURE_PRE_ROOM_DATA, room_data); -- Execute Pre Room Data update Callbacks (room_data(table))
	local room_function = CoopTreasure.RoomConfigs[room_type] and CoopTreasure.RoomConfigs[room_type][room_variant] or nil;
	if room_function then room_function(room,room_data); end
	if room_data == nil or room_data.Spawn.Maximum == 0 or room_data.Assign <= 0 then return; end
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.TREASURE_POST_ROOM_DATA, room_data); -- Execute Post Room Data update Callbacks (room_data(table))
	
	-- Set Pedestal Assignments
	local players = Utils.getMainPlayers();
	if room_data.Assign == CoopTreasure.AssignmentTypes.Auto then
		for i,player_entity in pairs(players) do
			room_data.Treasure.Assignments[i] = player_entity.ControllerIndex + 1;
		end
	end
	
	-- Move Restock boxes
	local restock_boxes = Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.SHOP_RESTOCK_MACHINE, -1);
	for _,entity in pairs(restock_boxes) do
		entity.Position = room:GetCenterPos();
	end
	
	local item_pos = room_data.Positions[1];
	local isDevilDeal = (room_type == RoomType.ROOM_DEVIL or room_type == RoomType.ROOM_BLACK_MARKET);
	local safe_args = room_data.Safe.Mode > 0 and ({room_data.Safe.Mode < 3 and 1 or 0, (room_data.Safe.Mode == 1 or room_data.Safe.Mode == 3) and 1 or 0,2}) or Vector.Zero;
	CoopTreasure.ClearGridSpace(orig_peds[1].Position, 1); -- Clear grid entities from where pedestal was
	
	for i,pedestal_entity in pairs(orig_peds) do
		pedestal_entity = pedestal_entity:ToPickup();
		CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.TREASURE_PRE_PEDESTAL, 1, pedestal_entity); -- Execute Pre Pedestal updates for player 1 Callbacks (player_index, pedestal_entity(EntityPickup))
		if i > room_data.Spawn.Maximum then
			pedestal_entity:Remove();
		else
			item_pos = item_pos + (i > 1 and (room_data.MoreOptions.Offset / (math.min(room_data.Spawn.Maximum,#orig_peds) >= 3 and 2 or 1)) or Vector.Zero);
			CoopTreasure.ClearGridSpace(item_pos, room_data.Spawn.Radius); -- Clear grid entities from around pedestals
			if room_data.Safe.Enable and room_data.Safe.Mode > 0 then item_pos = Utils.GetSafeSpawnPosition(game:GetPlayer().Position, item_pos, safe_args); end -- Safe Pos Check
			local new_pedestal_entity = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item_pos, Vector.Zero, nil, pedestal_entity.SubType, math.max(1,room:GetSpawnSeed())):ToPickup(); -- Spawn new one to remove extra items from coop (e.g. Boss Item Pedestals)
			pedestal_entity:Remove();
			if room_data.MoreOptions.Enabled then new_pedestal_entity.OptionsPickupIndex = 1; end
			if room_data.Assign > 1 and players[1]:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then new_pedestal_entity.Price = 15; new_pedestal_entity.ShopItemId = -1; elseif isDevilDeal then new_pedestal_entity.Price = Utils.GetDevilPrice(players[1],nil,new_pedestal_entity.SubType); else new_pedestal_entity.Price = room_data.Treasure.Prices[1] or 0; end
			local pedestal_data = {Pointer = EntityPtr(new_pedestal_entity), Position = item_pos, Price = new_pedestal_entity.Price, IsBlind = new_pedestal_entity:IsBlind()};
			table.insert(room_data.Treasure.Items[1],pedestal_data);
			CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.TREASURE_POST_PEDESTAL, 1, new_pedestal_entity, pedestal_data); -- Execute Post Pedestal updates for player 1 Callbacks (player_index, new_pedestal_entity(EntityPickup), pedestal_data(table))
		end
	end
	
	-- Spawn the extra Items for co-op players
	for i = 2, room_data.Spawn.Total, 1 do
		local edge_multipliers = Vector((i % 2 == 0) and -1 or 1, i > 2 and -1 or 1);
		item_pos = room_data.Positions[i];
		for ii = 1, #room_data.Treasure.Items[1], 1 do
			if ii > 1 then item_pos = item_pos + ((room_data.MoreOptions.Offset / (#room_data.Treasure.Items[1] >= 3 and 2 or 1)) * edge_multipliers); end
			CoopTreasure.ClearGridSpace(item_pos, room_data.Spawn.Radius); -- Clear grid entities from around pedestals
			if room_data.Safe.Enable and room_data.Safe.Mode > 0 then item_pos = Utils.GetSafeSpawnPosition(game:GetPlayer().Position, item_pos, {safe_args[1] * edge_multipliers.X,safe_args[2] * edge_multipliers.Y,2}); end -- Safe Pos Check
			local item_id = item_pool:GetCollectible(room:GetItemPool(math.max(room:GetSpawnSeed())), true, math.max(1,room:GetSpawnSeed())); -- Gets seed accurate Collectible Type
			local pedestal_entity = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item_pos, Vector.Zero, nil, item_id, math.max(1,room:GetSpawnSeed())):ToPickup();
			pedestal_entity:SetForceBlind(room_data.Treasure.Items[1][ii].IsBlind);
			CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.TREASURE_PRE_PEDESTAL, i, pedestal_entity); -- Execute Pre Pedestal updates for player 1 Callbacks (player_index, pedestal_entity(EntityPickup))
			
			if room_data.Assign > 1 and players[i]:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then pedestal_entity.Price = 15; pedestal_entity.ShopItemId = -1; -- Set Miser costs
			elseif isDevilDeal then pedestal_entity.Price = Utils.GetDevilPrice(players[i],nil,item_id); else pedestal_entity.Price = room_data.Treasure.Prices[i] or 0; end -- Set Health price
			if room_data.MoreOptions.Enabled then pedestal_entity.OptionsPickupIndex = i; end -- Set OptionsPickupIndex
			local pedestal_data = {Pointer = EntityPtr(pedestal_entity), Position = item_pos, SubType = pedestal_entity.SubType, IsBlind = pedestal_entity:IsBlind()};
			--Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, item_pos, Vector.Zero, nil);
			table.insert(room_data.Treasure.Items[i],pedestal_data);
			CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.TREASURE_POST_PEDESTAL, i, pedestal_entity, pedestal_data); -- Execute Post Pedestal updates for player 1 Callbacks (player_index, pedestal_entity(EntityPickup), pedestal_data(table))
		end
	end
	
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.TREASURE_POST_ROOM_SETUP,room_data); -- Execute Post Room Data Setup (room_data(table))
	CoopTreasure.DATA[room_ID] = room_data;
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.Priorities[4], CoopTreasure.onRoom);

function CoopTreasure:onFloor()
	CoopTreasure.DATA = {}; -- Clear Previous FLoor data since its no longer needed and would cause issues on the new one
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, CoopTreasure.onFloor);