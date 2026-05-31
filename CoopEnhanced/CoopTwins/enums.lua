local mod = CoopEnhanced;
local CoopTwins = CoopEnhanced.CoopTwins;

local Utils = mod.Utils;

-- Init Functions
-- Functions ran when Twins are first initialized. Only runs once to setup Twins data and only one per PlayerType. [PlayerType / Function Array] (Main_twin (EntityPlayer), Second Player ControllerIndex (Number))
CoopTwins.InitFunctions = {
	[PlayerType.PLAYER_JACOB] = CoopTwins.InitJacobEsau,
	[PlayerType.PLAYER_THEFORGOTTEN] = CoopTwins.InitForgottenSoul,
	[PlayerType.PLAYER_THESOUL] = CoopTwins.InitForgottenSoul,
};

-- Start Functions
-- Functions ran when a game starts or is restarted. [PlayerType / Function Array] (Main_twin (EntityPlayer), Other_twin (EntityPlayer))
CoopTwins.StartFunctions = {
	[PlayerType.PLAYER_THEFORGOTTEN] = {CoopTwins.StartForgottenSoul},
};

-- Continuous Functions
-- Functions ran twice a second. Best to only use this for light functions. [PlayerType / Function Array] (Main_twin (EntityPlayer), Other_twin (EntityPlayer))
CoopTwins.TwinFunctions = {
	[PlayerType.PLAYER_THEFORGOTTEN] = {CoopTwins.UpdateForgottenSoul},
	[PlayerType.PLAYER_THESOUL] = {CoopTwins.UpdateForgottenSoul},
};

CoopTwins.RoomFunctions = {};

-- Button Functions
-- Functions for button inputs. Warning: This fires over 1400 times per second, only use if neccessary. [ButtonAction / PlayerType / Function Array] (Main_twin (EntityPlayer), InputHook (Number))
CoopTwins.ButtonFunctions = {
	[ButtonAction.ACTION_BOMB] = {
		[PlayerType.PLAYER_JACOB] = {CoopTwins.BombJacobEsau},
		[PlayerType.PLAYER_ESAU] = {CoopTwins.BombJacobEsau},
	},
};

-- Collectible Functions
-- Functions for adding/removing Collectibles. Adding functions to Add/Remove means it fires for every collectible, otherwise you can specify which CollectibleType to use. [CollectibleType / PlayerType / Function Array] (Main_twin (EntityPlayer), Adding_Collectible (Boolean)) or [Add / PlayerType / Function Array] (Main_twin (EntityPlayer), CollectibleType (Number))
CoopTwins.ItemFunctions = {
	Add = {
		[PlayerType.PLAYER_THEFORGOTTEN] = {CoopTwins.ItemAddForgottenSoul},
		[PlayerType.PLAYER_THESOUL] = {CoopTwins.ItemAddForgottenSoul},
	},
	Remove = {
		[PlayerType.PLAYER_THEFORGOTTEN] = {CoopTwins.ItemRemoveForgottenSoul},
		[PlayerType.PLAYER_THESOUL] = {CoopTwins.ItemRemoveForgottenSoul},
	},
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = {
		[PlayerType.PLAYER_JACOB] = {CoopTwins.BirthrightJacobEsau},
		[PlayerType.PLAYER_ESAU] = {CoopTwins.BirthrightJacobEsau},
	},
};

-- Pickup Functions
-- Functions for pickup collisions. Returning true/false does cancel the pickup collision like normal. Adding functions to Add/Remove means it fires for every pickup, otherwise you can specify which PickupVariant to use. [PickupVariant / PlayerType / Function Array] (Main_twin (EntityPlayer), pickup_entity (EntityPickup)) or [Add / PlayerType / Function Array] (Main_twin (EntityPlayer), pickup_entity (EntityPickup))
CoopTwins.PickupFunctions = {
	Add = {},
	Remove = {},
	[PickupVariant.PICKUP_HEART] = {
		[PlayerType.PLAYER_THEFORGOTTEN] = {CoopTwins.PickupForgottenSoul},
		[PlayerType.PLAYER_THESOUL] = {CoopTwins.PickupForgottenSoul},
	},
};

-- Health Functions
-- Functions for pre adding health. Functions depend on if CustomHealthAPI is installed. Vanilla: Returning a Number will set how much health is gained/lost. [PlayerType / Function Array] (Main_twin (EntityPlayer), HP_Amount (Number), HealthTypes (Bit)) or CustomHealthAPI: Returning a Number will set how much health is gained/lost. [PlayerType / Function Array] (Main_twin (EntityPlayer), HP_Amount (Number), HealthKey (String))
CoopTwins.HealthFunctions = {};

-- Stat Cahing Functions
-- Functions ran whenever a player has their Cache updated. Adding functions to All means it fires for every stat change, otherwise you can specify which CacheFlag to use. [CacheFlag / PlayerType / Function Array] (Main_twin (EntityPlayer)) or [All / PlayerType / Function Array] (Main_twin (EntityPlayer), cache_flag (CacheFlag))
CoopTwins.StatFunctions = {
	All = {},
	[CacheFlag.CACHE_SPEED] = {
		[PlayerType.PLAYER_JACOB] = {CoopTwins.SpeedJacobEsau},
		[PlayerType.PLAYER_ESAU] = {CoopTwins.SpeedJacobEsau},
	},
};

