local mod = CoopEnhanced;
local CoopExtras = CoopEnhanced.CoopExtras;

local game = Game();
local Colors = mod.Colors;
local Utils = mod.Utils;

-- Saving and Loading
function CoopEnhanced.CoopExtras.gameStart(isCont, data)
	CoopExtras.DATA = {Pickups = {}};
	if isCont and data and data.CoopExtras then
		CoopExtras.DATA = data.CoopExtras;
	end
end
function CoopEnhanced.CoopExtras.gameEnd(data)
	if data == nil then data = {CoopExtras = {}}; end
	data.CoopExtras = CoopExtras.DATA;
	return data;
end

function CoopExtras:onFloor()
	CoopExtras.DATA.Pickups = {}; -- Clear FLoor data since we dont need it anymore and it can cause issues
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, CoopExtras.onFloor);

function CoopExtras.GetPickupID(pickup)
	return tostring(pickup.SubType) .. "|" .. tostring(pickup.Position.X) .. "|" .. tostring(pickup.Position.Y); -- Unique enough ID to help find collectibles and be able to save/load it for later
end

--Greed Revive Machine
function CoopExtras.GreedRevive(_)
	local room = game:GetRoom();
	if mod.Config.CoopExtras.greed_revive and game:IsGreedMode() and room:GetType() == RoomType.ROOM_SHOP and game:GetLevel():GetCurrentRoomDesc().VisitedCount <= 1 and Game():GetLevel():GetStage() ~= LevelStage.STAGE1_GREED and Game():GetLevel():GetStage() ~= LevelStage.STAGE7_GREED then
		local revive_pos = room:GetCenterPos() + Vector(0,mod.GridSize / 2);
		revive_pos = Utils.GetSafeSpawnPosition(game:GetPlayer().Position, revive_pos, {0,1,2});
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.EXTRAS_PRE_GREED_REVIVE, revive_pos); -- Execute Pre Spawn Revive Machine Callbacks (revive_pos(Vector))
		local revive_machine = Isaac.Spawn(EntityType.ENTITY_SLOT, 19, -1, revive_pos, Vector.Zero, game:GetPlayer());
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.EXTRAS_POST_GREED_REVIVE, revive_machine); -- Execute Post Spawn Revive Machine Callbacks (revive_machine(Entity))
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CoopExtras.GreedRevive);


-- Coop Prices Updates
function CoopExtras.CoopPrices(_,pickup)
	if mod.Config.CoopExtras.item_prices and pickup ~= nil and pickup.SubType ~= 0 then
		local room_ID = Utils.GetRoomID();
		local room_type = game:GetRoom():GetType();
		if CoopExtras.DATA.Pickups[room_ID] == nil then
			if game:GetLevel():GetStage() ~= LevelStage.STAGE7 and (room_type == RoomType.ROOM_TREASURE or room_type == RoomType.ROOM_LIBRARY or room_type == RoomType.ROOM_PLANETARIUM or room_type == RoomType.ROOM_ANGEL or room_type == RoomType.ROOM_DEVIL or room_type == RoomType.ROOM_SECRET or room_type == RoomType.ROOM_SUPERSECRET or room_type == RoomType.ROOM_ULTRASECRET or room_type == RoomType.ROOM_BOSS or room_type == RoomType.ROOM_BOSSRUSH or game:GetLevel():GetStage() == LevelStage.STAGE6) then CoopExtras.DATA.Pickups[room_ID] = {}; else CoopExtras.DATA.Pickups[room_ID] = false; end
		end
		if not CoopExtras.DATA.Pickups[room_ID] then return; end
		local room_data = CoopExtras.DATA.Pickups[room_ID];
		local pickup_id = CoopExtras.GetPickupID(pickup);
		if room_data[pickup_id] == nil then
			local price = pickup.Price ~= 0 and ((room_type == RoomType.ROOM_DEVIL or room_type == RoomType.ROOM_BLACK_MARKET or (game:GetLevel():GetName() == "Dark Room" and game:GetLevel():GetCurrentRoomIndex() == game:GetLevel():GetStartingRoomIndex())) and PickupPrice.PRICE_ONE_HEART or pickup.Price) or pickup.Price;
			room_data[pickup_id] = {Price = price, Last = nil, Item = pickup.SubType};
		end
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.EXTRAS_PRE_PRICE_DATA, room_data); -- Execute Pre item Pricing Callbacks (room_data(table))
		if room_data[pickup_id].Price == nil then return; end -- Make sure that Couponed items and old replaced actives stay free
		local price = room_data[pickup_id].Price + 0;
		
		local player, health, distance = nil, nil, nil;
		
		for i = 1, Game():GetNumPlayers(), 1 do
			local player_entity = Isaac.GetPlayer(i - 1);
			local player_health = CustomHealthAPI.PersistentData.OverriddenFunctions.GetHearts(player_entity);
			local player_distance = player_entity.Position:Distance(pickup.Position);
			local isOwner = (not mod.Config.modules.CoopTreasure or mod.CoopTreasure.GetRoomAssignment(room_type) < 2 or mod.CoopTreasure.IsOwner(Utils.GetMainPlayerIndex(player_entity),pickup));
			if not player_entity:IsCoopGhost() and isOwner and player_health and (not distance or player_distance < distance) then
				player, health, distance = player_entity, player_health, player_distance;
			end
		end
		if player then
			if price >= PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART and price <= PickupPrice.PRICE_ONE_HEART then
				price = Utils.GetDevilPrice(player,health,pickup.SubType);
			elseif player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
				pickup.AutoUpdatePrice = true;
				pickup.ShopItemId = -1;
				price = Isaac.GetItemConfig():GetCollectible(pickup.SubType).ShopPrice / (PlayerManager.GetNumCollectibles(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1);
			end
		end
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.EXTRAS_POST_PRICE_DATA, price); -- Execute Post item Pricing Callbacks (price(int))
		if pickup.Price == 0 and (price ~= 0 and price == room_data[pickup_id].Last) or pickup.Touched then room_data[pickup_id].Price = nil; return; end
		room_data[pickup_id].Last = price;
		pickup.Price = price;
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CoopExtras.CoopPrices, PickupVariant.PICKUP_COLLECTIBLE);


