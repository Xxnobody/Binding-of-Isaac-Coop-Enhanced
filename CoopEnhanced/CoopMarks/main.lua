local mod = CoopEnhanced;
local CoopMarks = CoopEnhanced.CoopMarks;

local Colors = mod.Colors;
local Utils = mod.Utils;

local game = Game();
local hud = game:GetHUD();
local pause = PauseMenu.GetSprite();

local json = require("json");

function CoopMarks.getMarks(player_entity, player_index, position)
	local player_type = player_entity:GetPlayerType();
	local player_sync = mod.Config.CoopMarks.player_sync;
	local screen_dimensions = Utils.GetScreenDimensions();
	local completion_marks = Isaac.GetCompletionMarks(player_type);
	local mark_pos = screen_dimensions.Center + ((Vector(60, -50) + mod.Config.CoopMarks.offset) * Vector(1 / mod.Config.CoopMarks.scale.X, 1 / mod.Config.CoopMarks.scale.Y));
	if not completion_marks then return nil; end
		
	local player_config = player_sync == "Global" and mod.Config.players[player_index] or (mod.Config[player_sync] and mod.Config[player_sync].players[player_index] or mod.Config.CoopMarks.players[player_index]);
	if not player_config then return nil; end
		
	local isTainted = Utils.IsTainted(player_entity);
	local player_color = Colors[player_config.color].Value;
			
	local player_data = {};
	player_data.Total = 0;
	player_data.Color = Utils.ConvertColorToFont(player_color, mod.Config.CoopMarks.opacity);
	player_data.Pos = position or (player_index == 1 and nil or mark_pos + (Vector(0,(player_index - 1) * 80) + mod.Config.CoopMarks.rel_offset) * mod.Config.CoopMarks.scale.Y);
	
	-- Text
	if mod.Config.CoopMarks.display > 1 then 
		player_data.Text = {Value = (Utils.GetPlayerName(player_entity, player_index, player_config.type, player_config.name, false)), Pos = (mod.Config.CoopMarks.text_offset + (player_index == 1 and screen_dimensions.Center + Vector(-36, -110) or player_data.Pos + Vector(18 * mod.Config.CoopMarks.text_scale.X, -16 * mod.Config.CoopMarks.text_scale.Y))), Scale = (player_index == 1 and Vector(1.5,1.5) or mod.Config.CoopMarks.text_scale)};
		player_data.Text.Pos.X = player_data.Text.Pos.X - ((mod.Fonts.CoopMarks.mark:GetStringWidth(player_data.Text.Value) / 2) * player_data.Text.Scale.X);
	end
	-- Head
	if mod.Config.CoopLabels.display == 1 or mod.Config.CoopLabels.display == 3 then
		player_data.Head = {Sprite = Utils.GetHeadSprite(nil, player_entity), Pos = (player_data.Text.Pos + (mod.Config.CoopMarks.head_offset - Vector(2,8)) * mod.Config.CoopMarks.head_scale)};
		if player_data.Head.Sprite then
			player_data.HeadSprite.Scale = mod.Config.CoopMarks.head_scale;
			player_data.HeadSprite.Color = player_color;
		end
	end
	
	if not player_data.Sprite then
		local sprite = Sprite();
		sprite:Load("gfx/ui/completion_widget.anm2",true);
		sprite:Play("Idle");
		sprite.Color = mod.Config.CoopMarks.colors and player_color or Color.Default;
		sprite.Scale = mod.Config.CoopMarks.scale;
		sprite:SetFrame(0);
		for x = 0, 11, 1 do sprite:ReplaceSpritesheet(x,"gfx/ui/completion_widget_pause.png"); end
		sprite:LoadGraphics();
		player_data.Sprite = sprite;
	end
	
	for mark,value in pairs(completion_marks) do
		if value == 3 then value = isTainted and 4 or 2; end -- Values get returned as 3 which results in aqua color pallette instead of red/purple for hard mode
		if mark == "Delirium" then player_data.Sprite:SetLayerFrame(0,value + (isTainted and 3 or 0)); end
		if CoopMarks.Layers[mark] then
			player_data.Sprite:SetLayerFrame(CoopMarks.Layers[mark],value);
			if value > 0 then player_data.Total = player_data.Total + 1; end
		end
	end
	return player_data;
