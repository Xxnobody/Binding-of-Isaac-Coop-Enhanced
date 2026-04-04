local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;

function CoopHUD.ClockPickups()
	if not ClockPickupCounter then return; end
	
	local pixel3, pixel2, pixel1 = ClockPickupCounter.sprs.Pixel3, ClockPickupCounter.sprs.Pixel2, ClockPickupCounter.sprs.Pixel1;
	local counter_index = {
		["Coin"] = 1,
		["Bomb"] = 2,
		["Key"] = 3,
		["Poop"] = 4,
		["BlueHeart"] = 5,
		["RedHeart"] = 6
	};
	local function AnimatePickups(misc_data)
		if not misc_data or not misc_data["Pickups"].Visible or not mod.Config.CoopHUD.mods.ANIMATEDPICKUPS.enabled then return; end
		local animated_sprites = ClockPickupCounter.PoryadokPokaza.SamPoryadok;
		if not animated_sprites then return; end
		
		local player_entity = Isaac.GetPlayer(0);
		
		-- Render animated sprites
		for i,sprite_data in pairs(animated_sprites) do
			
			local pickup_data = misc_data["Pickups"][counter_index[sprite_data.name]];
			if not pickup_data or not pickup_data.Data then goto skip_pickup; end
			local text_height = pickup_data.Data.Text.Font:GetLineHeight();
			
			if sprite_data.update then sprite_data.update(player_entity, sprite_data); end
			local sprite = sprite_data.spr;
			
			pixel1.Scale = pickup_data.Data.Scale;
			pixel2.Scale = pickup_data.Data.Scale;
			pixel3.Scale = pickup_data.Data.Scale;
			
			local maxvalue = sprite_data.getmaxvalue(player_entity);
			local currentvalue = sprite_data.getvalue(player_entity);

			if sprite_data.premaxvalue ~= maxvalue then
				local digitsNum = maxvalue == 0 and 1 or math.floor(math.log(maxvalue, 10)) + 1;
				for ii = 1, digitsNum do
					local powten = ii == 1 and 1 or 10;

					sprite_data.digits[ii] = sprite_data.digits[ii] or {};
					local dig = sprite_data.digits[ii];
					dig.prevalue = dig.prevalue or 0;
					dig.pos = dig.pos or Vector(pickup_data.Data.Text.Font:GetStringWidth("0"), 0)
					dig.value = sprite_data.getvalue(player_entity) // powten;
					dig.wight = pickup_data.Data.Text.Font:GetStringWidth(tostring(math.floor(dig.value % 10)));
				end
				for ii = (digitsNum + 1), #sprite_data.digits, 1 do
					sprite_data.digits[ii] = nil;
				end
				sprite_data.premaxvalue = maxvalue;
				
				
				if not Utils.IsPauseMenuOpen() then
					sprite:Update();

					if not sprite_data.overadeAnim and sprite_data.spr_idleAnim and sprite_data.spr_animAnim then
						local canplaystop = false;
						local canplayanim = false;
						if sprite:IsFinished() then
							local curanim = sprite:GetAnimation();
							if curanim == sprite_data.spr_animAnim then
								canplaystop = true;
								if sprite_data.spr_startAnim then canplayanim = true; end
							elseif curanim == sprite_data.spr_startAnim then canplayanim = true; end
							sprite:Play(sprite_data.spr_idleAnim);
						end
						if sprite_data.digits[1] then
							if canplayanim then sprite:Play(sprite_data.spr_animAnim); end
							if math.abs(currentvalue - sprite_data.digits[1].value) > 0.9 then
								if sprite_data.spr_startAnim then
									if sprite:GetAnimation() == sprite_data.spr_idleAnim then
										sprite:Play(sprite_data.spr_startAnim, true);
									end
								else
									sprite:Play(sprite_data.spr_animAnim);
								end
							elseif canplaystop then
								sprite:Play(sprite_data.spr_stopAnim or sprite_data.spr_idleAnim);
							end
						end
					end
				end
				
				-- Render Digits from last to first
				for ii = #sprite_data.digits, 1, -1 do
					local dig = sprite_data.digits[ii];

					if not Utils.IsPauseMenuOpen() then
						local powten = ii==1 and 1 or 10;
						local predig = sprite_data.digits[(ii - 1)];
						local predigvalue = predig and predig.value;
						local valueoff = 0;
						if predigvalue and currentvalue > predigvalue then valueoff = 0.5; end

						local targetValue = (predigvalue and (predigvalue+valueoff) or currentvalue) // powten;

						local tarcurdiffabs = math.abs(targetValue - dig.value);
						local isbigger = targetValue > dig.value;
						if tarcurdiffabs > 1000 then
							dig.value = isbigger and (dig.value + 48.7) or (dig.value - 48.7);
						elseif tarcurdiffabs > 100 then
							dig.value = isbigger and (dig.value + 4.8) or (dig.value - 4.8);
						elseif tarcurdiffabs > 10 then
							dig.value = isbigger and (dig.value + .49) or (dig.value - .49);
						elseif tarcurdiffabs > 5 then
							dig.value = isbigger and (dig.value + .2) or (dig.value - .2);
						else
							dig.value = dig.value * 0.93 + targetValue * 0.07;
							if math.abs(targetValue - dig.value) < 0.02 then
								dig.value = targetValue;
								dig.prevalue = targetValue;
								dig.wight = pickup_data.Data.Text.Font:GetStringWidth(tostring(math.floor(dig.value % 10)));
							end
						end
					end

					local proc = dig.value % 1;
					local text_value = math.floor(dig.value % 10);
					
					local digit_pos = pickup_data.Data.Text.Pos + Vector((dig.wight * (ii - 1)),0);
					print(digit_pos);
						
					if proc > 0 then
						pixel3:Render(pickup_data.Data.Pos + (Vector(-2,-11) * pickup_data.Data.Scale));
						pixel2:Render(pickup_data.Data.Pos + (Vector(-2,text_height + 1) * pickup_data.Data.Scale));
						
						pickup_data.Data.Text.Font:DrawStringScaled(
							text_value,
							digit_pos.X, digit_pos.Y,
							pickup_data.Data.Text.Scale.X, pickup_data.Data.Text.Scale.Y,
							KColor.White, pickup_data.Data.Text.Width or 0, pickup_data.Data.Text.Center or true
						);
						pickup_data.Data.Text.Font:DrawStringScaled(
							(tonumber(text_value) + 1),
							digit_pos.X, digit_pos.Y,
							pickup_data.Data.Text.Scale.X, pickup_data.Data.Text.Scale.Y,
							KColor.White, pickup_data.Data.Text.Width or 0, pickup_data.Data.Text.Center or true
						);
					else
						pixel2:Render(pickup_data.Data.Pos + (Vector(-2,-11) * pickup_data.Data.Scale));
						pixel1:Render(pickup_data.Data.Pos + (Vector(-2,text_height + 1) * pickup_data.Data.Scale));
							pickup_data.Data.Text.Font:DrawStringScaled(
							text_value,
							digit_pos.X, digit_pos.Y,
							pickup_data.Data.Text.Scale.X, pickup_data.Data.Text.Scale.Y,
							KColor.White, pickup_data.Data.Text.Width or 0, pickup_data.Data.Text.Center or true
						);
					end
					misc_data["Pickups"][counter_index[sprite_data.name]].Data.Text.Value = nil;
				end
			end
			misc_data["Pickups"][counter_index[sprite_data.name]].Sprite = sprite_data.spr;
			::skip_pickup::
		end
	end
	
	mod.Registry.AddCallback(mod.Callbacks.HUD_PRE_MISC_RENDER, AnimatePickups);
	mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, function()
		IsShaderRenderState = true;
	end)
end