-- Coop Ghost Flight
function CoopExtras:GhostFlight(player_entity)
	if not mod.Config.CoopExtras.ghost_flight.enabled then mod:RemoveCallback(ModCallbacks.MC_EVALUATE_CACHE, CoopExtras.GhostFlight); end
	if player_entity:IsCoopGhost() then player_entity.CanFly = true; end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CoopExtras.GhostFlight, CacheFlag.CACHE_FLYING);

function CoopExtras:onGhostPickup(pickup_entity, entity)
	local player_entity = entity:ToPlayer();
	if not mod.Config.CoopExtras.ghost_flight.pickups or not player_entity or not player_entity:IsCoopGhost() then return; end
	
	local canPickup = CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.EXTRAS_PRE_GHOST_PICKUP, player_entity, chest_type); -- Execute Pre Ghost Pickup Callbacks (player_entity(EntityPlayer), pickup_entity(EntityPickup)) Return true to allow pickup
	if canPickup then return; end
	if mod.Config.CoopExtras.ghost_flight.interact == 4 or mod.Config.CoopExtras.ghost_flight.shopping and pickup_entity.Price ~= 0 then return true; end
	
	local other_pos = nil;
	for i,player in pairs(PlayerManager.GetPlayers()) do
		if not player:IsCoopGhost() and (not other_pos or player_entity.Position:Distance(player.Position) < player_entity.Position:Distance(other_pos)) then
			other_pos = player.Position;
			if player.CanFly then return; end
		end
	end
	if other_pos and not someone_has_flight and not Utils.CheckSafeSpawnPosition(other_pos,pickup_entity.Position) then return false; end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CoopExtras.onGhostPickup);

function CoopExtras:onGhostChest(chest_type,player_entity)
	if not player_entity or not player_entity:IsCoopGhost() then return; end
	local canOpen = CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.EXTRAS_PRE_GHOST_CHEST, player_entity, chest_type); -- Execute Pre Ghost Chest Callbacks (player_entity(EntityPlayer), chest_type(PickupVariant)) Return true to allow opening
	if not canOpen and mod.Config.CoopExtras.ghost_flight.chests then return false; end
end
mod:AddCallback(ModCallbacks.MC_PRE_OPEN_CHEST, CoopExtras.onGhostChest);

function CoopExtras:onGhostCollide(player_entity, entity)
	local enemy_entity = entity:ToNPC();
	if not player_entity:IsCoopGhost() or not enemy_entity then return; end
	local canCollide = CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.EXTRAS_PRE_GHOST_COLLISION, player_entity, enemy_entity); -- Execute Pre item Pricing Callbacks (player_entity(EntityPlayer), enemy_entity(EntityNPC))
	if canCollide then return; end
	if mod.Config.CoopExtras.ghost_flight.interact == 4 then return true; end
	if enemy_entity:GetBossID() > 0 and mod.Config.CoopExtras.ghost_flight.interact >= 3 then return true; end
	if enemy_entity:GetBossID() == 0 and mod.Config.CoopExtras.ghost_flight.interact >= 1 then return true; end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, CoopExtras.onGhostCollide);

function CoopExtras:onGhostButton(player_entity, grid_index, grid_entity)
	if not grid_entity or not grid_entity:GetType() ~= GridEntityType.GRID_PRESSURE_PLATE or not player_entity:IsCoopGhost() then return; end
	local canActivate = CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.EXTRAS_PRE_GHOST_BUTTON, player_entity, grid_entity:ToPressurePlate()); -- Execute Pre item Pricing Callbacks (player_entity(EntityPlayer), grid_entity(GridEntityPressurePlate))
	if canActivate then return; end
	return true;
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_GRID_COLLISION, CoopExtras.onGhostButton);


-- Coop Sacrificial Revive
function CoopExtras:sacrificalRevive(player_entity, damage, damage_flags)
	if not mod.Config.CoopExtras.sacrifice_revive.enabled or game:GetRoom():GetType() ~= RoomType.ROOM_SACRIFICE or (damage_flags & DamageFlag.DAMAGE_SPIKES == 0) or (damage_flags & DamageFlag.DAMAGE_NO_PENALTIES == 0) then return; end
	local revive_chance = CoopExtras.DATA.ReviveChance or 0;
	local ghost_entity = nil;
	for i,player in pairs(PlayerManager.GetPlayers()) do
		if player:IsCoopGhost() and (not ghost_entity or player_entity.Position:Distance(player.Position) < player_entity.Position:Distance(other_pos)) then
			ghost_entity = player;
		end
	end
	if not ghost_entity then return; end
	local rng = RNG(math.max(1,game:GetRoom():GetSpawnSeed()));
	local revive_check = rng:RandomInt(0,100);
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.EXTRAS_PRE_SACRIFICE_REVIVE, player_entity, ghost_entity, revive_chance, revive_check);
	if revive_check <= revive_chance then
		revive_chance = 0;
		ghost_entity:ReviveCoopGhost();
	elseif mod.Config.CoopExtras.sacrifice_revive.increase then
		revive_chance = math.min(100,revive_chance + mod.Config.CoopExtras.sacrifice_revive.chance);
	end
	CoopExtras.DATA.ReviveChance = revive_chance;
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, CoopExtras.sacrificalRevive);