local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Player = CoopHUD.Player;

local Colors = mod.Colors;
local Utils = mod.Utils;

local game = Game();

local function setDefaultHUDNEW(bool) -- Not Working, Need more HUD api to truly work
	local SPRITES = {
		CARDS = Game():GetHUD():GetCardsPillsSprite(),
		CHARGE = Game():GetHUD():GetChargeBarSprite(),
		CRAFT = Game():GetHUD():GetCraftingSprite(),
		COOP = Game():GetHUD():GetCoopMenuSprite(),
		FORTUNE = Game():GetHUD():GetFortuneSprite(),
		INVENTORY = Game():GetHUD():GetInventorySprite(),
		PICKUPS = Game():GetHUD():GetPickupsHUDSprite(),
		Banner = Game():GetHUD():GetBannerSprite(),
		POOP = Game():GetHUD():GetPoopSpellSprite(),
	};
	Game():GetHUD():GetPickupsHUDSprite():GetLayer(0):SetVisible(false);
	Game():GetHUD():GetPickupsHUDSprite():GetLayer(1):SetVisible(false);
	Game():GetHUD():GetPickupsHUDSprite():Update();
	for k,v in pairs(SPRITES) do
		for i = 0, #v:GetAllLayers() - 1, 1 do
			v:GetLayer(i):SetVisible(CoopHUD.isVisible);
			print(v:GetLayer(i):GetName());
		end
	end
end

local function leadingZero(val)
	if val<10 and val>=0 then
		return '0'..val;
	end
	return val;
end

local function refreshTimer(timeString)
	if game:IsPaused() then	return timeString or "00:00:00"; end

	local time = game.TimeCounter;
	local secs = math.floor(time/30)%60;
	local mins = math.floor(time/30/60)%60;
	local hours = math.floor(time/30/60/60)%24;
	timeString = leadingZero(hours)..':'..leadingZero(mins)..':'..leadingZero(secs);

	return timeString;
end

