local mod = CoopEnhanced;
local CoopLabels = CoopEnhanced.CoopLabels;

local Utils = mod.Utils;

mod.CoopLabels.DefaultConfig = {
	CMD = "labels",
	
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
	display = 2,
	player_sync = "Global",
	opacity = 1,
	offset = Vector(0,0),
	head_offset = Vector(0,0),
	text_offset = Vector(0,0),
	scale = Vector(1,1),
	text_scale = Vector(1,1),
	head_scale = Vector(1,1),
	scale_sync = false,
	tear_colors = false,
	player_colors = false,
	fonts = {labels = 'terminus',}
};
	
function mod.CoopLabels.ResetConfig()
	mod.Config.CoopLabels = Utils.cloneTable(mod.CoopLabels.DefaultConfig);
end
if mod.Config.CoopLabels == nil then CoopLabels.ResetConfig(); end

if ModConfigMenu == nil then return; end

CoopLabels.MCM = {};
CoopLabels.MCM.category = "Co-op Labels";
CoopLabels.MCM.Info = "Co-op Label settings";

ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopLabels.display; end,
		Display = function() return 'Display: ' .. (mod.Config.CoopLabels.display == 0 and "None" or (mod.Config.CoopLabels.display == 1 and "Head" or (mod.Config.CoopLabels.display == 2 and "Name" or "Head & Name"))); end,
		OnChange = function(n) mod.Config.CoopLabels.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopLabels.player_colors; end,
		Display = function() return 'Isaac Colors: ' .. (mod.Config.CoopLabels.player_colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopLabels.player_colors = b; end,
		Info = {'Enable to Tint each player character to their specific color.'},
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopLabels.tear_colors; end,
		Display = function() return 'Tear Colors: ' .. (mod.Config.CoopLabels.tear_colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopLabels.tear_colors = b; end,
		Info = {'Enable to Tint player tears to their color.'},
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopLabels.scale_sync; end,
		Display = function() return 'Label Scaling: ' .. (mod.Config.CoopLabels.scale_sync and 'Player' or 'Config'); end,
		OnChange = function(b) mod.Config.CoopLabels.scale_sync = b; end,
		Info = {'Choose how labels scale, either with the config setting or with player character scale.'},
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopLabels.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopLabels.offset.X; end,
		OnChange = function(n) mod.Config.CoopLabels.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopLabels.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopLabels.offset.Y; end,
		OnChange = function(n) mod.Config.CoopLabels.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopLabels.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopLabels.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopLabels.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopLabels.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopLabels.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopLabels.opacity = n / 100; end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopLabels.head_offset.X; end,
		Display = function() return 'Head Offset (X): ' .. mod.Config.CoopLabels.head_offset.X; end,
		OnChange = function(n) mod.Config.CoopLabels.head_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopLabels.head_offset.Y; end,
		Display = function() return 'Head Offset (Y): ' .. mod.Config.CoopLabels.head_offset.Y; end,
		OnChange = function(n) mod.Config.CoopLabels.head_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopLabels.head_scale.X * 100)); end,
		Display = function() return 'Head Scale: ' .. string.format('%.0f', mod.Config.CoopLabels.head_scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopLabels.head_scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopLabels.text_offset.X; end,
		Display = function() return 'Text Offset (X): ' .. mod.Config.CoopLabels.text_offset.X; end,
		OnChange = function(n) mod.Config.CoopLabels.text_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopLabels.text_offset.Y; end,
		Display = function() return 'Text Offset (Y): ' .. mod.Config.CoopLabels.text_offset.Y; end,
		OnChange = function(n) mod.Config.CoopLabels.text_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopLabels.text_scale.X * 100)); end,
		Display = function() return 'Text Scale: ' .. string.format('%.0f', mod.Config.CoopLabels.text_scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopLabels.text_scale = Vector(n/100, n/100); end,
	}
);

local sync_modules = {"Global"};
mod.Registry.AddCallback(mod.Callbacks.POST_REGISTRY_EXECUTE, function()
	for name,_ in pairs(mod.Registry.Modules) do
		if mod.Config[name] and mod.Config[name].players ~= nil then table.insert(sync_modules,name); end
	end
end);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		CurrentSetting = function() for i,sync in pairs(sync_modules) do if mod.Config.CoopLabels.player_sync == sync then return i; end	end	return 1; end,
		Display = function() return 'Player Sync: ' .. mod.Config.CoopLabels.player_sync; end,
		OnChange = function(n) n = n > #sync_modules and 1 or n; mod.Config.CoopLabels.player_sync = sync_modules[n]; end,
		Info = {'Choose which config this uses for Player Color/Names.'},
	}
);

ModConfigMenu.AddSpace(CoopLabels.MCM.category)
ModConfigMenu.AddTitle(CoopLabels.MCM.category, 'Player Names');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		CoopLabels.MCM.category,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopLabels.players[i].type; end,
			Minimum = 0,
			Maximum = 2,
			Display = function() return 'Player ' .. tostring(i) ..' Label: ' .. (mod.Config.CoopLabels.players[i].type == 0 and "P" .. i or (mod.Config.CoopLabels.players[i].type == 1 and "Character" or (string.len(mod.Config.CoopLabels.players[i].name) == 0 and "Custom" or mod.Config.CoopLabels.players[i].name))); end,
			OnChange = function(n) mod.Config.CoopLabels.players[i].type = n; end,
			Info = "Character displays your character's name. (i.e. Isaac, Cain, etc). Custom requires using the command 'CoopLabels label <player_number> <label>'.",
		}
	);
end

ModConfigMenu.AddSpace(CoopLabels.MCM.category)
ModConfigMenu.AddTitle(CoopLabels.MCM.category, 'Player Colors');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		CoopLabels.MCM.category,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopLabels.players[i].color; end,
			Minimum = 1,
			Maximum = #mod.Colors,
			Display = function() return 'Player ' .. tostring(i) ..' Color: ' .. mod.Colors[mod.Config.CoopLabels.players[i].color].Name; end,
			OnChange = function(n) mod.Config.CoopLabels.players[i].color = n; end,
			Info = "Set the player color.",
		}
	);
end

ModConfigMenu.AddSpace(CoopLabels.MCM.category);
local fonts = {};
for key, _ in pairs(mod.Fnts) do
	table.insert(fonts, key);
end

ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopLabels.fonts.labels); end,
		Display = function() return 'Label Font: ' .. mod.Config.CoopLabels.fonts.labels; end,
		OnChange = function(n) mod.Config.CoopLabels.fonts.labels = fonts[n] Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddSpace(CoopLabels.MCM.category);
ModConfigMenu.AddSetting(
	CoopLabels.MCM.category,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return true; end,
		Display = function() return 'Reset Settings'; end,
		OnChange = function(_) CoopLabels.ResetConfig(); end,
	}
);