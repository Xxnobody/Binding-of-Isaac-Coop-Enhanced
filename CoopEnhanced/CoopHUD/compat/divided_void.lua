local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;


function CoopHUD.DividedVoid()
	if not DIVIDED_VOID then return; end
	local VOID_ID = CollectibleType.COLLECTIBLE_VOID;
	local DIV_VOID_ID = Isaac.GetItemIdByName('[DIVIDED VOID]Tech ID') + 1;
	
	DIVIDED_VOID.ChargeColor = Utils.ConvertColorToColorize(Color(0.9,0.5,0.9,1), 1, 0.75, 1);
	DIVIDED_VOID.ExtraChargeColor = Utils.ConvertColorToColorize(Color(0.0,0.75,1.0,1), 1, 0.75, 1);
	
	local valid_charges = {};
	for i,_ in pairs(CoopHUD.Item.ChargeBar.Charge) do table.insert(valid_charges,i); end
	table.sort(valid_charges);

	local SubChargeSprite = nil;

	local function RenderVoid(sprite,item_data,sprite_data,player_entity)
		DIVIDED_VOID.MaxCharge = valid_charges[mod.Config.CoopHUD.mods.DIVOID.max_charge];

		local void_data = DIVIDED_VOID.PlayerswithVoid and DIVIDED_VOID.PlayerswithVoid[player_entity.Index];
		if void_data then
			--item_data.Bar.Charge.Max = DIVIDED_VOID.MaxCharge;
			SubChargeSprite = CoopHUD.Item.ChargeBar.GetSprite(SubChargeSprite, item_data.Bar);
			local isPocket = item_data.Item.Slot ~= nil;
			local player_data = CoopHUD.getDataFromEntity(player_entity);
			local COOP_DATA = player_data and (not isPocket and player_data.Inventory.Active[item_data.Slot] or player_data.Inventory.Pocket[item_data.Slot]) or nil;
			if not COOP_DATA or not COOP_DATA.Data then return; end

			sprite_data.Anm2 = "gfx/items/collectibles/DIV_VOID/div_void.anm2";
			sprite_data.Animation = void_data.full and "mode" .. void_data.mode .. "_full" or "mode" .. void_data.mode;
			sprite_data.Sheets = {};
			sprite_data.Play = (void_data.full and sprite:GetAnimation() ~= (void_data.mode .. tostring(void_data.mode) .. "_full")) or (not void_data.full and sprite:GetAnimation() ~= (void_data.mode .. tostring(void_data.mode)));
			if void_data.frame then	sprite_data.Frame = void_data.frame; end

			if item_data.Bar.Display then
				local bar_pos = item_data.Bar.Pos + (Vector(4,2) * item_data.Bar.Scale) + Vector(mod.Config.CoopHUD.mods.DIVOID.offset.X * (item_data.Bar.Flip and -1 or 1),mod.Config.CoopHUD.mods.DIVOID.offset.Y);
				local opacity = mod.Config.CoopHUD.mods.DIVOID.opacity;
				local current_charge = void_data.subcharge;
				local max_charge = DIVIDED_VOID.MaxCharge;
				local extra_charge = math.max(0,current_charge - max_charge);
				local BarExtra = {Display = item_data.Bar.Display, Pos = bar_pos, Charge = {Current = current_charge, Max = max_charge, Extra = extra_charge}, Scale = item_data.Bar.Scale};
				
				local charge_color = mod.Config.CoopHUD.mods.DIVOID.colorize == 0 and Color(0.75,0.75,0.75,opacity) or (mod.Config.CoopHUD.mods.DIVOID.colorize == 1 and DIVIDED_VOID.ChargeColor or (mod.Config.CoopHUD.mods.DIVOID.colorize == 2 and Utils.ConvertColorToColorize(player_data.Player.Color,item_data.Color.A) or Utils.ConvertColorToColorize(mod.Colors[mod.Config.CoopHUD.mods.DIVOID.color].Value,opacity)));
				local chargeextra_color = mod.Config.CoopHUD.mods.DIVOID.colorize == 0 and Utils.ColorBrighthness(CoopHUD.Item.ChargeBar.ExtraColor,0.75) or (mod.Config.CoopHUD.mods.DIVOID.colorize == 1 and DIVIDED_VOID.ExtraChargeColor or (mod.Config.CoopHUD.mods.DIVOID.colorize == 2 and Utils.ConvertColorToColorize(Color.Lerp(player_data.Player.Color,Utils.GetColorByName("Yellow"),0.75)) or Utils.ConvertColorToColorize(mod.Colors[mod.Config.CoopHUD.mods.DIVOID.color_extra].Value)));
				
				if not isPocket then
					SubChargeSprite.Offset = Vector(2,0); -- Fixes weird rendering
					item_data.Item.Pos = item_data.Item.Pos + (Vector(-3,2) * item_data.Scale); -- Offset for the extra void arrow
				end
				
				SubChargeSprite.charge.Scale = item_data.Bar.Scale;
				SubChargeSprite.bg.Scale = item_data.Bar.Scale;
				SubChargeSprite.overlay.Scale = item_data.Bar.Scale;
				SubChargeSprite.extra.Scale = item_data.Bar.Scale;
				
				if mod.Config.CoopHUD.mods.DIVOID.display == 0 and void_data.mode ~= 0 then
					SubChargeSprite.charge.Color = COOP_DATA.ChargeSprite.charge.Color;
					SubChargeSprite.extra.Color = COOP_DATA.ChargeSprite.extra.Color;
					COOP_DATA.ChargeSprite.charge.Color = charge_color;
					COOP_DATA.ChargeSprite.extra.Color = chargeextra_color;
				else
					SubChargeSprite.charge.Color = charge_color;
					SubChargeSprite.extra.Color = chargeextra_color;
				end
				
				COOP_DATA.ChargeExtraSprite = SubChargeSprite;
				COOP_DATA.Data.BarExtra = BarExtra;
			end
		end
	end

	CoopEnhanced.CoopHUD.Item.Active.Special[VOID_ID] = function(sprite,item_data,sprite_data,player_entity)
		RenderVoid(sprite,item_data,sprite_data,player_entity);
	end
	CoopEnhanced.CoopHUD.Item.Active.Special[DIV_VOID_ID] = function(sprite,item_data,sprite_data,player_entity)
		RenderVoid(sprite,item_data,sprite_data,player_entity);
	end
end
