local mod = CoopEnhanced;
local CoopMarks = CoopEnhanced.CoopMarks;

local Colors = mod.Colors;
local Utils = mod.Utils;

local game = Game();
local hud = game:GetHUD();
local pause = PauseMenu.GetSprite();

local json = require("json");

function CoopMarks.getMarksSprite()
	local sprite = Sprite();
	sprite:Load(mod.Animations.Marks,true);
	sprite:Play("Idle");
	sprite:SetFrame(0);
	if PauseMenu.GetState() == PauseMenuStates.OPEN then for i = 0, 11, 1 do sprite:ReplaceSpritesheet(i,"gfx/ui/completion_widget_pause.png"); end end
	sprite:LoadGraphics();
	return sprite;
end

function CoopMarks.getMarks(player_entity, player_index, position)
	local player_type = player_entity:GetPlayerType();
	local player_sync = mod.Config.CoopMarks.player_sync;
	local screen_dimensions = Utils.GetScreenDimensions();
	local completion_marks = Isaac.GetCompletionMarks(player_type);
	if not completion_marks then return nil; end
		
	local player_config = player_sync == "Global" and mod.Config.players[player_index] or (mod.Config[player_sync] and mod.Config[player_sync].players[player_index] or mod.Config.CoopMarks.players[player_index]);
	if not player_config then return nil; end
		
	local isTainted = Utils.IsTainted(player_type);
	local player_color = Colors[player_config.color].Value;
	local player_one = player_index == 1 and not mod.Config.CoopMarks.player_one;
			
	local player_data = {};
	player_data.Total = 0;
	player_data.Scale = mod.Config.CoopMarks.scale;
	player_data.Color = Utils.ConvertColorToColorize(player_color, mod.Config.CoopMarks.opacity, 1, mod.Config.CoopMarks.tint_amount);
	
	player_data.Pos = position or (screen_dimensions.Center  + mod.Config.CoopMarks.players[player_index].offset + (mod.Config.CoopMarks.space * math.max(0,player_index - (mod.Config.CoopMarks.player_one and 1 or 2))) + (player_one and mod.Config.CoopMarks.player_one_offset or mod.Config.CoopMarks.offset));
	
	-- Label
	if mod.Config.CoopMarks.display > 1 then 
		local text_scale = (player_one and Vector(1.5,1.5) or mod.Config.CoopMarks.text_scale * player_data.Scale);
		player_data.Text = {Value = (Utils.GetPlayerName(player_entity, player_index, player_config.type, player_config.name, mod.Config.players.tainted_names)), Pos = (player_data.Pos + (mod.Config.CoopMarks.text_offset) * text_scale), Scale = text_scale, Color = Utils.ConvertColorToFont(player_color, mod.Config.CoopMarks.text_opacity)};
		player_data.Text.Pos.X = player_data.Text.Pos.X - ((mod.Fonts.CoopMarks.mark:GetStringWidth(player_data.Text.Value) / 2) * text_scale.X);
	end
	-- Head
	if mod.Config.CoopMarks.display == 1 or mod.Config.CoopMarks.display == 3 then
		local head_scale = (player_one and Vector(1,1) or mod.Config.CoopMarks.head_scale * player_data.Scale);
		local head_sprite = Utils.GetHeadSprite(nil,nil,player_type);
		head_sprite.Color = Utils.ColorOpacity(Color.Default, mod.Config.CoopMarks.head_opacity);
		player_data.Head = {Sprite = head_sprite, Pos = (player_data.Pos + (mod.Config.CoopMarks.head_offset + Vector(2,-10)) * head_scale), Scale = head_scale};
	end
	
	-- P1 Extra Sprite stuff
	if player_index == 1 then
		for i,layer in pairs(PauseMenu.GetCompletionMarksSprite():GetAllLayers()) do
			if (layer:IsVisible() and player_one) or (not layer:IsVisible() and not player_one) then break; end
			layer:SetVisible(player_one);
		end
		player_data.Sprite = player_one and PauseMenu.GetCompletionMarksSprite() or CoopMarks.getMarksSprite();
	end
	if not player_data.Sprite then player_data.Sprite = CoopMarks.getMarksSprite(); end
	player_data.Sprite.Color = mod.Config.CoopMarks.colors and player_data.Color or Color.Default;
	
	-- Marks
	local total_hardmode = 0;
	local delirium = 0;
	for mark,value in pairs(completion_marks) do
		if mark == "Delirium" then delirium = value;
		elseif CoopMarks.Layers[mark] then
			if value > 0 then
				player_data.Total = player_data.Total + 1;
				if value > 1 and isTainted and mod.Config.CoopMarks.tainted_colors then value = value + 2; end -- Do Online colors for tainted instead
				if value > 2 and not isTainted and not mod.Config.CoopMarks.online_colors then value = value - 1; end -- Fix REPENTOGON rendering aqua color 
				if value == 2 or value == 4 then total_hardmode = total_hardmode + 1; end
			end
			player_data.Sprite:SetLayerFrame(CoopMarks.Layers[mark],value);
		end
	end
	local all_hard = total_hardmode == CoopMarks.Layers.Total;
	
	-- Paper Background
	local paper_back = CoopMarks.Papers.Normal;
	if isTainted then
		paper_back = CoopMarks.Papers.TaintedNormal;
		if delirium > 1 then paper_back = mod.Config.CoopMarks.tainted_colors and CoopMarks.Papers.TaintedOnlineHardmode or CoopMarks.Papers.TaintedHardmode;
		elseif delirium > 0 then paper_back = mod.Config.CoopMarks.tainted_colors and CoopMarks.Papers.TaintedOnlineDelirium or CoopMarks.Papers.TaintedDelirium; end
	else
		if delirium > 1 then paper_back = CoopMarks.Papers.Hardmode;
		elseif delirium > 0 then paper_back = CoopMarks.Papers.Delirium; end
	end
	player_data.Sprite:SetLayerFrame(0,paper_back);
	
	return player_data;
