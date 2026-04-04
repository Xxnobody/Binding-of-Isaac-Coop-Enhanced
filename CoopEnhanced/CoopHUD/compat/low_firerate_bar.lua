local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;

-- Thank you catinsured for an easy to use API
function CoopHUD.LowFirerateChargeBar()
	if not LowFirerateChargeBar then return; end
	
	local function renderBar(_,player_data)
		LowFirerateChargeBar:SetPlayerOffset(player_data.Player.Type, mod.Config.CoopHUD.mods.LOWFIRERATEBAR.offset);
	end
	mod.Registry.AddCallback(mod.Callbacks.HUD_POST_PLAYER_RENDER, renderBar);
end
