local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

CoopHUD.Item.Active.D_INFINITY = { -- taken from coopHUD+ (Konoca)
	D1 = 0,
	D4 = 65536,
	D6 = 131072,
	E6 = 196608,
	D7 = 262144,
	D8 = 327680,
	D10 = 393216,
	D12 = 458752,
	D20 = 524288,
	D100 = 589824,
};
CoopHUD.Item.ChargeBar.ExtraColor = Color(1, 1, 1, 1, 0, 0, 0);
CoopHUD.Item.ChargeBar.ExtraColor:SetColorize(1.8, 1.8, 0, 1); -- taken from coopHUD+ (Konoca)
CoopHUD.Item.ChargeBar.Charge = { -- taken from coopHUD+ (Konoca)
	[2] = {
		[0] = 26,
		[1] = 14,   -- 1/2
	},
	[3] = {
		[0] = 26,
		[1] = 19,   -- 1/3
		[2] = 10,   -- 2/3
	},
	[4] = {
		[0] = 26,
		[1] = 20,   -- 1/4
		[2] = 14,   -- 1/2
		[3] = 8,	-- 3/4
	},
	[5] = {
		[0] = 26,
		[1] = 20,
		[2] = 15,
		[3] = 11,
		[4] = 6,
	},
	[6] = {
		[0] = 26,
		[1] = 22,   -- 1/6
		[2] = 19,   -- 1/3
		[3] = 14,   -- 1/2
		[4] = 10,   -- 2/3
		[5] = 7,	-- 5/6
	},
	[8] = {
		[0] = 26,
		[1] = 23,
		[2] = 20,	-- 1/4
		[3] = 17,
		[4] = 14,	-- 1/2
		[5] = 11,
		[6] = 8,	 -- 3/4
		[7] = 5,
	},
	[12] = {
		[0] = 26,
		[1] = 24,   -- 1/12
		[2] = 22,   -- 1/6
		[3] = 20,   -- 1/4
		[4] = 18,   -- 1/3
		[5] = 16,
		[6] = 14,   -- 1/2
		[7] = 12,
		[8] = 10,   -- 2/3
		[9] = 8,	-- 3/4
		[10] = 6,
		[11] = 4,
	}
};

CoopHUD.Item.Pocket.CardBacks = {
	Tarot = 0,
	Suit = 1,
	Reverse = 2,
	Humanity = 3,
	Credit = 4,
	Holy = 5,
	Monopoly = 6,
	Magic = 7,
	UNO = 8,
};

CoopHUD.Item.Active.Special = { -- taken from coopHUD+ (Konoca)
	[CollectibleType.COLLECTIBLE_D_INFINITY] = function(_,item_data,sprite_data,_)
		local tmpFrame = 0;
		local varData = item_data.Item.Desc.VarData;
		local path = mod.Images.DInfinity;
		if varData then
			if varData == Active.D_INFINITY.D4 then tmpFrame = 2;
			elseif varData == Active.D_INFINITY.D6 then tmpFrame = 4;
			elseif varData == Active.D_INFINITY.E6 then tmpFrame = 6;
			elseif varData == Active.D_INFINITY.D7 then tmpFrame = 8;
			elseif varData == Active.D_INFINITY.D8 then tmpFrame = 10;
			elseif varData == Active.D_INFINITY.D10 then tmpFrame = 12;
			elseif varData == Active.D_INFINITY.D12 then tmpFrame = 14;
			elseif varData == Active.D_INFINITY.D20 then tmpFrame = 16;
			elseif varData == Active.D_INFINITY.D100 then tmpFrame = 18;
			end
		end
		sprite_data.Animation = 'DInfinity';
		sprite_data.Frame = (tmpFrame + sprite_data.Frame);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_THE_JAR] = function(_,_,sprite_data,player_entity)
		local path = mod.Images.TheJar;
		sprite_data.Animation = 'Jar';
		sprite_data.Frame = math.ceil(player_entity:GetJarHearts() / 2);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_JAR_OF_FLIES] = function(_,_,sprite_data,player_entity)
		local path = mod.Images.JarOfFlies;
		sprite_data.Animation = 'Jar';
		sprite_data.Frame = player_entity:GetJarFlies();
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_JAR_OF_WISPS] = function(_,item_data,sprite_data,_)
		local path = mod.Images.JarOfWisps;
		sprite_data.Animation = 'WispJar';
		sprite_data.Frame = ((item_data.Item.Desc.VarData - 1) + (15 * sprite_data.Frame));
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_EVERYTHING_JAR] = function(_,_,sprite_data,_)
		local path = mod.Images.EverythingJar;
		sprite_data.Animation = 'EverythingJar';
		sprite_data.Frame = (item_data.Bar.Charge.Current + 1);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_MAMA_MEGA] = function(_,_,sprite_data,player_entity)
		local path = mod.Images.MamaMega;
		sprite_data.Frame = (player_entity:HasGoldenBomb() and sprite_data.Frame + 1 or sprite_data.Frame);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_SMELTER] = function(_,_,sprite_data,_)
		sprite_data.Frame = (3 * sprite_data.Frame);
	end,
	[CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS] = function(_,item_data,sprite_data,_)
		local path = mod.Images.GlowingHourGlass;
		sprite_data.Animation = 'GlowingHourGlass';
		sprite_data.Frame = ((3 - data.Item.Desc.VarData) + 1);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_URN_OF_SOULS] = function(_,_,sprite_data,player_entity)
		--print(player_entity:GetTotalActiveCharge(0))
		--((21 * player_entity:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_URN_OF_SOULS)) + player_entity:GetUrnSouls() + 1)
		
		local path = mod.Images.UrnOfSouls;
		sprite_data.Animation = 'SoulUrn';
		sprite_data.Frame = (0); -- currently player_entity:GetUrnSouls() is broken and returns the number 1065353216 regardlesss of Urn amount
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_FLIP] = function(_,_,sprite_data,player_entity)
		local path = mod.Images.Flip;
		sprite_data.Animation = 'Flip';
		sprite_data.Frame = (player_entity:GetType() == PlayerType.PLAYER_LAZARUS2_B and 1 or 0);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
};
CoopHUD.Item.Inventory.GetInfo = { -- taken from coopHUD+ (Konoca)
	[PlayerType.PLAYER_ISAAC_B] = function (player_data)
		local max_slots, row_size = 8, 4;
		if player_data.Player.Entity.Ref:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
			max_slots = 12;
			row_size = 6;
		end
		return max_slots, row_size, player_data.Inventory.Passive.Images;
	end,
	[PlayerType.PLAYER_CAIN_B] = function (player_data)
		return 8, 4, player_data.Player.Entity.Ref:ToPlayer():GetBagOfCraftingContent();
	end,
	[PlayerType.PLAYER_BLUEBABY_B] = function (player_data)
		local inv = {};
		for i = 0, 6, 1 do
			table.insert(inv, player_data.Player.Entity.Ref:ToPlayer():GetPoopSpell(i));
		end
		return 6, 6, inv;
	end
};

