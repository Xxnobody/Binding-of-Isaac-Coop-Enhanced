local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;

ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.toggle_hud.pause_display; end,
		Display = function() return 'Enable HUD on pause: ' .. (mod.Config.CoopHUD.toggle_hud.pause_display and 'on' or 'off'); end,
		OnChange = function(b) CoopHUD.isVisible = (b and Utils.IsPauseMenuOpen()) mod.Config.CoopHUD.toggle_hud.pause_display = b; end,
		Info = {'Sets whether the HUD renders when a pause menu is loaded. Useful for tweaking HUD values.'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return mod.Config.CoopHUD.toggle_hud.coop_only; end,
		Display = function() return 'Coop Only HUD: ' .. (mod.Config.CoopHUD.toggle_hud.coop_only and 'on' or 'off'); end,
		OnChange = function(b) mod.Config.CoopHUD.toggle_hud.coop_only = b; end,
		Info = {'HUD only appears during Coop games.'},
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.general)
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.offset.X; end,
		Display = function() return 'HUD X Offset: ' .. (mod.Config.CoopHUD.offset.X); end,
		OnChange = function(n) mod.Config.CoopHUD.offset.X = n; end,
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.offset.Y; end,
		Display = function() return 'HUD Y Offset: ' .. (mod.Config.CoopHUD.offset.Y); end,
		OnChange = function(n) mod.Config.CoopHUD.offset.Y = n; end,
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.general);
ModConfigMenu.AddKeyboardSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	"ToggleHUDKeyboard",
	mod.Config.CoopHUD.toggle_hud.key,
	"Toggle HUD Key: ",
	true,
	"Press this key to toggle between Co-Op Enhanced HUD and the Default HUD"
).IsOpenMenuKeybind = true;

ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		Minimum = 1,
		Maximum = #mod.Controls,
		CurrentSetting = function() return mod.Config.CoopHUD.toggle_hud.button; end,
		Display = function() return 'Toggle HUD Button: ' .. mod.Controls[mod.Config.CoopHUD.toggle_hud.button].Name; end,
		OnChange = function(b) mod.Config.CoopHUD.toggle_hud.button = b; end,
		Info = {'Press this button to toggle between Co-Op Enhanced HUD and the Default HUD'},
	}
);

local callbacks = {
	ModCallbacks.MC_HUD_RENDER,
	ModCallbacks.MC_POST_HUD_RENDER,
	ModCallbacks.MC_HUD_UPDATE,
	ModCallbacks.MC_POST_HUD_UPDATE,
	ModCallbacks.MC_POST_RENDER
};
ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.general)
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.renderer.callback; end,
		Minimum = 1,
		Maximum = #callbacks,
		Display = function() return 'Render Callback: ' .. (mod.Config.CoopHUD.renderer.callback == 1 and 'Hud Render' or (mod.Config.CoopHUD.renderer.callback == 2 and 'Post Hud Render' or (mod.Config.CoopHUD.renderer.callback == 3 and 'Hud Update' or (mod.Config.CoopHUD.renderer.callback == 4 and 'Post Hud Update' or 'Post Game Render')))); end,
		OnChange = function(c) mod.Config.CoopHUD.renderer.callback = c; end,
		Info = {'Set what callback will trigger the mod. Useful if you want the mod to trigger before/after another mod. REQUIRES RESTART'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.renderer.priority; end,
		Minimum = 1,
		Maximum = #mod.Priorities,
		Display = function() return 'Render Priority: ' .. (mod.Config.CoopHUD.renderer.priority == 1 and 'Very Early' or (mod.Config.CoopHUD.renderer.priority == 2 and 'Early' or (mod.Config.CoopHUD.renderer.priority == 3 and 'Default' or (mod.Config.CoopHUD.renderer.priority == 4 and 'Late' or 'Very Late')))); end,
		OnChange = function(p) mod.Config.CoopHUD.renderer.priority = p; end,
		Info = {'Set when the mod is called. Useful if you want the mod to trigger before/after another mod. REQUIRES RESTART'},
	}
);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function() return mod.Config.CoopHUD.renderer.refresh; end,
		Minimum = 1,
		Maximum = 6,
		Display = function() return 'Refresh Rate: ' .. (60 / mod.Config.CoopHUD.renderer.refresh) .. " FPS"; end,
		OnChange = function(n) mod.Config.CoopHUD.renderer.refresh = n; end,
		Info = {'Set HUD refresh rate. Lower = less lag but the HUD takes extra time to update.'},
	}
);

ModConfigMenu.AddSpace(CoopHUD.MCM.title, CoopHUD.MCM.categories.general);
ModConfigMenu.AddSetting(
	CoopHUD.MCM.title,
	CoopHUD.MCM.categories.general,
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function() return true; end,
		Display = function() return 'Reset settings'; end,
		OnChange = function(_) mod.CoopHUD.ResetConfig(); end,
	}
);