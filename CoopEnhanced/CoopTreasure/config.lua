local mod = CoopEnhanced;
local CoopTreasure = CoopEnhanced.CoopTreasure;

local Utils = mod.Utils;

mod.CoopTreasure.DefaultConfig = {
	CMD = "treasure",
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
	player_sync = "Global",
	dead = false,
	clean = false,
	single = false,
	extras = 0,
	safe = 1,
	radius = 0,
	max = 1,
	modes = {
		normal = 3,
		greed = 3,
	},
	assign = {
		global = 0,
		type = 0,
		display = 3,
		offset = Vector(0,0),
		scale = Vector(1,1),
		head = {
			scale = Vector(0.5,0.5),
			offset = Vector(0,0),
			opacity = 1,
		},
		text = {
			scale = Vector(1,1),
			offset = Vector(0,0),
			opacity = 1,
		},
		rooms = {
			Treasure = 1,
			Silver = 0,
			Library = 0,
			Planetarium = 0,
			Angel = 0,
			Devil = 0,
			Secret = 0,
			SuperSecret = 0,
			UltraSecret = 0
		},
	},
	fonts = {treasure = 'luaminioutlined',}
};

function CoopEnhanced.CoopTreasure.ResetConfig()
	mod.Config.CoopTreasure = Utils.cloneTable(mod.CoopTreasure.DefaultConfig);
end
if mod.Config.CoopTreasure == nil then mod.CoopTreasure.ResetConfig(); end

if ModConfigMenu == nil then return; end