local map_frames = 0;
function CoopHUD.RenderPlayers(screen_dimensions)
	if game:GetNumPlayers() > 0 then
		local players = {};
		local num_twins = 0;
		local player_sync = mod.Config.CoopHUD.player_sync;
		if mod.CoopHUD.DATA.Players == nil then mod.CoopHUD.DATA.Players = {}; end
		
		for i = 1, game:GetNumPlayers(), 1 do
			local index = i;
			local player_index = 0;
			local player_entity = Isaac.GetPlayer(i - 1);
			if not player_entity then return; end -- Something went horribly wrong (or horribly right)
			local edge = {Pos = Utils.Clone(screen_dimensions.Min), Offset = Utils.Clone(mod.Config.CoopHUD.offset), Multipliers = Vector.One};
			
			if mod.Players.Twins[i] then
				index = -i;
				num_twins = num_twins + 1;
				player_index = mod.Players.Twins[i];
				edge.Pos = edge.Pos + mod.Config.CoopHUD.players.twins.offset;
				if mod.Config.CoopHUD.players.twins.offset_w_pockets and mod.CoopHUD.DATA.Players[player_index] and mod.CoopHUD.DATA.Players[player_index].Inventory.Pocket.Total > 0 then
					edge.Pos.Y = edge.Pos.Y + mod.CoopHUD.DATA.Players[player_index].Inventory.Pocket.Total * (32 * mod.Config.CoopHUD.pocket[(mod.CoopHUD.DATA.Players[player_index].Inventory.Pocket.Total - 1)].scale.Y);
				end
			else
				player_index = i - num_twins;
				local map_down = Input.IsActionPressed(ButtonAction.ACTION_MAP, player_entity.ControllerIndex);
				CoopHUD.IsMapDown = CoopHUD.IsMapDown or map_down;
				CoopHUD.IsPlayerMapDown[player_entity.ControllerIndex] = map_down;
				if map_down then
					map_frames = map_frames + 1;
				else
					if map_frames > 1 and map_frames <= mod.Config.CoopHUD.toggle_hud.frames then CoopHUD.IsMapToggled = not CoopHUD.IsMapToggled; end
					map_frames = 0;
				end
				if not game:IsPaused() and Input.IsActionTriggered(ButtonAction.ACTION_DROP, player_entity.ControllerIndex) then
					local player_data = mod.CoopHUD.DATA.Players[index];
					if player_data then CoopHUD.Item.Inventory.Shift(player_data); end
				end
			end
			
			local player_config = player_sync == "Global" and mod.Config.players[player_index] or (mod.Config[player_sync] and mod.Config[player_sync].players[player_index] or mod.Config.CoopHUD.players[player_index]);
			
			if player_index == 0 or player_config == nil then break; end --Should never be Zero or above 4
			local player_name = Utils.GetPlayerName(player_entity, player_index, player_config.type, player_config.name, mod.Config.players.tainted_names);
			local player_scale = (index > 0 and mod.Config.CoopHUD.players[player_index].scale or mod.Config.CoopHUD.players.twins.scale);
			
			-- Edge Stuff
			if (player_index % 2) == 0 then
				edge.Offset.X = -edge.Offset.X;
				edge.Pos.X = screen_dimensions.Max.X - (edge.Pos.X + mod.Config.CoopHUD.players.mirrored_offset.X);
				edge.Multipliers.X = -1;
			end
			if player_index > 2 then
				edge.Offset.Y = -edge.Offset.Y;
				edge.Pos.Y = screen_dimensions.Max.Y - (edge.Pos.Y + mod.Config.CoopHUD.players.mirrored_offset.Y);
				edge.Multipliers.Y = -1;
			end
			edge.Offset = edge.Offset + mod.Config.CoopHUD.players[player_index].offset;
			
			if not mod.CoopHUD.DATA.Players[index] then
				mod.CoopHUD.DATA.Players[index] = {
					ID = Utils.GetPlayerID(player_entity),
					Inventory = {Active = {[0] = {},[1] = {},},Trinket = {[0] = {},[1] = {}},Pocket = {[0] = {},[1] = {},[2] = {},[3] = {},Total = 0},Passive = {},Special = {}},
					Stats = {Current = {},Updates = {},Data = {}},
					Label = {Sprite = Utils.GetHeadSprite(nil,player_entity)},
					Health = {}
				};
				CoopHUD.Item.Inventory.Reload(mod.CoopHUD.DATA.Players[index],player_entity);
				CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PLAYER_INIT, index, mod.CoopHUD.DATA.Players[index]); -- Execute Post Player Register Callbacks (index(number),player_data(table))
			end
			mod.CoopHUD.DATA.Players[index].Player = {Index = player_index,Config = player_config,Entity = EntityPtr(player_entity),Name = player_name,Type = player_entity:GetPlayerType(),Color = Colors[player_config.color].Value,Scale = (player_scale or Vector.One)};
			mod.CoopHUD.DATA.Players[index].Edge = edge;
			mod.CoopHUD.DATA.Players[index].Index = i;
			mod.CoopHUD.DATA.Players[index].Controller = player_entity.ControllerIndex;
			players[index] = true;
			
			CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_PLAYER_RENDER, index, mod.CoopHUD.DATA.Players[index]); -- Execute Pre Player Render Callbacks (index(number),player_data(table))
			
			Player.Render(index, screen_dimensions);
			
			CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_PLAYER_RENDER, index, mod.CoopHUD.DATA.Players[index]); -- Execute Post Player Render Callbacks (index(number),player_data(table))
			
		end
		-- Remove any players that no longer exist
		for i,_ in pairs(mod.CoopHUD.DATA.Players) do
			if not players[i] then mod.CoopHUD.DATA.Players[i] = nil; end
		end
	end
end

