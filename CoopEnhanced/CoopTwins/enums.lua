local mod = CoopEnhanced;
local CoopTwins = CoopEnhanced.CoopTwins;

local Utils = mod.Utils;

CoopTwins.SetTwin = {
	[PlayerType.PLAYER_JACOB] = function(main_twin,controller_index)
		local twin_entity = main_twin:GetOtherTwin();
		local twin_pos = twin_entity.Position;
		local twin_type = twin_entity:GetPlayerType();
		
		PlayerManager.RemoveCoPlayer(twin_entity);
		
		local new_twin = PlayerManager.SpawnCoPlayer2(twin_type);
		new_twin.Position = twin_pos;
		new_twin:SetControllerIndex(controller_index);
		CoopTwins.DATA.Twins[Utils.GetPlayerID(main_twin)] = Utils.GetPlayerID(new_twin);
		mod.RefreshFrameCount();
	end,
	[PlayerType.PLAYER_THEFORGOTTEN] = function(main_twin,controller_index)
		local twin_entity = main_twin:GetOtherTwin();
		if not twin_entity then return; end
		CoopTwins.DATA.Twins[Utils.GetPlayerID(main_twin)] = Utils.GetPlayerID(twin_entity);
	end
};

CoopTwins.ItemFunctions = {
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = {
		[PlayerType.PLAYER_JACOB] = {CoopTwins.BirthrightJacobEsau},
		[PlayerType.PLAYER_ESAU] = {CoopTwins.BirthrightJacobEsau},
	},
};

