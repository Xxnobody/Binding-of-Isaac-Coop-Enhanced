local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.trinket,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.trinket.colors; end,
		Display = function() return 'Player Colors: ' .. (mod.Config.CoopHUD.trinket.colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.trinket.colors = b; end,
		Info = {'Colorize Trinkets based on player color.'},
	}
);

for i = 0, 1, 1 do
	ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.trinket);
	ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.trinket, 'Slot '..i+1);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.trinket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.trinket[i].offset.X; end,
			Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.trinket[i].offset.X; end,
			OnChange = function(n) mod.Config.CoopHUD.trinket[i].offset.X = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.trinket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.trinket[i].offset.Y; end,
			Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.trinket[i].offset.Y; end,
			OnChange = function(n) mod.Config.CoopHUD.trinket[i].offset.Y = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.trinket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			Minimum = 0.0,
			CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.trinket[i].scale.X * 100)); end,
			Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.trinket[i].scale.X * 100) .. '%'; end,
			OnChange = function(n) mod.Config.CoopHUD.trinket[i].scale = Vector(n/100, n/100); end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.trinket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			Minimum = 0.0,
			Maximum = 100.0,
			CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.trinket[i].opacity * 100)); end,
			Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.trinket[i].opacity * 100) .. '%'; end,
			OnChange = function(n) mod.Config.CoopHUD.trinket[i].opacity = n / 100; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.trinket,
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.trinket[i].pocket_offset; end,
		Display = function() return 'Pocket Offset: ' .. (mod.Config.CoopHUD.trinket[i].pocket_offset and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.trinket[i].pocket_offset = b; end,
		Info = {'When enabled, trinkets are moved down by the number of pocket items.'},
		}
	);
end
