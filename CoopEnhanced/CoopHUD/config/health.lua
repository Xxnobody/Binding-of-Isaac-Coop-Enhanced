local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.offset.X end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.health.offset.X end,
		OnChange = function(n) mod.Config.CoopHUD.health.offset.X = n end,
	}
)
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.offset.Y end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.health.offset.Y end,
		OnChange = function(n) mod.Config.CoopHUD.health.offset.Y = n end,
	}
)
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.health.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.health.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.health.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.health.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.health.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.health.opacity = n / 100; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.health.ignore_curse; end,
		Display = function() return 'Ignore Curse of Unknown: ' .. (mod.Config.CoopHUD.health.ignore_curse and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.health.ignore_curse = b; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.health)
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.health, 'Custom Health API');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.hearts_per_row; end,
		Display = function() return 'Hearts per row: ' .. mod.Config.CoopHUD.health.hearts_per_row; end,
		OnChange = function(n) mod.Config.CoopHUD.health.hearts_per_row = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.space.X; end,
		Display = function() return 'Space Between Hearts: ' .. mod.Config.CoopHUD.health.space.X; end,
		OnChange = function(n) mod.Config.CoopHUD.health.space.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.space.Y; end,
		Display = function() return 'Space Between Rows: ' .. mod.Config.CoopHUD.health.space.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.health.space.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.health.invert; end,
		Display = function() return 'Invert (P2 & P4): ' .. (mod.Config.CoopHUD.health.invert and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.health.invert = b; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.health)
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.health, 'Twins');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.health.twin.snap; end,
		Display = function() return 'Twin Anchor: ' .. (mod.Config.CoopHUD.health.twin.snap and 'Character' or 'HUD'); end,
		OnChange = function(n) mod.Config.CoopHUD.health.twin.snap = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.twin.offset.X; end,
		Display = function() return 'Twin Offset (X): ' .. mod.Config.CoopHUD.health.twin.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.health.twin.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.twin.offset.Y; end,
		Display = function() return 'Twin Offset (Y): ' .. mod.Config.CoopHUD.health.twin.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.health.twin.offset.Y = n; end,
	}
);
