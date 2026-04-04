local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.misc, 'Timer');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.timer.display; end,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.misc.timer.display == 0 and 'Always' or (mod.Config.CoopHUD.misc.timer.display == 1 and 'Map' or (mod.Config.CoopHUD.misc.timer.display == 2 and 'No Map' or 'Never'))); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.timer.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.timer.anchor; end,
		Minimum = 0,
		Maximum = 2,
		Display = function() return 'Anchor Position: ' .. (mod.Config.CoopHUD.misc.timer.anchor == 0 and 'Center' or (mod.Config.CoopHUD.misc.timer.anchor == 1 and 'Top' or 'Bottom')); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.timer.anchor = n; end,
		Info = {'Choose where the timer will be anchored.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.timer.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.misc.timer.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.timer.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.timer.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.misc.timer.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.timer.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.misc.timer.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.misc.timer.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.timer.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.misc.timer.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.misc.timer.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.timer.opacity = n / 100; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.misc);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.misc, 'Pickups');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.pickups.display; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.misc.pickups.display == 0 and 'Always' or (mod.Config.CoopHUD.misc.pickups.display == 1 and 'Map' or (mod.Config.CoopHUD.misc.pickups.display == 2 and 'No Map' or 'Never'))); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.pickups.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.pickups.anchor; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Anchor Position: ' .. (mod.Config.CoopHUD.misc.pickups.anchor == 0 and 'Bottom' or (mod.Config.CoopHUD.misc.pickups.anchor == 1 and 'Top' or (mod.Config.CoopHUD.misc.pickups.anchor == 2 and 'Right' or 'Left'))); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.pickups.anchor = n; end,
		Info = {'Choose where the pickups HUD will be anchored.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.pickups.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.misc.pickups.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.pickups.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.pickups.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.misc.pickups.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.pickups.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.pickups.text_offset.X; end,
		Display = function() return 'Text Offset (X): ' .. mod.Config.CoopHUD.misc.pickups.text_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.pickups.text_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.pickups.text_offset.Y; end,
		Display = function() return 'Text Offset (Y): ' .. mod.Config.CoopHUD.misc.pickups.text_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.pickups.text_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.misc.pickups.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.misc.pickups.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.pickups.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.misc);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.misc, 'Difficulty');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.difficulty.display; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.misc.difficulty.display == 0 and 'Always' or (mod.Config.CoopHUD.misc.difficulty.display == 1 and 'Map' or (mod.Config.CoopHUD.misc.difficulty.display == 2 and 'No Map' or 'Never'))); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.difficulty.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.difficulty.anchor; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Anchor Position: ' .. (mod.Config.CoopHUD.misc.difficulty.anchor == 0 and 'Bottom' or (mod.Config.CoopHUD.misc.difficulty.anchor == 1 and 'Top' or (mod.Config.CoopHUD.misc.difficulty.anchor == 2 and 'Right' or 'Left'))); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.difficulty.anchor = n; end,
		Info = {'Choose where the Difficulty Icons will be anchored.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.difficulty.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.misc.difficulty.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.difficulty.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.difficulty.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.misc.difficulty.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.difficulty.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.misc.difficulty.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.misc.difficulty.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.difficulty.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.misc);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.misc, 'Waves');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.wave.display; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.misc.wave.display == 0 and 'Always' or (mod.Config.CoopHUD.misc.wave.display == 1 and 'Map' or (mod.Config.CoopHUD.misc.wave.display == 2 and 'No Map' or 'Never'))); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.wave.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.wave.anchor; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Anchor Position: ' .. (mod.Config.CoopHUD.misc.wave.anchor == 0 and 'Bottom' or (mod.Config.CoopHUD.misc.wave.anchor == 1 and 'Top' or (mod.Config.CoopHUD.misc.wave.anchor == 2 and 'Right' or 'Left'))); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.wave.anchor = n; end,
		Info = {'Choose where the Enemy Wave counter will be anchored.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.wave.background; end,
		Display = function() return 'Background: ' .. (mod.Config.CoopHUD.misc.wave.background and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.misc.wave.background = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.wave.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.misc.wave.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.wave.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.wave.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.misc.wave.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.wave.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.wave.text_offset.X; end,
		Display = function() return 'Text Offset (X): ' .. mod.Config.CoopHUD.misc.wave.text_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.wave.text_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.wave.text_offset.Y; end,
		Display = function() return 'Text Offset (Y): ' .. mod.Config.CoopHUD.misc.wave.text_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.wave.text_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.misc.wave.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.misc.wave.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.wave.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.misc.wave.text_scale.X * 100)); end,
		Display = function() return 'Text Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.misc.wave.text_scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.wave.text_scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.misc.wave.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.misc.wave.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.wave.opacity = n / 100; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.misc);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.misc, 'Victory Laps / Extras');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.extra.display; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.misc.extra.display == 0 and 'Always' or (mod.Config.CoopHUD.misc.extra.display == 1 and 'Map' or (mod.Config.CoopHUD.misc.extra.display == 2 and 'No Map' or 'Never'))); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.extra.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.extra.anchor; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Anchor Position: ' .. (mod.Config.CoopHUD.misc.extra.anchor == 0 and 'Bottom' or (mod.Config.CoopHUD.misc.extra.anchor == 1 and 'Top' or (mod.Config.CoopHUD.misc.extra.anchor == 2 and 'Right' or 'Left'))); end,
		OnChange = function(n) mod.Config.CoopHUD.misc.extra.anchor = n; end,
		Info = {'Choose where the other miscellaneous elements will be anchored.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.extra.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.misc.extra.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.extra.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.misc.extra.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.misc.extra.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.extra.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.misc.extra.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.misc.extra.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.extra.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.misc,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.misc.extra.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.misc.extra.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.misc.extra.opacity = n / 100; end,
	}
);