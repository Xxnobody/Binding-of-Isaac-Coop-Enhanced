local mod = CoopEnhanced;
local CoopMarks = CoopEnhanced.CoopMarks;

local Colors = mod.Colors;
local Utils = mod.Utils;

local game = Game();
local hud = game:GetHUD();
local pause = PauseMenu.GetSprite();

local json = require("json");

function CoopMarks.getMarks(player_entity, player_index)
	local player_type = player_entity:GetPlayerType();
	local player_sync = mod.Config.CoopMarks.player_sync;
	local screen_dimensions = Utils.GetScreenDimensions();
	local completion_marks = Isaac.GetCompletionMarks(player_type);
	local mark_pos = screen_dimensions.Center + ((Vector(60, -50) + mod.Config.CoopMarks.offset) * Vector(1 / mod.Config.CoopMarks.scale.X, 1 / mod.Config.CoopMarks.scale.Y));
	if not completion_marks then return nil; end
		
	local player_config = player_sync == "Global" and mod.Config.players[player_index] or (mod.Config[player_sync] and mod.Config[player_sync].players[player_index] or mod.Config.CoopMarks.players[player_index]);
		
	local isTainted = Utils.IsTainted(player_entity);
	local player_color = Colors[player_config.color].Value;
	
	local sprite = Sprite();
	sprite:Load("gfx/ui/completion_widget.anm2",true);
	sprite:Play("Idle");
	sprite.Color = mod.Config.CoopMarks.colors and player_color or Color.Default;
	sprite.Scale = mod.Config.CoopMarks.scale;
	sprite:SetFrame(0);
	for x = 0, 11, 1 do sprite:ReplaceSpritesheet(x,"gfx/ui/completion_widget_pause.png"); end
	sprite:LoadGraphics();
		
	local player_data = {};
	player_data.Total = 0;
	player_data.Color = Utils.ConvertColorToFont(player_color, mod.Config.CoopMarks.opacity);
	player_data.Pos = (player_index == 1 and nil or mark_pos + (Vector(0,(player_index - 1) * 80) + mod.Config.CoopMarks.rel_offset) * mod.Config.CoopMarks.scale.Y);
	player_data.Text = {Value = (Utils.getPlayerName(player_entity, player_index, player_config.type, player_config.name, mod.Config.CoopHUD.tainted)), Pos = (player_index == 1 and screen_dimensions.Center + Vector(-36, -110) or player_data.Pos + Vector(18 * mod.Config.CoopMarks.text_scale.X, -16 * mod.Config.CoopMarks.text_scale.Y)), Scale = (player_index == 1 and Vector(1.5,1.5) or mod.Config.CoopMarks.text_scale)};
	player_data.Sprite = sprite;
	player_data.Text.Pos.X = player_data.Text.Pos.X - ((mod.Fonts.CoopMarks.mark:GetStringWidth(player_data.Text.Value) / 2) * player_data.Text.Scale.X);
		
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
	local players = Utils.getMainPlayers();
	for i,player_entity in ipairs(players) do
		CoopMarks.DATA[i] = CoopMarks.getMarks(player_entity, i);
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.MARKS_POST_DATA, i, CoopMarks.DATA[i]); -- Execute Post Player Marks Data update Callbacks (player_index, player_data(table))
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PAUSE_SCREEN_RENDER, CoopMarks.onPause);

function CoopMarks.onRender()
	if mod.Challenge.ID ~= Challenge.CHALLENGE_NULL or not game:IsPauseMenuOpen() or PauseMenu.GetState() ~= PauseMenuStates.OPEN or not pause:IsFinished() then return; end
	for i = 1, mod.Players.Total, 1 do
		local player_data = CoopMarks.DATA[i];
		CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.MARKS_PRE_RENDER, i, player_data); -- Execute Pre Marks Render Callbacks (player_index, player_data(table))
		if player_data and player_data.Total > 0 and (i > 1 or mod.Players.Total > 1 or not mod.Config.CoopMarks.coop_only) then -- Dont render if nothing has been completed, same as vanilla
			if i > 1 then player_data.Sprite:Render(player_data.Pos); end
			mod.Fonts.CoopMarks.mark:DrawStringScaled(
				player_data.Text.Value,
				player_data.Text.Pos.X, player_data.Text.Pos.Y,
				player_data.Text.Scale.X, player_data.Text.Scale.Y,
				player_data.Color, player_data.Text.Width or 0, player_data.Text.Center or true
			);
		end
	end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, CoopMarks.onRender);

mod.Registry:AddCallback(mod.Callbacks.POST_REGISTRY_EXECUTE, function()
	mod.Registry:AddCallback(mod.Callbacks.HUD_PRE_COOP_MENU_RENDER, CoopMarks.onRenderCoopMenu);
end);

function CoopMarks.onRenderCoopMenu(joining, unlocked)
	if not mod.Config.CoopMarks.coop_menu or not joining then return; end
	local character_data = unlocked[joining.Selected];
	if character_data.Type < 0 then return; end
	local player_config = EntityConfig.GetPlayer(character_data.Type);
	local player_data = CoopMarks.getMarks(player_config, joining.Index);
	if not player_data then return; end
	
	player_data.Pos = joining.Pos + mod.Config.CoopMarks.menu_offset + Vector((-16 * joining.Sprites[1].Sprite.Scale.X),(joining.Index <= 2 and 35 or 5) * joining.Sprites[1].Sprite.Scale.Y);
	player_data.Text.Pos = player_data.Pos + Vector(18 * mod.Config.CoopMarks.text_scale.X, -16 * mod.Config.CoopMarks.text_scale.Y);
	player_data.Text.Pos.X = player_data.Text.Pos.X - ((mod.Fonts.CoopMarks.mark:GetStringWidth(player_data.Text.Value) / 2) * player_data.Text.Scale.X);
	player_data.Sprite:Render(player_data.Pos);
	mod.Fonts.CoopMarks.mark:DrawStringScaled(
		player_data.Text.Value,
		player_data.Text.Pos.X, player_data.Text.Pos.Y,
		player_data.Text.Scale.X, player_data.Text.Scale.Y,
		player_data.Color, player_data.Text.Width or 0, player_data.Text.Center or true
	);
end
