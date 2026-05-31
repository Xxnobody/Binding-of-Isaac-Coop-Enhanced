local mod = CoopEnhanced;
local CoopTwins = CoopEnhanced.CoopTwins;

local Utils = mod.Utils;
local game = Game();

if not REPENTOGON then return; end

local function ModCompat()
	if UniqueProgressBarIcon then
		mod:AddCallback(UniqueProgressBarIcon.Callbacks.POST_CREATE_ICON, function(_, iconData, player_entity)
			local coop_anim = "gfx/ui/coop_menu.anm2";
			if not CoopTwins.IsTwin(player_entity) then return; end
			if iconData.PlayerType == PlayerType.PLAYER_JACOB then
				iconData.Icon:Load(coop_anim, true);
				iconData.Icon:SetFrame("Twins", 0);
			elseif iconData.PlayerType == PlayerType.PLAYER_THEFORGOTTEN then
				iconData.Icon:Load(coop_anim, true);
				iconData.Icon:SetFrame("Twins", 4);
			elseif iconData.PlayerType == PlayerType.PLAYER_THESOUL then
				iconData.Icon:Load(coop_anim, true);
				iconData.Icon:SetFrame("Twins", 5);
			elseif iconData.PlayerType == PlayerType.PLAYER_JACOB_B then
				iconData.Icon:Load(coop_anim, true);
				iconData.Icon:SetFrame("Twins", 2);
			end
		end)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ModCompat);