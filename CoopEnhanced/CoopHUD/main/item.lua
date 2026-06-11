local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Active = CoopHUD.Item.Active;
local ChargeBar = CoopHUD.Item.ChargeBar;
local Inventory = CoopHUD.Item.Inventory;
local Trinket = CoopHUD.Item.Trinket;
local Pocket = CoopHUD.Item.Pocket;

local game = Game();
local Utils = mod.Utils;

function Active.GetBook(player_entity, id)
	local hasVirtues = player_entity:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and id ~= CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES;
	local hasBelial = (player_entity:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) or player_entity:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE)) and player_entity:GetActiveItem(ActiveSlot.SLOT_SECONDARY) ~= CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL and id ~= CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL;

	if hasVirtues and hasBelial then return mod.Images.BookOfBelialVirtues; end
	if hasVirtues then return mod.Images.BookOfVirtues; end
	if hasBelial then return mod.Images.BookOfBelial; end
	return nil;
end

function Pocket.GetCardType(id)
	local card = Isaac.GetItemConfig():GetCard(id);
	local card_type = -1;
	if card and card.CardType then 
		card_type = CoopHUD.Item.CardBacks[id] ~= nil and CoopHUD.Item.CardBacks[id] or (card.CardType == ItemConfig.CARDTYPE_SUIT and CoopHUD.CardType.SUIT or (card.CardType == ItemConfig.CARDTYPE_TAROT and CoopHUD.CardType.TAROT or (card.CardType == ItemConfig.CARDTYPE_TAROT_REVERSE and CoopHUD.CardType.REVERSE or card_type)));
	end
	return card_type;
end

function Pocket.GetPillType(id)
	local pill_type = -1;
	if id and id > PillColor.PILL_NULL then
		pill_type = id < PillColor.NUM_PILLS and CoopHUD.PillType.VANILLA or (id < PillColor.PILL_GIANT_FLAG and CoopHUD.PillType.MODDED or (id < (PillColor.NUM_PILLS + PillColor.PILL_GIANT_FLAG) and CoopHUD.PillType.VANILLA_HORSE or CoopHUD.PillType.MODDED_HORSE));
	end
	return pill_type;
end

function Pocket.GetPillAnm2(id)
	local pill = XMLData.GetEntityByTypeVarSub(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_PILL,id); -- Get Pill entity to get custom pill anm2
	if Pocket.GetPillType(id) > CoopHUD.PillType.VANILLA_HORSE and pill and pill.anm2root then
		return (pill.anm2root .. pill.anm2path);
	end
	return nil;
end

function Pocket.GetItem(slot, player_entity)
	local pocket_item = player_entity:GetPocketItem(slot);
	local type = pocket_item:GetSlot() > 0 and pocket_item:GetType() or -1;
	local id = type == PocketItemType.ACTIVE_ITEM and player_entity:GetActiveItemDesc((pocket_item:GetSlot() - 1)).Item or (type > -1 and pocket_item:GetSlot() or CollectibleType.COLLECTIBLE_NULL);
	local name = id > CollectibleType.COLLECTIBLE_NULL and type > -1 and ((type == PocketItemType.PILL and (id > PillColor.PILL_NULL and game:GetItemPool():IsPillIdentified(id) and XMLData.GetEntryById(XMLNode.PILL, game:GetItemPool():GetPillEffect(id,player_entity)).name or "???")) or (XMLData.GetEntryById((type == PocketItemType.CARD and XMLNode.CARD or XMLNode.ITEM),id).name or "")) or "";
	local extra_data = type == PocketItemType.ACTIVE_ITEM and player_entity:GetActiveItemDesc((pocket_item:GetSlot() - 1)).VarData or (type == PocketItemType.CARD and Pocket.GetCardType(id) or (type == PocketItemType.PILL and Pocket.GetPillAnm2(id)));
	return {ID = id, Type = type, Name = name, Slot = (pocket_item:GetSlot() - 1), Extra = extra_data};
end

function Pocket.GetItems(player_entity)
	local pocket_items = {};
	local pocket_total = 0;
	for slot = PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY, 1 do
		pocket_items[slot] = Pocket.GetItem(slot, player_entity);
		if pocket_items[slot].Type > -1 then pocket_total = pocket_total + 1; end
	end
	return pocket_items, pocket_total;
end

