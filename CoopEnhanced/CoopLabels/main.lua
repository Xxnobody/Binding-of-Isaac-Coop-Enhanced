local mod = CoopEnhanced;
local CoopLabels = CoopEnhanced.CoopLabels;

local Colors = mod.Colors;
local Utils = mod.Utils;

local game = Game();
local hud = game:GetHUD();

function CoopLabels.RenderLabels(_)
	if (not mod.Config.modules.CoopLabels or mod.Config.CoopLabels.display == 0 or Utils.IsPauseMenuOpen() or (game:GetRoom():GetType() == RoomType.ROOM_BOSS and game:GetRoom():IsFirstVisit() and game:GetRoom():GetFrameCount() < 5)) then return;
	elseif mod.Fonts.CoopLabels == nil then
		mod.Debug("Fonts not loaded properly due to an unknown error. Labels must abort!",CoopLabels.Name);
		return;
	end
	
	local player_sync = mod.Config.CoopLabels.player_sync;
	local num_twins = 0;
	for i = 1, game:GetNumPlayers(), 1 do
		local player_entity = Isaac.GetPlayer(i - 1);
		if (game:GetFrameCount() % 30) == 0 then -- Only update data once per second
			if not CoopLabels.DATA[i] then CoopLabels.DATA[i] = {}; end
			CoopLabels.DATA[i].Data = {};
			local player_index = i;
			if mod.Players.Twins[i] then
				player_index = mod.Players.Twins[i];
				num_twins = num_twins + 1;
			else
				player_index = i - num_twins;
			end
			local player_config = player_sync == "Global" and mod.Config.players[player_index] or (mod.Config[player_sync] and mod.Config[player_sync].players[player_index] or mod.Config.CoopLabels.players[player_index]);
			if player_config == nil then goto continue; end
			
			local scale = mod.Config.CoopLabels.scale_sync and player_entity.SpriteScale or mod.Config.CoopLabels.scale;
			local player_color = Colors[(player_config.color)].Value;
			local player_data = {Scale = mod.Config.CoopLabels.head_scale * scale, Color = Utils.ConvertColorToFont(player_color, mod.Config.CoopLabels.opacity)};
			
			-- Tinted Players
			if mod.Config.CoopLabels.player_colors then
				player_entity:SetColor(Utils.ConvertColorToColorize(player_color), 60, 1, false, true);
			end
			
			-- Tinted Tears
			if mod.Config.CoopLabels.tear_colors then
				player_entity.LaserColor = player_color;
				player_entity.TearColor = player_color;
			else
				player_entity.LaserColor = Color.Default;
				player_entity.TearColor = Color.Default;
			end
			
			-- Head
			local head_sprite = mod.Config.CoopLabels.display == 1 or mod.Config.CoopLabels.display == 3 and Utils.GetHeadSprite(CoopLabels.DATA[i].Sprite, player_entity) or nil;
			if head_sprite then head_sprite.Color = (mod.Config.CoopLabels.player_colors and player_color or Color.Default); end
			
			-- Name
			if mod.Config.CoopLabels.display > 1 then
				local player_name = Utils.GetPlayerName(player_entity, player_index, player_config.type, player_config.name, mod.Config.CoopLabels.tainted);
				if player_name and player_name:len() > 0 then player_data.Text = {Value = player_name, Scale = mod.Config.CoopLabels.text_scale * scale} end
			end
			
			CoopLabels.DATA[i] = {Sprite = head_sprite, Data = player_data};
			CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.LABELS_POST_DATA, i, CoopLabels.DATA[i]); -- Execute Post Player Label Data update Callbacks (player_index, player_data(table))
		end
		if CoopLabels.DATA[i] ~= nil then
			local player_data = CoopLabels.DATA[i].Data;
			player_data.Pos = Isaac.WorldToScreen(player_entity.Position) + mod.Config.CoopLabels.offset;
			CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.LABELS_PRE_RENDER, i, player_data); -- Execute Pre Label Render Callbacks (player_index, player_data(table))
			if player_data.Text and player_data.Text.Value then
				local text_offset = mod.Config.CoopLabels.text_offset;
				player_data.Pos.X = (player_data.Pos.X - ((mod.Fonts.CoopLabels.labels:GetStringWidth(player_data.Text.Value) / 2) * player_data.Text.Scale.X)) + text_offset.X;
				player_data.Pos.Y = player_data.Pos.Y + 1 + text_offset.Y;
				mod.Fonts.CoopLabels.labels:DrawStringScaled(
					player_data.Text.Value,
					player_data.Pos.X, player_data.Pos.Y,
					player_data.Text.Scale.X, player_data.Text.Scale.Y,
					player_data.Color, player_data.Text.Width or 0, player_data.Text.Center or true
				);
			end
			if CoopLabels.DATA[i].Sprite then
				local head_offset = mod.Config.CoopLabels.head_offset;
				local head_pos = Vector(player_data.Pos.X - (8 * player_data.Scale.X),player_data.Pos.Y + 1);
				CoopLabels.DATA[i].Sprite.Scale = player_data.Scale;
				CoopLabels.DATA[i].Sprite:Render(head_pos);
			end
		end
		::continue::
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.LATE, CoopLabels.RenderLabels);
