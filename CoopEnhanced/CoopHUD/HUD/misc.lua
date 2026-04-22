local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Misc = CoopHUD.Misc;
local DATA = CoopHUD.DATA;

local Utils = mod.Utils;

local game = Game();

function Misc.GetPickup(pickup_type)
	if not mod.CoopHUD.Misc.Pickups then return; end
	for i,pickup in pairs(mod.CoopHUD.Misc.Pickups) do
		if pickup.Type == pickup_type then return pickup, i; end
	end
	return nil;
end

function Misc.GetPickups(screen_dimensions)
	if not mod.CoopHUD.Misc.Pickups then mod.CoopHUD.Misc.Pickups = {}; end
	
	local pickups = {};
	local player_entity = game:GetPlayer();
	
	pickups[1] = {Sprite = Misc.GetSprite(mod.CoopHUD.Misc.Pickups[1] and mod.CoopHUD.Misc.Pickups[1].Sprite or nil, CoopHUD.MiscType.COIN), Type = "Coin", Value = player_entity:GetNumCoins() or 0};

	local bomb_sprite = player_entity:GetNumGigaBombs() > 0 and CoopHUD.MiscType.GIGA_BOMB or (player_entity:HasGoldenBomb() and CoopHUD.MiscType.GOLDEN_BOMB or CoopHUD.MiscType.BOMB);
	pickups[2] = {Sprite = Misc.GetSprite(mod.CoopHUD.Misc.Pickups[2] and mod.CoopHUD.Misc.Pickups[2].Sprite or nil, bomb_sprite), Type = "Bomb", Value = player_entity:GetNumBombs() or 0};
		
	local key_sprite = player_entity:HasGoldenKey() and CoopHUD.MiscType.GOLDEN_KEY or CoopHUD.MiscType.KEY;
	pickups[3] = {Sprite = Misc.GetSprite(mod.CoopHUD.Misc.Pickups[3] and mod.CoopHUD.Misc.Pickups[3].Sprite or nil, key_sprite), Type = "Key", Value = player_entity:GetNumKeys() or 0};
	
	if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BLUEBABY_B) then
		local poop = {Sprite = Misc.GetSprite(mod.CoopHUD.Misc.Pickups[4] and mod.CoopHUD.Misc.Pickups[4].Sprite or nil, CoopHUD.MiscType.POOP), Type = "Poop", Value = player_entity:GetPoopMana() or 0};
		if Utils.AnyoneIsNotPlayerType(PlayerType.PLAYER_BLUEBABY_B) then pickups[4] = poop; else pickups[2] = poop; end
	else 
		pickups[4] = {};
	end
	if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BETHANY) then
		pickups[5] = {Sprite = Misc.GetSprite(mod.CoopHUD.Misc.Pickups[5] and mod.CoopHUD.Misc.Pickups[5].Sprite or nil, CoopHUD.MiscType.SOUL_HEART), Type = "Soul", Value = player_entity:GetSoulCharge() or 0};
	else 
		pickups[5] = {};
	end
	if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BETHANY_B) then
		pickups[6] = {Sprite = Misc.GetSprite(mod.CoopHUD.Misc.Pickups[6] and mod.CoopHUD.Misc.Pickups[6].Sprite or nil, CoopHUD.MiscType.RED_HEART), Type = "Blood", Value = player_entity:GetBloodCharge() or 0};
	else 
		pickups[6] = {};
	end
	
	
	mod.CoopHUD.Misc.Pickups.Visible = (mod.Config.CoopHUD.misc.pickups.display == 0 or (mod.Config.CoopHUD.misc.pickups.display == 1 and CoopHUD.IsMapDown or (mod.Config.CoopHUD.misc.pickups.display == 2 and not CoopHUD.IsMapDown or false)));
	if not mod.CoopHUD.Misc.Pickups.Visible then return; end
	
	local pos = Utils.CloneObject(CoopHUD.Positions.Pickups);
	local offset = mod.Config.CoopHUD.offset;
	local anchor = mod.Config.CoopHUD.misc.pickups.anchor;
	local edge_multipliers = Vector(anchor < 3 and -1 or 1,anchor == 1 and -1 or 1);
	local scale = mod.Config.CoopHUD.misc.pickups.scale;
	local size = 14 * scale.X;
	local seperation = 0;
	local total_width = 0;
	local pickups_total = 0;

	if anchor < 2 then
		for i,pickup in ipairs(mod.CoopHUD.Misc.Pickups) do
			if pickup and pickup.Data ~= nil then
				total_width = total_width + (((pickup.Data.Text.Font:GetStringWidth(pickup.Data.Text.Value)) * scale.X) + (size * 2));
				pickups_total = pickups_total + 1;
			end
		end
		local other_data = mod.CoopHUD.Stats.Deals.Anchor == anchor and mod.CoopHUD.Stats.Deals.Visible and mod.CoopHUD.Stats.Deals.Data[1] or nil;
		pos.X = (screen_dimensions.Center.X - (total_width / 2));
		pos.Y = (other_data and (other_data.Pos.Y + (anchor == 0 and (-size * scale.X) or (size * mod.Config.CoopHUD.stats.scale.Y)))) or ((anchor == 0 and (screen_dimensions.Max.Y - size) or 0) + (offset.Y * edge_multipliers.Y));
	else
		pos.X = pos.X + (anchor == 2 and (screen_dimensions.Max.X - (pos.X + (size + 5) or 0)) + (offset.X * edge_multipliers.X));
	end
	pos = pos + ((mod.Config.CoopHUD.misc.pickups.offset) * edge_multipliers);
	
	for i,pickup in ipairs(pickups) do
		local pickup_data = {};
		if pickup and pickup.Value ~= nil then
			if anchor < 2 then 
				pos.X = pos.X + size + seperation;
			else
				pos.Y = pos.Y + size;
			end
			local text_value = string.format('%02d', pickup.Value);
			local text_pos = (pos + ((Vector((size + 2) - (anchor == 2 and (mod.Fonts.CoopHUD.pickups:GetStringWidth(string.rep("0",text_value:len())) * 2) or 0),1) * scale) + mod.Config.CoopHUD.misc.pickups.text_offset));
			pickup_data.Sprite = pickup.Sprite;
			pickup_data.Data = {Pos = Utils.CloneObject(pos), Text = {Pos = text_pos, Value = text_value, Scale = scale, Font = mod.Fonts.CoopHUD.pickups}, Scale = scale, Type = pickup.Type};
			seperation = (mod.Fonts.CoopHUD.pickups:GetStringWidth(text_value) + 2) * scale.X;
		end
		mod.CoopHUD.Misc.Pickups[i] = pickup_data;
	end
	mod.CoopHUD.Misc.Pickups.Total = pickups_total;
