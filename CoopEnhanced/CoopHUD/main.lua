local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;

local game = Game();
local hud = game:GetHUD();

-- Coop HUD Functions
function CoopHUD.IsVisible()
	return CoopHUD.isVisible;
end

function CoopHUD.SetVisible(force)
	local toggle = not CoopHUD.isVisible;
	if type(force) == "boolean" then toggle = force; end
	if toggle then
		game:GetHUD():SetVisible(false);
		CoopHUD.isVisible = true;
	else
		game:GetHUD():SetVisible(true);
		CoopHUD.isVisible = false;
	end
end

function CoopHUD.gameStart(isCont, data)
	CoopEnhanced.CoopHUD.DATA.Players = {};
	CoopEnhanced.CoopHUD.DATA.Joining = {Total = 0};
	CoopEnhanced.CoopHUD.DATA.Timer = {};
	CoopEnhanced.CoopHUD.DATA.Banner = {};
	CoopEnhanced.CoopHUD.Misc.Pickups = {};
	CoopEnhanced.CoopHUD.Misc.Difficulty = {[1] = {}};
	CoopEnhanced.CoopHUD.Misc.Wave = {[1] = {}};
	CoopEnhanced.CoopHUD.Misc.Extra = {[1] = {},[2] = {}};
	CoopHUD.isVisible = true;
	if isCont and data.CoopHUD then
		if CoopEnhanced and CoopEnhanced.CoopHUD then CoopEnhanced.CoopHUD.DATA.Players = data.CoopHUD.players; end
	end
end
function CoopHUD.gameEnd(data)
	if data == nil then data = {CoopHUD = {}} elseif data.CoopHUD == nil then data.CoopHUD = {}; end
	data.CoopHUD.banner = CoopHUD.DATA.Banner;
	data.CoopHUD.players = CoopHUD.DATA.Players;
	return data;
end

function CoopHUD.createBanner(name, desc, banner_type, display_bottom_paper)
	local sprite = Sprite();
	if banner_type == CoopHUD.BannerType.FORTUNE then sprite:Load(mod.Animations.Fortune, true) else sprite:Load(mod.Animations.Banner, true); end
	local banner_timer = game:GetFrameCount() + (banner_type == CoopHUD.BannerType.FLOOR and 1800 or (30 * mod.Config.CoopHUD.banner.duration));
	if not display_bottom_paper then sprite:ReplaceSpritesheet(1, mod.Images.Blank); end
	sprite:LoadGraphics();
	sprite:Play('Text', false);
	sprite.PlaybackSpeed = mod.Config.CoopHUD.banner.speed;
	CoopHUD.DATA.Banner = {Sprite = sprite, Name = name, Desc = desc, Curse = display_bottom_paper, Type = banner_type, Timer = banner_timer};
end

function CoopHUD.getDataFromController(controller_index)
	for i = #CoopHUD.DATA.Players, (#CoopHUD.DATA.Players * -1), -1 do
		if CoopHUD.DATA.Players[i] and CoopHUD.DATA.Players[i].Controller == controller_index then
			return CoopHUD.DATA.Players[i];
		end
	end
	return nil, 0;
end
function CoopHUD.getDataFromIndex(player_index)
	for i = #CoopHUD.DATA.Players, (#CoopHUD.DATA.Players * -1), -1 do
		if CoopHUD.DATA.Players[i] and CoopHUD.DATA.Players[i].Index == player_index then
			return CoopHUD.DATA.Players[i], i;
		end
	end
	return nil, 0;
end
function CoopHUD.getDataFromEntity(player_entity)
	if player_entity then
		local player_id = Utils.GetPlayerID(player_entity);
		for i = #CoopHUD.DATA.Players, (#CoopHUD.DATA.Players * -1), -1 do
			if CoopHUD.DATA.Players[i] and (CoopHUD.DATA.Players[i].ID == player_id or CoopHUD.DATA.Players[i].Player.Entity and CoopHUD.DATA.Players[i].Player.Entity.Ref and Utils.GetPlayerID(CoopHUD.DATA.Players[i].Player.Entity.Ref:ToPlayer()) == player_id) then
				return CoopHUD.DATA.Players[i], i;
			end
		end
	end
	return nil, 0;
