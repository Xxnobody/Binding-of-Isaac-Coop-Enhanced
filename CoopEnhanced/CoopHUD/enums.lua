local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

CoopHUD.MiscType = {
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
CoopHUD.Destination = {
	MOM = 0,
	HEART = 1,
	SATAN = 2,
	ISAAC = 3,
	LAMB = 4,
	BLUE = 5,
	MEGA = 6,
	HUSH = 8,
	VOID = 9,
	CORPSE = 11,
	BEAST = 12
};
CoopHUD.BannerType = {
	FLOOR = 0,
	ITEM = 1,
	FORTUNE = 2,
};
CoopHUD.WaveType = {
	GREED = 0,
	GREEDIER = 1,
	BOSSRUSH = 2,
	GIDEON = 3,
};
CoopHUD.CardType = {
	SUIT = 0,
	TAROT = 1,
	REVERSE = 2,
	HUMANITY = 3,
	CREDIT = 4,
	HOLY = 5,
	MONOPOLY = 6,
	MAGIC = 7,
	UNO = 8,
};
CoopHUD.PillType = {
	VANILLA = 0,
	VANILLA_HORSE = 1,
	MODDED = 2,
	MODDED_HORSE = 3
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
CoopHUD.Positions = {
	Active = {[0] = Vector(20,15),[1] = Vector(5,5)},
	Coop = Vector(45,15),
	Difficulty = Vector(10,70),
	Health = Vector(45,10),
	Inventory = Vector(45,80),
	Misc = Vector(4,65),
	Pickups = Vector(1,50),
	Pocket = {[0] = Vector(8,55),[1] = Vector(8,65),[2] = Vector(8,75),[3] = Vector(8,85),},
	Special = Vector(25,70),
	Stats = Vector(0,90),
	Trinket = {[0] = Vector(12,65),[1] = Vector(25,68)},
};
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
CoopHUD.Item.CardBacks = { -- Add a card id and CoopHUD.CardType for custom back rendering
	[Card.CARD_CREDIT] = CoopHUD.CardType.CREDIT,
	[Card.CARD_HUMANITY] = CoopHUD.CardType.HUMANITY,
	[Card.CARD_GET_OUT_OF_JAIL] = CoopHUD.CardType.MONOPOLY,
	[Card.CARD_HOLY] = CoopHUD.CardType.HOLY,
	[Card.CARD_WILD] = CoopHUD.CardType.UNO,
	[Card.CARD_CHAOS] = CoopHUD.CardType.MAGIC,
	[Card.CARD_HUGE_GROWTH] = CoopHUD.CardType.MAGIC,
	[Card.CARD_ANCIENT_RECALL] = CoopHUD.CardType.MAGIC,
	[Card.CARD_ERA_WALK] = CoopHUD.CardType.MAGIC,
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

CoopHUD.Item.Active.Functions = { -- taken from coopHUD+ (Konoca)
	[CollectibleType.COLLECTIBLE_D_INFINITY] = function(_,item_data,sprite_data,_)
		local tmpFrame = 0;
		local varData = item_data.Item.Desc.VarData;
		local path = mod.Images.DInfinity;
		if varData then -- Requires checking a range since every use results in a different varData depending on die chosen
			if varData >= CoopHUD.Item.Active.D_INFINITY.D100 then tmpFrame = 18;
			elseif varData >= CoopHUD.Item.Active.D_INFINITY.D20 then tmpFrame = 16;
			elseif varData >= CoopHUD.Item.Active.D_INFINITY.D12 then tmpFrame = 14;
			elseif varData >= CoopHUD.Item.Active.D_INFINITY.D10 then tmpFrame = 12;
			elseif varData >= CoopHUD.Item.Active.D_INFINITY.D8 then tmpFrame = 10;
			elseif varData >= CoopHUD.Item.Active.D_INFINITY.D7 then tmpFrame = 8;
			elseif varData >= CoopHUD.Item.Active.D_INFINITY.E6 then tmpFrame = 6;
			elseif varData >= CoopHUD.Item.Active.D_INFINITY.D6 then tmpFrame = 4;
			elseif varData >= CoopHUD.Item.Active.D_INFINITY.D4 then tmpFrame = 2;
			end
		end
		sprite_data.Animation = "DInfinity";
		sprite_data.Frame = (tmpFrame + sprite_data.Frame);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_THE_JAR] = function(_,_,sprite_data,player_entity)
		local path = mod.Images.TheJar;
		sprite_data.Animation = "Jar";
		sprite_data.Frame = math.ceil(player_entity:GetJarHearts() / 2);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_JAR_OF_FLIES] = function(_,_,sprite_data,player_entity)
		local path = mod.Images.JarOfFlies;
		sprite_data.Animation = "Jar";
		sprite_data.Frame = player_entity:GetJarFlies();
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_JAR_OF_WISPS] = function(_,item_data,sprite_data,_)
		local path = mod.Images.JarOfWisps;
		sprite_data.Animation = "WispJar";
		sprite_data.Frame = ((item_data.Item.Desc.VarData - 1) + (15 * sprite_data.Frame));
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_EVERYTHING_JAR] = function(_,item_data,sprite_data,_)
		local path = mod.Images.EverythingJar;
		sprite_data.Animation = "EverythingJar";
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
		sprite_data.Animation = "GlowingHourGlass";
		sprite_data.Frame = math.max(0,(3 - item_data.Item.Desc.VarData));
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_URN_OF_SOULS] = function(_,_,sprite_data,player_entity) -- currently player_entity:GetUrnSouls() is broken and returns the number 1065353216
		local path = mod.Images.UrnOfSouls;
		local jar_state = player_entity:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_URN_OF_SOULS); -- Returns 1 for closed, 2 for opened
		sprite_data.Animation = "SoulUrn";
		--print(player_entity:GetUrnSouls())
		--sprite_data.Frame = ((21 * jar_state) + (player_entity:GetUrnSouls() + 1))
		sprite_data.Frame = (0);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_FLIP] = function(_,_,sprite_data,player_entity)
		local path = mod.Images.Flip;
		sprite_data.Animation = "Flip";
		sprite_data.Frame = (player_entity:GetType() == PlayerType.PLAYER_LAZARUS2_B and 1 or 0);
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end,
	[CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING] = function(_,item_data,_,player_entity)
		local player_data = CoopHUD.GetPlayerDataFromEntity(player_entity);
		if not player_data then return; end
		local max_slots, row_size, inventory = 8,4,player_entity:GetBagOfCraftingContent();
		local special_data = {Total = 0,Data = {}, Sprite = Sprite(mod.Animations.Crafting, false)};
		special_data.Sprite = CoopHUD.Item.Inventory.GetSprite(special_data.Sprite, special_data, player_data, max_slots, row_size, inventory);
		
		special_data.Function = function(sprite, data, i)
			if not sprite then return; end
			sprite:SetFrame("Idle", (data.Item or 0));
			sprite:LoadGraphics();
			return sprite;
		end;
		
		item_data.Function = function(player_data)
			if not player_data or not player_data.Inventory.Special.Visible then return; end
			local function GetResult()
				local id = player_entity:GetBagOfCraftingOutput();
				if special_data.Total ~= max_slots or id == CollectibleType.COLLECTIBLE_NULL then return nil; end
				local item = Isaac:GetItemConfig():GetCollectible(id);
				if (Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND) == LevelCurse.CURSE_OF_BLIND and not mod.Config.CoopHUD.inventory.special.ignore_curse then return (ReworkedCOB ~= nil and ("gfx/items/collectibles/questionmark_Q" .. item.Quality .. ".png") or mod.Images.QuestionMark); end
				return item.GfxFileName;
			end;
			
			local result = GetResult();
			if not special_data.Sprite or not special_data.Data[1] then return; end
			if result or mod.Config.CoopHUD.inventory.special.result_display then 
				local result_pos = special_data.Data[#special_data.Data].Pos + (((Vector(((mod.Config.CoopHUD.inventory.special.space.X * 3) * mod.Config.CoopHUD.inventory.special.scale.X), (((mod.Config.CoopHUD.inventory.special.space.Y - 3) / -1.5) * mod.Config.CoopHUD.inventory.special.scale.Y)) + mod.Config.CoopHUD.inventory.special.result_offset) * mod.Config.CoopHUD.inventory.special.result_scale) * player_data.Edge.Multipliers);
				
				special_data.Sprite.Color = Color(1, 1, 1, mod.Config.CoopHUD.inventory.special.result_opacity);
				special_data.Sprite.Scale = mod.Config.CoopHUD.inventory.special.result_scale;
				
				special_data.Sprite.FlipX = player_data.Edge.Multipliers.X < 0;
				special_data.Sprite:SetFrame("Result", 0);
				
				special_data.Sprite:LoadGraphics();
				special_data.Sprite:Render(result_pos);
				
				if result then
					local result_sprite = special_data.ResultSprite or Sprite(mod.Animations.Item, false);
					result_sprite.Scale = special_data.Sprite.Scale;
					result_sprite.Color = special_data.Sprite.Color;
					result_sprite:ReplaceSpritesheet(0, result);
					result_sprite:ReplaceSpritesheet(1, result);
					result_sprite:ReplaceSpritesheet(2, result);
					result_sprite:SetFrame("Idle", 0);
					result_sprite:LoadGraphics();
					result_sprite:Render((result_pos + Vector(0,22 * result_sprite.Scale.Y)));
					special_data.ResultSprite = result_sprite;
				end
			end
			special_data.Sprite.Color = Color(1, 1, 1, mod.Config.CoopHUD.inventory.special.opacity);
			special_data.Sprite.Scale = mod.Config.CoopHUD.inventory.special.scale;
			special_data.Sprite.FlipX = false;
			special_data.Sprite:LoadGraphics();
		end
		table.insert(player_data.Inventory.Special.Data,special_data);
	end,
};