end

function CoopMarks.onPause(_)
	if mod.Challenge.ID ~= Challenge.CHALLENGE_NULL or PauseMenu.GetState() ~= PauseMenuStates.OPEN or pause:GetAnimation() ~= "Idle" then return; end
	if mod.Config.modules.CoopMarks or (Isaac:GetFrameCount() % 30) == 0 then
		local players = Utils.GetMainPlayers();
		for i,player_entity in ipairs(players) do
			CoopMarks.DATA[i] = CoopMarks.getMarks(player_entity, i);
			CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.MARKS_POST_DATA, i, CoopMarks.DATA[i]); -- Execute Post Player Marks Data update Callbacks (player_index, player_data(table))
		end
	end
	for i = 1, mod.Players.Total, 1 do
		local player_data = CoopMarks.DATA[i];
		local player_one = i == 1 and mod.Config.CoopMarks.player_one;
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.MARKS_PRE_RENDER, i, player_data, false); -- Execute Pre Marks Render Callbacks (player_index, player_data(table), isCoopSelectMenu(Boolean))
		if player_data and player_data.Total > 0 and ((player_one or i > 1) or mod.Players.Total > 1 or not mod.Config.CoopMarks.coop_only) then -- Dont render if nothing has been completed, same as vanilla
			if player_one or i > 1 then
				player_data.Sprite.Scale = player_data.Scale;
				player_data.Sprite:Render(player_data.Pos);
			end
			if player_data.Head and player_data.Head.Sprite then
				player_data.Head.Sprite.Scale = player_data.Head.Scale;
				player_data.Head.Sprite:Render(player_data.Head.Pos);
			end
			if player_data.Text and player_data.Text.Value then
				mod.Fonts.CoopMarks.mark:DrawStringScaled(
					player_data.Text.Value,
					player_data.Text.Pos.X, player_data.Text.Pos.Y,
					player_data.Text.Scale.X, player_data.Text.Scale.Y,
					player_data.Text.Color, player_data.Text.Width or 0, player_data.Text.Center or true
				);
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PAUSE_SCREEN_RENDER, CoopMarks.onPause);

-- Render Marks w/ Co-op Character Select
function CoopMarks.onRender(_)
	if mod.Config.CoopMarks.coop_menu and mod.IsPlayerJoining() and not Utils.IsPauseMenuOpen() then
		for i,joining in pairs(mod.Players.Joining) do
			local character_data = mod.Players.Unlocked[joining.Selected];
			if character_data.Type < 0 or CoopMarks.IgnoredCharacters[character_data.Type] then goto continue; end
			
			local extra_offset = mod.CoopHUD.IsVisible() and Vector(((joining.Index % 2) == 0 and -160 or 80),(joining.Index > 2 and -40 or 10)) or Vector((joining.Index % 2) == 0 and 25 or 0,(joining.Index > 2 and -50 or 10));
			local joining_pos = joining.Pos + mod.Config.CoopMarks.menu_offset + (extra_offset * mod.Config.CoopMarks.scale);
			local player_config = EntityConfig.GetPlayer(character_data.Type);
			local player_data = CoopMarks.getMarks(player_config, joining.Index, joining_pos);
			if not player_data then goto continue; end
			CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.MARKS_PRE_RENDER, joining.Index, player_data, true); -- Execute Pre Marks Render Callbacks (player_index, player_data(table), isCoopSelectMenu(Boolean))
			
			player_data.Sprite.Scale = player_data.Scale;
			player_data.Sprite.Color = mod.Config.CoopMarks.colors and player_data.Color or Color.Default;
			player_data.Sprite:Render(player_data.Pos);
			if player_data.Head and player_data.Head.Sprite then
				player_data.Head.Sprite.Scale = player_data.Head.Scale;
				player_data.Head.Sprite.Color = mod.Config.CoopMarks.head_colors and player_data.Color or Color.Default;
				player_data.Head.Sprite:Render(player_data.Head.Pos);
			end
			if player_data.Text and player_data.Text.Value then
				mod.Fonts.CoopMarks.mark:DrawStringScaled(
					player_data.Text.Value,
					player_data.Text.Pos.X, player_data.Text.Pos.Y,
					player_data.Text.Scale.X, player_data.Text.Scale.Y,
					player_data.Text.Color, player_data.Text.Width or 0, player_data.Text.Center or true
				);
			end
			::continue::
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, CoopMarks.onRender);

require(mod.Directory .. 'CoopMarks.compat');