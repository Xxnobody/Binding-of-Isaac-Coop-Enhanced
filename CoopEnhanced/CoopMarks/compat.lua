local mod = CoopEnhanced;
local CoopMarks = CoopEnhanced.CoopMarks;

local Utils = mod.Utils;
local game = Game();

if not REPENTOGON then return; end

local function ModCompat()
	if Epiphany then
		CoopMarks.IgnoredCharacters[Isaac.GetPlayerTypeByName("[TECHNICAL] C-Side Detect")] = true;
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ModCompat);