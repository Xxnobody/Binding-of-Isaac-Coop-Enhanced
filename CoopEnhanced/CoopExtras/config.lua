local mod = CoopEnhanced;
local CoopExtras = CoopEnhanced.CoopExtras;

local Utils = mod.Utils;

mod.CoopExtras.DefaultConfig = {
	CMD = "extras",
	
	item_prices = true,
	greed_revive = true,
	sacrifice_revive = {
		enabled = true,
		chance = 25.0,
		increase = true,
	},
	ghost_flight = {
		enabled = true,
		pickups = true,
		shopping = true,
		chests = false,
		buttons = false,
		interact = 0,
	},
};
	
function mod.CoopExtras.ResetConfig()
	mod.Config.CoopExtras = Utils.CloneObject(mod.CoopExtras.DefaultConfig);
end
if mod.Config.CoopExtras == nil then CoopExtras.ResetConfig(); end

if ModConfigMenu == nil then return; end

CoopExtras.MCM = {};
CoopExtras.MCM.category = "Co-op Extras";
CoopExtras.MCM.Info = "Co-op Extra settings";

ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.item_prices; end,
		Display = function() return 'Coop Prices: ' .. (mod.Config.CoopExtras.item_prices and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.item_prices = b; end,
		Info = {'Devil deal prices change to use the closest players health instead. Item pedestals also update for Keepers automatically.'},
	}
);

ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.greed_revive; end,
		Display = function() return 'Greed Revive Machine: ' .. (mod.Config.CoopExtras.greed_revive and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.greed_revive = b; end,
		Info = {'Adds a Revive Machine to Greed mode shop after Floor 1 and until the final floor.'},
	}
);

ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.ghost_flight.enabled; end,
		Display = function() return 'Ghost Flight: ' .. (mod.Config.CoopExtras.ghost_flight.enabled and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.ghost_flight.enabled = b; end,
		Info = {'Dead Ghost players can fly!'},
	}
);
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.ghost_flight.pickups; end,
		Display = function() return 'Unreachable Pickups: ' .. (mod.Config.CoopExtras.ghost_flight.pickups and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.ghost_flight.pickups = b; end,
		Info = {'Flying Co-op players cannot pickup items they normally couldnt reach.'},
	}
);
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.ghost_flight.chests; end,
		Display = function() return 'Heavy Locks: ' .. (mod.Config.CoopExtras.ghost_flight.chests and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.ghost_flight.chests = b; end,
		Info = {'Co-op players cannot open chests, only push them.'},
	}
);
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.ghost_flight.shopping; end,
		Display = function() return 'Broke Ghosts: ' .. (mod.Config.CoopExtras.ghost_flight.shopping and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.ghost_flight.shopping = b; end,
		Info = {'Co-op players cannot buy anything from shops.'},
	}
);
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopExtras.ghost_flight.interact; end,
		Display = function() return 'Prevent Touching: ' .. (mod.Config.CoopExtras.ghost_flight.interact == 0 and "None" or (mod.Config.CoopExtras.ghost_flight.interact == 1 and "Enemies" or (mod.Config.CoopExtras.ghost_flight.interact == 2 and "Bosses" or (mod.Config.CoopExtras.ghost_flight.interact == 3 and "Enemies & Bosses" or "Everything")))); end,
		OnChange = function(n) mod.Config.CoopExtras.ghost_flight.interact = n; end,
		Info = {'Co-op Ghost players cannot interact with enemies, and thus cannot block them. Everything means pickups as well.'},
	}
);