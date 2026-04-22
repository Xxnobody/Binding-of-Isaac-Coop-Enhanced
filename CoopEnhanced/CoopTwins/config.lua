local mod = CoopEnhanced;
local CoopTwins = CoopEnhanced.CoopTwins;

local Utils = mod.Utils;

mod.CoopTwins.DefaultConfig = {
	CMD = "twins",

	tp_distance = 3,
};
	
function mod.CoopTwins.ResetConfig()
	mod.Config.CoopTwins = Utils.CloneObject(mod.CoopTwins.DefaultConfig);
end
if mod.Config.CoopTwins == nil then CoopTwins.ResetConfig(); end

if ModConfigMenu == nil then return; end

CoopTwins.MCM = {};
CoopTwins.MCM.category = "Co-op Twins";
CoopTwins.MCM.Info = "Co-op Twins settings";

ModConfigMenu.AddSetting(
	CoopTwins.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = 15,
		CurrentSetting = function() return mod.Config.CoopTwins.tp_distance; end,
		Display = function() return 'Distance: ' .. mod.Config.CoopTwins.tp_distance .. " Grids"; end,
		OnChange = function(n) mod.Config.CoopTwins.tp_distance = n; end,
	}
);