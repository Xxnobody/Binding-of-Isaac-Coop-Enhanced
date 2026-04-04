local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;

local fonts = {};
for key, _ in pairs(mod.Fnts) do
	table.insert(fonts, key);
end

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Pocket');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.pocket); end,
		Display = function() return mod.Config.CoopHUD.fonts.pocket; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.pocket = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Player');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.players); end,
		Display = function() return mod.Config.CoopHUD.fonts.players; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.players = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Pickups');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.pickups); end,
		Display = function() return mod.Config.CoopHUD.fonts.pickups; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.pickups = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Misc');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.misc); end,
		Display = function() return mod.Config.CoopHUD.fonts.misc; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.misc = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Stat');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.stats); end,
		Display = function() return mod.Config.CoopHUD.fonts.stats; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.stats = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Lives');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.lives); end,
		Display = function() return mod.Config.CoopHUD.fonts.lives; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.lives = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Banner');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.banners); end,
		Display = function() return mod.Config.CoopHUD.fonts.banners; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.banners = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Curse');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.curse); end,
		Display = function() return mod.Config.CoopHUD.fonts.curse; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.curse = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Description');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.description); end,
		Display = function() return mod.Config.CoopHUD.fonts.description; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.description = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.fonts, 'Timer');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.fonts,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopHUD.fonts.timer); end,
		Display = function() return mod.Config.CoopHUD.fonts.timer; end,
		OnChange = function(n) mod.Config.CoopHUD.fonts.timer = fonts[n]; Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);