end

function CoopHUD.InitNewPlayers(screen_dimensions)
	if not mod.IsPlayerJoining() or mod.Config.CoopHUD.players.menu.display == 0 then return; end
	for i,joining in pairs(mod.Players.Joining) do
		if joining.Sprites == nil then
			joining.Pos = Vector((joining.Index % 2) == 0 and (screen_dimensions.Max.X - (CoopHUD.Positions.Coop.X + mod.Config.CoopHUD.players.mirrored_offset.X + 8)) or CoopHUD.Positions.Coop.X, joining.Index > 2 and (screen_dimensions.Max.Y - (CoopHUD.Positions.Coop.Y + mod.Config.CoopHUD.offset.Y + mod.Config.CoopHUD.players.mirrored_offset.Y + (-5 * (1 - mod.Config.CoopHUD.players.menu.scale.Y)))) or CoopHUD.Positions.Coop.Y);
			joining.Sprites = CoopHUD.getCoopMenuSprites(joining);
		end
		CoopHUD.RenderCoopMenuSprite(joining);
	end
end
function CoopHUD.getCoopMenuSprites(joininig)
	local scale = mod.Config.CoopHUD.players.menu.scale;
	local opacity = mod.Config.CoopHUD.players.menu.opacity;
	local rel_offset = mod.Config.CoopHUD.players.menu.rel_offset;
	local scale_milti = mod.Config.CoopHUD.players.menu.distance == 0 and 0 or (mod.Config.CoopHUD.players.menu.distance == 1 and -1 or 1);
	local opacity_milti = mod.Config.CoopHUD.players.menu.fade == 0 and 0 or (mod.Config.CoopHUD.players.menu.fade == 1 and -1 or 1);
	local extra_amount = math.floor((#mod.Players.Unlocked - 1) / 2);
	local change_percent = 1 / math.max(1,extra_amount);
	
	local sprites = {};
	for i = 0, math.min(mod.Config.CoopHUD.players.menu.max,extra_amount), 1 do
		local sprite = Sprite(mod.Animations.Coop,false);
		sprite:ReplaceSpritesheet(1,mod.Images.Blank);
		sprite:LoadGraphics();
		sprite.Scale = scale_milti and scale + Utils.VectorFrom((change_percent * i) * scale_milti) or scale;
		if sprite.Scale.X < 0.15 then sprite.Scale = Vector(0.15,0.15); end
		sprite.Color = Utils.ColorOpacity(Color.Default,(opacity_milti and math.max(0.05,opacity + ((change_percent * i) * opacity_milti)) or opacity));
		local offset = (rel_offset * i) * sprite.Scale;
		if mod.Config.CoopHUD.players.menu.circle then offset = offset - Vector(offset.X * (i * change_percent), -rel_offset.Y * (i * (change_percent * 2))); end
		table.insert(sprites,{Sprite = sprite, Offset = offset});
	end
	
	local arrow_sprite = Sprite(mod.Animations.Coop,true);
	arrow_sprite:ReplaceSpritesheet(1,mod.Images.Blank);
	arrow_sprite:LoadGraphics();
	arrow_sprite.Scale = scale;
	arrow_sprite.Color = Utils.ColorOpacity(Color.Default,opacity);
	sprites[0] = {Sprite = arrow_sprite};
	
	return sprites;
end
function CoopHUD.RenderCoopMenuSprite(joining)
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_COOP_MENU_RENDER, joining, mod.Players.Unlocked); -- Execute pre Coop Menu rendering functions (Joining Player Data, Unlocked Characters Data)
	
	local sel = joining.Selected;
	local max = #mod.Players.Unlocked;
	local edge_multipliers = Vector(((joining.Index % 2 == 0) and -1 or 1),(joining.Index > 2 and -1 or 1));
	local main_pos = (joining.Pos + (mod.Config.CoopHUD.players.menu.offset * edge_multipliers));
	if CoopHUD.Refresh then joining.Sprites = CoopEnhanced.CoopHUD.getCoopMenuSprites(joininig); end
	if #joining.Sprites > 1 then
		-- Render Extra Heads on the left/right
		for i = #joining.Sprites, 2, -1 do
			local joining_sprite = joining.Sprites[i];
			local character_data = mod.Players.Unlocked[Utils.ClampFlow(1, max, (sel + (i - 1)))];
			if joining_sprite.Sprite:GetFilename() ~= character_data.Sprite.Anm2 then
				joining_sprite.Sprite:Load(character_data.Sprite.Anm2,false);
				if character_data.Sprite.Sheets then 
					for id,sheet in pairs(character_data.Sprite.Sheets) do
						joining_sprite.Sprite:ReplaceSpritesheet(id,sheet);
					end
				end
				joining_sprite.Sprite:LoadGraphics();
			end
			joining_sprite.Sprite:SetFrame(character_data.Sprite.Animation,character_data.Sprite.Frame);
			joining_sprite.Sprite:Render(main_pos + joining_sprite.Offset);
			
			character_data = mod.Players.Unlocked[Utils.ClampFlow(1, max, (sel - (i - 1)))];
			
			if joining_sprite.Sprite:GetFilename() ~= character_data.Sprite.Anm2 then
				joining_sprite.Sprite:Load(character_data.Sprite.Anm2,false);
				if character_data.Sprite.Sheets then 
					for id,sheet in pairs(character_data.Sprite.Sheets) do
						joining_sprite.Sprite:ReplaceSpritesheet(id,sheet);
					end
				end
				joining_sprite.Sprite:LoadGraphics();
			end
			joining_sprite.Sprite:SetFrame(character_data.Sprite.Animation,character_data.Sprite.Frame);			
			joining_sprite.Sprite:Render(main_pos - (joining_sprite.Offset * Vector(1,mod.Config.CoopHUD.players.menu.rel_invert and 1 or -1)));
		end
	end
	
	-- Render the main head
	local main_sprite = joining.Sprites[1].Sprite;
	local character_data = mod.Players.Unlocked[sel];
	if main_sprite:GetFilename() ~= character_data.Sprite.Anm2 then
		main_sprite:Load(character_data.Sprite.Anm2,false);
		if character_data.Sprite.Sheets then 
			for id,sheet in pairs(character_data.Sprite.Sheets) do
				main_sprite:ReplaceSpritesheet(id,sheet);
			end
		end
		main_sprite:LoadGraphics();
	end
	main_sprite:SetFrame(character_data.Sprite.Animation,character_data.Sprite.Frame);
	main_sprite:Render(main_pos);
		
	-- Render Arrows
	local arrow_sprite = joining.Sprites[0].Sprite;
	arrow_sprite:SetOverlayFrame("Arrows",(mod.FrameCount < 30 and 1 or 0));
	arrow_sprite:RenderLayer(2,main_pos);
	arrow_sprite.FlipX = true;
	arrow_sprite:RenderLayer(2,main_pos);
	arrow_sprite.FlipX = false;
end

local function minimapConfig(setting, value)
	if not mod.Config.CoopHUD.mods.mAPI.override then
		MinimapAPI.OverrideConfig[setting] = MinimapAPI.Config[setting];
	elseif MinimapAPI.OverrideConfig[setting] ~= value then
		MinimapAPI.OverrideConfig[setting] = value;
	end
end

-- Ititialize the rest of the HUD
require(mod.Directory .. 'CoopHUD.HUD.stats');
require(mod.Directory .. 'CoopHUD.HUD.item');
require(mod.Directory .. 'CoopHUD.HUD.player');
require(mod.Directory .. 'CoopHUD.HUD.misc');
require(mod.Directory .. 'CoopHUD.HUD.render');

-- Callbacks
local function addCollectible(_, collectible_type, _, _, _, _, player_entity)
	local item = Isaac.GetItemConfig():GetCollectible(collectible_type);
	local player_data = CoopEnhanced.CoopHUD.getDataFromEntity(player_entity);
	if not player_data or not player_data.Inventory.Passive or item.Type == ItemType.ITEM_ACTIVE or item.Type == ItemType.ITEM_TRINKET or CoopHUD.Item.Inventory.IgnoredCollectibles[item.ID] then return; end
	
	CoopHUD.Item.Inventory.Add(player_data, item);
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, addCollectible);
local function removeCollectible(_, player_entity, collectible_type)
	local item = Isaac.GetItemConfig():GetCollectible(collectible_type);
	local player_data = CoopEnhanced.CoopHUD.getDataFromEntity(player_entity);
	if not player_data or not player_data.Inventory.Passive or item.Type == ItemType.ITEM_ACTIVE or item.Type == ItemType.ITEM_TRINKET or CoopHUD.Item.Inventory.IgnoredCollectibles[item.ID] then return; end
	
	CoopHUD.Item.Inventory.Remove(player_data, item);
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, removeCollectible);