CoopHUD.Item.Inventory.GetSprite = { -- taken from coopHUD+ (Konoca)
	[PlayerType.PLAYER_ISAAC_B] = function(sprite, item, i)
		sprite = sprite or Sprite();
		sprite:Load(mod.Animations.Inventory, false);
		sprite:SetFrame('Idle', i - 1);
		if item then sprite:ReplaceSpritesheet(2, item); end
		sprite:LoadGraphics();
		return sprite;
	end,
	[PlayerType.PLAYER_CAIN_B] = function(sprite, item, i)
		sprite = sprite or Sprite();
		sprite:Load(mod.Animations.Crafting, false);
		sprite:SetFrame('Idle', (item or 0));
		sprite:LoadGraphics();
		return sprite;
	end,
	[PlayerType.PLAYER_BLUEBABY_B] = function(sprite, item, i)
		sprite = sprite or Sprite();
		sprite:Load(mod.Animations.Poops, false);
		sprite:SetFrame(i == 1 and 'Idle' or 'IdleSmall', item);
		sprite:LoadGraphics();
		return sprite;
	end
};

CoopHUD.Item.Inventory.ExtraFunctions = { -- taken from coopHUD+ (Konoca)
	[PlayerType.PLAYER_CAIN_B] = function(player_data)
		local function GetResult()
			local id = player_data.Player.Entity.Ref:ToPlayer():GetBagOfCraftingOutput();
			if player_data.Inventory.Special.Total ~= 8 or id == 0 then return nil; end
			local item = Isaac:GetItemConfig():GetCollectible(id);
			if (Game():GetLevel():GetCurses() & 64) == 64 and not mod.Config.CoopHUD.inventory.special.ignore_curse then return (ReworkedCOB ~= nil and ("gfx/items/collectibles/questionmark_Q" .. item.Quality .. ".png") or mod.Images.QuestionMark); end
			return item.GfxFileName;
		end
		local result = GetResult();
		local sprite = player_data.Inventory.Special.Sprite;
		if result or mod.Config.CoopHUD.inventory.special.result_display then 
			local result_pos = player_data.Inventory.Special.Data[#player_data.Inventory.Special.Data].Pos + ((Vector((16 * mod.Config.CoopHUD.inventory.special.scale.X) + (8 * mod.Config.CoopHUD.inventory.special.result_scale.X), (mod.Config.CoopHUD.inventory.special.space.Y / -2) + (3 * mod.Config.CoopHUD.inventory.special.result_scale.Y)) + mod.Config.CoopHUD.inventory.special.result_offset) * player_data.Edge.Multipliers);
			
			sprite.Color = Color(1, 1, 1, mod.Config.CoopHUD.inventory.special.result_opacity);
			sprite.Scale = mod.Config.CoopHUD.inventory.special.result_scale;
			
			sprite.FlipX = player_data.Edge.Multipliers.X < 0;
			sprite:SetFrame('Result', 0);
			
			sprite:LoadGraphics();
			sprite:Render(result_pos);
			
			if result then
				local result_sprite = player_data.Inventory.Special.ResultSprite or Sprite(mod.Animations.Item, false);
				result_sprite.Scale = sprite.Scale;
				result_sprite.Color = sprite.Color;
				result_sprite:ReplaceSpritesheet(0, result);
				result_sprite:ReplaceSpritesheet(1, result);
				result_sprite:ReplaceSpritesheet(2, result);
				result_sprite:SetFrame('Idle', 0);
				result_sprite:LoadGraphics();
				result_sprite:Render((result_pos + Vector(0,22 * result_sprite.Scale.Y)));
				player_data.Inventory.Special.ResultSprite = result_sprite;
			end
		end
		sprite.Color = Color(1, 1, 1, mod.Config.CoopHUD.inventory.special.opacity);
		sprite.Scale = mod.Config.CoopHUD.inventory.special.scale;
		sprite.FlipX = false;
		sprite:LoadGraphics();
	end
};
CoopHUD.Item.Inventory.IgnoredCollectibles = {
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = true,
	[CollectibleType.COLLECTIBLE_POLAROID] = true,
	[CollectibleType.COLLECTIBLE_NEGATIVE] = true,
	[CollectibleType.COLLECTIBLE_KEY_PIECE_1] = true,
	[CollectibleType.COLLECTIBLE_KEY_PIECE_2] = true,
	[CollectibleType.COLLECTIBLE_KNIFE_PIECE_1] = true,
	[CollectibleType.COLLECTIBLE_KNIFE_PIECE_2] = true,
	[CollectibleType.COLLECTIBLE_DADS_NOTE] = true,
	[CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE] = true,
	[CollectibleType.COLLECTIBLE_DOGMA] = true,
};
CoopHUD.Stats.Stat = {
	SPEED = 0,
	FIRE_DELAY = 1,
	DAMAGE = 2,
	RANGE = 3,
	SHOT_SPEED = 4,
	LUCK = 5,
	DEVIL = 6,
	ANGEL = 7,
	PLANETARIUM = 8,
	GREED = 9,
	DUALITY = 10,
	LIBRARY = 11,
	NUMBER = 12,
};
CoopHUD.Misc = {
	COIN = 0,
	KEY = 1,
	BOMB = 2,
	GOLDEN_KEY = 3,
	HARD = 4,
	NO_ACHIEVEMENTS = 5,
	GOLDEN_BOMB = 6,
	GREED = 7,
	DAILY = 8,
	GREED_MACHINE = 9,
	VICTORY_LAP = 10,
	GREEDIER = 11,
	SOUL_HEART = 12,
	BLACK_HEART = 13,
	GIGA_BOMB = 14,
	RED_HEART = 15,
	POOP = 16,
};
CoopHUD.Destinations = {
	MOM = 0,
	HEART = 1,
	SATAN = 2,
	ISAAC = 3,
	LAMB = 4,
	MEGA = 5,
	CHEST = 6,
	HUSH = 7,
	VOID = 8,
	CORPSE = 9,
	BEAST = 10,
	MISC = 11,
};
CoopHUD.Banner = {
	FLOOR = 0,
	ITEM = 1,
	FORTUNE = 2,
};
CoopHUD.SkinColors = {
	[SkinColor.SKIN_PINK] = Color(1.0,1.0,1.0,0),
	[SkinColor.SKIN_WHITE] = Color(1.0,1.0,1.0,1),
	[SkinColor.SKIN_BLACK] = Color(0.2,0.2,0.2,1),
	[SkinColor.SKIN_BLUE] = Color(0.0,0.0,1.0,1),
	[SkinColor.SKIN_RED] = Color(1.0,0.0,0.0,1),
	[SkinColor.SKIN_GREEN] = Color(0.0,1.0,0.0,1),
	[SkinColor.SKIN_GREY] = Color(0.35,0.35,0.35,1),
	[SkinColor.SKIN_SHADOW] = Color(0.05,0.05,0.05,1)
};
CoopHUD.Callbacks = {
	POST_PLAYER_RENDER = 1,
	PRE_HEALTH_RENDER = 2,
	PRE_MISC_RENDER = 3,
	PRE_STATS_RENDER = 4,
	POST_HUD_RENDER = 5,
};
CoopHUD.Positions = {
	Active = {[0] = Vector(20,15),[1] = Vector(5,5)},
	Coop = Vector(45,15),
	Difficulty = Vector(10,70),
	Health = Vector(45,10),
	Inventory = Vector(8,55),
	Misc = Vector(4,65),
	Pickups = Vector(1,50),
	Pocket = {[0] = Vector(8,55),[1] = Vector(8,65),[2] = Vector(8,75),[3] = Vector(8,85),},
	Stats = Vector(0,100),
	Trinket = {[0] = Vector(12,65),[1] = Vector(25,68)},
};