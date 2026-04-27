local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;


local function configSetup()
	if ModConfigMenu == nil then return; end
	
	if ClockPickupCounterXX then -- Doesnt Work Yet
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'Animated Pickups');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.ANIMATEDPICKUPS.enabled; end,
				Display = function() return 'Enable: ' .. (mod.Config.CoopHUD.compat.ANIMATEDPICKUPS.enabled and 'on' or 'off'); end,
				OnChange = function(b) mod.Config.CoopHUD.compat.ANIMATEDPICKUPS.enabled = b; end,
				Info = {'Animates the HUD pickups using Animated Pickups.'},
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end
	
	if DIVIDED_VOID then
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'Divided Void');
		local valid_charges = {};
		for i,_ in pairs(CoopHUD.Item.ChargeBar.Charge) do table.insert(valid_charges,i); end
		table.sort(valid_charges);
		--[[ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 1,
				Maximum = #valid_charges,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.DIVOID.max_charge; end,
				Display = function() return 'Void Max Charge: ' .. valid_charges[mod.Config.CoopHUD.compat.DIVOID.max_charge]; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.DIVOID.max_charge = n; end,
			}
		);]]-- Doesn't Work because the mod loads the value once at runtime, change it in the mod directly
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.DIVOID.display; end,
				Minimum = 0,
				Maximum = 1,
				Display = function() return 'Sub-Bar Display: ' .. (mod.Config.CoopHUD.compat.DIVOID.display == 0 and 'Enhanced' or 'Divided Void'); end,
				OnChange = function(n) mod.Config.CoopHUD.compat.DIVOID.display = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.DIVOID.colorize; end,
				Minimum = 0,
				Maximum = 3,
				Display = function() return 'Sub-Bar Colors: ' .. (mod.Config.CoopHUD.compat.DIVOID.colorize == 0 and 'Vanilla' or (mod.Config.CoopHUD.compat.DIVOID.colorize == 1 and 'Divided Void' or (mod.Config.CoopHUD.compat.DIVOID.colorize == 2 and "Player" or "Config"))); end,
				OnChange = function(n) mod.Config.CoopHUD.compat.DIVOID.colorize = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.DIVOID.offset.X; end,
				Display = function() return 'Sub-Bar Offset (X): ' .. mod.Config.CoopHUD.compat.DIVOID.offset.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.DIVOID.offset.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.DIVOID.offset.Y; end,
				Display = function() return 'Sub-Bar Offset (Y): ' .. mod.Config.CoopHUD.compat.DIVOID.offset.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.DIVOID.offset.Y = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 0.0,
				Maximum = 100.0,
				CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.compat.DIVOID.opacity * 100)); end,
				Display = function() return 'Sub-Bar Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.compat.DIVOID.opacity * 100) .. '%'; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.DIVOID.opacity = n / 100; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.DIVOID.color; end,
				Minimum = 1,
				Maximum = #mod.Colors,
				Display = function() return 'Charge Color: ' .. mod.Colors[mod.Config.CoopHUD.compat.DIVOID.color].Name; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.DIVOID.color = n; end,
				Info = "Set the charge bar color.",
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.DIVOID.color_extra; end,
				Minimum = 1,
				Maximum = #mod.Colors,
				Display = function() return 'Extra Charge Color: ' .. mod.Colors[mod.Config.CoopHUD.compat.DIVOID.color_extra].Name; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.DIVOID.color_extra = n; end,
				Info = "Set the extra charge color.",
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end
	
	if EID then
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'External Item Descriptions');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.EID.display; end,
				Minimum = 0,
				Maximum = 3,
				Display = function() return 'EID Display: ' .. (mod.Config.CoopHUD.compat.EID.display == 0 and 'Always' or (mod.Config.CoopHUD.compat.EID.display == 1 and 'Map' or (mod.Config.CoopHUD.compat.EID.display == 2 and 'No Map' or 'Never'))); end,
				OnChange = function(n) mod.Config.CoopHUD.compat.EID.display = n; end,
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end

	if Epiphany then
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'Epiphany');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.EPIPHANY.hud_element_pos.X; end,
				Display = function() return 'Epiphany HUD (X): ' .. mod.Config.CoopHUD.compat.EPIPHANY.hud_element_pos.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.EPIPHANY.hud_element_pos.X = n; end,
				Info = {'Used for rendering any additional HUD elements for Epiphany Tarnished characters'},
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.EPIPHANY.hud_element_pos.Y; end,
				Display = function() return 'Epiphany HUD (Y): ' .. mod.Config.CoopHUD.compat.EPIPHANY.hud_element_pos.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.EPIPHANY.hud_element_pos.Y = n; end,
				Info = {'Used for rendering any additional HUD elements for Epiphany Tarnished characters'},
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end
	
	if HPBars then
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'Enhanced Boss Bars');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.EBB.auto_pad.enabled; end,
				Display = function() return 'Auto-padding: ' .. (mod.Config.CoopHUD.compat.EBB.auto_pad.enabled and 'on' or 'off'); end,
				OnChange = function(b) mod.Config.CoopHUD.compat.EBB.auto_pad.enabled = b; end,
				Info = {'Makes the health bar not cover HUD elements.'},
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.EBB.auto_pad.pickups; end,
				Display = function() return 'Padding (Pickups): ' .. mod.Config.CoopHUD.compat.EBB.auto_pad.pickups; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.EBB.auto_pad.pickups = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.EBB.auto_pad.stats; end,
				Display = function() return 'Padding (Stats): ' .. mod.Config.CoopHUD.compat.EBB.auto_pad.stats; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.EBB.auto_pad.stats = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.EBB.auto_pad.wave; end,
				Display = function() return 'Padding (Wavebar): ' .. mod.Config.CoopHUD.compat.EBB.auto_pad.wave; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.EBB.auto_pad.wave = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.EBB.offset.X; end,
				Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.compat.EBB.offset.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.EBB.offset.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.EBB.offset.Y; end,
				Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.compat.EBB.offset.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.EBB.offset.Y = n; end,
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end
	
	if FancyBossBar then
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'Enhanced Boss Bars');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.FBB.auto_pad.enabled; end,
				Display = function() return 'Auto-padding: ' .. (mod.Config.CoopHUD.compat.FBB.auto_pad.enabled and 'on' or 'off'); end,
				OnChange = function(b) mod.Config.CoopHUD.compat.FBB.auto_pad.enabled = b; end,
				Info = {'Makes the health bar not cover HUD elements.'},
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.FBB.auto_pad.pickups; end,
				Display = function() return 'Padding (Pickups): ' .. mod.Config.CoopHUD.compat.FBB.auto_pad.pickups; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.FBB.auto_pad.pickups = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.FBB.auto_pad.stats; end,
				Display = function() return 'Padding (Stats): ' .. mod.Config.CoopHUD.compat.FBB.auto_pad.stats; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.FBB.auto_pad.stats = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.FBB.auto_pad.wave; end,
				Display = function() return 'Padding (Wavebar): ' .. mod.Config.CoopHUD.compat.FBB.auto_pad.wave; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.FBB.auto_pad.wave = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.FBB.offset.X; end,
				Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.compat.FBB.offset.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.FBB.offset.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.FBB.offset.Y; end,
				Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.compat.FBB.offset.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.FBB.offset.Y = n; end,
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end
	
	
	if IsaacReflourished then
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'Isaac Reflourished');
		ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, '--Excited Timer--');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.display; end,
				Minimum = 0,
				Maximum = 3,
				Display = function() return 'Display: ' .. (mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.display == 0 and 'Always' or (mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.display == 1 and 'Map' or (mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.display == 2 and 'No Map' or (mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.display == 3 and 'Reflourished' or 'Never')))); end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.display = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.anchor; end,
				Minimum = 0,
				Maximum = 1,
				Display = function() return 'Anchor: ' .. (mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.anchor == 0 and 'Character' or 'HUD'); end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.anchor = n; end,
				Info = {'Choose where the Excited Timer will be anchored.'},
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.offset.X; end,
				Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.offset.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.offset.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.offset.Y; end,
				Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.offset.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.offset.Y = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 0.0,
				Maximum = 100.0,
				CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.fade_speed * 100)); end,
				Display = function() return 'Fade Speed: ' .. string.format('%.0f', mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.fade_speed * 100); end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.fade_speed = n / 100; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 0.0,
				CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.scale.X * 100)); end,
				Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.scale.X * 100) .. '%'; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.scale = Vector(n/100, n/100); end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 0.0,
				Maximum = 100.0,
				CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.opacity * 100)); end,
				Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.opacity * 100) .. '%'; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.excited_timer.opacity = n / 100; end,
			}
		);
		ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, '--Boss Wave Counter--');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.enabled; end,
				Display = function() return 'Enable: ' .. (mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.enabled and 'on' or 'off'); end,
				OnChange = function(b) mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.enabled = b; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.offset.X; end,
				Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.offset.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.offset.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.offset.Y; end,
				Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.offset.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.offset.Y = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.text_offset.X; end,
				Display = function() return 'Text Offset (X): ' .. mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.text_offset.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.text_offset.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.text_offset.Y; end,
				Display = function() return 'Text Offset (Y): ' .. mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.text_offset.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REFLOURISHED.boss_counter.text_offset.Y = n; end,
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end	
	
	if LowFirerateChargeBar then
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'Low Firerate Chargebar');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.LOWFIRERATEBAR.offset.X; end,
				Display = function() return 'Bar Offset (X): ' .. mod.Config.CoopHUD.compat.LOWFIRERATEBAR.offset.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.LOWFIRERATEBAR.offset.X = n; end,
				Info = {'Used for moving Jukebox title not in the way of the HUD'},
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.LOWFIRERATEBAR.offset.Y; end,
				Display = function() return 'Bar Offset (Y): ' .. mod.Config.CoopHUD.compat.LOWFIRERATEBAR.offset.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.LOWFIRERATEBAR.offset.Y = n; end,
				Info = {'Used for moving Jukebox title not in the way of the HUD'},
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end
	
	if MinimapAPI then
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'MinimapAPI');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.mAPI.enabled; end,
				Display = function() return 'MinimapAPI Settings: ' .. (mod.Config.CoopHUD.compat.mAPI.enabled and 'on' or 'off'); end,
				OnChange = function(b) mod.Config.CoopHUD.compat.mAPI.enabled = b; end,
				Info = {'Main mAPI settings will not be erased.'},
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.mAPI.pos.X; end,
				Display = function() return 'Position (X): ' .. mod.Config.CoopHUD.compat.mAPI.pos.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.mAPI.pos.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.mAPI.pos.Y; end,
				Display = function() return 'Position (Y): ' .. mod.Config.CoopHUD.compat.mAPI.pos.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.mAPI.pos.Y = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.mAPI.frame.X; end,
				Display = function() return 'Frame Width: ' .. mod.Config.CoopHUD.compat.mAPI.frame.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.mAPI.frame.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.mAPI.frame.Y; end,
				Display = function() return 'Frame Height: ' .. mod.Config.CoopHUD.compat.mAPI.frame.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.mAPI.frame.Y = n; end,
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end
	
	if Reverie then
		ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, 'Reverie - Touhou Combinations');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REVERIE.enabled; end,
				Display = function() return 'Reverie Settings: ' .. (mod.Config.CoopHUD.compat.REVERIE.enabled and 'on' or 'off'); end,
				OnChange = function(b) mod.Config.CoopHUD.compat.REVERIE.enabled = b; end,
				Info = {'Enable compat for Reverie.'},
			}
		);
		ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, '--Addiction Bar--');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REVERIE.addictbar.offset.X; end,
				Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.compat.REVERIE.addictbar.offset.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REVERIE.addictbar.offset.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REVERIE.addictbar.offset.Y; end,
				Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.compat.REVERIE.addictbar.offset.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REVERIE.addictbar.offset.Y = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 0.0,
				CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.compat.REVERIE.addictbar.scale.X * 100)); end,
				Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.compat.REVERIE.addictbar.scale.X * 100) .. '%'; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REVERIE.addictbar.scale = Vector(n/100, n/100); end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 0.0,
				Maximum = 100.0,
				CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.compat.REVERIE.addictbar.opacity * 100)); end,
				Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.compat.REVERIE.addictbar.opacity * 100) .. '%'; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REVERIE.addictbar.opacity = n / 100; end,
			}
		);
		ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods, '--Quality Meter--');
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REVERIE.quality.offset.X; end,
				Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.compat.REVERIE.quality.offset.X; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REVERIE.quality.offset.X = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function() return mod.Config.CoopHUD.compat.REVERIE.quality.offset.Y; end,
				Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.compat.REVERIE.quality.offset.Y; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REVERIE.quality.offset.Y = n; end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 0.0,
				CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.compat.REVERIE.quality.scale.X * 100)); end,
				Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.compat.REVERIE.quality.scale.X * 100) .. '%'; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REVERIE.quality.scale = Vector(n/100, n/100); end,
			}
		);
		ModConfigMenu.AddSetting(
			CoopHUD.MCM.title,
			CoopHUD.MCM.categories.mods,
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				Minimum = 0.0,
				Maximum = 100.0,
				CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.compat.REVERIE.quality.opacity * 100)); end,
				Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.compat.REVERIE.quality.opacity * 100) .. '%'; end,
				OnChange = function(n) mod.Config.CoopHUD.compat.REVERIE.quality.opacity = n / 100; end,
			}
		);
		ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.mods);
	end