end

function Misc.GetWave(screen_dimensions)
	if not mod.CoopHUD.Misc.Wave then mod.CoopHUD.Misc.Wave = {[1] = {}}; end
	mod.CoopHUD.Misc.Wave[1].Data = {};
		
	local wave_type = game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH and CoopHUD.WaveType.BOSSRUSH or ((game:IsGreedMode() and stage ~= LevelStage.STAGE7_GREED and game:GetLevel():GetCurrentRoomIndex() == game:GetLevel():GetStartingRoomIndex() and (game.Difficulty == Difficulty.DIFFICULTY_GREEDIER and CoopHUD.WaveType.GREEDIER or CoopHUD.WaveType.GREED)) or (game:GetRoom():GetBossID() == BossType.GREAT_GIDEON and CoopHUD.WaveType.GIDEON or nil));
	if not wave_type then mod.CoopHUD.Misc.Wave.Visible = false; return; end
	
	mod.CoopHUD.Misc.Wave.Visible = (mod.Config.CoopHUD.misc.wave.display == 0 or (mod.Config.CoopHUD.misc.wave.display == 1 and CoopHUD.IsMapDown or (mod.Config.CoopHUD.misc.wave.display == 2 and not CoopHUD.IsMapDown or false)));
	if not mod.CoopHUD.Misc.Wave.Visible then return; end
	
	local max_waves = wave_type == CoopHUD.WaveType.BOSSRUSH and Ambush.GetMaxBossrushWaves() or ((wave_type == CoopHUD.WaveType.GREED or wave_type == CoopHUD.WaveType.GREEDIER) and (game:GetGreedWavesNum() - 1) or 6);
	local wave = wave_type == CoopHUD.WaveType.BOSSRUSH and Ambush.GetCurrentWave() or ((wave_type == CoopHUD.WaveType.GREED or wave_type == CoopHUD.WaveType.GREEDIER) and (game:GetLevel().GreedModeWave) or 0);
	
	-- Temporary fix until Gideon Waves are exposed to the API
	if wave_type == CoopHUD.WaveType.GIDEON then
		if not Isaac.FindByType(EntityType.ENTITY_GIDEON)[1] then return; end
		if not CoopHUD.Misc.Gideon then
			local function gideonWaveTracker(_,entity_type,_,_,_,_,spawner_entity)
				if entity_type == EntityType.ENTITY_EFFECT or entity_type < EntityType.ENTITY_GAPER then return; end
				local gideon_entity = Isaac.FindByType(EntityType.ENTITY_GIDEON)[1];
				if not gideon_entity then
					CoopHUD.Misc.Gideon = nil;
					mod:RemoveCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, gideonWaveTracker);
					return;
				end
				if not spawner_entity or spawner_entity.Type ~= EntityType.ENTITY_GIDEON or game:GetFrameCount() < CoopHUD.Misc.Gideon.Cooldown then return; end
				CoopHUD.Misc.Gideon.Cooldown = game:GetFrameCount() + 60;
				CoopHUD.Misc.Gideon.Wave = CoopHUD.Misc.Gideon.Wave + 1;
			end
			mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, gideonWaveTracker);
			CoopHUD.Misc.Gideon = {Cooldown = (game:GetFrameCount() + 60), Wave = wave};
		else
			wave = CoopHUD.Misc.Gideon.Wave;
		end
	end
	
	local anchor = mod.Config.CoopHUD.misc.wave.anchor;
	local offset = mod.Config.CoopHUD.offset;
	local scale = mod.Config.CoopHUD.misc.wave.scale;
	local size = 15 * scale.X;
	local edge_multipliers = Vector(anchor < 3 and -1 or 1,anchor == 0 and -1 or 1);
	
	local text = {Value = string.format('%d/%d', wave, max_waves), Pos = Vector.Zero, Font = mod.Fonts.CoopHUD.misc, Width = 1, Center = false};
	text.Scale = mod.Config.CoopHUD.misc.wave.text_scale;
	local text_width = mod.Fonts.CoopHUD.misc:GetStringWidth("00/00") * text.Scale.X;
	local text_height = mod.Fonts.CoopHUD.misc:GetBaselineHeight(text.Value) * text.Scale.Y;
	
	text.Scale = mod.Config.CoopHUD.misc.wave.text_scale;
	text.Pos.X = anchor == 2 and (screen_dimensions.Max.X - (text_width / 1.5)) or (anchor == 3 and (text_width / 1.1) or (screen_dimensions.Center.X + (4 * text.Scale.X)));
	
	if anchor < 2 then
		local other_data = (mod.Config.CoopHUD.misc.pickups.anchor == anchor and mod.CoopHUD.Misc.Pickups.Visible and CoopHUD.Misc.Pickups[1].Data) or (CoopHUD.Stats.Deals.Anchor == anchor and mod.CoopHUD.Stats.Deals.Visible and CoopHUD.Stats.Deals.Data[1] or nil);
		if other_data then
			other_data.Text.Font = other_data.Text.Font or mod.Fonts.CoopHUD.stats;
			local other_height = (other_data.Text.Font:GetBaselineHeight("0") + 2) * (other_data.Text.Scale and other_data.Text.Scale.Y or other_data.Scale.Y);
			text.Pos.Y = other_data.Text.Pos.Y + (anchor == 0 and -size or other_height);
		else
			text.Pos.Y = (anchor == 0 and screen_dimensions.Max.Y - size or 2) + (offset.Y * edge_multipliers.Y);
		end
	else
		text.Pos.X = ((edge_multipliers.X < 0 and (screen_dimensions.Max.X - (text_width / 2)) or text_width) + (offset.X * edge_multipliers.X));
		text.Pos.Y = CoopHUD.Positions.Difficulty.Y + (text_height * 1.5);
	end
	pos = text.Pos + Vector((-text_width - 8) * scale.X,(text_height / -1.45) * scale.Y);
	text.Pos = text.Pos + ((mod.Config.CoopHUD.misc.wave.text_offset + mod.Config.CoopHUD.misc.wave.offset) * edge_multipliers);
	pos = pos + ((mod.Config.CoopHUD.misc.wave.offset) * edge_multipliers);
	
	local sprite = mod.Config.CoopHUD.misc.wave.background and (mod.CoopHUD.Misc.Wave[1].Sprite or Sprite(mod.Animations.Waves,true)) or nil;
	if sprite then sprite:SetFrame(wave_type, 0); end
	mod.CoopHUD.Misc.Wave[1] = {Sprite = sprite, Data = {Pos = pos, Text = text, Scale = scale, Type = wave_type, Wave = {Current = wave, Max = max_waves}}};
