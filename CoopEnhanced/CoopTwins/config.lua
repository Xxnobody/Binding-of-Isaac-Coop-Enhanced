local mod = CoopEnhanced;
local CoopTwins = CoopEnhanced.CoopTwins;

local Utils = mod.Utils;

mod.CoopTwins.DefaultConfig = {
	CMD = "twins",
	
	tp_distance = 3,
	twin_death = true,
	forgottensoul = {
		share_items = true,
	},
};
	
function mod.CoopTwins.ResetConfig()
	mod.Config.CoopTwins = Utils.Clone(mod.CoopTwins.DefaultConfig);
end
if mod.Config.CoopTwins == nil then CoopTwins.ResetConfig(); end

if ModConfigMenu == nil then return; end

CoopTwins.MCM = {};
CoopTwins.MCM.category = "Co-op Twins";
CoopTwins.MCM.Info = "Co-op Twins settings";

ModConfigMenu.AddSetting(
	CoopTwins.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopTwins.twin_death; end,
		Display = function() return "Twin Death: " .. (mod.Config.CoopTwins.twin_death and "on" or "off"); end,
		OnChange = function(b) mod.Config.CoopTwins.twin_death = b; end,
		Info = {"When one twin dies, the opther dies with them."},
	}
);
ModConfigMenu.AddSetting(
	CoopTwins.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = 15,
		CurrentSetting = function() return mod.Config.CoopTwins.tp_distance; end,
		Display = function() return "Distance: " .. mod.Config.CoopTwins.tp_distance .. " Grids"; end,
		OnChange = function(n) mod.Config.CoopTwins.tp_distance = n; end,
	}
);

ModConfigMenu.AddTitle(CoopTwins.MCM.category, "Forgotten/Soul");
ModConfigMenu.AddSetting(
	CoopTwins.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopTwins.forgottensoul.share_items; end,
		Display = function() return "Share Items: " .. (mod.Config.CoopTwins.forgottensoul.share_items and "on" or "off"); end,
		OnChange = function(b) mod.Config.CoopTwins.forgottensoul.share_items = b; end,
		Info = {"Enable to have the Forgotten and Soul share items."},
	}
);