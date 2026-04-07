local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local DATA = CoopHUD.DATA;
local Item = CoopHUD.Item;
local Player = CoopHUD.Player;

local Active = Item.Active;
local ChargeBar = Item.ChargeBar;
local Inventory = Item.Inventory;
local Trinket = Item.Trinket;
local Pocket = Item.Pocket;

local Utils = mod.Utils;

function Active.GetBook(player_entity, id)
	local hasVirtues = player_entity:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and id ~= CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES;
	local hasBelial = player_entity:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) and id ~= CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL;
	local hasWeird = LibraryExpanded and player_entity:HasCollectible(LibraryExpanded.Item.WEIRD_BOOK.ID) and id == LibraryExpanded.Item.WEIRD_BOOK.ID;

	if hasVirtues and hasBelial then return mod.Images.BookOfBelialVirtues; end
	if hasVirtues then return mod.Images.BookOfVirtues; end
	if hasBelial then return mod.Images.BookOfBelial; end
	if hasWeird then return (not LibraryExpanded:PlayerRunSave(player_entity).isDeli and "gfx/ui/hud_bookofweird.png" or nil); end
	return nil;
end

function Pocket.GetItems(player_entity)
	local items = {};
	local total = 0;
	local item_pool = Game():GetItemPool();
	for slot = PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY, 1 do
		local pocket_item = player_entity:GetPocketItem(slot);
		local type = pocket_item:GetSlot() > 0 and pocket_item:GetType() or -1;
		local id = type == PocketItemType.ACTIVE_ITEM and player_entity:GetActiveItemDesc((pocket_item:GetSlot() - 1)).Item or pocket_item:GetSlot() or 0;
		if id > 2048 then id = (id - 2048) + 16; end -- convert horse pill ID to match anm2
		local name = id > 0 and type > -1 and ((type == PocketItemType.PILL and (id > PillColor.PILL_NULL and item_pool:IsPillIdentified(id) and XMLData.GetEntryById(XMLNode.PILL, item_pool:GetPillEffect(id,player_entity)).name or "???")) or (XMLData.GetEntryById((type == PocketItemType.CARD and XMLNode.CARD or XMLNode.ITEM),id).name or "")) or "";
		items[slot] = {ID = id, Type = type, Name = name, Slot = (pocket_item:GetSlot() - 1)};
		if type > -1 then total = total + 1; end
	end
	return items, total;
end

function ChargeBar.GetCharge(current_charge, max_charge, partial_charge);
	if not current_charge then return Vector(1,1);
	elseif current_charge <= 0 and (partial_charge == nil or partial_charge <= 0) then
		return Vector(1, 26);
	elseif current_charge >= max_charge then
		return Vector(1, 3);
	elseif ChargeBar.Charge[max_charge] == nil then
		return Vector(1, 28 - (current_charge * (24 / max_charge)));
	elseif partial_charge ~= nil and partial_charge > 0 then
		local init = ChargeBar.Charge[max_charge][current_charge];
		local partial = (init - ChargeBar.Charge[max_charge][current_charge + 1]) * partial_charge;
		return Vector(1, init - partial);
	end

	return Vector(1, ChargeBar.Charge[max_charge][current_charge]);
end

function Inventory.Add(player_data, item)
	local display, max_slots = Inventory.GetInfo[player_data.Player.Type];
	if display and max_slots ~= nil and #player_data.Inventory.Passive.Images == max_slots then
		player_data.Inventory.Passive.Images[1] = item.GfxFileName;
		return;
	end
	table.insert(player_data.Inventory.Passive.Images, item.GfxFileName);
end

function Inventory.Remove(player_data, item)
	for i,gfx in pairs(player_data.Inventory.Passive.Images) do
		if gfx:sub(-15) == item.GfxFileName:sub(-15) then
			table.remove(player_data.Inventory.Passive.Images, i);
			break;
		end
	end
end

