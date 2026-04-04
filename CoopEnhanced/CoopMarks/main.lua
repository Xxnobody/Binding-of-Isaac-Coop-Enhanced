local mod = CoopEnhanced;
local CoopMarks = CoopEnhanced.CoopMarks;

local Colors = mod.Colors;
local Utils = mod.Utils;

local game = Game();
local hud = game:GetHUD();
local pause = PauseMenu.GetSprite();

local json = require("json");

function CoopMarks.onPause(_)
	if not mod.Config.modules.CoopMarks or (Isaac:GetFrameCount() % 30) ~= 0 or mod.Challenge.ID ~= Challenge.CHALLENGE_NULL then return; end
	local player_sync = mod.Config.CoopMarks.player_sync;
	local mark_pos = Utils.GetScreenCenter() + ((Vector(60, -50) + mod.Config.CoopMarks.offset) * Vector(1 / mod.Config.CoopMarks.scale.X, 1 / mod.Config.CoopMarks.scale.Y));
	for i,player_entity in ipairs(Utils.getMainPlayers()) do
		local player_type = player_entity:GetPlayerType();
		local completion_marks = Isaac.GetCompletionMarks(player_type);
		if not completion_marks then goto continue; end
		
		local player_config = player_sync == "Global" and mod.Config.players[i] or (mod.Config[player_sync] and mod.Config[player_sync].players[i] or mod.Config.CoopMarks.players[i]);
		
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
		
		CoopMarks.DATA[i] = {};
		CoopMarks.DATA[i].Total = 0;
		CoopMarks.DATA[i].Color = Utils.ConvertColorToFont(player_color, mod.Config.CoopMarks.opacity);
		CoopMarks.DATA[i].Pos = (i == 1 and nil or mark_pos + (Vector(0,(i - 1) * 80) + mod.Config.CoopMarks.rel_offset) * mod.Config.CoopMarks.scale.Y);
		CoopMarks.DATA[i].Text = {Value = (player_config.type == 0 and "P" .. i or (player_config.type == 1 and ((isTainted and "T. " or "") .. player_entity:GetName()) or player_config.name)), Pos = (i == 1 and Utils.GetScreenCenter() + Vector(-36, -110) or CoopMarks.DATA[i].Pos + Vector(18 * mod.Config.CoopMarks.text_scale.X, -16 * mod.Config.CoopMarks.text_scale.Y)), Scale = (i == 1 and Vector(1.5,1.5) or mod.Config.CoopMarks.text_scale)};
		CoopMarks.DATA[i].Sprite = sprite;
		CoopMarks.DATA[i].Text.Pos.X = CoopMarks.DATA[i].Text.Pos.X - ((mod.Fonts.CoopMarks.mark:GetStringWidth(CoopMarks.DATA[i].Text.Value) / 2) * CoopMarks.DATA[i].Text.Scale.X);
		
		for mark,value in pairs(completion_marks) do
			if value == 3 then value = isTainted and 4 or 2; end -- Values get returned as 3 which results in aqua color pallette instead of red/purple for hard mode
			if mark == "Delirium" then CoopMarks.DATA[i].Sprite:SetLayerFrame(0,value + (isTainted and 3 or 0)); end
			if CoopMarks.Layers[mark] then
				CoopMarks.DATA[i].Sprite:SetLayerFrame(CoopMarks.Layers[mark],value);
				if value > 0 then CoopMarks.DATA[i].Total = CoopMarks.DATA[i].Total + 1; end
			end
		end
		CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.MARKS_POST_DATA, i, CoopMarks.DATA[i]); -- Execute Post Player Marks Data update Callbacks (player_index, player_data(table))
		::continue::
	end
end

function CoopMarks.onRender()
	if mod.Challenge.ID ~= Challenge.CHALLENGE_NULL or not game:IsPauseMenuOpen() or PauseMenu.GetState() ~= PauseMenuStates.OPEN or not pause:IsFinished() then return; end
	for i = 1, mod.Players.Total, 1 do
		local player_data = CoopMarks.DATA[i];
		CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.MARKS_PRE_RENDER, i, player_data); -- Execute Pre Marks Render Callbacks (player_index, player_data(table))
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
mod:AddCallback(ModCallbacks.MC_PRE_PAUSE_SCREEN_RENDER, CoopMarks.onPause);
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, CoopMarks.onRender);
