local mod = CoopEnhanced;
local CoopFixes = CoopEnhanced.CoopFixes;

local Utils = mod.Utils;

mod.CoopFixes.DefaultConfig = {
	CMD = "fixes",
	
	fullscreen = {
		enable = false,
		pos = Vector(0,0)
	},
	join = {
		enable = true,
		max = 2
	},
	rejoin = true,
};
	
function mod.CoopFixes.ResetConfig()
	mod.Config.CoopFixes = Utils.CloneObject(mod.CoopFixes.DefaultConfig);
end
if mod.Config.CoopFixes == nil then mod.CoopFixes.ResetConfig(); end

if ModConfigMenu == nil then return; end

CoopFixes.MCM = {};
CoopFixes.MCM.category = "Co-op Fixes";
CoopFixes.MCM.Info = "Co-op Fix settings";

ModConfigMenu.AddTitle(CoopFixes.MCM.category, 'Fullscreen Offset Fix');
ModConfigMenu.AddSetting(
	CoopFixes.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return CoopEnhanced.Config.CoopFixes.fullscreen.enable; end,
		Display = function() return 'Fullscreen Fix: ' .. (CoopEnhanced.Config.CoopFixes.fullscreen.enable and 'on' or 'off'); end,
		OnChange = function(b) CoopEnhanced.Config.CoopFixes.fullscreen.enable = b; CoopEnhanced.CoopFixes.RefreshFullscreen(); end,
		Info = {'Enable to fix an issue where fullscreen makes the window offset. Screen will flash momentarily.'},
	}
);
ModConfigMenu.AddSetting(
	CoopFixes.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return CoopEnhanced.Config.CoopFixes.fullscreen.pos.X; end,
		Display = function() return 'Window Position (X): ' .. CoopEnhanced.Config.CoopFixes.fullscreen.pos.X; end,
		OnChange = function(n) CoopEnhanced.Config.CoopFixes.fullscreen.pos.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopFixes.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return CoopEnhanced.Config.CoopFixes.fullscreen.pos.Y; end,
		Display = function() return 'Window Position (Y): ' .. CoopEnhanced.Config.CoopFixes.fullscreen.pos.Y; end,
		OnChange = function(n) CoopEnhanced.Config.CoopFixes.fullscreen.pos.Y = n; end,
	}
);

ModConfigMenu.AddSpace(CoopFixes.MCM.category);
ModConfigMenu.AddTitle(CoopFixes.MCM.category, 'Join Fix');
ModConfigMenu.AddSetting(
	CoopFixes.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return CoopEnhanced.Config.CoopFixes.join.enable; end,
		Display = function() return 'True Co-op Join Fix: ' .. (CoopEnhanced.Config.CoopFixes.join.enable and 'on' or 'off'); end,
		OnChange = function(b) CoopEnhanced.Config.CoopFixes.join.enable = b; end,
		Info = {'Enable to fix an issue where sometimes True Co-op games cannot be started. RESTART REQUIRED'},
	}
);
ModConfigMenu.AddSetting(
	CoopFixes.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		CurrentSetting = function() return CoopEnhanced.Config.CoopFixes.join.max; end,
		Display = function() return 'Maximim Visits: ' .. CoopEnhanced.Config.CoopFixes.join.max; end,
		OnChange = function(n) CoopEnhanced.Config.CoopFixes.join.max = n; end,
		Info = {'Set the maximum amount of Visits to the start room that will allow starting True Co-op. Increase this if the fix doesnt work.'},
	}
);

ModConfigMenu.AddSpace(CoopFixes.MCM.category)
ModConfigMenu.AddTitle(CoopFixes.MCM.category, 'Rejoin Fix');
ModConfigMenu.AddSetting(
	CoopFixes.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return CoopEnhanced.Config.CoopFixes.rejoin; end,
		Display = function() return 'Character Rejoin Fix: ' .. (CoopEnhanced.Config.CoopFixes.rejoin and 'on' or 'off'); end,
		OnChange = function(b) CoopEnhanced.Config.CoopFixes.rejoin = b; end,
		Info = {'Enable to fix a bug that can happen when rejoining that causes all character types to become the same as player 1. RESTART REQUIRED'},
	}
);

ModConfigMenu.AddSpace(CoopFixes.MCM.category)
ModConfigMenu.AddSetting(
	CoopFixes.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return true; end,
		Display = function() return 'Reset Settings'; end,
		OnChange = function(_) CoopFixes.ResetConfig(); end,
	}
);