function Inventory.Shift(player_data)
	for _ = 1, #player_data.Inventory - 1, 1 do
		table.insert(player_data.Inventory.Passive.Images, 1, table.remove(player_data.Inventory.Passive.Images, #player_data.Inventory.Passive.Images));
	end
end

function Inventory.Reload(player_data, player_entity)
	local item_config = Isaac.GetItemConfig();
	if player_data and player_data.Inventory then
		player_data.Inventory.Passive.Images = {};
		local history_items = player_entity:GetHistory():GetCollectiblesHistory();
		for i,history in pairs(history_items) do
			local item = item_config:GetCollectible(history:GetItemID());
			if item and item.Type ~= ItemType.ITEM_ACTIVE and item.Type ~= ItemType.ITEM_TRINKET then table.insert(player_data.Inventory.Passive.Images,item.GfxFileName); end
		end																																	
	end
end

function Active.GetSprite(sprite, active_data, player_entity)
	if not active_data.Item then return nil; end
	sprite = sprite or Sprite();
	
	local item_image = Isaac.GetItemConfig():GetCollectible(active_data.Item.ID).GfxFileName;
	local sprite_data = {Anm2 = mod.Animations.Active, Animation = "Idle", Frame = 0, Sheets = {[0] = item_image, [1] = item_image, [2] = item_image},Play = nil};
	if (active_data.Bar.Charge.Current + active_data.Bar.Charge.Soul >= active_data.Bar.Charge.Max and active_data.Bar.Charge.Max > 0) then sprite_data.Frame = 1; end
	local special_func = CoopHUD.Item.Active.Special[active_data.Item.ID];
	
	if active_data.Item.Book then
		sprite_data.Sheets[3] = active_data.Item.Book;
		sprite_data.Sheets[4] = active_data.Item.Book;
		if mod.Config.CoopHUD.active.book_charge_outline then sprite_data.Sheets[5] = active_data.Item.Book; end
	end
	
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
	if not pocket_data.Item then return; end
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
		
		if pocket_data.Item.Type == PocketItemType.CARD then
			local card = item_config:GetCard(pocket_data.Item.ID);
			if card.ModdedCardFront then
				local card_front = card.ModdedCardFront;
				sprite_data.Anm2 = card_front:GetFilename();
				sprite_data.Animation = card_front:GetAnimation():len() > 0 and card_front:GetAnimation() or card_front:GetDefaultAnimation();
				sprite_data.Frame = card_front:GetFrame() >= 0 and card_front:GetFrame() or 0;
				for i,layer in pairs(card_front:GetAllLayers()) do
					sprite_data.Sheets[layer:GetLayerID()] = layer:GetSpritesheetPath();
				end
			elseif not mod.Config.CoopHUD.pocket[pocket_data.Slot].cardfronts and not card:IsRune() and card.CardType ~= ItemConfig.CARDTYPE_SPECIAL_OBJECT and card.ID ~= Card.CARD_EMERGENCY_CONTACT then
				sprite_data.Sheets[1] = mod.Images.Blank;
				sprite_data.Sheets[2] = mod.Images.CardsPills;
				sprite_data.Frame = 0;

				if card.CardType == ItemConfig.CARDTYPE_TAROT then sprite_data.Frame = Pocket.CardBacks.Tarot;
				elseif card.CardType == ItemConfig.CARDTYPE_SUIT then sprite_data.Frame = Pocket.CardBacks.Suit;
				elseif card.CardType == ItemConfig.CARDTYPE_TAROT_REVERSE then sprite_data.Frame = Pocket.CardBacks.Reverse;
				elseif card.ID == Card.CARD_RULES or card.ID == Card.CARD_SUICIDE_KING or card.ID == Card.CARD_QUESTIONMARK or card.ID == Card.CARD_QUEEN_OF_HEARTS then sprite_data.Frame = Pocket.CardBacks.Suit;
				elseif card.ID == Card.CARD_CREDIT then sprite_data.Frame = Pocket.CardBacks.Credit;
				elseif card.ID == Card.CARD_HUMANITY then sprite_data.Frame = Pocket.CardBacks.Humanity;
				elseif card.ID == Card.CARD_GET_OUT_OF_JAIL then sprite_data.Frame = Pocket.CardBacks.Monopoly;
				elseif card.ID == Card.CARD_HOLY then sprite_data.Frame = Pocket.CardBacks.Holy;
				elseif card.ID == Card.CARD_WILD then sprite_data.Frame = Pocket.CardBacks.UNO;
				elseif card.ID == Card.CARD_CHAOS or card.ID == Card.CARD_HUGE_GROWTH or card.ID == Card.CARD_ANCIENT_RECALL or card.ID == Card.CARD_ERA_WALK then sprite_data.Frame = Pocket.CardBacks.Magic; end
			end
		end
	else
		local special_func = CoopHUD.Item.Active.Special[pocket_data.Item.ID];
		local item_image = Isaac.GetItemConfig():GetCollectible(pocket_data.Item.ID).GfxFileName;
		sprite_data.Anm2 = mod.Animations.Active;
		sprite_data.Animation = "Idle";
		sprite_data.Sheets = {[0] = item_image, [1] = item_image, [2] = item_image};
		if (pocket_data.Bar.Charge.Current + pocket_data.Bar.Charge.Soul >= pocket_data.Bar.Charge.Max and pocket_data.Bar.Charge.Max > 0) then sprite_data.Frame = 1; end
		
		if special_func then
			special_func(sprite, pocket_data, sprite_data, player_entity);
			if not sprite_data then return sprite; end
		end
	end
	sprite:Load(sprite_data.Anm2, false);
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
	sprite:SetFrame('Idle', 0);
	sprite:LoadGraphics();

	return sprite;
end

function ChargeBar.GetSprite(sprite, charge_data);
	if not charge_data.Charge or charge_data.Charge.Max == 0 then return nil; end

	local ChargeAnim = mod.Animations.Chargebar;
	if not sprite or not sprite.overlay then sprite = {overlay = Sprite(ChargeAnim, true),charge = Sprite(ChargeAnim, true),bg = Sprite(ChargeAnim, true),extra = Sprite(ChargeAnim, true),beth = Sprite(ChargeAnim, true)}; end
	
	if ChargeBar.Charge[charge_data.Charge.Max] ~= nil then
		sprite.overlay:Load(ChargeAnim, true);
		sprite.overlay:SetFrame('BarOverlay' .. charge_data.Charge.Max, 0);
	else
		sprite.overlay:Load(ChargeAnim, false);
	end
	sprite.overlay.Scale = charge_data.Scale;
	sprite.overlay.Color = charge_data.Color;
	
	sprite.charge:SetFrame('BarFull', 0);
	sprite.charge.Scale = charge_data.Scale;
	sprite.charge.Color = charge_data.Color;
	
	sprite.bg:SetFrame('BarEmpty', 0);
	sprite.bg.Scale = charge_data.Scale;
	sprite.bg.Color = charge_data.Color;

	sprite.extra:SetFrame('BarFull', 0);
	sprite.extra.Scale = charge_data.Scale;
	sprite.extra.Color = ChargeBar.ExtraColor;

	if charge_data.Charge.Soul > 0 or charge_data.Charge.Blood > 0 then
		local beth_color = Utils.ConvertColorToColorize(charge_data.Charge.Blood > 0 and Utils.GetColorByName("Blood") or Utils.GetColorByName("Soul"));
		sprite.beth:SetFrame('BarFull', 0);
		sprite.beth.Color = beth_color;
		sprite.beth.Scale = charge_data.Scale;
	end
	return sprite;
end

function Active.Render(player_number);
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_ACTIVE_RENDER, mod.CoopHUD.DATA.Players[player_number].Inventory.Active); -- Execute Pre Active Render Callbacks (actives_data(table))
	
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	local actives = player_data.Inventory.Active;
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
		::continue::
	end
end

function Trinket.Render(player_number);
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_TRINKET_RENDER, mod.CoopHUD.DATA.Players[player_number].Inventory.Trinket); -- Execute Pre Trinket Render Callbacks (trinkets_data(table))
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	local trinkets = player_data.Inventory.Trinket;
	for slot,trinket in pairs(trinkets) do
		local d = trinket.Data;
		if d and d.Item and trinket.Sprite then 
			trinket.Sprite:Render(d.Item.Pos);
		end
	end
