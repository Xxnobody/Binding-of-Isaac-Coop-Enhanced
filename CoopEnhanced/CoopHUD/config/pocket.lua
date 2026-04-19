local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.pocket,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.pocket.display; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.pocket.display == 0 and 'Always' or (mod.Config.CoopHUD.pocket.display == 1 and 'Map' or (mod.Config.CoopHUD.pocket.display == 2 and 'No Map' or 'Never'))); end,
		OnChange = function(n) mod.Config.CoopHUD.pocket.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.pocket,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.pocket.colors; end,
		Display = function() return 'Player Colors: ' .. (mod.Config.CoopHUD.pocket.colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.pocket.colors = b; end,
		Info = {'Colorize Pocket Items based on player color.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.pocket,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.pocket.bar_colors; end,
		Display = function() return 'Player Bar Colors: ' .. (mod.Config.CoopHUD.pocket.bar_colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.pocket.bar_colors = b; end,
		Info = {'Colorize Charge Bars based on player color.'},
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.pocket);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.pocket, 'Chargebar');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.pocket,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.pocket.chargebar.display; end,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.pocket.chargebar.display and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.pocket.chargebar.display = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.pocket,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.pocket.chargebar.mirror; end,
		Display = function() return 'Flip Side (P2 & P4): ' .. (mod.Config.CoopHUD.pocket.chargebar.mirror and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.pocket.chargebar.mirror = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.pocket,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.pocket.chargebar.invert; end,
		Display = function() return 'Invert Sides: ' .. (mod.Config.CoopHUD.pocket.chargebar.invert and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.pocket.chargebar.invert = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.pocket,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.pocket.chargebar.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.pocket.chargebar.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.pocket.chargebar.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.pocket,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.pocket.chargebar.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.pocket.chargebar.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.pocket.chargebar.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.pocket,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.pocket.chargebar.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.pocket.chargebar.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.pocket.chargebar.scale = Vector(n/100, n/100); end,
	}
);

for i = 0, 3, 1 do
	ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.pocket);
	ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.pocket, 'Slot '..i+1);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.pocket[i].cardfronts; end,
		Display = function() return 'Show Card Front: ' .. (mod.Config.CoopHUD.pocket[i].cardfronts and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.pocket[i].cardfronts = b; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.pocket[i].offset.X; end,
			Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.pocket[i].offset.X; end,
			OnChange = function(n) mod.Config.CoopHUD.pocket[i].offset.X = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.pocket[i].offset.Y; end,
			Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.pocket[i].offset.Y; end,
			OnChange = function(n) mod.Config.CoopHUD.pocket[i].offset.Y = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			Minimum = 0.0,
			CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.pocket[i].scale.X * 100)); end,
			Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.pocket[i].scale.X * 100) .. '%'; end,
			OnChange = function(n) mod.Config.CoopHUD.pocket[i].scale = Vector(n/100, n/100); end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			Minimum = 0.0,
			CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.pocket[i].opacity * 100)); end,
			Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.pocket[i].opacity * 100) .. '%'; end,
			OnChange = function(n) mod.Config.CoopHUD.pocket[i].opacity = n / 100; end,
		}
	);
	ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.pocket, 'Text');
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.pocket[i].text.display; end,
			Minimum = 0,
			Maximum = 3,
			Display = function() return 'Display: ' .. (mod.Config.CoopHUD.pocket[i].text.display == 0 and 'Always' or (mod.Config.CoopHUD.pocket[i].text.display == 1 and 'Map' or (mod.Config.CoopHUD.pocket[i].text.display == 2 and 'No Map' or 'Never'))); end,
			OnChange = function(n) mod.Config.CoopHUD.pocket[i].text.display = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.pocket[i].text.offset.X; end,
			Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.pocket[i].text.offset.X; end,
			OnChange = function(n) mod.Config.CoopHUD.pocket[i].text.offset.X = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.pocket[i].text.offset.Y; end,
			Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.pocket[i].text.offset.Y; end,
			OnChange = function(n) mod.Config.CoopHUD.pocket[i].text.offset.Y = n; end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			Minimum = 0.0,
			CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.pocket[i].text.scale.X * 100)); end,
			Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.pocket[i].text.scale.X * 100) .. '%'; end,
			OnChange = function(n) mod.Config.CoopHUD.pocket[i].text.scale = Vector(n/100, n/100); end,
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.pocket,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			Minimum = 0.0,
			Maximum = 100.0,
			CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.pocket[i].text.opacity * 100)); end,
			Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.pocket[i].text.opacity * 100) .. '%'; end,
			OnChange = function(n) mod.Config.CoopHUD.pocket[i].text.opacity = n / 100; end,
		}
	);
end
