local mod = CoopEnhanced;
local CoopTwins = CoopEnhanced.CoopTwins;

CoopTwins.ItemFunctions = {
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = {
		[PlayerType.PLAYER_JACOB] = {CoopTwins.BirthrightJacobEsau},
		[PlayerType.PLAYER_ESAU] = {CoopTwins.BirthrightJacobEsau},
	},
};