end

function Pocket.Render(player_number);
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_POCKET_RENDER, mod.CoopHUD.DATA.Players[player_number].Inventory.Pocket); -- Execute Pre Pocket Render Callbacks (pockets_data(table))
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	local pockets = player_data.Inventory.Pocket;
	
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
		end
	end
end

function Inventory.Render(player_number) 
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_INVENTORY_RENDER, mod.CoopHUD.DATA.Players[player_number].Inventory.Special); -- Execute Pre Inventory Render Callbacks (inventory_data(table))
	local player_data = mod.CoopHUD.DATA.Players[player_number];
	local sprite_func = Inventory.GetSprite[player_data.Player.Type];
	
	if sprite_func then
		local sprite = player_data.Inventory.Special.Sprite;
		local extra_func = Inventory.ExtraFunctions[player_data.Player.Type];
		
		for i,data in pairs(player_data.Inventory.Special.Data) do
			sprite = sprite_func(sprite,data.Item,i);
			sprite:Render(data.Pos);
		end
		if extra_func then extra_func(player_data); end
	end
	
	CoopEnhanced.Registry.ExecuteCallback(CoopEnhanced.Callbacks.HUD_PRE_PASSIVE_RENDER, mod.CoopHUD.DATA.Players[player_number].Inventory.Passive); -- Execute Pre Passives Render Callbacks (passives_data(table))
	if player_data.Inventory.Passive and player_data.Inventory.Passive.Data and #player_data.Inventory.Passive.Data > 0 then
		for i,data in pairs(player_data.Inventory.Passive.Data) do
			mod.CoopHUD.Item.Inventory.Sprite:ReplaceSpritesheet(1, data.Item);
			mod.CoopHUD.Item.Inventory.Sprite:LoadGraphics();
			mod.CoopHUD.Item.Inventory.Sprite:Render(data.Pos);
		end
	end
end