local mod = CoopEnhanced;
local CoopExtras = CoopEnhanced.CoopExtras;

local Utils = mod.Utils;

mod.CoopExtras.DefaultConfig = {
	CMD = "extras",
	
	item_prices = true,
	greed_revive = true,
	tainted_bombs = false,
	perfection = {
		enabled = true,
		once = true,
		required = 3,
	},
	sacrifice_revive = {
		enabled = true,
		chance = 0.25,
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
	mod.Config.CoopExtras = Utils.Clone(mod.CoopExtras.DefaultConfig);
end
if mod.Config.CoopExtras == nil then CoopExtras.ResetConfig(); end

if ModConfigMenu == nil then return; end

CoopExtras.MCM = {};
CoopExtras.MCM.category = "Co-op Extras";
CoopExtras.MCM.Info = "Co-op Extra settings";

ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddTitle(CoopExtras.MCM.category, 'Autopricing');
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.item_prices; end,
		Display = function() return 'Enabled: ' .. (mod.Config.CoopExtras.item_prices and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.item_prices = b; end,
		Info = {'Devil deal prices change to use the closest players health instead. Item pedestals also update for Keepers automatically.'},
	}
);

ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddTitle(CoopExtras.MCM.category, 'Greed Revive Machine');
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.greed_revive; end,
		Display = function() return 'Enabled: ' .. (mod.Config.CoopExtras.greed_revive and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.greed_revive = b; end,
		Info = {'Adds a Revive Machine to Greed mode shop after Floor 1 and until the final floor.'},
	}
);

ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddTitle(CoopExtras.MCM.category, 'Tainted ??? Bombs');
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.tainted_bombs; end,
		Display = function() return 'Enabled: ' .. (mod.Config.CoopExtras.tainted_bombs and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.tainted_bombs = b; end,
		Info = {'When tainted ??? picks up bombs/bomb items while another player isnt also tainted ???, bombs are added instead.'},
	}
);

ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddTitle(CoopExtras.MCM.category, 'Per (player) fection');
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.perfection.enabled; end,
		Display = function() return 'Enabled: ' .. (mod.Config.CoopExtras.perfection.enabled and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.perfection.enabled = b; end,
		Info = {'Perfection is tracked and spawned per player instead of as a group.'},
	}
);
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.perfection.once; end,
		Display = function() return 'Perfection Only Once: ' .. (mod.Config.CoopExtras.perfection.once and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.perfection.once = b; end,
		Info = {'When off, perfection will spawn after every 3 bosses you clear, instead of only once and never again.'},
	}
);
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		CurrentSetting = function() return  mod.Config.CoopExtras.perfection.required; end,
		Display = function() return 'Perfection Minimum: ' ..  mod.Config.CoopExtras.perfection.required; end,
		OnChange = function(n) mod.Config.CoopExtras.perfection.required = n; end,
		Info = {'Set the minimum amount of floors without hits to spawn Perfection. Setting ot 0 means it spawns after the next floor boss as long as no damage is taken.'},
	}
);

ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddTitle(CoopExtras.MCM.category, 'Ghost Flight');
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.ghost_flight.enabled; end,
		Display = function() return 'Enabled: ' .. (mod.Config.CoopExtras.ghost_flight.enabled and 'on' or 'off'); end,
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
		CurrentSetting = function() return mod.Config.CoopExtras.ghost_flight.shopping; end,
		Display = function() return 'Broke Ghosts: ' .. (mod.Config.CoopExtras.ghost_flight.shopping and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.ghost_flight.shopping = b; end,
		Info = {'Co-op players cannot buy anything from shops.'},
	}
);
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.ghost_flight.chests; end,
		Display = function() return 'Heavy Locks: ' .. (mod.Config.CoopExtras.ghost_flight.chests and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.ghost_flight.chests = b; end,
		Info = {'Co-op players cannot open chests, only push them. (Requires REPENTOGON)'},
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
		Info = {'Co-op Ghost players cannot interact with enemies, and thus cannot block them. Everything means pickups as well.  (Requires REPENTOGON)'},
	}
);

ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddTitle(CoopExtras.MCM.category, 'Sacrificial Revives');
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.sacrifice_revive.enabled; end,
		Display = function() return 'Enabled: ' .. (mod.Config.CoopExtras.sacrifice_revive.enabled and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.sacrifice_revive.enabled = b; end,
		Info = {'Revive players using sacrifice rooms. (Requires REPENTOGON)'},
	}
);
ModConfigMenu.AddSpace(CoopExtras.MCM.category)
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopExtras.sacrifice_revive.increase; end,
		Display = function() return 'Chance Increases: ' .. (mod.Config.CoopExtras.sacrifice_revive.increase and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopExtras.sacrifice_revive.increase = b; end,
		Info = {'Enable to have the base chance increase after each sacrifice.'},
	}
);
ModConfigMenu.AddSetting(
	CoopExtras.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopExtras.sacrifice_revive.chance * 100)); end,
		Display = function() return 'Revival Chance: ' .. string.format('%.0f', mod.Config.CoopExtras.sacrifice_revive.chance * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopExtras.sacrifice_revive.chance = n / 100; end,
	}
);