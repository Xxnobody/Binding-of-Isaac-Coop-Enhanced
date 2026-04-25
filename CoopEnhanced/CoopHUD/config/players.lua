local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;


local sync_modules = {"Global"};
mod.Registry:AddCallback(mod.Callbacks.POST_REGISTRY_EXECUTE, function()
	for name,_ in pairs(mod.Registry.Modules) do
		if mod.Config[name] and mod.Config[name].players ~= nil then table.insert(sync_modules,name); end
	end
end);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		CurrentSetting = function() for i,sync in pairs(sync_modules) do if mod.Config.CoopHUD.player_sync == sync then return i; end end return 1; end,
		Display = function() return 'Player Sync: ' .. mod.Config.CoopHUD.player_sync; end,
		OnChange = function(n) n = n > #sync_modules and 1 or n; mod.Config.CoopHUD.player_sync = sync_modules[n]; end,
		Info = {'Choose which config this uses for Player Color/Names.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.mirrored_offset.X; end,
		Display = function() return 'P2 & P4 Additional Offset (X): ' .. mod.Config.CoopHUD.players.mirrored_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.players.mirrored_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.mirrored_offset.Y; end,
		Display = function() return 'P3 & P4 Addtional Offset (Y): ' .. mod.Config.CoopHUD.players.mirrored_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.players.mirrored_offset.Y = n; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.players);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.players, 'Twins');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.twins.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.players.twins.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.players.twins.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.twins.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.players.twins.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.players.twins.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.players.twins.offset_w_pockets; end,
		Display = function() return 'Pocket Offset: ' .. (mod.Config.CoopHUD.players.twins.offset_w_pockets and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.players.twins.offset_w_pockets = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.players.twins.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.players.twins.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.players.twins.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.players);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.players, 'Player Heads');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.players.heads.display; end,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.players.heads.display and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.players.heads.display = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.players.heads.color; end,
		Display = function() return 'Head Colors: ' .. (mod.Config.CoopHUD.players.heads.color and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.players.heads.color = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.heads.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.players.heads.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.players.heads.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.heads.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.players.heads.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.players.heads.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.players.heads.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.players.heads.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.players.heads.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.players.heads.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.players.heads.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.players.heads.opacity = n / 100; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.heads.item_offset.X; end,
		Display = function() return 'Item Offset (X): ' .. mod.Config.CoopHUD.players.heads.item_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.players.heads.item_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.heads.item_offset.Y; end,
		Display = function() return 'Item Offset (Y): ' .. mod.Config.CoopHUD.players.heads.item_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.players.heads.item_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.players.heads.sync.scale; end,
		Display = function() return 'Head Scaling: ' .. (mod.Config.CoopHUD.players.heads.sync.scale and 'Player' or 'Config'); end,
		OnChange = function(b) mod.Config.CoopHUD.players.heads.sync.scale = b; end,
		Info = {'Choose how heads scale, either with the config setting or with player character scale.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.players.heads.sync.color; end,
		Display = function() return 'Head Coloring: ' .. (mod.Config.CoopHUD.players.heads.sync.color and 'Player' or 'Config'); end,
		OnChange = function(b) mod.Config.CoopHUD.players.heads.sync.color = b; end,
		Info = {'Choose how heads are colored, either with the config setting or with player character color.'},
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.players);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.players, 'Player Names');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.players.names.display; end,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.players.names.display and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.players.names.display = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.names.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.players.names.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.players.names.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.names.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.players.names.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.players.names.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.players.names.head_offset; end,
		Display = function() return 'Head Offset: ' .. (mod.Config.CoopHUD.players.names.head_offset and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.players.names.head_offset = b; end,
		Info = "Enable to move Player names over whenever the player head icon is moved down by an item.",
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.players.names.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.players.names.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.players.names.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.players.names.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.players.names.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.players.names.opacity = n / 100; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.players);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.players, 'Player Names');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.players,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.players[i].type; end,
			Minimum = 0,
			Maximum = 2,
			Display = function() return 'Player ' .. tostring(i) ..' Name: ' .. (mod.Config.CoopHUD.players[i].type == 0 and "P" .. i or (mod.Config.CoopHUD.players[i].type == 1 and "Character" or (string.len(mod.Config.CoopHUD.players[i].name) == 0 and "Custom" or mod.Config.CoopHUD.players[i].name))); end,
			OnChange = function(n) mod.Config.CoopHUD.players[i].type = n; end,
			Info = "Character displays your character's name. (i.e. Isaac, Cain, etc). Custom requires using the command 'CoopHUD label <player_number> <label>'.",
		}
	);
