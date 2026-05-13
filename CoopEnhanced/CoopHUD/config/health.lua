local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.health.invert; end,
		Display = function() return "Invert (P2 & P4): " .. (mod.Config.CoopHUD.health.invert and "on" or "off"); end,
		OnChange = function(b) mod.Config.CoopHUD.health.invert = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.health.colors; end,
		Display = function() return "Player Colors: " .. (mod.Config.CoopHUD.health.colors and "on" or "off"); end,
		OnChange = function(b) mod.Config.CoopHUD.health.colors = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.offset.X end,
		Display = function() return "Offset (X): " .. mod.Config.CoopHUD.health.offset.X end,
		OnChange = function(n) mod.Config.CoopHUD.health.offset.X = n end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.offset.Y end,
		Display = function() return "Offset (Y): " .. mod.Config.CoopHUD.health.offset.Y end,
		OnChange = function(n) mod.Config.CoopHUD.health.offset.Y = n end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format("%.0f", mod.Config.CoopHUD.health.scale.X * 100)); end,
		Display = function() return "Scale: " .. string.format("%.0f", mod.Config.CoopHUD.health.scale.X * 100) .. "%"; end,
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
		CurrentSetting = function() return tonumber(string.format("%.0f", mod.Config.CoopHUD.health.opacity * 100)); end,
		Display = function() return "Opacity: " .. string.format("%.0f", mod.Config.CoopHUD.health.opacity * 100) .. "%"; end,
		OnChange = function(n) mod.Config.CoopHUD.health.opacity = n / 100; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.health)
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.health, "Custom Health API");
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.hearts_per_row; end,
		Display = function() return "Hearts per row: " .. mod.Config.CoopHUD.health.hearts_per_row; end,
		OnChange = function(n) mod.Config.CoopHUD.health.hearts_per_row = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.space.X; end,
		Display = function() return "Space Between Hearts: " .. mod.Config.CoopHUD.health.space.X; end,
		OnChange = function(n) mod.Config.CoopHUD.health.space.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.space.Y; end,
		Display = function() return "Space Between Rows: " .. mod.Config.CoopHUD.health.space.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.health.space.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.health.ignore_curse; end,
		Display = function() return "Ignore Curse of Unknown: " .. (mod.Config.CoopHUD.health.ignore_curse and "on" or "off"); end,
		OnChange = function(b) mod.Config.CoopHUD.health.ignore_curse = b; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.health)
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.health, "Health Anchor");
for i = 1, 4, 1 do
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.health,
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function() return mod.Config.CoopHUD.health.snap[i]; end,
			Display = function() return "Player " .. tostring(i) .." Anchor: " .. (mod.Config.CoopHUD.health.snap[i] and "Character" or "HUD"); end,
			OnChange = function(b) mod.Config.CoopHUD.health.snap[i] = b; end,
			Info = {"Character renders health above the player's head instead."},
		}
	);
end

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.health)
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.snap_offset.X end,
		Display = function() return "Character Offset (X): " .. mod.Config.CoopHUD.health.snap_offset.X end,
		OnChange = function(n) mod.Config.CoopHUD.health.snap_offset.X = n end,
		Info = {"Used when health renders above a player's head (e.g. Strawman)."},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.snap_offset.Y end,
		Display = function() return "Character Offset (Y): " .. mod.Config.CoopHUD.health.snap_offset.Y end,
		OnChange = function(n) mod.Config.CoopHUD.health.snap_offset.Y = n end,
		Info = {"Used when health renders above a player's head (e.g. Strawman)."},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format("%.0f", mod.Config.CoopHUD.health.snap_scale.X * 100)); end,
		Display = function() return "Character Scale: " .. string.format("%.0f", mod.Config.CoopHUD.health.snap_scale.X * 100) .. "%"; end,
		OnChange = function(n) mod.Config.CoopHUD.health.snap_scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.health)
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.health, "Twins");
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.twin.offset.X; end,
		Display = function() return "Twin Offset (X): " .. mod.Config.CoopHUD.health.twin.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.health.twin.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.health.twin.offset.Y; end,
		Display = function() return "Twin Offset (Y): " .. mod.Config.CoopHUD.health.twin.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.health.twin.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.health,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format("%.0f", mod.Config.CoopHUD.health.twin.scale.X * 100)); end,
		Display = function() return "Scale: " .. string.format("%.0f", mod.Config.CoopHUD.health.twin.scale.X * 100) .. "%"; end,
		OnChange = function(n) mod.Config.CoopHUD.health.twin.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.health)
ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.health, "Twin Health Anchor");
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.health,
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function() return mod.Config.CoopHUD.health.twin.snap[i]; end,
			Display = function() return "Player " .. tostring(i) .." Anchor: " .. (mod.Config.CoopHUD.health.twin.snap[i] and "Character" or "HUD"); end,
			OnChange = function(b) mod.Config.CoopHUD.health.twin.snap[i] = b; end,
			Info = {"Character renders health above the player's head instead."},
		}
	);
end