local mod = CoopEnhanced
local CoopHUD = CoopEnhanced.CoopHUD

ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.inventory, 'Passive Collectibles');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.display; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.inventory.items.display == 0 and 'Always' or (mod.Config.CoopHUD.inventory.items.display == 1 and 'Map' or (mod.Config.CoopHUD.inventory.items.display == 2 and 'No Map' or 'Never'))); end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.anchor; end,
		Display = function() return 'Anchor: ' .. (mod.Config.CoopHUD.inventory.items.anchor == 0 and 'Player' or (mod.Config.CoopHUD.inventory.items.anchor == 1 and 'Split' or (mod.Config.CoopHUD.inventory.items.anchor == 2 and 'Left' or 'Right'))); end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.anchor = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.max; end,
		Display = function() return 'Max Displayed: ' .. mod.Config.CoopHUD.inventory.items.max; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.max = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.dead; end,
		Display = function() return 'Dead Players: ' .. (mod.Config.CoopHUD.inventory.items.dead and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.inventory.items.dead = b; end,
		Info = {'Enable to show passive items for dead players.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.colors; end,
		Display = function() return 'Item Colors: ' .. (mod.Config.CoopHUD.inventory.items.colors and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.inventory.items.colors = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.offset_w_pockets; end,
		Display = function() return 'Pocket Offset: ' .. (mod.Config.CoopHUD.inventory.items.offset_w_pockets and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.inventory.items.offset_w_pockets = b; end,
		Info = {'Enable to shift the inventory position down with pocket items.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.offset_w_twins; end,
		Display = function() return 'Twins Offset: ' .. (mod.Config.CoopHUD.inventory.items.offset_w_twins and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.inventory.items.offset_w_twins = b; end,
		Info = {'Enable to shift the inventory position when you have a twin.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.inventory.items.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.inventory.items.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.twin_offset.X; end,
		Display = function() return 'Twin Offset (X): ' .. mod.Config.CoopHUD.inventory.items.twin_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.twin_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.twin_offset.Y; end,
		Display = function() return 'Twin Offset (Y): ' .. mod.Config.CoopHUD.inventory.items.twin_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.twin_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.twins_offset.X; end,
		Display = function() return 'Offset w/ Twin (X): ' .. mod.Config.CoopHUD.inventory.items.twins_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.twins_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.twins_offset.Y; end,
		Display = function() return 'Offset w/ Twin (Y): ' .. mod.Config.CoopHUD.inventory.items.twins_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.twins_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.inventory.items.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.inventory.items.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		Maximum = 100.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.inventory.items.opacity * 100)); end,
		Display = function() return 'Opacity: ' .. string.format('%.0f', mod.Config.CoopHUD.inventory.items.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.opacity = n / 100; end,
	}
);

ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.inventory, 'Grid');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.direction; end,
		Display = function() return 'Direction: ' .. (mod.Config.CoopHUD.inventory.items.direction == 0 and 'Left' or (mod.Config.CoopHUD.inventory.items.direction == 1 and 'Up' or (mod.Config.CoopHUD.inventory.items.direction == 2 and 'Right' or 'Down'))); end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.direction = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.invert_direction.X; end,
		Minimum = 0,
		Maximum = 1,
		Display = function() return 'Invert Direction (X): ' .. (mod.Config.CoopHUD.inventory.items.invert_direction.X == 1 and 'on' or 'off'); end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.invert_direction.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.invert_direction.Y; end,
		Minimum = 0,
		Maximum = 1,
		Display = function() return 'Invert Direction (Y): ' .. (mod.Config.CoopHUD.inventory.items.invert_direction.Y == 1 and 'on' or 'off'); end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.invert_direction.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.max_grid.X; end,
		Display = function() return 'Max Columns: ' .. math.floor(mod.Config.CoopHUD.inventory.items.max_grid.X); end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.max_grid.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.max_grid.Y; end,
		Display = function() return 'Max Rows: ' .. math.floor(mod.Config.CoopHUD.inventory.items.max_grid.Y); end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.max_grid.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.space.X; end,
		Display = function() return 'Space Between Columns: ' .. mod.Config.CoopHUD.inventory.items.space.X; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.space.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.items.space.Y; end,
		Display = function() return 'Space Between Rows: ' .. mod.Config.CoopHUD.inventory.items.space.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.items.space.Y = n; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.inventory);
ModConfigMenu.AddTitle(CoopHUD.MCM.title, CoopHUD.MCM.categories.inventory, 'Crafting/Special');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.display; end,
		Minimum = 0,
		Maximum = 3,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.inventory.special.display == 0 and 'Always' or (mod.Config.CoopHUD.inventory.special.display == 1 and 'Map' or (mod.Config.CoopHUD.inventory.special.display == 2 and 'No Map' or 'Never'))); end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.special.display = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.offset_w_pockets; end,
		Display = function() return 'Pocket Offset: ' .. (mod.Config.CoopHUD.inventory.special.offset_w_pockets and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.inventory.special.offset_w_pockets = b; end,
		Info = {'Enable to shift the inventory position down with pocket items.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopHUD.inventory.special.offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.special.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopHUD.inventory.special.offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.special.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.inventory.special.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.inventory.special.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.special.scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.space.X; end,
		Display = function() return 'Spacing (X): ' .. mod.Config.CoopHUD.inventory.special.space.X; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.special.space.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.space.Y; end,
		Display = function() return 'Spacing (Y): ' .. mod.Config.CoopHUD.inventory.special.space.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.special.space.Y = n; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.inventory);
ModConfigMenu.AddText(CoopHUD.MCM.title, CoopHUD.MCM.categories.inventory, 'Bag of Crafting');
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.result_display; end,
		Display = function() return 'Display: ' .. (mod.Config.CoopHUD.inventory.special.result_display and 'Always' or 'Result'); end,
		OnChange = function(b) mod.Config.CoopHUD.inventory.special.result_display = b; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.result_offset.X; end,
		Display = function() return 'Result Offset (X): ' .. mod.Config.CoopHUD.inventory.special.result_offset.X; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.special.result_offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.result_offset.Y; end,
		Display = function() return 'Result Offset (Y): ' .. mod.Config.CoopHUD.inventory.special.result_offset.Y; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.special.result_offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopHUD.inventory.special.result_scale.X * 100)); end,
		Display = function() return 'Result Scale: ' .. string.format('%.0f', mod.Config.CoopHUD.inventory.special.result_scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopHUD.inventory.special.result_scale = Vector(n/100, n/100); end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.inventory,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.inventory.special.ignore_curse; end,
		Display = function()
			return 'Ignore Curse of Blind: ' .. (mod.Config.CoopHUD.inventory.special.ignore_curse and 'on' or 'off');
		end,
		OnChange = function(b) mod.Config.CoopHUD.inventory.special.ignore_curse = b; end,
	}
);
