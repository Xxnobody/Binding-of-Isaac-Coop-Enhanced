local mod = CoopEnhanced;
local CoopMarks = CoopEnhanced.CoopMarks;

local Utils = mod.Utils;

mod.CoopMarks.DefaultConfig = {
	CMD = "marks",

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
	},
	coop_only = false,
	coop_menu = true,
	colors = false,
	player_sync = "Global",
	opacity = 1,
	offset = Vector(0,0),
	menu_offset = Vector(0,0),
	rel_offset = Vector(0,0),
	scale = Vector(0.5,0.5),
	text_scale = Vector(1,1),
	fonts = {mark = 'luaminioutlined',}
};
	
function mod.CoopMarks.ResetConfig()
	mod.Config.CoopMarks = Utils.cloneTable(mod.CoopMarks.DefaultConfig);
end
if mod.Config.CoopMarks == nil then CoopMarks.ResetConfig(); end

if ModConfigMenu == nil then return; end

CoopMarks.MCM = {};
CoopMarks.MCM.category = "Co-op Marks";
CoopMarks.MCM.Info = "Co-op Completion Marks settings";

ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopMarks.colors; end,
		Display = function() return 'Mark Colors: ' .. (mod.Config.CoopMarks.colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopMarks.colors = b; end,
		Info = {'Enable to Tint each character mark sheet to their specific color.'},
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopMarks.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopMarks.offset.X; end,
		OnChange = function(n) mod.Config.CoopMarks.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopMarks.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopMarks.offset.Y; end,
		OnChange = function(n) mod.Config.CoopMarks.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopMarks.rel_offset.X; end,
		Display = function() return 'Relative Offset (X): ' .. mod.Config.CoopMarks.rel_offset.X; end,
		OnChange = function(n) mod.Config.CoopMarks.rel_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopMarks.rel_offset.Y; end,
		Display = function() return 'Relative Offset (Y): ' .. mod.Config.CoopMarks.rel_offset.Y; end,
		OnChange = function(n) mod.Config.CoopMarks.rel_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopMarks.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopMarks.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopMarks.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopMarks.text_scale.X * 100)); end,
		Display = function() return 'Text Scale: ' .. string.format('%.0f', mod.Config.CoopMarks.text_scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopMarks.text_scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopMarks.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopMarks.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopMarks.opacity = n / 100; end,
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopMarks.coop_only; end,
		Display = function() return 'Coop Only: ' .. (mod.Config.CoopMarks.coop_only and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopMarks.coop_only = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopMarks.coop_menu; end,
		Display = function() return 'Coop Menu: ' .. (mod.Config.CoopMarks.coop_menu and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopMarks.coop_menu = b; end,
		Info = {'Enable to show completion marks with the Coop character select menu.'},
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopMarks.menu_offset.X; end,
		Display = function() return 'Menu Offset (X): ' .. mod.Config.CoopMarks.menu_offset.X; end,
		OnChange = function(n) mod.Config.CoopMarks.menu_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopMarks.menu_offset.Y; end,
		Display = function() return 'Menu Offset (Y): ' .. mod.Config.CoopMarks.menu_offset.Y; end,
		OnChange = function(n) mod.Config.CoopMarks.menu_offset.Y = n; end,
	}
);

local sync_modules = {"Global"};
mod.Registry:AddCallback(mod.Callbacks.POST_REGISTRY_EXECUTE, function()
	for name,_ in pairs(mod.Registry.Modules) do
		if mod.Config[name] and mod.Config[name].players ~= nil then table.insert(sync_modules,name); end
	end
end);
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		CurrentSetting = function() for i,sync in pairs(sync_modules) do if mod.Config.CoopMarks.player_sync == sync then return i; end	end	return 1; end,
		Display = function() return 'Player Sync: ' .. mod.Config.CoopMarks.player_sync; end,
		OnChange = function(n) n = n > #sync_modules and 1 or n; mod.Config.CoopMarks.player_sync = sync_modules[n]; end,
		Info = {'Choose which config this uses for Player Color/Names.'},
	}
);

ModConfigMenu.AddSpace(CoopMarks.MCM.category)
ModConfigMenu.AddTitle(CoopMarks.MCM.category, 'Player Names');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		CoopMarks.MCM.category,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopMarks.players[i].type; end,
			Minimum = 0,
			Maximum = 2,
			Display = function() return 'Player ' .. tostring(i) ..' Label: ' .. (mod.Config.CoopMarks.players[i].type == 0 and "P" .. i or (mod.Config.CoopMarks.players[i].type == 1 and "Character" or (string.len(mod.Config.CoopMarks.players[i].name) == 0 and "Custom" or mod.Config.CoopMarks.players[i].name))); end,
			OnChange = function(b) mod.Config.CoopMarks.players[i].type = b; end,
			Info = "Character displays your character's name. (i.e. Isaac, Cain, etc). Custom requires using the command 'CoopMarks label <player_number> <label>'.",
		}
	);
end

ModConfigMenu.AddSpace(CoopMarks.MCM.category)
ModConfigMenu.AddTitle(CoopMarks.MCM.category, 'Player Colors');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		CoopMarks.MCM.category,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopMarks.players[i].color; end,
			Minimum = 1,
			Maximum = #mod.Colors,
			Display = function() return 'Player ' .. tostring(i) ..' Color: ' .. mod.Colors[mod.Config.CoopMarks.players[i].color].Name; end,
			OnChange = function(b) mod.Config.CoopMarks.players[i].color = b; end,
			Info = "Set the player color.",
		}
	);
end

ModConfigMenu.AddSpace(CoopMarks.MCM.category);
local fonts = {};
for key, _ in pairs(mod.Fnts) do
	table.insert(fonts, key);
end

ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopMarks.fonts.mark); end,
		Display = function() return 'Label Font: ' .. mod.Config.CoopMarks.fonts.mark; end,
		OnChange = function(n) mod.Config.CoopMarks.fonts.mark = fonts[n] Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddSpace(CoopMarks.MCM.category)
ModConfigMenu.AddSetting(
	CoopMarks.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return true; end,
		Display = function() return 'Reset Settings'; end,
		OnChange = function(_) CoopMarks.ResetConfig(); end,
	}
);