end

function Misc.GetDifficulty(screen_dimensions)
	if not mod.CoopHUD.Misc.Difficulty then mod.CoopHUD.Misc.Difficulty = {[1] = {}}; end
	mod.CoopHUD.Misc.Difficulty[1].Data = {};
	
	local diffMap = {
		[Difficulty.DIFFICULTY_NORMAL] = nil,
		[Difficulty.DIFFICULTY_HARD] = CoopHUD.MiscType.HARD,
		[Difficulty.DIFFICULTY_GREED] = CoopHUD.MiscType.GREED,
		[Difficulty.DIFFICULTY_GREEDIER] = CoopHUD.MiscType.GREEDIER,
	};
	local challenge = mod.Challenge;
	local difficulty = challenge.ID == Challenge.CHALLENGE_NULL and diffMap[game.Difficulty] or nil;
	if not difficulty and challenge.ID == Challenge.CHALLENGE_NULL then 
		mod.CoopHUD.Misc.Difficulty.Visible = false;
		return;
	end
	
	mod.CoopHUD.Misc.Difficulty.Visible = (mod.Config.CoopHUD.misc.difficulty.display == 0 or (mod.Config.CoopHUD.misc.difficulty.display == 1 and CoopHUD.IsMapDown or (mod.Config.CoopHUD.misc.difficulty.display == 2 and not CoopHUD.IsMapDown or false)));
	if not mod.CoopHUD.Misc.Difficulty.Visible then return; end
	
	local pos = Utils.CloneObject(CoopHUD.Positions.Difficulty);
	local offset = mod.Config.CoopHUD.offset;
	local anchor = mod.Config.CoopHUD.misc.difficulty.anchor;
	local scale = mod.Config.CoopHUD.misc.difficulty.scale;
	local size = 16 * scale.X;
	local edge_multipliers = Vector(anchor < 3 and -1 or 1,anchor == 1 and -1 or 1);
	
	if anchor < 2 then
		local other_data = (CoopHUD.Stats.Deals.Anchor == anchor and mod.CoopHUD.Stats.Deals.Visible and CoopHUD.Stats.Deals.Data[1]) or (mod.Config.CoopHUD.misc.pickups.anchor == anchor and mod.CoopHUD.Misc.Pickups.Visible and CoopHUD.Misc.Pickups[1].Data or (mod.Config.CoopHUD.misc.wave.anchor == anchor and mod.CoopHUD.Misc.Wave.Visible and CoopHUD.Misc.Wave[1].Data)) or nil;
		if other_data then
			pos.X = other_data.Pos.X - size;
		else
			pos.X = screen_dimensions.Center.X - (size / 2);
		end
		pos.Y = offset.Y + (anchor == 0 and screen_dimensions.Max.Y - size or 0);
	else
		pos.X = pos.X + ((anchor == 2 and (screen_dimensions.Max.X - (pos.X + (size * 2))) or 0) + (offset.X * edge_multipliers.X));
	end
	pos = pos + ((mod.Config.CoopHUD.misc.difficulty.offset) * edge_multipliers);
	
	local sprite = challenge.ID == Challenge.CHALLENGE_NULL and Misc.GetSprite(mod.CoopHUD.Misc.Difficulty[1].Sprite, difficulty) or (mod.CoopHUD.Misc.Difficulty[1].Sprite or Misc.GetDestination());
	mod.CoopHUD.Misc.Difficulty[1] = {Sprite = sprite, Data = {Pos = pos, Scale = scale}};