local function fortuneDisplay(_)
	local fortunesprite = game:GetHUD():GetFortuneSprite();
	CoopHUD.DATA.Banner.Sprite = fortunesprite;
	CoopHUD.DATA.Banner.Type = CoopHUD.BannerType.FORTUNE;
end
mod:AddCallback(ModCallbacks.MC_PRE_FORTUNE_DISPLAY, fortuneDisplay);
local function displayBanner(_ , name, description, isSticky, IsCurse)
	if name == CoopHUD.DATA.Banner.Name then return; end
	local banner_type = isSticky and CoopHUD.BannerType.FLOOR or CoopHUD.BannerType.ITEM;
	CoopEnhanced.CoopHUD.createBanner(name, description, banner_type, IsCurse);
	return false;
end
mod:AddCallback(ModCallbacks.MC_PRE_ITEM_TEXT_DISPLAY, displayBanner);

local hotkey_timer = 0;
local function onRender()
	-- Renderer Checks
	if not mod.Config.modules.CoopHUD or game:GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) or (not Isaac:CanStartTrueCoop() and mod.Config.CoopHUD.toggle_hud.coop_only and not PlayerManager.IsCoopPlay()) then -- Check if HUD can be rendered at all
		CoopHUD.isVisible = false;
		CoopHUD.Refresh = false;
		return;
	elseif (mod.Config.CoopHUD.toggle_hud.coop_only and not PlayerManager.IsCoopPlay()) or (not mod.Config.CoopHUD.toggle_hud.pause_display and Utils.IsPauseMenuOpen()) then -- Check for Coop play and pause screens
		return;
	elseif mod.Fonts.CoopHUD == nil then
		mod.Debug("Fonts not loaded properly due to an unknown error. HUD must abort!",CoopHUD.Name);
		return;
	end
	
	local screen_dimensions = Utils.GetScreenDimensions();
	mod.CoopHUD.Refresh = (mod.Config.CoopHUD.renderer.refresh == 1 or (CoopEnhanced.FrameCount % mod.Config.CoopHUD.renderer.refresh) == 0);
	
	if CoopHUD.DATA.Banner.Type == CoopHUD.BannerType.FORTUNE then -- Temperary fix until an API to get Fortune text is available
		if CoopHUD.DATA.Banner.Sprite:IsFinished() then
			CoopHUD.DATA.Banner = {};
		else
			hud:SetVisible(true);
			return;
		end
	elseif Isaac:CanStartTrueCoop() and not game:IsPaused() and CoopHUD.isVisible then 
		CoopHUD.InitNewPlayers(screen_dimensions);
		if mod.Config.CoopHUD.players.menu.display == 0 and CoopHUD.IsPlayerJoining() then hud:SetVisible(true); return; end
	elseif game:GetRoom():GetType() == RoomType.ROOM_BOSS and game:GetRoom():IsFirstVisit() and game:GetRoom():GetFrameCount() < 5 then -- Hide all HUDs when entering a boss cutscene
		hud:SetVisible(false);
		return;
	end
	
	-- Toggle HUD Keybinds
	local controller_index = game:GetPlayer(0).ControllerIndex;
	local hotkeys = mod.Controls[mod.Config.CoopHUD.toggle_hud.button];
	if hotkeys.Held and (Input.IsActionPressed(hotkeys.Buttons.X, controller_index) and hotkey_timer < hotkeys.Buttons.Y) then
		hotkey_timer = hotkey_timer + 1;
		if hotkey_timer == hotkeys.Buttons.Y then
			hotkeys.isHeld = true;
		end
	elseif (Input.IsButtonTriggered(ModConfigMenu and ModConfigMenu.Config[CoopHUD.MCM.title]["ToggleHUDKeyboard"] or mod.Config.CoopHUD.toggle_hud.key, 0) and not game:IsPaused()) or (hotkeys.isHeld or (not hotkeys.Held and (Input.IsActionPressed(hotkeys.Buttons.X, controller_index) and Input.IsActionTriggered(hotkeys.Buttons.Y, controller_index)))) then
		hotkeys.isHeld = nil;
		CoopHUD.SetVisible();
	else
		hotkey_timer = 0;
	end
	
	if not CoopHUD.isVisible then return; end
	hud:SetVisible(false);
	
	CoopHUD.IsMapDown = false;
	CoopHUD.IsPlayerMapDown = {};
	
	if CoopHUD.Refresh then
		-- mAPI
		if MinimapAPI then
			minimapConfig('DisplayOnNoHUD', true);
			minimapConfig('DisplayMode', 2);
			minimapConfig('PositionX', mod.Config.CoopHUD.mods.mAPI.pos.X);
			minimapConfig('PositionY', mod.Config.CoopHUD.mods.mAPI.pos.Y);
			minimapConfig('MapFrameWidth', mod.Config.CoopHUD.mods.mAPI.frame.X);
			minimapConfig('MapFrameHeight', mod.Config.CoopHUD.mods.mAPI.frame.Y);
			minimapConfig('DisplayLevelFlags', 2);
			minimapConfig('BorderColorA', 0.5);
		end
		
		-- CustomHealthAPI
		if CustomHealthAPI then
			CustomHealthAPI.Constants.HEART_PIXEL_WIDTH_DEFAULT = mod.Config.CoopHUD.health.space.X;
			CustomHealthAPI.Constants.HEART_PIXEL_HEIGHT_DEFAULT = mod.Config.CoopHUD.health.space.Y;
			CustomHealthAPI.Constants.HEARTS_PER_ROW = mod.Config.CoopHUD.health.hearts_per_row;
			CustomHealthAPI.Constants.FONT = mod.Fonts.CoopHUD.lives;
		end
	end
	
	-- EID 
	if EID then EID.isHidden = mod.Config.CoopHUD.mods.EID.display == 3 or (mod.Config.CoopHUD.mods.EID.display == 2 and not CoopHUD.IsMapDown or (mod.Config.CoopHUD.mods.EID.display == 1 and CoopHUD.IsMapDown or false)); end
	
	-- Render the various HUD elements
	CoopHUD.RenderPlayers(screen_dimensions);
	CoopHUD.Misc.Render(screen_dimensions);
	CoopHUD.RenderBanners(screen_dimensions);
	CoopHUD.RenderTimer(screen_dimensions);
end

local callbacks = {
	ModCallbacks.MC_HUD_RENDER,
	ModCallbacks.MC_POST_HUD_RENDER,
	ModCallbacks.MC_HUD_UPDATE,
	ModCallbacks.MC_POST_HUD_UPDATE,
	ModCallbacks.MC_POST_RENDER
};
mod:AddPriorityCallback(callbacks[mod.Config.CoopHUD.renderer.callback], mod.Priorities[mod.Config.CoopHUD.renderer.priority], onRender);