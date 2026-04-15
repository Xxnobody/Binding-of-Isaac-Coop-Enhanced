local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Stats = CoopHUD.Stats;
local DATA = CoopHUD.DATA

local Utils = mod.Utils;

local game = Game();

function Stats.GetDevilAngelChance()
	local level = game:GetLevel();
	local room = game:GetRoom();
	local stage = level:GetStage();
	local curses = level:GetCurses();
	local disallowed_stages = {[LevelStage.STAGE4_3] = true,[LevelStage.STAGE5] = true,[LevelStage.STAGE6] = true,[LevelStage.STAGE7] = true,[LevelStage.STAGE8] = true}; -- stages where you cant get a deal
	local chances = {deal = 0.0,calc = 0.0,angel = 0.0,devil = 0.0,duality = false};
	local mods = {};
	local collectibles = {[CollectibleType.COLLECTIBLE_KEY_PIECE_1] = 0.75,[CollectibleType.COLLECTIBLE_KEY_PIECE_2] = 0.75,[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = 0.75};
	local trinkets = {[TrinketType.TRINKET_ROSARY_BEAD] = 0.5};
	local level_flags = {[LevelStateFlag.STATE_BUM_KILLED] = 0.75,[LevelStateFlag.STATE_BUM_LEFT] = 0.9,[LevelStateFlag.STATE_EVIL_BUM_LEFT] = 1.1};
	local eucharist = false;
	local book_of_virtues = false;
	
	for i = 0, game:GetNumPlayers() - 1, 1 do
		local p = Isaac.GetPlayer(i);
		for k, v in pairs(collectibles) do
			if p:HasCollectible(k) then
				table.insert(mods, v);
			end
		end
		for k, v in pairs(trinkets) do
			if p:HasTrinket(k) then
				table.insert(mods, v);
			end
		end
		if p:HasCollectible(CollectibleType.COLLECTIBLE_EUCHARIST) then eucharist = true; end
		if p:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then book_of_virtues = true; end
		if p:HasCollectible(CollectibleType.COLLECTIBLE_DUALITY) then chances.duality = true; end
	end
	if (stage == LevelStage.STAGE1_1 and (curses & LevelCurse.CURSE_OF_LABYRINTH) == 0 and level:GetStageType() ~= StageType.STAGETYPE_REPENTANCE and level:GetStageType() ~= StageType.STAGETYPE_REPENTANCE_B) or level:IsPreAscent() or disallowed_stages[stage] then return chances; end

	chances.deal = room:GetDevilRoomChance();
	chances.deal = chances.deal > 1 and 1 or chances.deal;
	chances.angel = 1.0;
	if eucharist then
		chances.devil = 0;
		return chances;
	end

	for k, v in pairs(level_flags) do -- check level flags
		if level:GetStateFlag(k) then
			table.insert(mods, v);
		end
	end
	
	if game:GetDonationModAngel() >= 10 then -- donation machine
		table.insert(mods, 0.5);
	end
	
	-- calculation
	local devil_spawned = game:GetStateFlag(GameStateFlag.STATE_DEVILROOM_SPAWNED);
	local devil_visited = game:GetStateFlag(GameStateFlag.STATE_DEVILROOM_VISITED);
	local devil_item_taken = game:GetDevilRoomDeals() > 0;
	local angel_spawned = game:GetStateFlag(GameStateFlag.STATE_FAMINE_SPAWNED); -- repurposed state in Rep
	if devil_visited and not devil_item_taken then
		chances.calc = 0.5;
		for i = 1, #mods, 1 do
			chances.calc = chances.calc * mods[i];
		end
		chances.calc = 1.0 - (chances.calc * (1.0 - level:GetAngelRoomChance()));
	end
	chances.devil = chances.deal * (1.0 - chances.calc);
	chances.angel = chances.deal * chances.calc;

	if (devil_spawned and not devil_visited) or book_of_virtues then
		local tmp = chances.devil;
		chances.devil = chances.angel;
		chances.angel = tmp;
		if book_of_virtues and angel_spawned then
			chances.devil = chances.angel * 0.375;
			chances.angel = chances.angel - chances.devil;
			return chances;
		end
	end

	if devil_spawned and angel_spawned and not devil_item_taken then
		local tmp = chances.devil + chances.angel;
		chances.devil = tmp / 2.0;
		chances.angel = tmp / 2.0;
	end

	return chances;
end

function Stats.GetLibraryChance()
	local chance = LibraryChance and LibraryChance.Util:GetData("LibraryChance", nil, LibraryChance.Enum.DataPersistenceFlag.RUN).LibraryChance or 0.0;
	-- Player Items
	for i = 1, game:GetNumPlayers(), 1 do
		-- Active Items 
		for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_SECONDARY do
			ID = Isaac.GetPlayer(i - 1):GetActiveItem(slot);
			if LibraryChance and (ID == LibraryChance.Collectible.Eudaimonia.ID or ID == LibraryChance.Collectible.Melancholicon.ID) then chance = chance + 0.1; end -- Needed because LibraryChance doesn't add this automatically
		end
	end
	if IsaacReflourished and IsaacReflourished.SaveManager.GetDeadSeaScrollsSave().Toggles["MoreLibrariesHoldingBookEnabled"] and game:GetStateFlag(GameStateFlag.STATE_BOOK_PICKED_UP) then chance = chance + 0.2; end
	return math.min(1.0, chance);
end

function Stats.GetStat(value, stat, is_percent)
	return {
		Frame = stat,
		Text = {Value = string.format(is_percent and '%.1f%%' or '%.2f', value)},
		IsPercent = is_percent,
		Value = value,
	};
end

function Stats.GetStats(player_entity, player_number)
	local stats = {};
	stats[CoopHUD.StatType.SPEED] = Stats.GetStat(player_entity.MoveSpeed, CoopHUD.StatType.SPEED, false);
	stats[CoopHUD.StatType.FIRE_DELAY] = Stats.GetStat(30 / (player_entity.MaxFireDelay + 1), CoopHUD.StatType.FIRE_DELAY, false);
	stats[CoopHUD.StatType.DAMAGE] = Stats.GetStat(player_entity.Damage, CoopHUD.StatType.DAMAGE, false);
	stats[CoopHUD.StatType.RANGE] = Stats.GetStat(player_entity.TearRange / 40, CoopHUD.StatType.RANGE, false);
	stats[CoopHUD.StatType.SHOT_SPEED] = Stats.GetStat(player_entity.ShotSpeed, CoopHUD.StatType.SHOT_SPEED, false);
	stats[CoopHUD.StatType.LUCK] = Stats.GetStat(player_entity.Luck, CoopHUD.StatType.LUCK, false);

	if player_number == 1 then
		local chances = Stats.GetDevilAngelChance()
		if chances.duality then
			stats[CoopHUD.StatType.DEVIL] = Stats.GetStat(chances.devil * 100, CoopHUD.StatType.DUALITY, true);
		else
			stats[CoopHUD.StatType.DEVIL] = Stats.GetStat(chances.devil * 100, CoopHUD.StatType.DEVIL, true);
			stats[CoopHUD.StatType.ANGEL] = Stats.GetStat(chances.angel * 100, CoopHUD.StatType.ANGEL, true);
		end
		stats[CoopHUD.StatType.PLANETARIUM] = Stats.GetStat(game:GetLevel():GetPlanetariumChance() * 100, CoopHUD.StatType.PLANETARIUM, true);
		if mod.Config.CoopHUD.stats.library_chance then
			local library_chance = Stats.GetLibraryChance();
			stats[CoopHUD.StatType.LIBRARY] = Stats.GetStat(library_chance * 100, 0, true);
			stats[CoopHUD.StatType.LIBRARY].Sprite = Sprite("gfx/ui/ui_librarychance.anm2", true);
			stats[CoopHUD.StatType.LIBRARY].Scale = Vector(0.85,0.85);
		end
		if game:IsGreedMode() and mod.UnlocksAllowed and (mod.Config.CoopHUD.stats.greed_display or #Isaac.FindByType(EntityType.ENTITY_SLOT,SlotVariant.GREED_DONATION_MACHINE, -1) > 0) then
			stats[CoopHUD.StatType.GREED] = Stats.GetStat(player_entity:GetGreedDonationBreakChance(),CoopHUD.MiscType.GREED_MACHINE,true);
			stats[CoopHUD.StatType.GREED].Sprite = Sprite(mod.Animations.Misc, true);
			stats[CoopHUD.StatType.GREED].Scale = Vector(0.8,0.9);
		end
	end

	local oldStats = DATA.Players[player_number] and DATA.Players[player_number].Stats and DATA.Players[player_number].Stats.Data or {};
	for i, stat in pairs(stats) do
		local oldStat = oldStats[i];
		if oldStat and stat.Value ~= oldStat.Value then
			local val = stat.Value - oldStat.Value;
			if DATA.Players[player_number].Stats.Updates[i] then
				val = DATA.Players[player_number].Stats.Updates[i].Value + val;
			end
			DATA.Players[player_number].Stats.Updates[i] = {Value = val, Frames = (mod.Config.CoopHUD.stats.text.update.duration * 30)};
		end
	end
	Stats.Stats = stats;
	return stats;
end

function Stats.Render(player_number)
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	local stats = player_data.Stats;
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_STATS_RENDER, player_number, mod.CoopHUD.DATA.Players[player_number].Stats); -- Execute Pre Stats Render Callbacks (stats_data(table))
	
	if not stats.Visible and not mod.CoopHUD.Stats.Deals.Visible then return; end
	
	local updates = stats.Updates;
	
	for i,stat in pairs(stats.Data) do
		if stat and stat.Sprite and ((stats.Visible and i < CoopHUD.StatType.DEVIL) or (mod.CoopHUD.Stats.Deals.Visible and i >= CoopHUD.StatType.DEVIL)) then
			
			if stat.Render then
				stat.Sprite.Scale = stat.Scale;
				stat.Sprite:SetFrame('Idle', stat.Frame);
				stat.Sprite:Render(stat.Pos);
			end
			
			if stat.Text then
				mod.Fonts.CoopHUD.stats:DrawStringScaled(
					stat.Text.Value,
					stat.Text.Pos.X, stat.Text.Pos.Y,
					mod.Config.CoopHUD.stats.text.scale.X,
					mod.Config.CoopHUD.stats.text.scale.Y,
					KColor(stat.Color.R,stat.Color.G,stat.Color.B, 0.5), stat.Text.Width or 0, stat.Text.Center or true
				);
			end
		
			if updates[i] then
				updates[i].Frames = updates[i].Frames - 1;
				if updates[i].Frames < 0 or (updates[i].Value > 0 and updates[i].Value < 0.1) or updates[i].Pos == nil then 
					updates[i] = nil;
				else
					mod.Fonts.CoopHUD.stats:DrawStringScaled(
						updates[i].Text.Value,
						updates[i].Pos.X, updates[i].Pos.Y,
						mod.Config.CoopHUD.stats.text.scale.X,
						mod.Config.CoopHUD.stats.text.scale.Y,
						updates[i].Color, updates[i].Text.Width or 0, updates[i].Text.Center or true
					);
				end
			end
		end
	end
end