function CoopHUD.RenderBanners(screen_dimensions)
	if not mod.Config.CoopHUD.banner.display or not CoopHUD.DATA.Banner.Type or not CoopHUD.DATA.Banner.Sprite then return; end
	
	local frame = CoopHUD.DATA.Banner.Sprite:GetFrame();
	if frame < CoopHUD.DATA.Banner.Sprite:GetCurrentAnimationData():GetLength() / 2 or (CoopHUD.DATA.Banner.Type == CoopHUD.BannerType.FLOOR and not CoopHUD.IsMapDown) or game:GetFrameCount() > CoopHUD.DATA.Banner.Timer then
		CoopHUD.DATA.Banner.Sprite:Update();
	end
	
	if CoopHUD.DATA.Banner.Sprite:IsFinished() or (CoopHUD.DATA.Banner.Timer and game:GetFrameCount() > (CoopHUD.DATA.Banner.Timer + 1800)) then
		CoopHUD.DATA.Banner = {};
		return;
	end
	
	if not CoopHUD.DATA.Banner.Pos then 
		CoopHUD.DATA.Banner.Pos = screen_dimensions.Center;
		local anchor = mod.Config.CoopHUD.banner.anchor;
		local edge_multiplier = anchor == 1 and 1 or -1;
		if anchor > 0 then CoopHUD.DATA.Banner.Pos.Y = (anchor == 1 and mod.Config.CoopHUD.offset.Y or screen_dimensions.Max.Y - mod.Config.CoopHUD.offset.Y) + ((50 * mod.Config.CoopHUD.banner.scale.Y) * edge_multiplier); end
		CoopHUD.DATA.Banner.Pos = CoopHUD.DATA.Banner.Pos + Vector(mod.Config.CoopHUD.banner.offset.X,mod.Config.CoopHUD.banner.offset.Y * edge_multiplier);
	end
	
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_BANNER_RENDER, mod.CoopHUD.DATA.Banner);
	CoopHUD.DATA.Banner.Sprite:Render(CoopHUD.DATA.Banner.Pos, Vector.Zero, Vector.Zero);
	if frame > 5 and frame < 60 and CoopHUD.DATA.Banner.Name then
		mod.Fonts.CoopHUD.banners:DrawStringScaled(
			CoopHUD.DATA.Banner.Name,
			CoopHUD.DATA.Banner.Pos.X + mod.Config.CoopHUD.banner.name.offset.X - 2,
			CoopHUD.DATA.Banner.Pos.Y + mod.Config.CoopHUD.banner.name.offset.Y - (mod.Fonts.CoopHUD.banners:GetBaselineHeight(CoopHUD.DATA.Banner.Name) / 1.5),
			mod.Config.CoopHUD.banner.name.scale.X * mod.Config.CoopHUD.banner.scale.X,
			mod.Config.CoopHUD.banner.name.scale.Y * mod.Config.CoopHUD.banner.scale.Y,
			KColor.White, mod.Config.CoopHUD.banner.name.box_width, mod.Config.CoopHUD.banner.name.centered
		);
		if CoopHUD.DATA.Banner.Curse then
			local scale = mod.Config.CoopHUD.banner.curse.scale * mod.Config.CoopHUD.banner.scale;
			local text_pos = CoopHUD.DATA.Banner.Pos + mod.Config.CoopHUD.banner.curse.offset + Vector(0,(8 + mod.Fonts.CoopHUD.curse:GetBaselineHeight(CoopHUD.DATA.Banner.Desc)) * scale.Y);
			mod.Fonts.CoopHUD.curse:DrawStringScaled(
				CoopHUD.DATA.Banner.Desc,
				text_pos.X, text_pos.Y,
				scale.X, scale.Y ,
				KColor.Black, mod.Config.CoopHUD.banner.curse.box_width, mod.Config.CoopHUD.banner.curse.centered
			);
		elseif CoopHUD.DATA.Banner.Desc then
			local scale = mod.Config.CoopHUD.banner.description.scale * mod.Config.CoopHUD.banner.scale;
			local text_pos = CoopHUD.DATA.Banner.Pos + mod.Config.CoopHUD.banner.description.offset + Vector(0,(mod.Fonts.CoopHUD.description:GetBaselineHeight(CoopHUD.DATA.Banner.Desc) - 4) * scale.Y);
			mod.Fonts.CoopHUD.description:DrawStringScaled(
				CoopHUD.DATA.Banner.Desc,
				text_pos.X, text_pos.Y,
				scale.X, scale.Y,
				KColor.White, mod.Config.CoopHUD.banner.description.box_width, mod.Config.CoopHUD.banner.description.centered
			);
		end
	end
end