CoopTreasure.MCM = {};
CoopTreasure.MCM.title = "Co-op Treasure";
CoopTreasure.MCM.categories = {
	general = 'General',
	rooms = 'Rooms',
};
CoopTreasure.MCM.Info = "Co-op Treasure Room Settings";


ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.global; end,
		Display = function() return 'Global Assignment: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.global]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.global = n; end,
		Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopTreasure.dead; end,
		Display = function() return 'Spawn for the Dead: ' .. (mod.Config.CoopTreasure.dead and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopTreasure.dead = b; end,
		Info = {'Enable to spawn item pedestals for dead players.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopTreasure.extras; end,
		Display = function() return 'Spawn Extras: ' .. mod.Config.CoopTreasure.extras; end,
		OnChange = function(n) mod.Config.CoopTreasure.extras = n; end,
		Info = {'Spawn extra item pedestals, up to a maximum of 4.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.max; end,
		Display = function() return 'Max Per Player: ' .. mod.Config.CoopTreasure.max; end,
		OnChange = function(n) mod.Config.CoopTreasure.max = n; end,
		Info = {'Set the maximum amount of pedestals a player can grab per treasure room.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopTreasure.single; end,
		Display = function() return 'Singleplayer Extras: ' .. (mod.Config.CoopTreasure.single and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopTreasure.single = b; end,
		Info = {'Enable to spawn extra pedestals in non-Coop games. (You Cheater!)'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopTreasure.clean; end,
		Display = function() return 'Cleanup Extras: ' .. (mod.Config.CoopTreasure.clean and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopTreasure.clean = b; end,
		Info = {'Enable to remove extra item pedestals that cant be picked up once everyone has reached their maximum.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 5,
		CurrentSetting = function() return mod.Config.CoopTreasure.radius; end,
		Display = function() return 'Clearance Radius: ' .. mod.Config.CoopTreasure.radius; end,
		OnChange = function(n) mod.Config.CoopTreasure.radius = n; end,
		Info = {'Set how far rocks and other obstacles are cleared from new pedestal positions.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopTreasure.safe; end,
		Display = function() return 'Safe Placement: ' ..(mod.Config.CoopTreasure.safe == 0 and "off" or (mod.Config.CoopTreasure.safe == 1 and "Diagonally" or (mod.Config.CoopTreasure.safe == 2 and "Horizontally" or "Vertically"))); end,
		OnChange = function(n) mod.Config.CoopTreasure.safe = n; end,
		Info = {'Add extra logic to prevent pedestals from spawning in inaccessible areas (pits, blocks, etc). Checks in this directions towards the center.'},
	}
);

local sync_modules = {"Global"};
mod.Registry:AddCallback(mod.Callbacks.POST_REGISTRY_EXECUTE, function()
	for name,_ in pairs(mod.Registry.Modules) do
		if mod.Config[name] and mod.Config[name].players ~= nil then table.insert(sync_modules,name); end
	end
end);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		CurrentSetting = function() for i,sync in pairs(sync_modules) do if mod.Config.CoopTreasure.player_sync == sync then return i; end	end	return 1; end,
		Display = function() return 'Player Sync: ' .. mod.Config.CoopTreasure.player_sync; end,
		OnChange = function(n) n = n > #sync_modules and 1 or n; mod.Config.CoopTreasure.player_sync = sync_modules[n]; end,
		Info = {'Choose which config this uses for Player Color/Names.'},
	}
);

ModConfigMenu.AddSpace(CoopTreasure.MCM.title,CoopTreasure.MCM.categories.general);
ModConfigMenu.AddTitle(CoopTreasure.MCM.title,CoopTreasure.MCM.categories.general, 'Pedestal Labels');
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.display; end,
		Display = function() return 'Display: ' .. (mod.Config.CoopTreasure.assign.display == 0 and "None" or (mod.Config.CoopTreasure.assign.display == 1 and "Head" or (mod.Config.CoopTreasure.assign.display == 2 and "Name" or "Head & Name"))); end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.display = n; end,
		Info = {'Enable to show visible labels of pedestal ownership.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.offset.X; end,
		Display = function() return 'Offset (X): ' .. mod.Config.CoopTreasure.assign.offset.X; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.offset.Y; end,
		Display = function() return 'Offset (Y): ' .. mod.Config.CoopTreasure.assign.offset.Y; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopTreasure.assign.scale.X * 100)); end,
		Display = function() return 'Scale: ' .. string.format('%.0f', mod.Config.CoopTreasure.assign.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddTitle(CoopTreasure.MCM.title,CoopTreasure.MCM.categories.general, 'Player Head');
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.head.offset.X; end,
		Display = function() return 'Head Offset (X): ' .. mod.Config.CoopTreasure.assign.head.offset.X; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.head.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.head.offset.Y; end,
		Display = function() return 'Head Offset (Y): ' .. mod.Config.CoopTreasure.assign.head.offset.Y; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.head.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopTreasure.assign.head.opacity * 100)); end,
		Display = function() return 'Head Opacity: ' .. string.format('%.0f', mod.Config.CoopTreasure.assign.head.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.head.opacity = n/100; end,
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopTreasure.assign.head.scale.X * 100)); end,
		Display = function() return 'Head Scale: ' .. string.format('%.0f', mod.Config.CoopTreasure.assign.head.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.head.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddTitle(CoopTreasure.MCM.title,CoopTreasure.MCM.categories.general, 'Player Name');
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.text.offset.X; end,
		Display = function() return 'Name Offset (X): ' .. mod.Config.CoopTreasure.assign.text.offset.X; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.text.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.text.offset.Y; end,
		Display = function() return 'Name Offset (Y): ' .. mod.Config.CoopTreasure.assign.text.offset.Y; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.text.offset.Y = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopTreasure.assign.text.opacity * 100)); end,
		Display = function() return 'Name Opacity: ' .. string.format('%.0f', mod.Config.CoopTreasure.assign.text.opacity * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.text.opacity = n/100; end,
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0.0,
		CurrentSetting = function() return tonumber(string.format('%.0f', mod.Config.CoopTreasure.assign.text.scale.X * 100)); end,
		Display = function() return 'Name Scale: ' .. string.format('%.0f', mod.Config.CoopTreasure.assign.text.scale.X * 100) .. '%'; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.text.scale = Vector(n/100, n/100); end,
	}
);

