local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.display; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Stats Display: ' .. (mod.Config.CoopHUD.stats.display == 0 and 'Always' or (mod.Config.CoopHUD.stats.display == 1 and 'Map' or (mod.Config.CoopHUD.stats.display == 2 and 'No Map' or 'Never'))); end,
		OnChange = function(n) mod.Config.CoopHUD.stats.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.dead; end,
		Display = function() return 'Show Dead Players: ' .. (mod.Config.CoopHUD.stats.dead and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.stats.dead = b; end,
		Info = {'Enable to display stats for dead (ghost) players.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.text.colors; end,
		Display = function() return 'Enable Stat Colors: ' .. (mod.Config.CoopHUD.stats.text.colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.stats.text.colors = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.stats.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.stats.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.stats.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.stats.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.stats);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.twin_offset.X; end,
		Display = function() return 'Twin Offset (X): ' .. mod.Config.CoopHUD.stats.twin_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.twin_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.twin_offset.Y; end,
		Display = function() return 'Twin Offset (Y): ' .. mod.Config.CoopHUD.stats.twin_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.twin_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.mirrored_offset.X; end,
		Display = function() return 'Mirrored Offset (X): ' .. mod.Config.CoopHUD.stats.mirrored_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.mirrored_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.mirrored_offset.Y; end,
		Display = function() return 'Mirrored Offset (Y): ' .. mod.Config.CoopHUD.stats.mirrored_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.mirrored_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.lowered_offset.X; end,
		Display = function() return 'Lowered Offset (X): ' .. mod.Config.CoopHUD.stats.lowered_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.lowered_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.lowered_offset.Y; end,
		Display = function() return 'Lowered Offset (Y): ' .. mod.Config.CoopHUD.stats.lowered_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.lowered_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.rel_offset.X; end,
		Display = function() return 'Relative Offset (X): ' .. mod.Config.CoopHUD.stats.rel_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.rel_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.rel_offset.Y; end,
		Display = function() return 'Relative Offset (Y): ' .. mod.Config.CoopHUD.stats.rel_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.rel_offset.Y = n; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.stats);
ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.stats, 'Deals');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.deals.display; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Deals Display: ' .. (mod.Config.CoopHUD.stats.deals.display == 0 and 'Synced' or (mod.Config.CoopHUD.stats.deals.display == 1 and 'Always' or (mod.Config.CoopHUD.stats.deals.display == 2 and 'Map' or 'Never'))); end,
		OnChange = function(b) mod.Config.CoopHUD.stats.deals.display = b; end,
		Info = {'Choose how Deal chances display. Synced means it follows Stats Display.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.deals.anchor; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Deals Position: ' .. (mod.Config.CoopHUD.stats.deals.anchor == 0 and 'Bottom' or (mod.Config.CoopHUD.stats.deals.anchor == 1 and 'Top' or (mod.Config.CoopHUD.stats.deals.anchor == 2 and 'Right' or 'Left'))); end,
		OnChange = function(b) mod.Config.CoopHUD.stats.deals.anchor = b; end,
		Info = {'Choose where Deal chances will be anchored.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.greed_display; end,
		Display = function() return 'Greed Jam Display: ' .. (mod.Config.CoopHUD.stats.greed_display and 'Always' or 'Machine'); end,
		OnChange = function(b) mod.Config.CoopHUD.stats.greed_display = b; end,
		Info = {'Set when Greed Donation Machine Jam chance will display.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.library_chance; end,
		Display = function() return 'Library Chance: ' .. (mod.Config.CoopHUD.stats.library_chance and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.stats.library_chance = b; end,
		Info = {'Shows that chance a library will spawn. Requires a mod that adds to library chance to function.'},
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.stats);
ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.stats, 'Text');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.text.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.stats.text.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.text.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.text.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.stats.text.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.text.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.stats.text.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.stats.text.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.text.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.stats);
ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.stats, 'Updates');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.text.update.duration; end,
		Display = function() return 'Display Duration: ' .. mod.Config.CoopHUD.stats.text.update.duration .. "s"; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.text.update.duration = n; end,
		Info = {'Set how many seconds Stat changes are displayed. Setting to 0 disables update text.'}
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.text.update.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.stats.text.update.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.text.update.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.stats,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.stats.text.update.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.stats.text.update.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.stats.text.update.offset.Y = n; end,
	}
);