function CoopHUD.RenderScore(screen_dimensions)
	mod.CoopHUD.DATA.Score.Visible = CoopHUD.IsElementVisible(mod.Config.CoopHUD.misc.score.display);
	
	if mod.CoopHUD.DATA.Score.Visible then
		if CoopHUD.Refresh then
			ScoreSheet.Calculate();
			CoopHUD.DATA.Score.Value = ((mod.Config.CoopHUD.misc.score.show_text and "Score:   " or "") .. ScoreSheet.GetTotalScore());
			if not CoopHUD.DATA.Score.Value then return; end
			local anchor = mod.Config.CoopHUD.misc.score.anchor;
			local edge_multi = Vector(1,anchor == 2 and -1 or 1);
			CoopHUD.DATA.Score.Pos = screen_dimensions.Center - Vector(((mod.Fonts.CoopHUD.score:GetStringWidth(CoopHUD.DATA.Score.Value) * mod.Config.CoopHUD.misc.score.scale.X) / 2),0);
			if anchor > 0 then CoopHUD.DATA.Score.Pos.Y = anchor == 1 and mod.Config.CoopHUD.offset.Y or screen_dimensions.Max.Y - (mod.Config.CoopHUD.offset.Y + (mod.Fonts.CoopHUD.score:GetBaselineHeight() * mod.Config.CoopHUD.misc.score.scale.Y)); end
			CoopHUD.DATA.Score.Pos = CoopHUD.DATA.Score.Pos + (((mod.Config.CoopHUD.misc.timer.anchor == anchor and Vector(0,mod.Fonts.CoopHUD.timer:GetBaselineHeight()) or Vector.Zero) + mod.Config.CoopHUD.misc.score.offset) * edge_multi);
		end
		
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_SCORE_RENDER, mod.CoopHUD.DATA.Score);
		if CoopHUD.DATA.Score.Value then
			mod.Fonts.CoopHUD.score:DrawStringScaled(
				CoopHUD.DATA.Score.Value,
				CoopHUD.DATA.Score.Pos.X, CoopHUD.DATA.Score.Pos.Y,
				mod.Config.CoopHUD.misc.score.scale.X, mod.Config.CoopHUD.misc.score.scale.Y,
				KColor(1, 1, 1, mod.Config.CoopHUD.misc.score.opacity),
				mod.Fonts.CoopHUD.score:GetStringWidth(CoopHUD.DATA.Score.Value), true
			);
		end
	end
end

function CoopHUD.RenderTimer(screen_dimensions)
	mod.CoopHUD.DATA.Timer.Visible = CoopHUD.IsElementVisible(mod.Config.CoopHUD.misc.timer.display);
	
	if mod.CoopHUD.DATA.Timer.Visible then
		if CoopHUD.Refresh then
			CoopHUD.DATA.Timer.Value = ((mod.Config.CoopHUD.misc.timer.show_text and "Time: " or "") .. refreshTimer(CoopHUD.DATA.Timer.Value));
			if not CoopHUD.DATA.Timer.Value then return; end
			local anchor = mod.Config.CoopHUD.misc.timer.anchor;
			local edge_multi = Vector(1,anchor == 2 and -1 or 1);
			CoopHUD.DATA.Timer.Pos = screen_dimensions.Center - Vector(((mod.Fonts.CoopHUD.timer:GetStringWidth(CoopHUD.DATA.Timer.Value) * mod.Config.CoopHUD.misc.timer.scale.X) / 2),0);
			if anchor > 0 then CoopHUD.DATA.Timer.Pos.Y = anchor == 1 and mod.Config.CoopHUD.offset.Y or screen_dimensions.Max.Y - (mod.Config.CoopHUD.offset.Y + (mod.Fonts.CoopHUD.timer:GetBaselineHeight() * mod.Config.CoopHUD.misc.timer.scale.Y)); end
			CoopHUD.DATA.Timer.Pos = CoopHUD.DATA.Timer.Pos + (mod.Config.CoopHUD.misc.timer.offset * edge_multi);
		end
		
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_TIMER_RENDER, mod.CoopHUD.DATA.Timer);
		if CoopHUD.DATA.Timer.Value then
			mod.Fonts.CoopHUD.timer:DrawStringScaled(
				CoopHUD.DATA.Timer.Value,
				CoopHUD.DATA.Timer.Pos.X, CoopHUD.DATA.Timer.Pos.Y,
				mod.Config.CoopHUD.misc.timer.scale.X, mod.Config.CoopHUD.misc.timer.scale.Y,
				KColor(1, 1, 1, mod.Config.CoopHUD.misc.timer.opacity),
				mod.Fonts.CoopHUD.timer:GetStringWidth(CoopHUD.DATA.Timer.Value), true
			);
		end
	end
end