CoopHUD.Item.Inventory.Functions = { -- taken from coopHUD+ (Konoca)
	[PlayerType.PLAYER_ISAAC_B] = function (player_data)
		local max_slots, row_size = 8, 4;
		local player_entity = player_data.Player.Entity.Ref:ToPlayer();
		if player_entity:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
			max_slots = 12;
			row_size = 6;
		end
		local inventory = {};
		for i,data in ipairs(player_data.Inventory.Passive.Data) do inventory[i] = data.Item; end
		if #inventory == max_slots and not player_entity:IsItemQueueEmpty() and (player_entity.QueuedItem.Item.Type == ItemType.ITEM_PASSIVE or player_entity.QueuedItem.Item.Type == ItemType.ITEM_FAMILIAR) then inventory[1] = {ID = CollectibleType.COLLECTIBLE_NULL, GfxFileName = ""}; end
		return max_slots, row_size, inventory, mod.Animations.Inventory;
	end,
	[PlayerType.PLAYER_BLUEBABY_B] = function (player_data)
		local inv = {};
		for i = 0, 6, 1 do
			table.insert(inv, player_data.Player.Entity.Ref:ToPlayer():GetPoopSpell(i));
		end
		return 6, 6, inv, mod.Animations.Poops;
	end
};

CoopHUD.Item.Inventory.SpriteFunctions = { -- taken from coopHUD+ (Konoca)
	[PlayerType.PLAYER_ISAAC_B] = function(sprite, data, i)
		if not sprite then return; end
		if data and data.Item then sprite:ReplaceSpritesheet(2, data.Item.GfxFileName); else sprite:Load(mod.Animations.Inventory,false); end
		sprite:SetFrame("Idle", i - 1);
		sprite:LoadGraphics();
		return sprite;
	end,
	[PlayerType.PLAYER_BLUEBABY_B] = function(sprite, data, i)
		if not sprite then return; end
		sprite:SetFrame(i == 1 and "Idle" or "IdleSmall", data.Item);
		sprite:LoadGraphics();
		return sprite;
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
CoopHUD.Item.Inventory.ShiftQueue = {[1] = 0,[2] = 0,[3] = 0,[4] = 0,};