ModConfigMenu.AddSpace(CoopTreasure.MCM.title,CoopTreasure.MCM.categories.general);
ModConfigMenu.AddTitle(CoopTreasure.MCM.title,CoopTreasure.MCM.categories.general, 'Game Modes');
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopTreasure.modes.normal; end,
		Display = function() return 'Difficulty Mode: ' .. (mod.Config.CoopTreasure.modes.normal == 0 and "None" or (mod.Config.CoopTreasure.modes.normal == 1 and "Normal" or (mod.Config.CoopTreasure.modes.normal == 2 and "Hard" or "Normal & Hard"))); end,
		OnChange = function(n) mod.Config.CoopTreasure.modes.normal = n; end,
		Info = {'Set whether Co-op Treasure spawns depending on the difficulty.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 3,
		CurrentSetting = function() return mod.Config.CoopTreasure.modes.greed; end,
		Display = function() return 'Greed Mode: ' .. (mod.Config.CoopTreasure.modes.greed == 0 and "None" or (mod.Config.CoopTreasure.modes.greed == 1 and "Greed" or (mod.Config.CoopTreasure.modes.greed == 2 and "Greedier" or "Greed & Greedier"))); end,
		OnChange = function(n) mod.Config.CoopTreasure.modes.greed = n; end,
		Info = {'Set whether Co-op Treasure spawns depending on the greed mode.'},
	}
);

ModConfigMenu.AddSpace(CoopTreasure.MCM.title,CoopTreasure.MCM.categories.general);
local fonts = {};
for key, _ in pairs(mod.Fnts) do
	table.insert(fonts, key);
end

ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #fonts,
		CurrentSetting = function() return Utils.getTableIndex(fonts, mod.Config.CoopTreasure.fonts.treasure); end,
		Display = function() return 'Labels Font: ' .. mod.Config.CoopTreasure.fonts.treasure; end,
		OnChange = function(n) mod.Config.CoopTreasure.fonts.treasure = fonts[n] Utils.LoadFonts(); end,
		Info = {'Warning! Game might lag after changing fonts, please restart your game after changing this setting.'}
	}
);

ModConfigMenu.AddSpace(CoopTreasure.MCM.title,CoopTreasure.MCM.categories.general);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return true; end,
		Display = function() return 'Reset Settings'; end,
		OnChange = function(_) CoopTreasure.ResetConfig(); end,
	}
);

ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.rooms,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms.Treasure; end,
		Display = function() return 'Treasure Rooms: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms.Treasure]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.rooms.Treasure = n; end,
		Info = {'DISABLED: Vanilla - FREE: Take Any/All - AUTO - Assigned Items - SELF: Player Choice - GLOBAL: Use Global setting'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.rooms,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms.Silver; end,
		Display = function() return 'Silver Rooms: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms.Silver]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.rooms.Silver = n; end,
		Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice. - GLOBAL: Use Global setting.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.rooms,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms.Library; end,
		Display = function() return 'Libraries: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms.Library]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.rooms.Library = n; end,
		Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice. - GLOBAL: Use Global setting.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.rooms,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms.Planetarium; end,
		Display = function() return 'Planetariums: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms.Planetarium]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.rooms.Planetarium = n; end,
		Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice. - GLOBAL: Use Global setting.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.rooms,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms.Angel; end,
		Display = function() return 'Angel Deals: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms.Angel]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.rooms.Angel = n; end,
		Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice. - GLOBAL: Use Global setting.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.rooms,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms.Devil; end,
		Display = function() return 'Devil Deals: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms.Devil]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.rooms.Devil = n; end,
		Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice. - GLOBAL: Use Global setting.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.rooms,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms.Secret; end,
		Display = function() return 'Secret: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms.Secret]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.rooms.Secret = n; end,
		Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice. - GLOBAL: Use Global setting.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.rooms,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms.SuperSecret; end,
		Display = function() return 'Super-Secret: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms.SuperSecret]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.rooms.SuperSecret = n; end,
		Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice. - GLOBAL: Use Global setting.'},
	}
);
ModConfigMenu.AddSetting(
	CoopTreasure.MCM.title,
	CoopTreasure.MCM.categories.rooms,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 0,
		Maximum = 4,
		CurrentSetting = function() return mod.Config.CoopTreasure.assign.rooms.UltraSecret; end,
		Display = function() return 'Ultra-Secret: ' .. CoopTreasure.AssignmentTypes[mod.Config.CoopTreasure.assign.rooms.UltraSecret]; end,
		OnChange = function(n) mod.Config.CoopTreasure.assign.rooms.UltraSecret = n; end,
		Info = {'DISABLED: Vanilla. - FREE: Take Any/All. - AUTO - Assigned Items. - SELF: Player Choice. - GLOBAL: Use Global setting.'},
	}
);