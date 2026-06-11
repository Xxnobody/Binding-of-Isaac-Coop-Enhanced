local mod = CoopEnhanced;
local CoopLabels = CoopEnhanced.CoopLabels;

local Utils = mod.Utils;
local game = Game();

if not REPENTOGON then return; end

local function ModCompat()
	if EdithMod then
		CoopLabels.TargetTypes[EdithMod.Enums.EffectVariant.EDITH_TARGET] = true;
	elseif EdithRebuilt then
		CoopLabels.TargetTypes[EdithRebuilt.Enums.EffectVariant.EFFECT_EDITH_TARGET] = true;
	elseif EdithRestored then
		CoopLabels.TargetTypes[EdithRestored.Enums.Entities.EDITH_TARGET.Variant] = true;
	end
	if Epiphany then
		CoopLabels.IgnoredCharacters[Isaac.GetPlayerTypeByName("[TECHNICAL] C-Side Detect")] = true;
	end
	if VTRemaster then
		CoopLabels.IgnoredCharacters[Isaac.GetPlayerTypeByName("Selector")] = true;
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ModCompat);