end

function CoopMarks.onPause(_)
	if not mod.Config.modules.CoopMarks or (Isaac:GetFrameCount() % 30) ~= 0 or mod.Challenge.ID ~= Challenge.CHALLENGE_NULL then return; end
	local players = Utils.GetMainPlayers();
	for i,player_entity in ipairs(players) do
		CoopMarks.DATA[i] = CoopMarks.getMarks(player_entity, i);
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.MARKS_POST_DATA, i, CoopMarks.DATA[i]); -- Execute Post Player Marks Data update Callbacks (player_index, player_data(table))
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PAUSE_SCREEN_RENDER, CoopMarks.onPause);

function CoopMarks.onRender()
	if mod.Config.CoopMarks.coop_menu and not not Utils.IsPauseMenuOpen() then -- Render Marks w/ Co-op Character Select
		for i,joining in pairs(mod.Players.Joining) do
			local character_data = mod.Players.Unlocked[joining.Selected];
			if character_data.Type < 0 then goto continue; end
			
			local extra_offset = mod.CoopHUD.IsVisible() and Vector(((joining.Index % 2) == 0 and -160 or 80),(joining.Index > 2 and -40 or 10)) or Vector((joining.Index % 2) == 0 and 25 or 0,(joining.Index > 2 and -50 or 10));
			local joining_pos = joining.Pos + mod.Config.CoopMarks.menu_offset + (extra_offset * mod.Config.CoopMarks.scale);
			local player_config = EntityConfig.GetPlayer(character_data.Type);
			local player_data = CoopMarks.getMarks(player_config, joining.Index, joining_pos);
			if not player_data then goto continue; end
			CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.MARKS_PRE_RENDER, joining.Index, player_data, true); -- Execute Pre Marks Render Callbacks (player_index, player_data(table), isCoopSelectMenu(Boolean))
			
			player_data.Sprite:Render(player_data.Pos);
			if player_data.Head and player_data.Head.Sprite then player_data.Head.Sprite:Render(player_data.Head.Pos); end
			if player_data.Text and player_data.Text.Value then
				mod.Fonts.CoopMarks.mark:DrawStringScaled(
					player_data.Text.Value,
					player_data.Text.Pos.X, player_data.Text.Pos.Y,
					player_data.Text.Scale.X, player_data.Text.Scale.Y,
					player_data.Color, player_data.Text.Width or 0, player_data.Text.Center or true
				);
			end
			::continue::
		end
	end
	if mod.Challenge.ID ~= Challenge.CHALLENGE_NULL or not game:IsPauseMenuOpen() or PauseMenu.GetState() ~= PauseMenuStates.OPEN or not pause:IsFinished() then return; end
	for i = 1, mod.Players.Total, 1 do
		local player_data = CoopMarks.DATA[i];
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.MARKS_PRE_RENDER, i, player_data, false); -- Execute Pre Marks Render Callbacks (player_index, player_data(table), isCoopSelectMenu(Boolean))
		if player_data and player_data.Total > 0 and (i > 1 or mod.Players.Total > 1 or not mod.Config.CoopMarks.coop_only) then -- Dont render if nothing has been completed, same as vanilla
			if i > 1 then player_data.Sprite:Render(player_data.Pos); end
			if player_data.Head and player_data.Head.Sprite then player_data.Head.Sprite:Render(player_data.Head.Pos); end
			if player_data.Text and player_data.Text.Value then
				mod.Fonts.CoopMarks.mark:DrawStringScaled(
					player_data.Text.Value,
					player_data.Text.Pos.X, player_data.Text.Pos.Y,
					player_data.Text.Scale.X, player_data.Text.Scale.Y,
					player_data.Color, player_data.Text.Width or 0, player_data.Text.Center or true
				);
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, CoopMarks.onRender);