local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.active,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.active.book_charge_outline; end,
		Display = function() return 'Book Charge Outline: ' .. (mod.Config.CoopHUD.active.book_charge_outline and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.active.book_charge_outline = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.active,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.active.book_correction_offset.X; end,
		Display = function() return 'Book Correction Offset (X): ' .. mod.Config.CoopHUD.active.book_correction_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.active.book_correction_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.active,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.active.book_correction_offset.Y; end,
		Display = function() return 'Book Correction Offset (Y): ' .. mod.Config.CoopHUD.active.book_correction_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.active.book_correction_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.active,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.active.colors; end,
		Display = function() return 'Player Colors: ' .. (mod.Config.CoopHUD.active.colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.active.colors = b; end,
		Info = {'Colorize Items based on player color.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.active,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.active.bar_colors; end,
		Display = function() return 'Player Bar Colors: ' .. (mod.Config.CoopHUD.active.bar_colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.active.bar_colors = b; end,
		Info = {'Colorize Charge Bars based on player color.'},
	}
);

for i = 0, 1, 1 do
	ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.active);
	ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.active, 'Slot '..i+1);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.active,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.active[i].offset.X; end,
			Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.active[i].offset.X; end,
			OnChange = function(n) mod.Config.CoopHUD.active[i].offset.X = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.active,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.active[i].offset.Y; end,
			Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.active[i].offset.Y; end,
			OnChange = function(n) mod.Config.CoopHUD.active[i].offset.Y = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.active,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			Minimum = 0.0,
			CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.active[i].scale.X * 100)); end,
			Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.active[i].scale.X * 100) .. '%'; end,
			OnChange = function(n) mod.Config.CoopHUD.active[i].scale = Vector(n/100, n/100); end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.active,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			Minimum = 0.0,
			Maximum = 100.0,
			CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.active[i].opacity * 100)); end,
			Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.active[i].opacity * 100) .. '%'; end,
			OnChange = function(n) mod.Config.CoopHUD.active[i].opacity = n / 100; end,
		}
	);

	ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.active, 'Chargebar');
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.active,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.active[i].chargebar.offset.X; end,
			Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.active[i].chargebar.offset.X; end,
			OnChange = function(n) mod.Config.CoopHUD.active[i].chargebar.offset.X = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.active,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.active[i].chargebar.offset.Y; end,
			Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.active[i].chargebar.offset.Y; end,
			OnChange = function(n) mod.Config.CoopHUD.active[i].chargebar.offset.Y = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.active,
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function() return mod.Config.CoopHUD.active[i].chargebar.display; end,
			Display = function()
				return 'Display: ' .. (mod.Config.CoopHUD.active[i].chargebar.display and 'on' or 'off');
			end,
			OnChange = function(b) mod.Config.CoopHUD.active[i].chargebar.display = b; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.active,
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function() return mod.Config.CoopHUD.active[i].chargebar.mirror; end,
			Display = function() return 'Flip Side (P2 & P4): ' .. (mod.Config.CoopHUD.active[i].chargebar.mirror and 'on' or 'off'); end,
			OnChange = function(b) mod.Config.CoopHUD.active[i].chargebar.mirror = b; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.active,
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function() return mod.Config.CoopHUD.active[i].chargebar.invert; end,
			Display = function() return 'Invert Sides: ' .. (mod.Config.CoopHUD.active[i].chargebar.invert and 'on' or 'off'); end,
			OnChange = function(b) mod.Config.CoopHUD.active[i].chargebar.invert = b; end,
		}
	);
end
