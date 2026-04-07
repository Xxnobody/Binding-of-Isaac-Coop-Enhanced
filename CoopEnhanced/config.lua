local mod = CoopEnhanced;
local Utils = mod.Utils;

mod.DefaultConfig = {
	debug = false,
	commands = {
		CMD = "coop",
		config = true,
	},
	modules = {
		CoopHUD = true,
		CoopLabels = true,
		CoopTreasure = true,
		CoopMarks = true,
		CoopFixes = true,
		CoopExtras = true,
	},
	players = {
		[1] = {
			color = Utils.GetColorIndexByName("Red"),
			name = "",
			type = 0
		},
		[2] = {
			color = Utils.GetColorIndexByName("Blue"),
			name = "",
			type = 0
		},
		[3] = {
			color = Utils.GetColorIndexByName("Green"),
			name = "",
			type = 0
		},
		[4] = {
			color = Utils.GetColorIndexByName("Yellow"),
			name = "",
			type = 0
		}
	}
};
mod.Config = Utils.cloneTable(mod.DefaultConfig);

if ModConfigMenu == nil then return; end

mod.MCM = {};
mod.MCM.category = "Co-op Enhanced";
mod.MCM.Info = "Enable/Disable Enhanced Features. RESTART REQUIRED after any changes to take effect.";

ModConfigMenu.AddTitle(mod.MCM.category, 'Modules');
ModConfigMenu.AddSetting(
	mod.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.modules.CoopHUD; end,
		Display = function() return 'Enhanced HUD: ' .. (mod.Config.modules.CoopHUD and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.modules.CoopHUD = b; end,
		Info = {'A reformatted HUD with many features and settings to make your Co-op games awesome!'},
	}
);
ModConfigMenu.AddSetting(
	mod.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.modules.CoopLabels; end,
		Display = function() return 'Enhanced Labels: ' .. (mod.Config.modules.CoopLabels and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.modules.CoopLabels = b; end,
		Info = {'Co-op Labels to help track where your character is or isnt.'},
	}
);
ModConfigMenu.AddSetting(
	mod.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.modules.CoopTreasure; end,
		Display = function() return 'Enhanced Treasure: ' .. (mod.Config.modules.CoopTreasure and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.modules.CoopTreasure = b; end,
		Info = {'Co-op Treasure Rooms with a pedestal for every player and more.'},
	}
);
ModConfigMenu.AddSetting(
	mod.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.modules.CoopMarks; end,
		Display = function() return 'Enhanced Marks: ' .. (mod.Config.modules.CoopMarks and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.modules.CoopMarks = b; end,
		Info = {'Co-op Completion Marks on the pause screen.'},
	}
);
ModConfigMenu.AddSetting(
	mod.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.modules.CoopExtras; end,
		Display = function() return 'Enhanced Extras: ' .. (mod.Config.modules.CoopExtras and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.modules.CoopExtras = b; end,
		Info = {'Fixes for Co-op bugs that can cause issue for, or even destroy, Co-op fun.'},
	}
);
ModConfigMenu.AddSetting(
	mod.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.modules.CoopFixes; end,
		Display = function() return 'Enhanced Fixes: ' .. (mod.Config.modules.CoopFixes and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.modules.CoopFixes = b; end,
		Info = {'Fixes for Co-op bugs that can annoy or even destroy Co-op fun.'},
	}
);
ModConfigMenu.AddSpace(mod.MCM.category)
ModConfigMenu.AddSetting(
	mod.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.debug; end,
		Display = function() return 'Enable Debug: ' .. (mod.Config.debug and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.debug = b; end,
		Info = {'Enables Debug, mostly just a bunch of console vomit.'},
	}
);

ModConfigMenu.AddSpace(mod.MCM.category)
ModConfigMenu.AddTitle(mod.MCM.category, 'Global Player Names');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		mod.MCM.category,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.players[i].type; end,
			Minimum = 0,
			Maximum = 2,
			Display = function() return 'Player ' .. tostring(i) ..' Label: ' .. (mod.Config.players[i].type == 0 and "P" .. i or (mod.Config.players[i].type == 1 and "Character" or (string.len(mod.Config.players[i].name) == 0 and "Custom" or mod.Config.players[i].name))); end,
			OnChange = function(b) mod.Config.players[i].type = b; end,
			Info = "Character displays your character's name. (i.e. Isaac, Cain, etc). Custom requires using the command 'CoopMarks label <player_number> <label>'.",
		}
	);
end

ModConfigMenu.AddSpace(mod.MCM.category)
ModConfigMenu.AddTitle(mod.MCM.category, 'Global Player Colors');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		mod.MCM.category,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.players[i].color; end,
			Minimum = 1,
			Maximum = #mod.Colors,
			Display = function() return 'Player ' .. tostring(i) ..' Color: ' .. mod.Colors[mod.Config.players[i].color].Name; end,
			OnChange = function(b) mod.Config.players[i].color = b; end,
			Info = "Set the player color.",
		}
	);
end