function ChargeBar.GetCharge(current_charge, max_charge, partial_charge);
	if not current_charge then return Vector(1,1);
	elseif current_charge <= 0 and (partial_charge == nil or partial_charge <= 0) then
		return Vector(1, 26);
	elseif current_charge >= max_charge then
		return Vector(1, 3);
	elseif ChargeBar.Charge[max_charge] == nil then
		return Vector(1, 28 - (current_charge * (24 / max_charge)));
	elseif partial_charge ~= nil and partial_charge > 0 and ChargeBar.Charge[max_charge] and ChargeBar.Charge[max_charge][current_charge + 1] then
		local init = ChargeBar.Charge[max_charge][current_charge];
		local partial = (init - ChargeBar.Charge[max_charge][current_charge + 1]) * partial_charge;
		return Vector(1, init - partial);
	end

	return Vector(1, ChargeBar.Charge[max_charge][current_charge]);
end

function Inventory.Add(player_data, item)
	if player_data.Player.Type == PlayerType.PLAYER_ISAAC_B and CoopHUD.Item.Inventory.IgnoredCollectibles[item.ID] then return; end
	local max_slots = Inventory.Functions[player_data.Player.Type] and Inventory.Functions[player_data.Player.Type](player_data);
	if max_slots and #player_data.Inventory.Passive.Data >= max_slots then
		player_data.Inventory.Passive.Data[1] = {Slot = 1, Item = {ID = item.ID, GfxFileName = item.GfxFileName}};
		return;
	end
	table.insert(player_data.Inventory.Passive.Data, {Slot = (#player_data.Inventory.Passive.Data + 1), Item = {ID = item.ID, GfxFileName = item.GfxFileName}});
end

function Inventory.Remove(player_data, item)
	for i = #player_data.Inventory.Passive.Data, 1, -1 do
		local item_data = player_data.Inventory.Passive.Data[i];
		if item_data and item_data.ID == item.ID then
			table.remove(player_data.Inventory.Passive.Data, i);
			break;
		end
	end
end

function Inventory.Shift(player_data, amount)
	if mod.Config.CoopHUD.inventory.items.cycling or player_data.Player.Type == PlayerType.PLAYER_ISAAC_B then
		player_data.Inventory.Passive.Slot = player_data.Inventory.Passive.Slot or 1;
		amount = amount ~= nil and amount > 0 and amount or 1;
		for i = 1, amount, 1 do
			player_data.Inventory.Passive.Slot = player_data.Inventory.Passive.Slot >= #player_data.Inventory.Passive.Data and 1 or (player_data.Inventory.Passive.Slot + 1);
			for ii = 1, #player_data.Inventory.Passive.Data - 1, 1 do
				table.insert(player_data.Inventory.Passive.Data, 1, table.remove(player_data.Inventory.Passive.Data, #player_data.Inventory.Passive.Data));
			end
		end
	end
end

function Inventory.Reload(player_data, player_entity)
	if player_data and player_data.Inventory then
		local item_config = Isaac.GetItemConfig();
		player_data.Inventory.Passive.Data = {};
		local history_items = player_entity:GetHistory():GetCollectiblesHistory();
		for i,history in pairs(history_items) do
			local item = item_config:GetCollectible(history:GetItemID());
			if item and item.Type ~= ItemType.ITEM_ACTIVE and item.Type ~= ItemType.ITEM_TRINKET and (player_entity:GetPlayerType() ~= PlayerType.PLAYER_ISAAC_B or not CoopHUD.Item.Inventory.IgnoredCollectibles[item.ID]) then table.insert(player_data.Inventory.Passive.Data,{Slot = (#player_data.Inventory.Passive.Data + 1), Item = {ID = item.ID, GfxFileName = item.GfxFileName}}); end
		end
		player_data.Inventory.Passive.Slot = 1;
	end
end

function Active.GetSprite(sprite, active_data, player_entity)
	if not active_data.Item then return nil; end
	sprite = sprite or Sprite();
	
	local item_image = Isaac.GetItemConfig():GetCollectible(active_data.Item.ID).GfxFileName;
	local sprite_data = {Anm2 = mod.Animations.Active, Animation = "Idle", Frame = 0, Sheets = {[0] = item_image, [1] = item_image, [2] = item_image},Play = nil};
	if active_data.Bar.Charge.Full then sprite_data.Frame = 1; end
	
	if active_data.Item.Book then
		sprite_data.Sheets[3] = active_data.Item.Book;
		sprite_data.Sheets[4] = active_data.Item.Book;
		if mod.Config.CoopHUD.active.book_charge_outline then sprite_data.Sheets[5] = active_data.Item.Book; end
	end
	
	local special_func = CoopHUD.Item.Active.Functions[active_data.Item.ID];
	if special_func then
		special_func(sprite, active_data, sprite_data, player_entity);
		if not sprite_data then return sprite; end
	end
	
	sprite:Load(sprite_data.Anm2, false);
	sprite.Scale = active_data.Scale;
	sprite.Color = active_data.Color;
	
	if sprite_data.Sheets then
		for id,sheet in pairs(sprite_data.Sheets) do
			sprite:ReplaceSpritesheet(id,sheet);
		end
	end
	if sprite_data.Play then sprite:Play(sprite_data.Animation); end
	if sprite_data.Animation then sprite:SetFrame(sprite_data.Animation, sprite_data.Frame); else sprite:SetFrame(sprite_data.Frame); end
	sprite:LoadGraphics();
	return sprite;
end

function Pocket.GetSprite(sprite, pocket_data, player_entity)
	if not pocket_data.Item or pocket_data.Item.Type < 0 then return; end
	local sprite_data = {Anm2 = "", Animation = "", Frame = 0, Sheets = {}};
	
	sprite = sprite or Sprite();
	sprite.Scale = pocket_data.Scale;
	sprite.Color = pocket_data.Color;

	if pocket_data.Item.Type == PocketItemType.CARD or pocket_data.Item.Type == PocketItemType.PILL then
		local item_config = Isaac.GetItemConfig();
		sprite_data.Anm2 = mod.Animations.Pocket;
		sprite_data.Animation = (pocket_data.Item.Type == PocketItemType.CARD and "cards" or "pills");
		sprite_data.Frame = pocket_data.Item.ID;
		sprite_data.Sheets[0] = mod.Images.CardsPills;
		sprite_data.Sheets[1] = mod.Images.CardFronts;
		sprite_data.Sheets[2] = mod.Images.Blank;
		
		if pocket_data.Item.Type == PocketItemType.CARD then
			local card = item_config:GetCard(pocket_data.Item.ID);
			if not mod.Config.CoopHUD.pocket[pocket_data.Slot].cardfronts and (type(pocket_data.Item.Extra) == "number" and pocket_data.Item.Extra >= 0) and (not card:IsRune() and card.CardType ~= ItemConfig.CARDTYPE_SPECIAL_OBJECT) then
				sprite_data.Sheets[0] = mod.Images.Blank;
				sprite_data.Sheets[1] = mod.Images.Blank;
				sprite_data.Sheets[2] = mod.Images.CardsPills;
				sprite_data.Frame = pocket_data.Item.Extra;
			elseif card.ModdedCardFront then
				local card_front = card.ModdedCardFront;
				sprite_data.Anm2 = card_front:GetFilename();
				sprite_data.Animation = card_front:GetAnimation():len() > 0 and card_front:GetAnimation() or Utils.GetLocalizedString("pocketitems",card.Name);
				sprite_data.Frame = card_front:GetFrame() >= 0 and card_front:GetFrame() or 0;
				for i,layer in pairs(card_front:GetAllLayers()) do
					sprite_data.Sheets[layer:GetLayerID()] = layer:GetSpritesheetPath();
				end
			end
		else --if pocket_data.Item.Type == PocketItemType.PILL then
			if type(pocket_data.Item.Extra) == "string" then -- Modded Pills
				sprite_data.Sheets = {};
				sprite_data.Anm2 = pocket_data.Item.Extra;
				sprite_data.Animation = nil;
				sprite_data.Frame = 0;
			else
				if Pocket.GetPillType(pocket_data.Item.ID) == CoopHUD.PillType.VANILLA_HORSE then  -- convert horse pill ID to match anm2
					sprite_data.Frame = (pocket_data.Item.ID - (PillColor.PILL_GIANT_FLAG - PillColor.NUM_PILLS));
				end
			end
		end
	else
		local special_func = CoopHUD.Item.Active.Functions[pocket_data.Item.ID];
		local item_image = Isaac.GetItemConfig():GetCollectible(pocket_data.Item.ID).GfxFileName;
		sprite_data.Anm2 = mod.Animations.Active;
		sprite_data.Animation = "Idle";
		sprite_data.Sheets = {[0] = item_image, [1] = item_image, [2] = item_image};
		if pocket_data.Bar.Charge and pocket_data.Bar.Charge.Full then sprite_data.Frame = 1; end
		
		if special_func then
			special_func(sprite, pocket_data, sprite_data, player_entity);
			if not sprite_data then return sprite; end
		end
	end
	sprite:Load(sprite_data.Anm2, true);
	if sprite_data.Sheets then
		for id,sheet in pairs(sprite_data.Sheets) do
			sprite:ReplaceSpritesheet(id,sheet);
		end
	end
	if sprite_data.Play then sprite:Play(sprite_data.Animation); end
	if sprite_data.Animation then sprite:SetFrame(sprite_data.Animation, sprite_data.Frame); else sprite:SetFrame(sprite:GetDefaultAnimation(),sprite_data.Frame); end
	sprite:LoadGraphics();

	return sprite;
end

function Trinket.GetSprite(sprite, trinket_data)
	if not trinket_data.Item then return; end
	local path = Isaac.GetItemConfig():GetTrinket(trinket_data.Item.ID).GfxFileName;
	if trinket_data.Item.ID & TrinketType.TRINKET_GOLDEN_FLAG > 0 then
		sprite:SetRenderFlags(AnimRenderFlags.GOLDEN);
	end

	sprite = sprite or Sprite();
	sprite.Scale = trinket_data.Scale;
	sprite.Color = trinket_data.Color;
	sprite:Load(mod.Animations.Trinket, false);
	sprite:ReplaceSpritesheet(1, path);

	sprite:SetRenderFlags(0);
	sprite:SetFrame("Idle", 0);
	sprite:LoadGraphics();

	return sprite;
end

function ChargeBar.GetSprite(sprite, charge_data);
	if not charge_data.Charge or charge_data.Charge.Max == 0 then return nil; end

	local ChargeAnim = mod.Animations.Chargebar;
	if not sprite or not sprite.overlay then sprite = {overlay = Sprite(ChargeAnim, true),charge = Sprite(ChargeAnim, true),bg = Sprite(ChargeAnim, true),extra = Sprite(ChargeAnim, true),beth = Sprite(ChargeAnim, true)}; end
	
	if ChargeBar.Charge[charge_data.Charge.Max] ~= nil then
		sprite.overlay:Load(ChargeAnim, true);
		sprite.overlay:SetFrame("BarOverlay" .. charge_data.Charge.Max, 0);
	else
		sprite.overlay:Load(ChargeAnim, false);
	end
	sprite.overlay.Scale = charge_data.Scale;
	sprite.overlay.Color = charge_data.Color;
	
	sprite.charge:SetFrame("BarFull", 0);
	sprite.charge.Scale = charge_data.Scale;
	sprite.charge.Color = charge_data.Color;
	
	sprite.bg:SetFrame("BarEmpty", 0);
	sprite.bg.Scale = charge_data.Scale;
	sprite.bg.Color = charge_data.Color;

	sprite.extra:SetFrame("BarFull", 0);
	sprite.extra.Scale = charge_data.Scale;
	sprite.extra.Color = ChargeBar.ExtraColor;

	if charge_data.Charge.Soul > 0 or charge_data.Charge.Blood > 0 then
		local beth_color = Utils.ConvertColorToColorize(charge_data.Charge.Blood > 0 and Utils.GetColorByName("Blood") or Utils.GetColorByName("Soul"));
		sprite.beth:SetFrame("BarFull", 0);
		sprite.beth.Color = beth_color;
		sprite.beth.Scale = charge_data.Scale;
	end
	return sprite;
end

function Inventory.GetSprite(sprite, special_data, player_data, max_slots, row_size, inventory, extra_offset);
	sprite = sprite or Sprite();
	extra_offset = extra_offset or (mod.Config.CoopHUD.inventory.special.space_extra * #player_data.Inventory.Special.Data);
	
	local scale = mod.Config.CoopHUD.inventory.special.scale * player_data.Player.Scale;
	local screen_edge = player_data.Edge.Pos + player_data.Edge.Offset + (((CoopHUD.Positions.Special + mod.Config.CoopHUD.inventory.special.offset) * player_data.Player.Scale) * player_data.Edge.Multipliers);
	local offset = Vector(0,mod.Config.CoopHUD.inventory.special.offset_w_pockets and player_data.Inventory.Pocket.Total > 0 and player_data.Inventory.Pocket.Total * ((32 + (player_entity:GetTrinket(mod.TrinketSlot.PRIMARY) ~= TrinketType.TRINKET_NULL and (18 * mod.Config.CoopHUD.trinket[mod.TrinketSlot.PRIMARY].scale.X) or 2)) * (mod.Config.CoopHUD.pocket[(player_data.Inventory.Pocket.Total - 1)].scale.Y * scale.Y)) or 0);
				
	local data = {};
	local row = 0;
	local total = 0;
	for i = 1, max_slots, 1 do
		if i % (row_size + 1) == 0 and i ~= 1 then
			row = row + 1;
			offset.X = 0;
			offset.Y = offset.Y + (mod.Config.CoopHUD.inventory.special.space.Y * scale.Y);
		end
		data[i] = {Item = inventory[i], Pos = (screen_edge + ((offset + extra_offset) * player_data.Edge.Multipliers))};
		offset.X = offset.X + (mod.Config.CoopHUD.inventory.special.space.X * scale.X);
		if inventory[i] ~= nil then total = total + 1; end
	end
	
	sprite.Color = Color(1,1,1,mod.Config.CoopHUD.inventory.special.opacity);
	sprite.Scale = scale;
	special_data.Total = total;
	special_data.Data = data;
	
	return sprite;
end

function Active.Render(player_number);
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_ACTIVE_RENDER, player_number, mod.CoopHUD.DATA.Players[player_number].Inventory.Active); -- Execute Pre Active Render Callbacks (actives_data(table))
	
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	if not player_data.Inventory.Active.Visible then return; end
	
	local actives = player_data.Inventory.Active.Data;
	for slot = #actives, ActiveSlot.SLOT_PRIMARY, -1 do -- Run in reverse to have the secondary active render behind the primary
		if actives[slot] == nil then goto continue end
		local d = actives[slot].Data;
		if d == nil or d.Item == nil or actives[slot].Sprite == nil then goto continue; end

		actives[slot].Sprite:Render(d.Item.Pos);
		if d.BarExtra and actives[slot].ChargeExtraSprite then			
			actives[slot].ChargeExtraSprite.bg:Render(d.BarExtra.Pos);
			actives[slot].ChargeExtraSprite.charge:Render(d.BarExtra.Pos, ChargeBar.GetCharge(d.BarExtra.Charge.Current, d.BarExtra.Charge.Max, d.BarExtra.Charge.Partial));
			actives[slot].ChargeExtraSprite.extra:Render(d.BarExtra.Pos, ChargeBar.GetCharge(d.BarExtra.Charge.Extra, d.BarExtra.Charge.Max));
			if ChargeBar.Charge[d.BarExtra.Charge.Max] ~= nil then actives[slot].ChargeExtraSprite.overlay:Render(d.BarExtra.Pos); end
		end
		if d.Bar.Display and actives[slot].ChargeSprite then			
			actives[slot].ChargeSprite.bg:Render(d.Bar.Pos);
			if d.Bar.Charge.Soul > 0 and actives[slot].ChargeSprite.beth then actives[slot].ChargeSprite.beth:Render(d.Bar.Pos, ChargeBar.GetCharge(d.Bar.Charge.Soul + d.Bar.Charge.Current, d.Bar.Charge.Max));
			elseif d.Bar.Charge.Blood > 0 and actives[slot].ChargeSprite.beth then actives[slot].ChargeSprite.beth:Render(d.Bar.Pos, ChargeBar.GetCharge(d.Bar.Charge.Blood + d.Bar.Charge.Current, d.Bar.Charge.Max)); end
			actives[slot].ChargeSprite.charge:Render(d.Bar.Pos, ChargeBar.GetCharge(d.Bar.Charge.Current, d.Bar.Charge.Max, d.Bar.Charge.Partial));
			actives[slot].ChargeSprite.extra:Render(d.Bar.Pos, ChargeBar.GetCharge(d.Bar.Charge.Extra, d.Bar.Charge.Max));
			if ChargeBar.Charge[d.Bar.Charge.Max] ~= nil then actives[slot].ChargeSprite.overlay:Render(d.Bar.Pos); end
		end
		if d.Function then d.Function(player_data,slot); end
		::continue::
	end
end

function Trinket.Render(player_number);
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_TRINKET_RENDER, player_number, mod.CoopHUD.DATA.Players[player_number].Inventory.Trinket); -- Execute Pre Trinket Render Callbacks (trinkets_data(table))
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	if not player_data.Inventory.Trinket.Visible then return; end
	
	local trinkets = player_data.Inventory.Trinket.Data;
	for slot,trinket in pairs(trinkets) do
		local d = trinket.Data;
		if d and d.Item and trinket.Sprite then 
			if d.Function then d.Function(player_data,slot); end
			trinket.Sprite:Render(d.Item.Pos);
		end
	end
end

function Pocket.Render(player_number);
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_POCKET_RENDER, player_number, mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket); -- Execute Pre Pocket Render Callbacks (pockets_data(table))
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	local pockets = player_data.Inventory.Pocket.Data;
	
	if not player_data.Inventory.Pocket.Visible then return; end
	for slot = PillCardSlot.QUATERNARY, PillCardSlot.PRIMARY, -1 do
		local d = pockets[slot] and pockets[slot].Data or nil;
		if d and d.Item and pockets[slot].Sprite then 
			pockets[slot].Sprite:Render(d.Item.Pos);
			if d.Text then
				mod.Fonts.CoopHUD.pocket:DrawStringScaled(
					d.Text.Value,
					d.Text.Pos.X, d.Text.Pos.Y,
					d.Text.Scale.X, d.Text.Scale.Y,
					d.Text.Color, d.Text.Width or 0, d.Text.Center or true
				);
			end
			if d.BarExtra and d.BarExtra.Display and d.BarExtra.Charge and pockets[slot].ChargeExtraSprite then
				pockets[slot].ChargeExtraSprite.bg:Render(d.BarExtra.Pos);
				pockets[slot].ChargeExtraSprite.charge:Render(d.BarExtra.Pos, ChargeBar.GetCharge(d.BarExtra.Charge.Current, d.BarExtra.Charge.Max));
				pockets[slot].ChargeExtraSprite.extra:Render(d.BarExtra.Pos, ChargeBar.GetCharge(d.BarExtra.Charge.Extra, d.BarExtra.Charge.Max));
				if ChargeBar.Charge[d.BarExtra.Charge.Max] ~= nil then pockets[slot].ChargeExtraSprite.overlay:Render(d.BarExtra.Pos); end
			end
			if d.Bar.Display and d.Bar.Charge and pockets[slot].ChargeSprite then
				pockets[slot].ChargeSprite.bg:Render(d.Bar.Pos);
				if d.Bar.Charge.Soul > 0 and pockets[slot].ChargeSprite.beth then pockets[slot].ChargeSprite.beth:Render(d.Bar.Pos, ChargeBar.GetCharge(d.Bar.Charge.Soul, d.Bar.Charge.Max));
				elseif d.Bar.Charge.Blood > 0 and pockets[slot].ChargeSprite.beth then pockets[slot].ChargeSprite.beth:Render(d.Bar.Pos, ChargeBar.GetCharge(d.Bar.Charge.Blood, d.Bar.Charge.Max)); end
				pockets[slot].ChargeSprite.charge:Render(d.Bar.Pos, ChargeBar.GetCharge(d.Bar.Charge.Current, d.Bar.Charge.Max));
				pockets[slot].ChargeSprite.extra:Render(d.Bar.Pos, ChargeBar.GetCharge(d.Bar.Charge.Extra, d.Bar.Charge.Max));
				if ChargeBar.Charge[d.Bar.Charge.Max] ~= nil then pockets[slot].ChargeSprite.overlay:Render(d.Bar.Pos); end
			end
			if d.Function then d.Function(player_data,slot); end
		end
	end
end

function Inventory.Render(player_number) 
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_INVENTORY_RENDER, player_number, mod.CoopHUD.DATA.Players[player_number].Inventory.Special); -- Execute Pre Inventory Render Callbacks (inventory_data(table))
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	
	if player_data.Inventory.Special.Visible and #player_data.Inventory.Special.Data > 0 then
		for i, special_data in pairs(player_data.Inventory.Special.Data) do
			if special_data.Sprite then
				for i,data in pairs(special_data.Data) do
					if data.Pos then 
						if special_data.Function then special_data.Sprite = special_data.Function(special_data.Sprite,data,i); end
						special_data.Sprite:Render(data.Pos);
					end
				end
			end
		end
	end
	
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_PASSIVE_RENDER, player_number, mod.CoopHUD.DATA.Players[player_number].Inventory.Passive); -- Execute Pre Passives Render Callbacks (passives_data(table))
	if player_data.Inventory.Passive.Visible and player_data.Inventory.Passive.Sprite then
		for i,data in pairs(player_data.Inventory.Passive.Data) do
			if i > player_data.Inventory.Passive.Maximum then break; end
			if data.Item and data.Pos then
				player_data.Inventory.Passive.Sprite:ReplaceSpritesheet(1, data.Item.GfxFileName);
				player_data.Inventory.Passive.Sprite:LoadGraphics();
				player_data.Inventory.Passive.Sprite:Render(data.Pos);
			end
		end
	end
end