end

function Misc.GetExtra(screen_dimensions)
	if not mod.CoopHUD.Misc.Extra then mod.CoopHUD.Misc.Extra = {[1] = {},[2] = {}}; end
	mod.CoopHUD.Misc.Extra[1].Data = {};
	mod.CoopHUD.Misc.Extra[2].Data = {};
	if mod.UnlocksAllowed and game:GetVictoryLap() == 0 then
		mod.CoopHUD.Misc.Extra.Visible = false;
		return;
	end
	
	mod.CoopHUD.Misc.Extra.Visible = (mod.Config.CoopHUD.misc.extra.display == 0 or (mod.Config.CoopHUD.misc.extra.display == 1 and CoopHUD.IsMapDown or (mod.Config.CoopHUD.misc.extra.display == 2 and not CoopHUD.IsMapDown or false)));
	if not mod.CoopHUD.Misc.Extra.Visible then return; end
	
	local pos = Utils.CloneObject(CoopHUD.Positions.Difficulty);
	local anchor = mod.Config.CoopHUD.misc.extra.anchor;
	local scale = mod.Config.CoopHUD.misc.extra.scale;
	local size = 16 * scale.X;
	local offset = mod.Config.CoopHUD.offset;
	local edge_multipliers = Vector(anchor < 3 and -1 or 1,anchor == 1 and -1 or 1);
	local diff_offset = mod.Config.CoopHUD.misc.difficulty.anchor == anchor and mod.CoopHUD.Misc.Difficulty.Visible and (8 * mod.Config.CoopHUD.misc.difficulty.scale.X) or 0;
	
	if anchor < 2 then
		local other_data = (CoopHUD.Stats.Deals.Anchor == anchor and mod.CoopHUD.Stats.Deals.Visible and CoopHUD.Stats.Deals.Data[#CoopHUD.Stats.Deals.Data]) or (mod.Config.CoopHUD.misc.pickups.anchor == anchor and mod.CoopHUD.Misc.Pickups.Visible and CoopHUD.Misc.Pickups[#CoopHUD.Misc.Pickups].Data or (mod.Config.CoopHUD.misc.wave.anchor == anchor and mod.CoopHUD.Misc.Wave.Visible and CoopHUD.Misc.Wave[1].Data)) or nil;
		if other_data then
			other_data.Text.Font = other_data.Text.Font or mod.Fonts.CoopHUD.stats;
			diff_offset = 0;
			pos.X = (other_data.Text.Pos.X + (6 + other_data.Text.Font:GetStringWidth(other_data.Text.Value)) * (other_data.Text.Scale and other_data.Text.Scale.X or other_data.Scale.X));
		else
			pos.X = screen_dimensions.Center.X - (size / 2);
		end
		pos.Y = (anchor == 0 and screen_dimensions.Max.Y - size or 0) + (offset.Y * edge_multipliers.Y);
	else
		pos.X = pos.X + ((anchor == 2 and (screen_dimensions.Max.X - (pos.X + (size * 2))) or 0) + (offset.X * edge_multipliers.X));
	end
	pos = pos + ((mod.Config.CoopHUD.misc.extra.offset) * edge_multipliers) + Vector(diff_offset,0);
	mod.CoopHUD.Misc.Difficulty[1].Data.Pos.X = mod.CoopHUD.Misc.Difficulty[1].Data.Pos.X - diff_offset;
		
	if not mod.UnlocksAllowed then
		local sprite = Misc.GetSprite(mod.CoopHUD.Misc.Extra[1].Sprite, CoopHUD.MiscType.NO_ACHIEVEMENTS);
		mod.CoopHUD.Misc.Extra[1] = {Sprite = sprite, Data = {Pos = Utils.CloneObject(pos), Scale = scale}};
	end
	if game:GetVictoryLap() > 0 then
		if not mod.UnlocksAllowed then pos.X = pos.X + size; end
		local text_pos = pos + Vector(size + 2,0);
		local sprite = Misc.GetSprite(mod.CoopHUD.Misc.Extra[2].Sprite, CoopHUD.MiscType.VICTORY_LAP);
		mod.CoopHUD.Misc.Extra[2] = {Sprite = sprite, Data = {Pos = pos, Text = {Value = game:GetVictoryLap(), Pos = text_pos, Font = mod.Fonts.CoopHUD.misc, Scale = scale}, Scale = scale}};
	end
end

function Misc.GetDestination()
	if mod.Challenge.ID == Challenge.CHALLENGE_NULL then return nil; end
	local sprite = Sprite();
	local params = mod.Challenge.Params;
	local destination = 0;
	local anim_name = "Destination";
	
	if not params then return; end
	if mod.Challenge.IsDaily then
		anim_name = "Idle";
		destination = CoopHUD.MiscType.DAILY;
	elseif params:GetEndStage() == LevelStage.STAGE3_2 and not params:IsSecretPath() then destination = CoopHUD.Destination.MOM;
	elseif params:GetEndStage() == LevelStage.STAGE3_2 then destination = CoopHUD.Destination.MOM; sprite.Color = Utils.GetColorByName("Violet"); -- Color Mausoleum Mom
	elseif params:GetEndStage() == LevelStage.STAGE4_2 then destination = CoopHUD.Destination.HEART;
	elseif params:GetEndStage() == LevelStage.STAGE5 and not params:IsAltPath() then destination = CoopHUD.Destination.SATAN;
	elseif params:GetEndStage() == LevelStage.STAGE5 and params:IsAltPath() then destination = CoopHUD.Destination.ISAAC;
	elseif params:GetEndStage() == LevelStage.STAGE6 and not params:IsAltPath() then destination = CoopHUD.Destination.LAMB;
	elseif params:IsMegaSatanRun() then destination = CoopHUD.Destination.MEGA;
	elseif params:GetEndStage() == LevelStage.STAGE6 and params:IsAltPath() then destination = CoopHUD.Destination.CHEST;
	elseif params:GetEndStage() == LevelStage.STAGE4_3 then destination = CoopHUD.Destination.HUSH;
	elseif params:GetEndStage() == LevelStage.STAGE4_2 and params:IsSecretPath() then destination = CoopHUD.Destination.CORPSE;
	elseif params:IsBeastPath() then destination = CoopHUD.Destination.BEAST;
	else
		anim_name = "Idle";
		destination = CoopHUD.MiscType.VICTORY_LAP;
	end
	return Misc.GetSprite(sprite,destination,anim_name);
end

function Misc.GetSprite(sprite, frame, anim)
	sprite = sprite or Sprite();
	sprite:Load(mod.Animations.Misc, true);
	sprite:SetFrame((anim or 'Idle'), frame);
	return sprite;
end

function Misc.Render(screen_dimensions)
	if CoopHUD.Refresh then
		Misc.GetPickups(screen_dimensions);
		Misc.GetWave(screen_dimensions);
		Misc.GetDifficulty(screen_dimensions);
		Misc.GetExtra(screen_dimensions);
		
		mod.CoopHUD.Misc.Data = {};
		if mod.CoopHUD.Misc.Pickups.Visible then mod.CoopHUD.Misc.Data["Pickups"] = mod.CoopHUD.Misc.Pickups; end
		if mod.CoopHUD.Misc.Difficulty.Visible then mod.CoopHUD.Misc.Data["Difficulty"] = mod.CoopHUD.Misc.Difficulty; end
		if mod.CoopHUD.Misc.Wave.Visible then mod.CoopHUD.Misc.Data["Wave"] = mod.CoopHUD.Misc.Wave; end
		if mod.CoopHUD.Misc.Extra.Visible then mod.CoopHUD.Misc.Data["Extra"] = mod.CoopHUD.Misc.Extra; end
		
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_MISC_UPDATE,mod.CoopHUD.Misc.Data);
	end
	
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_MISC_RENDER,mod.CoopHUD.Misc.Data);
	
	if mod.CoopHUD.Misc.Data then
		for n,tbl in pairs(mod.CoopHUD.Misc.Data) do
			for i,misc in ipairs(tbl) do
				if misc.Data then
					if misc.Sprite and misc.Data.Pos then
						misc.Sprite.Scale = misc.Data.Scale;
						if misc.Data.Animated then misc.Sprite:Update(); end
						misc.Sprite:Render(misc.Data.Pos);
					end
					
					if misc.Data.Text and misc.Data.Text.Value then
						misc.Data.Text.Font:DrawStringScaled(
							misc.Data.Text.Value,
							misc.Data.Text.Pos.X, misc.Data.Text.Pos.Y,
							misc.Data.Text.Scale.X, misc.Data.Text.Scale.Y,
							KColor.White, misc.Data.Text.Width or 0, misc.Data.Text.Center or true
						);
					end
				end
			end
		end
	end
end