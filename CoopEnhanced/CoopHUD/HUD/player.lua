local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local DATA = CoopHUD.DATA;
local Player = CoopHUD.Player;
local Stats = CoopHUD.Stats;
local Item = CoopHUD.Item;

local Utils = mod.Utils;

function Player.Render(player_number, screen_dimensions)
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	if player_data == nil then return; end
	
	local player = player_data.Player;
	local player_entity = player.Entity.Ref:ToPlayer();
	local isPlayerMapDown = CoopHUD.IsPlayerMapDown[player_data.Controller];
	local isTwin = player_number < 0;
	local isKeeper = Utils.IsKeeper(player_entity);
	local isBaby = Utils.IsBaby(player_entity);
	local isTemporary = Utils.IsTemporary(isTwin, player_entity);
	local extra_scale = isTwin and mod.Config.CoopHUD.players.twins.scale or Vector.One;
	
	if CoopHUD.Refresh then
		if not isTemporary and not isBaby then -- Don't render anything except Health for strawmen or similar player types		
			-- Stats
			mod.CoopHUD.DATA.Players[player_number].Stats.Visible = (not player_entity:IsCoopGhost() or mod.Config.CoopHUD.stats.ghosts) and (mod.Config.CoopHUD.stats.display == 0 or (mod.Config.CoopHUD.stats.display == 1 and isPlayerMapDown or (mod.Config.CoopHUD.stats.display == 2 and not isPlayerMapDown))) or false;
			if player_number == 1 then mod.CoopHUD.Stats.Deals.Visible = (mod.Config.CoopHUD.stats.deals.display == 0 and mod.CoopHUD.DATA.Players[player_number].Stats.Visible or true) or mod.Config.CoopHUD.stats.deals.display == 1 or (mod.Config.CoopHUD.stats.deals.display == 2 and isPlayerMapDown) or false; end
			
			if mod.CoopHUD.DATA.Players[player_number].Stats.Visible or (player_number == 1 and mod.CoopHUD.Stats.Deals.Visible) then
				local stats = Stats.GetStats(player_entity, player_number);
				local opacity = mod.Config.CoopHUD.stats.opacity;
				local scale = mod.Config.CoopHUD.stats.scale;
				local size = (16 * scale.X);
				local seperation = 14 * scale.Y;
				local edge_indexed = ((player.Index % 2) == 0 and (screen_dimensions.Max.X - (player_data.Edge.Offset.X + size))) or player_data.Edge.Offset.X;
				local edge_multipliers = Vector(player_data.Edge.Multipliers.X, 1);
				local stats_edge = Vector(edge_indexed, player_data.Edge.Offset.Y);
				
				local pos = stats_edge + ((mod.Config.CoopHUD.stats.offset + ((CoopHUD.Positions.Stats + (isTwin and mod.Config.CoopHUD.stats.twin_offset or Vector.Zero) + (((player.Index) > 2) and mod.Config.CoopHUD.stats.lowered_offset or Vector.Zero))) * scale) * edge_multipliers);
				
				if ((player.Index) % 2) == 0 then
					pos = pos + mod.Config.CoopHUD.stats.mirrored_offset;
				end
					
				if mod.CoopHUD.DATA.Players[player_number].Stats.Visible then
					for slot = Stats.Stat.SPEED, Stats.Stat.LUCK, 1 do
						local stat = stats[slot];
						if stat ~= nil then
							stat.Sprite = stat.Sprite or Sprite(mod.Animations.Stats, true);
							stat.Scale = (stat.Scale or Vector.One) * scale;
							stat.Color = Utils.ColorOpacity((mod.Config.CoopHUD.stats.text.colors and player.Color or Color.Default),opacity);
							if slot > Stats.Stat.SPEED then pos = pos + (mod.Config.CoopHUD.stats.rel_offset + Vector(0,seperation)) * edge_multipliers; end
							stat.Pos = Utils.cloneTable(pos);
							stat.Render = not isTwin and player.Index < 3; -- Set whether the sprite image is rendered
							stat.Edge = Vector(edge_multipliers.X, 1);
							stat.Text.Pos = stat.Pos + (Vector(mod.Config.CoopHUD.stats.text.offset.X + (stat.Edge.X < 0 and mod.Fonts.CoopHUD.stats:GetStringWidth(stat.Text.Value) * mod.Config.CoopHUD.stats.text.scale.X or size), mod.Config.CoopHUD.stats.text.offset.Y) * stat.Edge);
							
							if CoopHUD.DATA.Players[player_number].Stats.Updates[slot] then
								local value = CoopHUD.DATA.Players[player_number].Stats.Updates[slot].Value;
								local prefix = value > 0 and '+' or '-';
								
								local value_text = string.format(stat.IsPercent and '%.1f%%' or '%.2f', math.abs(value));
								if ((player.Index) % 2) ~= 0 then value_text = prefix .. value_text; else value_text = value_text .. prefix; end
								local update_pos = stat.Text.Pos + ((mod.Config.CoopHUD.stats.text.update.offset + Vector(((stat.Edge.X > 0 and mod.Fonts.CoopHUD.stats:GetStringWidth(stat.Text.Value) or mod.Fonts.CoopHUD.stats:GetStringWidth(value_text)) + 2) * mod.Config.CoopHUD.stats.text.scale.X, 0)) * stat.Edge);
								
								mod.CoopHUD.DATA.Players[player_number].Stats.Updates[slot].Color = Utils.FontOpacity((value > 0 and KColor.Green or KColor.Red),opacity);
								mod.CoopHUD.DATA.Players[player_number].Stats.Updates[slot].Pos = update_pos;
								mod.CoopHUD.DATA.Players[player_number].Stats.Updates[slot].Text = {Value = value_text};
							end
						end
						mod.CoopHUD.DATA.Players[player_number].Stats.Data[slot] = stat;
					end
				end
				if player_number == 1 and mod.CoopHUD.Stats.Deals.Visible then
					local deals = mod.CoopHUD.Stats.Deals;
					deals.Anchor = mod.Config.CoopHUD.stats.deals.anchor;
					deals.Amount = 0;
					deals.Data = {};
					deals.Pos = Vector.Zero;
					for i = Stats.Stat.DEVIL, Stats.Stat.NUMBER, 1 do if stats[i] ~= nil then deals.Amount = deals.Amount + 1; end end
					deals.Pos.X = deals.Anchor < 2 and (screen_dimensions.Center.X - (((seperation * 3) * deals.Amount) / 2)) or (deals.Anchor == 2 and screen_dimensions.Max.X - pos.X or pos.X);
					deals.Pos.Y = deals.Anchor == 0 and screen_dimensions.Max.Y - size or deals.Anchor == 1 and -2 or 0;
					
					for slot = Stats.Stat.DEVIL, Stats.Stat.NUMBER, 1 do
						local stat = stats[slot];
						if stat ~= nil then
							stat.Sprite = stat.Sprite or Sprite(mod.Animations.Stats, true);
							stat.Scale = (stat.Scale or Vector.One) * scale;
							stat.Color = Utils.ColorOpacity((mod.Config.CoopHUD.stats.text.colors and (deals.Anchor == 3 and player.Color) or (deals.Anchor == 2 and mod.CoopHUD.DATA.Players[2] and mod.CoopHUD.DATA.Players[2].Player.Color) or Color.Default),opacity);
							if slot == Stats.Stat.DEVIL then 
								if deals.Anchor == 2 then edge_multipliers.X = -1; end
								pos = deals.Anchor < 2 and deals.Pos or (deals.Anchor == 2 and Vector(deals.Pos.X,pos.Y) or pos);
							else
								pos = pos + Vector(deals.Anchor < 2 and (seperation * 3) or 0, deals.Anchor >= 2 and seperation or 0);
							end
							stat.Pos = Utils.cloneTable(pos);
							stat.Render = true;
							stat.Edge = Vector(edge_multipliers.X, 1);
							stat.Text.Pos = stat.Pos + (Vector(mod.Config.CoopHUD.stats.text.offset.X + (stat.Edge.X < 0 and mod.Fonts.CoopHUD.stats:GetStringWidth(stat.Text.Value) * mod.Config.CoopHUD.stats.text.scale.X or size), mod.Config.CoopHUD.stats.text.offset.Y) * stat.Edge);
							
							if CoopHUD.DATA.Players[player_number].Stats.Updates[slot] then
								local value = CoopHUD.DATA.Players[player_number].Stats.Updates[slot].Value;
								local prefix = value > 0 and '+' or '-';
								
								local value_text = string.format(stat.IsPercent and '%.1f%%' or '%.2f', math.abs(value));
								if ((player.Index) % 2) ~= 0 then value_text = prefix .. value_text; else value_text = value_text .. prefix; end
								local update_pos = stat.Text.Pos + (((deals.Anchor < 2 and Vector(8, 4 * (deals.Anchor == 0 and -1 or 1)) or mod.Config.CoopHUD.stats.text.update.offset + Vector((mod.Fonts.CoopHUD.stats:GetStringWidth(stat.Text.Value) + 2) * mod.Config.CoopHUD.stats.text.scale.X, 0))) * stat.Edge);
								if stat.Edge.X < 0 then update_pos.X = update_pos.X - (mod.Fonts.CoopHUD.stats:GetStringWidth(value_text) * mod.Config.CoopHUD.stats.text.scale.X); end
								
								mod.CoopHUD.DATA.Players[player_number].Stats.Updates[slot].Color = Utils.FontOpacity((value > 0 and KColor.Green or KColor.Red),opacity);
								mod.CoopHUD.DATA.Players[player_number].Stats.Updates[slot].Pos = update_pos;
								mod.CoopHUD.DATA.Players[player_number].Stats.Updates[slot].Text = {Value = value_text};
							end
							table.insert(deals.Data, stat);
						end
						mod.CoopHUD.DATA.Players[player_number].Stats.Data[slot] = stat;
					end
					mod.CoopHUD.Stats.Deals = deals;
				end
			end
			CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_STATS_UPDATE, mod.CoopHUD.DATA.Players[player_number].Stats); -- Execute Post Stats data update Callbacks (stats_data(table))
			
			-- Active Items
			for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_SECONDARY, 1 do
				mod.CoopHUD.DATA.Players[player_number].Inventory.Active[slot].Data = {};
				local item_id = player_entity:GetActiveItem(slot);
				if item_id ~= CollectibleType.COLLECTIBLE_NULL then 
					local item_scale = mod.Config.CoopHUD.active[slot].scale * extra_scale;
					local item_size = 15 * item_scale.X;
					local bar_scale = mod.Config.CoopHUD.active[slot].chargebar.scale * extra_scale;
					local bar_size = 2 * bar_scale.X;
					
					local item_pos = player_data.Edge.Pos + (((CoopHUD.Positions.Active[slot] + mod.Config.CoopHUD.active[slot].offset) * extra_scale) * player_data.Edge.Multipliers);
					
					local bar_flip = 1;
					if mod.Config.CoopHUD.active[slot].chargebar.mirror then bar_flip = bar_flip * player_data.Edge.Multipliers.X; end
					if mod.Config.CoopHUD.active[slot].chargebar.invert then bar_flip = bar_flip > 0 and -bar_flip or math.abs(bar_flip); end
					local bar_pos = item_pos + ((Vector(item_size + (bar_flip < 0 and -bar_size or 0),1) + mod.Config.CoopHUD.active[slot].chargebar.offset) * Vector(bar_flip, player_data.Edge.Multipliers.Y));
					local current_charge = player_entity:GetActiveCharge(slot);
					local partial_charge = player_entity:GetActiveItemDesc(slot).PartialCharge;
					local max_charge = player_entity:GetActiveMaxCharge(slot);
					local soul_charge = player_entity:GetPlayerType() == PlayerType.PLAYER_BETHANY and player_entity:GetSoulCharge() or 0;
					local blood_charge = player_entity:GetPlayerType() == PlayerType.PLAYER_BETHANY_B and (player_entity:GetBloodCharge() + current_charge) or 0;
					local extra_charge = player_entity:GetBatteryCharge(slot);
					
					local book = nil
					if slot == ActiveSlot.SLOT_PRIMARY then
						book = Item.Active.GetBook(player_entity, item_id);
						if book then item_pos = item_pos + mod.Config.CoopHUD.active.book_correction_offset; end
					end
					
					local color = mod.Config.CoopHUD.active.colors and Utils.ConvertColorToColorize(player.Color,mod.Config.CoopHUD.active[slot].opacity) or Color.Default;
					
					local data = {Slot = slot, Item = {ID = item_id, Pos = item_pos, Desc = player_entity:GetActiveItemDesc(slot), Book = book}, Bar = {Display = mod.Config.CoopHUD.active[slot].chargebar.display, Flip = (bar_flip < 0), Pos = bar_pos, Charge = {Current = current_charge, Max = max_charge, Blood = blood_charge, Soul = soul_charge, Extra = extra_charge, Partial = partial_charge}, Scale = bar_scale, Color = color}, Scale = item_scale, Color = color};
					
					mod.CoopHUD.DATA.Players[player_number].Inventory.Active[slot].Data = data;
					mod.CoopHUD.DATA.Players[player_number].Inventory.Active[slot].ChargeSprite = max_charge > 0 and Item.ChargeBar.GetSprite(mod.CoopHUD.DATA.Players[player_number].Inventory.Active[slot].ChargeSprite, data.Bar) or nil;
					mod.CoopHUD.DATA.Players[player_number].Inventory.Active[slot].Sprite = Item.Active.GetSprite(mod.CoopHUD.DATA.Players[player_number].Inventory.Active[slot].Sprite, data, player_entity);
				end
			end
			CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_ACTIVE_UPDATE, mod.CoopHUD.DATA.Players[player_number].Inventory.Active); -- Execute Post Active Items data update Callbacks (actives_data(table))
			
			-- Pocket Items
			local pocket_items, pocket_total = Item.Pocket.GetItems(player_entity);
			mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket.Total = pocket_total;
			mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket.Visible = mod.Config.CoopHUD.pocket.display == 0 or (mod.Config.CoopHUD.pocket.display == 1 and isPlayerMapDown or (mod.Config.CoopHUD.pocket.display == 2 and not isPlayerMapDown or false));
			for slot = PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY, 1 do
				mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket[slot].Data = {};
				local item = pocket_items[slot];
				if mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket.Visible and item and item.ID ~= CollectibleType.COLLECTIBLE_NULL and item.Type > -1 then
					local item_scale = mod.Config.CoopHUD.pocket[slot].scale * extra_scale;
					local bar_scale = mod.Config.CoopHUD.pocket.chargebar.scale * extra_scale;
					local item_size = 14 * item_scale.X;
					local bar_size = 2 * bar_scale.X;
					
					item.Pos = player_data.Edge.Pos + (((CoopHUD.Positions.Pocket[slot] + mod.Config.CoopHUD.pocket[slot].offset) * extra_scale) * player_data.Edge.Multipliers);
					
					local bar_flip = 1;
					if mod.Config.CoopHUD.pocket.chargebar.mirror then bar_flip = bar_flip * player_data.Edge.Multipliers.X; end
					if mod.Config.CoopHUD.pocket.chargebar.invert then bar_flip = bar_flip > 0 and -bar_flip or math.abs(bar_flip); end
					
					local bar_pos = item.Pos + ((mod.Config.CoopHUD.pocket.chargebar.offset + Vector(item_size + (bar_flip < 0 and -bar_size or 0), 0)) * Vector(bar_flip, player_data.Edge.Multipliers.Y));
					local color = mod.Config.CoopHUD.pocket.colors and Utils.ConvertColorToColorize(player.Color,mod.Config.CoopHUD.pocket[slot].opacity) or Color.Default;
					local data = {Slot = slot, Item = item, Bar = {Display = mod.Config.CoopHUD.pocket.chargebar.display, Flip = (bar_flip < 0), Pos = bar_pos, Scale = bar_scale, Color = color}, Scale = item_scale, Color = color};
					
					if item.Type == PocketItemType.ACTIVE_ITEM then
						local partial_charge = player_entity:GetActiveItemDesc(item.Slot).PartialCharge;
						local current_charge = player_entity:GetActiveCharge(item.Slot);
						local max_charge = player_entity:GetActiveMaxCharge(item.Slot) or 0;
						local extra_charge = player_entity:GetBatteryCharge(item.Slot);
					local soul_charge = player_entity:GetPlayerType() == PlayerType.PLAYER_BETHANY and player_entity:GetSoulCharge() or 0;
					local blood_charge = player_entity:GetPlayerType() == PlayerType.PLAYER_BETHANY_B and (player_entity:GetBloodCharge() + current_charge) or 0;
						data.Bar.Charge = {Current = current_charge, Max = max_charge, Blood = blood_charge, Soul = soul_charge, Extra = extra_charge, Partial = partial_charge};
					end
						
					local isTextVisible = mod.Config.CoopHUD.pocket[slot].text.display == 0 or (mod.Config.CoopHUD.pocket[slot].text.display == 1 and isPlayerMapDown or (mod.Config.CoopHUD.pocket[slot].text.display == 2 and not isPlayerMapDown or false));
					if isTextVisible then
						local text_scale = mod.Config.CoopHUD.pocket[slot].text.scale * extra_scale;
						local text_pos = item.Pos + ((mod.Config.CoopHUD.pocket[slot].text.offset + Vector(item_size + (6 * text_scale.X) + (bar_flip > 0 and bar_size * player_data.Edge.Multipliers.X or 0), -(mod.Fonts.CoopHUD.pocket:GetBaselineHeight(item.Name) / 1.5) * text_scale.Y)) * player_data.Edge.Multipliers);
						if player_data.Edge.Multipliers.X < 0 then text_pos.X = text_pos.X - (mod.Fonts.CoopHUD.pocket:GetStringWidth(item.Name) * text_scale.X); end
						if player_data.Edge.Multipliers.Y < 0 then text_pos.Y = text_pos.Y - mod.Fonts.CoopHUD.pocket:GetBaselineHeight(item.Name); end
						data.Text = {Value = item.Name,Pos = text_pos,Scale = text_scale, Color = Utils.ConvertColorToFont(color,mod.Config.CoopHUD.pocket[slot].text.opacity)};
					end
					mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket[slot].Data = data;
					mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket[slot].ChargeSprite = data.Bar.Charge and Item.ChargeBar.GetSprite(mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket[slot].ChargeSprite, data.Bar) or nil;
					mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket[slot].Sprite = Item.Pocket.GetSprite(mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket[slot].Sprite, data, player_entity);
				end
			end
			CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_POCKET_UPDATE, mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket); -- Execute Post Pocket Items data update Callbacks (pockets_data(table))
			
			-- Trinket Items
			for slot = mod.TrinketSlot.PRIMARY, mod.TrinketSlot.SECONDARY, 1 do
				mod.CoopHUD.DATA.Players[player_number].Inventory.Trinket[slot].Data = {};
				local item_id = player_entity:GetTrinket(slot);
				if item_id ~= TrinketType.TRINKET_NULL then
					local scale = mod.Config.CoopHUD.trinket[slot].scale * extra_scale;
					local pocket_offset = pocket_total ~= nil and pocket_total > 0 and (mod.Config.CoopHUD.trinket[slot].pocket_offset and Vector(0,pocket_total * (20 * mod.Config.CoopHUD.pocket[(pocket_total - 1)].scale.Y))) or Vector.Zero;
					local pos = player_data.Edge.Pos + (((CoopHUD.Positions.Trinket[slot] + mod.Config.CoopHUD.trinket[slot].offset + pocket_offset) * extra_scale) * player_data.Edge.Multipliers);
					if player_data.Edge.Multipliers.Y < 0 then pos.Y = pos.Y + 20; end
					local color = Utils.ColorOpacity((mod.Config.CoopHUD.trinket.colors and player.Color or Color.Default),mod.Config.CoopHUD.trinket[slot].opacity);
					local data = {Item = {ID = item_id, Pos = pos}, Scale = scale, Color = color};
					mod.CoopHUD.DATA.Players[player_number].Inventory.Trinket[slot].Data = data;
					mod.CoopHUD.DATA.Players[player_number].Inventory.Trinket[slot].Sprite = Item.Trinket.GetSprite(player_data.Inventory.Trinket[slot].Sprite, data);
				end
			end
			CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_TRINKET_UPDATE, mod.CoopHUD.DATA.Players[player_number].Inventory.Trinket); -- Execute Post Trinket Items data update Callbacks (trinkets_data(table))
			
			-- Special/Crafting Inventory
			local GetInfo = Item.Inventory.GetInfo[player.Type];
			mod.CoopHUD.DATA.Players[player_number].Inventory.Special.Visible = GetInfo ~= nil and (mod.Config.CoopHUD.inventory.special.display == 0 or (mod.Config.CoopHUD.inventory.special.display == 1 and isPlayerMapDown or (mod.Config.CoopHUD.inventory.special.display == 2 and not isPlayerMapDown or false)));
			mod.CoopHUD.DATA.Players[player_number].Inventory.Special.Data = {};
			if mod.CoopHUD.DATA.Players[player_number].Inventory.Special.Visible then
				local max_slots, row_size, inventory = GetInfo(player_data);
				local scale = mod.Config.CoopHUD.inventory.special.scale * extra_scale;
				local screen_edge = player_data.Edge.Pos + (((CoopHUD.Positions.Inventory + mod.Config.CoopHUD.inventory.special.offset) * extra_scale) * player_data.Edge.Multipliers);
				local offset = Vector(0,mod.Config.CoopHUD.inventory.special.pocket_offset and player_data.Inventory.Pocket.Total > 0 and player_data.Inventory.Pocket.Total * (32 * (mod.Config.CoopHUD.pocket[(player_data.Inventory.Pocket.Total - 1)].scale.Y * scale.Y)) or 0);
				
				local data = {};
				local row = 0;
				local total = 0;
				for i = 1, max_slots, 1 do
					if i % (row_size + 1) == 0 and i ~= 1 then
						row = row + 1;
						offset.X = 0;
						offset.Y = offset.Y + (mod.Config.CoopHUD.inventory.special.space.Y * scale.Y);
					end
					local item = inventory and inventory[i] or nil;
					data[i] = {Item = item, Pos = (screen_edge + (offset * player_data.Edge.Multipliers))};
					offset.X = offset.X + (mod.Config.CoopHUD.inventory.special.space.X * scale.X);
					if item ~= nil then total = total + 1; end
				end
				mod.CoopHUD.DATA.Players[player_number].Inventory.Special.Sprite = mod.CoopHUD.DATA.Players[player_number].Inventory.Special.Sprite or Sprite();
				mod.CoopHUD.DATA.Players[player_number].Inventory.Special.Sprite.Color = Color(1,1,1,mod.Config.CoopHUD.inventory.special.opacity);
				mod.CoopHUD.DATA.Players[player_number].Inventory.Special.Sprite.Scale = scale;
				mod.CoopHUD.DATA.Players[player_number].Inventory.Special.Total = total;
				mod.CoopHUD.DATA.Players[player_number].Inventory.Special.Data = data;
			end
			CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_INVENTORY_UPDATE, mod.CoopHUD.DATA.Players[player_number].Inventory.Special); -- Execute Post Inventory/Crafting data update Callbacks (inventory_data(table))
			
			mod.CoopHUD.DATA.Players[player_number].Inventory.Passive.Data = {};
			if not isTwin then
				-- Collectible/Passive Items
				mod.CoopHUD.DATA.Players[player_number].Inventory.Passive.Visible = mod.Config.CoopHUD.inventory.items.display == 0 or (mod.Config.CoopHUD.inventory.items.display == 1 and isPlayerMapDown or (mod.Config.CoopHUD.inventory.items.display == 2 and not isPlayerMapDown or false));
				if mod.CoopHUD.DATA.Players[player_number].Inventory.Passive.Visible then
					local anchor = mod.Config.CoopHUD.inventory.items.anchor;
					local edge = anchor == 0 and player_data.Edge.Pos.X or (anchor == 1 and screen_dimensions.Max.X - player_data.Edge.Offset.X or player_data.Edge.Offset.X);
					local edge_multiplier = (anchor == 1 and -1 or 1);
					local edge_indexed = Vector(edge, screen_dimensions.Max.Y - player_data.Edge.Offset.Y);
					local scale = mod.Config.CoopHUD.inventory.items.scale;
						
					mod.CoopHUD.Item.Inventory.Sprite = mod.CoopHUD.Item.Inventory.Sprite or Sprite(mod.Animations.Item, false);
					mod.CoopHUD.Item.Inventory.Sprite:SetFrame('Idle', 0);
					mod.CoopHUD.Item.Inventory.Sprite.Scale = scale;
					mod.CoopHUD.Item.Inventory.Sprite.Color = mod.Config.CoopHUD.inventory.items.colors and Utils.ConvertColorToColorize(player_data.Player.Color,mod.Config.CoopHUD.inventory.items.opacity) or Color(1, 1, 1, mod.Config.CoopHUD.inventory.items.opacity);
					
					local offset = Vector.Zero;
					local item_offset = mod.Config.CoopHUD.inventory.items.space * scale;
					local item_pos = edge_indexed + (mod.Config.CoopHUD.inventory.items.offset + Vector((((((edge_multiplier < 0 and mod.Players.Total - (player.Index - 1) or player.Index) * item_offset.X) / (anchor == 0 and 2 or 1)) + 16 + mod.Config.CoopHUD.inventory.items.space.X) * scale.X) * edge_multiplier, (-item_offset.Y * mod.Config.CoopHUD.inventory.items.max) - (8 * scale.Y)));
					local inventory = player_data.Inventory.Passive.Images or {};
					if #inventory > 0 and (not player_entity:IsCoopGhost() or mod.Config.CoopHUD.inventory.items.dead) then
						local data = {};
						for i = 1, #inventory, 1 do
							if i > mod.Config.CoopHUD.inventory.items.max then break; end
							local item = inventory[(#inventory - (i - 1))];
							data[i] = {Item = item, Pos = (item_pos + offset)};
							offset = offset + Vector(0,item_offset.Y);
						end
						mod.CoopHUD.DATA.Players[player_number].Inventory.Passive.Data = data;
					end
				end
				CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_PASSIVE_UPDATE, mod.CoopHUD.DATA.Players[player_number].Inventory.Passive); -- Execute Post Inventory/Crafting data update Callbacks (passives_data(table))
				
				-- Player Heads
				if mod.Config.CoopHUD.players.heads.display then
					local head_pos = player_data.Edge.Pos + ((CoopHUD.Positions.Active[ActiveSlot.SLOT_PRIMARY] + (Vector((player_data.Edge.Multipliers.X > 0 and -0.5 or 1),8) * mod.Config.CoopHUD.players.heads.scale) + mod.Config.CoopHUD.active[ActiveSlot.SLOT_PRIMARY].offset + mod.Config.CoopHUD.players.heads.offset + (player_entity:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 and not player_entity:IsCoopGhost() and (mod.Config.CoopHUD.players.heads.item_offset * mod.Config.CoopHUD.active[ActiveSlot.SLOT_PRIMARY].scale) or Vector(0,-4))) * player_data.Edge.Multipliers);
					local head_opacity = mod.Config.CoopHUD.players.heads.opacity;
					local head_sprite = Utils.getHeadSprite(mod.CoopHUD.DATA.Players[player_number].Label.Sprite, player_entity);
					if head_sprite then
						head_sprite.Color = mod.Config.CoopHUD.players.heads.sync.color and Utils.ConvertColorToColorize(CoopHUD.SkinColors[(player_entity:GetHeadColor())], head_opacity) or (mod.Config.CoopHUD.players.heads.color and Utils.ConvertColorToColorize(player.Color, head_opacity) or Utils.ColorOpacity(Color.Default, head_opacity));
						head_sprite.Scale = mod.Config.CoopHUD.players.heads.sync.scale and player_entity.SpriteScale or mod.Config.CoopHUD.players.heads.scale;
					end
					mod.CoopHUD.DATA.Players[player_number].Label = {Sprite = head_sprite, Pos = head_pos};
				end
				
				-- Name under/over Active Items
				if mod.Config.CoopHUD.players.names.display then
					if not mod.CoopHUD.DATA.Players[player_number].Label then mod.CoopHUD.DATA.Players[player_number].Label = {}; end
					local player_name = player.Config.type == 1 and (Utils.getMainTwin(player_entity) ~= nil and (player.Name .. " & " .. Utils.getPlayerName(Utils.getMainTwin(player_entity), player.Index, player.Config.type, "", mod.Config.CoopHUD.tainted))) or player.Name;
					local scale = math.min(1,(6 / string.len(player_name)));
					local name_size = Vector(mod.Fonts.CoopHUD.players:GetStringWidth(player_name),mod.Fonts.CoopHUD.players:GetBaselineHeight(player_name));
					local head_offset = mod.Config.CoopHUD.players.heads.display and mod.Config.CoopHUD.players.names.head_offset and player_entity:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 and not player_entity:IsCoopGhost() and ((mod.Config.CoopHUD.players.heads.item_offset.Y * (player_data.Edge.Multipliers.X > 0 and -1.5 or 1.5)) * mod.Config.CoopHUD.players.heads.scale.X) or 0;
					local item_pos = player_data.Edge.Pos + ((CoopHUD.Positions.Active[ActiveSlot.SLOT_PRIMARY] + mod.Config.CoopHUD.active[ActiveSlot.SLOT_PRIMARY].offset) * player_data.Edge.Multipliers)
					local name_pos = Vector(item_pos.X - ((head_offset * mod.Config.CoopHUD.active[ActiveSlot.SLOT_PRIMARY].scale.X) + (8 - mod.Config.CoopHUD.players.names.offset.X) * player_data.Edge.Multipliers.X), item_pos.Y + (((mod.Config.CoopHUD.players.names.offset.Y + 2) * mod.Config.CoopHUD.active[ActiveSlot.SLOT_PRIMARY].scale.Y) * player_data.Edge.Multipliers.Y));
					if player_data.Edge.Multipliers.X < 0 then name_pos.X = name_pos.X - (name_size.X * scale); end
					if player_data.Edge.Multipliers.Y < 0 then name_pos.Y = name_pos.Y - (name_size.Y * scale); end
					name_pos.X = math.max(2,name_pos.X) -- Prevent it from leaving the screen
					mod.CoopHUD.DATA.Players[player_number].Label.Text = {Value = player_name, Pos = name_pos, Scale = (mod.Config.CoopHUD.players.names.scale * scale),  Color = Utils.ConvertColorToFont(player.Color, mod.Config.CoopHUD.players.names.opacity)};
				end
				CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_LABEL_UPDATE, mod.CoopHUD.DATA.Players[player_number].Label); -- Execute Post Label data update Callbacks (label_data(table))
			end
		end
		
		-- Health and HP Bar
		if not isTemporary then
			local bar_pos,_ = CustomHealthAPI and CustomHealthAPI.Helper.GetHealthBarPos(player_entity, (player.Index - 1)) or Vector.Zero;
			local flip = false;
			local scale = mod.Config.CoopHUD.health.scale * extra_scale;
			local health_pos = (player_data.Edge.Pos + (((CoopHUD.Positions.Health + mod.Config.CoopHUD.health.offset + (isTwin and mod.Config.CoopHUD.health.twin.offset or Vector.Zero))) * scale) * player_data.Edge.Multipliers) - bar_pos;
			if (player.Index % 2) == 0 then
				flip = mod.Config.CoopHUD.health.invert;
				health_pos.X = health_pos.X - 1 - (mod.Config.CoopHUD.health.space.X * (flip and 0 or 5));
				if not flip and player_entity:GetExtraLives() > 0 then health_pos.X = health_pos.X - (mod.Config.CoopHUD.health.space.X * 1); end
			end
			if player.Index > 2 then
				health_pos.Y = health_pos.Y + 1 - mod.Config.CoopHUD.health.space.Y;
			end
			mod.CoopHUD.DATA.Players[player_number].Health = {Pos = health_pos, Flip = flip, Scale = scale};
		end
		CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_POST_HEALTH_UPDATE, mod.CoopHUD.DATA.Players[player_number].Health); -- Execute Post Health data update Callbacks (health_data(table))
	end
	
	if not isTwin then
		CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_LABEL_RENDER, mod.CoopHUD.DATA.Players[player_number].Label); -- Execute Pre Label Render Callbacks (label_data(table))
		local label_data = mod.CoopHUD.DATA.Players[player_number].Label;
		
		-- Head Rendering
		if mod.Config.CoopHUD.players.heads.display and label_data.Sprite and label_data.Pos then
			label_data.Sprite:Render(label_data.Pos);
		end
		
		-- Name Rendering
		if mod.Config.CoopHUD.players.names.display and label_data.Text and label_data.Text.Value then
			mod.Fonts.CoopHUD.players:DrawStringScaled(
				label_data.Text.Value,
				label_data.Text.Pos.X or 0, label_data.Text.Pos.Y or 0,
				label_data.Text.Scale.X or 1,label_data.Text.Scale.Y or 1,
				label_data.Text.Color or KColor.White, label_data.Text.Width or 0, label_data.Text.Center or true
			);
		end
	end
	
	Stats.Render(player_number);
	
	if player_entity:IsCoopGhost() or player_entity:IsDead() then return; end
	
	Item.Active.Render(player_number);
	Item.Trinket.Render(player_number);
	Item.Pocket.Render(player_number);
	Item.Inventory.Render(player_number);

	-- Health Bar rendering using CustomHealthAPI
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_HEALTH_RENDER, mod.CoopHUD.DATA.Players[player_number].Health); -- Execute Pre Health Render Callbacks (label_data(table))
	local player_health = mod.CoopHUD.DATA.Players[player_number].Health;
	if not player_health then return; end
	if CustomHealthAPI then
		if isTemporary or (isTwin and mod.Config.CoopHUD.health.twin.snap) or (not isTwin and mod.Config.CoopHUD.health.snap[player.Index]) then -- Render Health above character
			if not Utils.IsPauseMenuOpen() then -- Dont render over menus
				CustomHealthAPI.Helper.RenderPlayerHPBar(player_entity, -1);
			end
		else -- Render Normal Health
			CustomHealthAPI.Helper.RenderPlayerHPBar(player_entity, (player.Index - 1), player_health.Pos, mod.Config.CoopHUD.health.ignore_curse, player_health.Flip, player_health.Scale);
		end
	elseif not isTemporary then
		local hearts_sprite = Game():GetHUD():GetHeartsSprite();
		hearts_sprite.FlipX = player_health.Flip;
		hearts_sprite:Render(player_health.Pos);
	end
end