end
ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.players)
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.players, 'Player Colors');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.players,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.players[i].color; end,
			Minimum = 1,
			Maximum = #mod.Colors,
			Display = function() return 'Player ' .. tostring(i) ..' Color: ' .. mod.Colors[mod.Config.CoopHUD.players[i].color].Name; end,
			OnChange = function(n) mod.Config.CoopHUD.players[i].color = n; end,
			Info = "Set the player color.",
		}
	);
end
ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.players)
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.players, 'Player Offsets');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.players,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.players[i].offset.X; end,
			Display = function() return 'Player ' .. tostring(i) ..' Offset (X): ' .. mod.Config.CoopHUD.players[i].offset.X; end,
			OnChange = function(n) mod.Config.CoopHUD.players[i].offset.X = n; end,
			Info = "Set the individual player offset.",
		}
	);
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.players,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return mod.Config.CoopHUD.players[i].offset.Y; end,
			Display = function() return 'Player ' .. tostring(i) ..' Offset (Y): ' .. mod.Config.CoopHUD.players[i].offset.Y; end,
			OnChange = function(n) mod.Config.CoopHUD.players[i].offset.Y = n; end,
			Info = "Set the individual player offset.",
		}
	);
end
ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.players)
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.players, 'Player Scales');
for i = 1, 4 do
	ModConfigMenu.AddSetting(
		CoopHUD.MCM.title,
		CoopHUD.MCM.categories.players,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.players[i].scale.X * 100)); end,
			Minimum = 0.0,
			Display = function() return 'Player ' .. tostring(i) ..' Scale: ' ..  string.format('%.0f', mod.Config.CoopHUD.players[i].scale.X * 100) .. '%'; end,
			OnChange = function(n) mod.Config.CoopHUD.players[i].scale = Vector(n/100, n/100); end,
			Info = "Set the player HUD scale.",
		}
	);
end

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.players);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.players, 'Character Select');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 2,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.display; end,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.players.menu.display == 0 and "Hide" or (mod.Config.CoopHUD.players.menu.display == 1 and "Heads" or "Heads + Names")); end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.display = n; end,
		Info = {'Choose how the Co-op Player select menu displays. Hide disables the HUD until the menu is closed.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 2,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.distance; end,
		Display = function() return 'Scale Extra: ' .. (mod.Config.CoopHUD.players.menu.distance == 0 and "off" or (mod.Config.CoopHUD.players.menu.distance == 1 and "Shrink" or "Grow")); end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.distance = n; end,
		Info = {'Sets whether the extra player heads on the left and right scale the further from the first they are.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 2,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.fade; end,
		Display = function() return 'Opacity Extra: ' .. (mod.Config.CoopHUD.players.menu.fade == 0 and "off" or (mod.Config.CoopHUD.players.menu.fade == 1 and "Fade" or "Un-Fade")); end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.fade = n; end,
		Info = {'Sets whether the extra player heads on the left and right have different opacity the further from the first they are.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = 20,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.max; end,
		Display = function() return 'Max Extra: ' .. mod.Config.CoopHUD.players.menu.max; end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.max = n; end,
		Info = {'Set how many characters will be displayed on the left and right.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.players.menu.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.players.menu.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.rel_offset.X; end,
		Display = function() return 'Relative Offset (X): ' .. mod.Config.CoopHUD.players.menu.rel_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.rel_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.rel_offset.Y; end,
		Display = function() return 'Relative Offset (Y): ' .. mod.Config.CoopHUD.players.menu.rel_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.rel_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.rel_invert; end,
		Display = function() return 'Invert Relative: ' .. (mod.Config.CoopHUD.players.menu.rel_invert and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.players.menu.rel_invert = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.players.menu.circle; end,
		Display = function() return 'Circularize: ' .. (mod.Config.CoopHUD.players.menu.circle and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.players.menu.circle = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.players.menu.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.players.menu.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.players,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.players.menu.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.players.menu.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.players.menu.opacity = n / 100; end,
	}
);
