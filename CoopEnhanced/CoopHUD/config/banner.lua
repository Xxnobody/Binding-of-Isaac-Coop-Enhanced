local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 2,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.anchor; end,
		Display = function() return 'Banner Position: ' .. (mod.Config.CoopHUD.banner.anchor == 0 and 'Center' or (mod.Config.CoopHUD.banner.anchor == 1 and 'Top' or 'Bottom')); end,
		OnChange = function(n) mod.Config.CoopHUD.banner.anchor = n; end,
		Info = {'Choose where Banners will be anchored.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.banner.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.banner.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.1,
		Maximum = 200.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.banner.speed * 100)); end,
		Display = function() return 'Display Speed: ' .. string.format('%.0f', mod.Config.CoopHUD.banner.speed * 100) .. "%"; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.speed = n / 100; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = 60,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.duration; end,
		Display = function() return 'Display Duration: ' .. mod.Config.CoopHUD.banner.duration .. "s"; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.duration = n; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.banner);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.banner, 'Banner Title');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.name.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.banner.name.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.name.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.name.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.banner.name.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.name.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.name.box_width; end,
		Display = function() return 'Box Width: ' .. mod.Config.CoopHUD.banner.name.box_width; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.name.box_width = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.name.centered; end,
		Display = function() return 'Centered: ' .. (mod.Config.CoopHUD.banner.name.centered and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.banner.name.centered = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.banner.name.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.banner.name.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.name.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.banner);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.banner, 'Item Description');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.description.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.banner.description.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.description.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.description.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.banner.description.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.description.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.description.box_width; end,
		Display = function() return 'Box Width: ' .. mod.Config.CoopHUD.banner.description.box_width; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.description.box_width = n; end,
	}
)
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.description.centered; end,
		Display = function() return 'Centered: ' .. (mod.Config.CoopHUD.banner.description.centered and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.banner.description.centered = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.banner.description.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.banner.description.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.description.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.banner);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.banner, 'Curse Description');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.curse.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.banner.curse.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.curse.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.curse.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.banner.curse.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.curse.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.curse.box_width; end,
		Display = function() return 'Box Width: ' .. mod.Config.CoopHUD.banner.curse.box_width; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.curse.box_width = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.banner.curse.centered; end,
		Display = function() return 'Centered: ' .. (mod.Config.CoopHUD.banner.curse.centered and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.banner.curse.centered = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.banner,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.banner.curse.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.banner.curse.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.banner.curse.scale = Vector(n/100, n/100); end,
	}
);