end

require(CoopHUD.Directory .. 'compat.clock_pickups');
require(CoopHUD.Directory .. 'compat.divided_void');
require(CoopHUD.Directory .. 'compat.fancy_boss_bar');
require(CoopHUD.Directory .. 'compat.enhanced_boss_bars');
require(CoopHUD.Directory .. 'compat.epiphany.main');
require(CoopHUD.Directory .. 'compat.jericho');
require(CoopHUD.Directory .. 'compat.library_expanded');
require(CoopHUD.Directory .. 'compat.low_firerate_bar');
require(CoopHUD.Directory .. 'compat.reflourished');
require(CoopHUD.Directory .. 'compat.reverie');

local mods = {
	{
		name = "Animated Pickups",
		file = function() CoopHUD.ClockPickups() end,
		condition = function() return ClockPickupCounterXX ~= nil end,
	},
	{
		name = "Divided Void",
		file = function() CoopHUD.DividedVoid() end,
		condition = function() return DIVIDED_VOID ~= nil end,
	},
	{
		name = "Enhanced Boss Bars",
		file = function() CoopHUD.EnhancedBossBars() end,
		condition = function() return HPBars ~= nil end,
	},
	{
		name = "Epiphany",
		file = function() CoopHUD.Epiphany() end,
		condition = function() return Epiphany ~= nil end,
	},
	{
		name = "Fancy Boss Bar",
		file = function() CoopHUD.FancyBossBar() end,
		condition = function() return FancyBossBar ~= nil end,
	},
	{
		name = "Isaac Reflourished",
		file = function() CoopHUD.Reflourished() end,
		condition = function() return IsaacReflourished ~= nil end,
	},
	{
		name = "Jericho",
		file = function() CoopHUD.Jericho() end,
		condition = function() return _JERICHO_MOD ~= nil end,
	},
	{
		name = "Library Expanded",
		file = function() CoopHUD.LibraryExpanded() end,
		condition = function() return LibraryExpanded ~= nil end,
	},
	{
		name = "Low Firerate Tear ChargeBar",
		file = function() CoopHUD.LowFirerateChargeBar() end,
		condition = function() return LowFirerateChargeBar ~= nil end,
	},
	{
		name = "Reverie - Touhou Combinations",
		file = function() CoopHUD.Reverie() end,
		condition = function() return Reverie ~= nil end,
	}
};

local function loadModCallbacks()
	for _, m in pairs(mods) do
		if m.condition() then
			print("CoopHUD Mod Compatability: "..m.name);
			m.file();
		end
	end
	configSetup();
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, loadModCallbacks);
