local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;

function CoopHUD.VoidedItems()
	if not VoidedItems then return; end
	
	local void_id = DIVIDED_VOID and (Isaac.GetItemIdByName('[DIVIDED VOID]Tech ID') + 1) or CollectibleType.COLLECTIBLE_VOID;
	local position = CoopHUD.Positions.Inventory + Vector(30,-30);
	
	local voided_data = {};
	for i = 1, 4, 1 do
		local sprite = Sprite(mod.Animations.Item, false);
		sprite:SetFrame('Idle', 0);
		voided_data[i] = {Sprite = sprite, Data = {}};
	end

	local function voided_function(index,player_data)
		if not player_data then return; end
		local player_entity = player_data.Player.Entity.Ref:ToPlayer();
		local void_data = voided_data[player_data.Player.Index];
		if not void_data or not player_entity:HasCollectible(void_id) then return; end
		
		local scale = mod.Config.CoopHUD.compat.VOIDED.scale * player_data.Player.Scale;
		local color = mod.Config.CoopHUD.compat.VOIDED.colors and Utils.ConvertColorToColorize(player_data.Player.Color,mod.Config.CoopHUD.compat.VOIDED.opacity) or Color(1, 1, 1, mod.Config.CoopHUD.compat.VOIDED.opacity);
		
		if CoopHUD.Refresh then
			void_data.Data = {};
			local isPlayerMapDown = CoopHUD.IsPlayerMapDown[player_data.Controller];
			local visible = CoopHUD.IsElementVisible(mod.Config.CoopHUD.compat.VOIDED.display);
			if not visible then return; end
			
			local inventory = player_entity:GetVoidedCollectiblesList();
			if DIVIDED_VOID then
				local data = player_entity:GetData();
				if not data or not data.DIV_VOID_data then return; end
				inventory = {}; -- Convert to VoidedCollectiblesList
				for item,_ in pairs(data.DIV_VOID_data.VoidedItems) do table.insert(inventory,tonumber(item)); end
				if #inventory == 0 then return; end
			end
				
			local edge = player_data.Edge;
			local space = mod.Config.CoopHUD.compat.VOIDED.space;
			local pos = edge.Pos + ((position + ((mod.Config.CoopHUD.compat.VOIDED.offset) * scale)) * edge.Multipliers);
			local item_offset = Vector.Zero;
				
			if #inventory > 0 then
				local direction = mod.Config.CoopHUD.compat.VOIDED.direction;
				local dir_multi = Vector(direction == Direction.LEFT and -1 or 1,direction == Direction.UP and -1 or 1);
				dir_multi = dir_multi * Vector((mod.Config.CoopHUD.compat.VOIDED.invert_direction.X == 1 or (player_data.Player.Index % 2) == 0) and -1 or 1, mod.Config.CoopHUD.compat.VOIDED.invert_direction.Y == 1 and -1 or 1);
				local max_grid = mod.Config.CoopHUD.compat.VOIDED.max_grid;
				local grid = Vector.One;
				local item_offset = Vector.Zero;
				for i = 1, #inventory, 1 do
					if i > mod.Config.CoopHUD.compat.VOIDED.max then break; end
					local collectible_type = inventory[(#inventory - (i - 1))];
					void_data.Data[i] = {Item = Isaac.GetItemConfig():GetCollectible(collectible_type).GfxFileName, Pos = (pos + item_offset)};
					if direction == Direction.LEFT or direction == Direction.RIGHT then
						grid.X = grid.X + 1;
						if grid.X <= max_grid.X then
							item_offset.X = item_offset.X + (space.X * dir_multi.X);
						else
							grid.X = 1; grid.Y = grid.Y + 1; 
							if grid.Y <= max_grid.Y then item_offset = Vector(0,item_offset.Y + (space.Y * dir_multi.Y)); else item_offset = Vector.Zero; grid.Y = 1; end
						end
					else
						grid.Y = grid.Y + 1;
						if grid.Y <= max_grid.Y then
							item_offset.Y = item_offset.Y + (space.Y * dir_multi.Y);
						else
							grid.Y = 1; grid.X = grid.X + 1; 
							if grid.X <= max_grid.X then item_offset = Vector(item_offset.X + (space.X * dir_multi.X),0); else item_offset = Vector.Zero; grid.X = 1; end
						end
					end
				end
			end
		end
		
		if void_data.Sprite and #void_data.Data > 0 then
			for i,data in pairs(void_data.Data) do
				void_data.Sprite:ReplaceSpritesheet(1, data.Item);
				void_data.Sprite:LoadGraphics();
				void_data.Sprite.Color = color;
				void_data.Sprite.Scale = scale;
				void_data.Sprite:Render(data.Pos);
			end
		end
	end
	mod.Registry:AddCallback(mod.Callbacks.HUD_POST_PLAYER_RENDER, voided_function);
end
