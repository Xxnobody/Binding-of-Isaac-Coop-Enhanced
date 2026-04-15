local mod = CoopEnhanced;

local Utils = mod.Utils;
local game = Game();

-- Basic Utilities
function Utils.VectorFrom(num) 
	return Vector(num,num);
end

function Utils.GetScreenDimensions() -- Taken from reHUD, credit to Wofsauge and _Kilburn
	local room = game:GetRoom();
	local pos = room:WorldToScreenPosition(Vector(0,0)) - room:GetRenderScrollOffset() - game.ScreenShakeOffset;

	local rx = pos.X + 60 * 26 / 40;
	local ry = pos.Y + 140 * (26 / 40);

	local screen_dimensions = {Max = Vector(rx*2 + 13*26, ry*2 + 7*26), Min = Vector.Zero};
	screen_dimensions.Center = screen_dimensions.Max / 2;
	
	return screen_dimensions;
end

function Utils.encodeData(data)-- Taken from CoopHUD+, credit to Kona
	local new_data = {};
	for key, value in pairs(data) do
		if type(value) == 'table' then
			value = Utils.encodeData(value);
		end
		if type(value) == 'userdata' then
			new_data[key..'X'] = value.X;
			new_data[key..'Y'] = value.Y;
			goto skip_encode;
		end
		new_data[key] = value;
		::skip_encode::
	end
	return new_data;
end
function Utils.decodeData(data) -- Taken from CoopHUD+, credit to Kona
	local new_data = {}
	for key, value in pairs(data) do
		local num = tonumber(key);
		if type(key) == 'string' and num ~= nil then
			key = num;
		end
		if type(value) == 'table' then
			value = Utils.decodeData(value);
		end
		if type(key) == 'string' and key:sub(-1) == 'Y' then
			goto skip_decode;
		end
		if type(key) == 'string' and key:sub(-1) == 'X' then
			key = key:sub(1, -2);
			if type(data[key..'Y']) ~= "number" then goto skip_decode; end
			value = Vector(value, data[key..'Y']);
		end
		new_data[key] = value;
		::skip_decode::
	end
	return new_data;
end
function Utils.ensureCompatibility(data1, data2) -- Taken from CoopHUD+, credit to Kona
	local new_config = {};
	for key, value in pairs(data1) do
		local new_value = (type(data2) == "table" or type(data2) == "userdata") and data2[key] or nil;
		
		if new_value == nil then
			new_config[key] = value;
			goto skip_key;
		elseif value ~= nil and type(new_value) ~= type(value) then
			new_value = value;
		end
		if type(value) == 'table' then
			new_value = Utils.ensureCompatibility(value, new_value);
		end
		new_config[key] = new_value;
		::skip_key::
	end
	return new_config;
end

function Utils.clampFlow(min, max, val, step)
	min = min or -4294967295;
	max = max or 4294967295;
	step = step or 1;
	return val < min and Utils.clampFlow(min,max,(max - ((min - val) - step)),step) or (val > max and Utils.clampFlow(min,max,(min + ((val - max) - step)),step) or val);
end
function Utils.getTableIndex(tbl, val)
	for i, v in pairs(tbl) do
		if v == val then return i end;
	end
	return 0;
end
function Utils.mergeTables(tbl1, tbl2)
	for k, v in pairs(tbl2) do
		tbl1[k] = v;
	end
	return tbl1;
end
function Utils.cloneTable(tbl)
	local new_tbl = {};
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			if type(v) == "table" or type(v) == "userdata" then
				new_tbl[k] = Utils.cloneTable(v);
			else
				new_tbl[k] = v;
			end
		end
	elseif type(tbl) == "userdata" and tbl.X then
		new_tbl = Vector(tbl.X,tbl.Y);
	else
		return tbl;
	end
	return new_tbl;
end
function Utils.shiftTable(tbl,step)
	if step == 0 then return; end
	local start_index = step > 0 and 1 or #tbl;
	local end_index = step > 0 and #tbl or 1;
	local new_tbl = {};
	for i = start_index, end_index, step do
		local next_index = (i + step > #tbl or i + step < 1) and start_index or i + step
		new_tbl[next_index] = tbl[i];
	end
	return new_tbl;
end
function Utils.printTable(var, level)
	local output = "";
	level = level or 0;
	level = level + 1;
	if type(var) == "table" then
		output = output .. "{";
		for key, value in pairs(var) do
			output = output .. "\n" .. string.rep("\t", level) .. string.format("[%s] = ", key) .. Utils.printTable(value, level) .. ",";
		end
		output = output .. "\n" .. string.rep("\t", level - 1) .. "}";
	elseif type(var) == "userdata" then
		if var.X then output = output .. "Vector(" .. var.X .. "," .. var.Y .. ")"; end
	elseif type(var) == "function" then
		output = output .. "function()";
	else
		output = output .. var;
	end
	level = level - 1;
	if level ~= 0 then
		return output;
	end
	print(output);
end
function Utils.CleanupName(name)
	return string.gsub(name,"_"," "):lower():gsub("(%a)([%w_']*)",function(f,r) return f:upper()..r:lower(); end);
end

-- Game Utilities
function Utils.IsPauseMenuOpen()
	return game:IsPauseMenuOpen() or Utils.IsMCMenuOpen() or Utils.IsDSSMenuOpen();
end
function Utils.IsMCMenuOpen()
	return ModConfigMenu and ModConfigMenu.IsVisible;
end
function Utils.IsDSSMenuOpen()
	return DeadSeaScrollsMenu and DeadSeaScrollsMenu.IsOpen();
end

function Utils.getHealthTypes()
	if not CustomHealthAPI then return mod.HealthTypes; end
	local health_types = {};
	for name,info in pairs(CustomHealthAPI.PersistentData.HealthDefinitions) do
		local total = info.MaxHP and info.MaxHP > 0 and info.MaxHP or (info.AnimationName ~= nil and (type(info.AnimationName) == "table" and #info.AnimationName > 0 and #info.AnimationName or 1) or (info.AnimationNames ~= nil and (type(info.AnimationNames) == "table" and #info.AnimationNames > 0 and #info.AnimationNames or 1)));
		table.insert(health_types,{Name = name, Total = total, Order = (info.SortOrder or 0)});
	end
	table.sort(health_types,function (a,b) return a.Order < b.Order end);
	return health_types;
end

function Utils.cloneSprite(sprite,sprite_data)
	if not sprite then return; end
	sprite_data = sprite_data or {};
	sprite_data.Anm2 = sprite_data.Anm2 or sprite:GetFilename();
	sprite_data.Animation = sprite_data.Animation or (sprite:GetAnimation():len() > 0 and sprite:GetAnimation() or sprite:GetDefaultAnimation());
	sprite_data.Frame = sprite_data.Frame or sprite:GetFrame();
	sprite_data.Sheets = sprite_data.Sheets or {};
	
	local new_sprite = Sprite(sprite_data.Anm2, true);
	
	for i,layer in pairs(sprite:GetAllLayers()) do
		sprite_data.Sheets[i] = sprite_data.Sheets[i] or layer:GetSpritesheetPath();
	end
	
	if sprite_data.Sheets then 
		for id,sheet in pairs(sprite_data.Sheets) do
			new_sprite:ReplaceSpritesheet(id,sheet);
		end
	end
	new_sprite:LoadGraphics();
	new_sprite:SetFrame(sprite_data.Animation, sprite_data.Frame);
	return new_sprite;
end

-- Color Utilities
function Utils.ColorOpacity(color,opacity)
	return Color(color.R,color.G,color.B,(opacity or color.A));
end
function Utils.FontOpacity(kcolor,opacity)
	return KColor(kcolor.Red,kcolor.Green,kcolor.Blue,(opacity or kcolor.Alpha));
end
function Utils.ColorBrighthness(color,brightness)
	return Color(color.R * brightness,color.G * brightness,color.B * brightness,color.A);
end
function Utils.ColorShift(color,shift)
	return Color(Utils.clampFlow(0,1,color.R + shift,0.1),Utils.clampFlow(0,1,color.G + shift,0.1),Utils.clampFlow(0,1,color.B + shift,0.1),color.A);
end
function Utils.ConvertColorToColorize(color,opacity,brightness,saturation)
	opacity = opacity or 1;
	brightness = brightness or 1;
	saturation = saturation or 1;
	local colorized = Color(brightness,brightness,brightness,opacity,0,0,0)
	colorized:SetColorize(color.R,color.G,color.B,saturation);
	return colorized;
end
function Utils.ConvertColorToTable(color,opacity)
	return {color.R,color.G,color.B,(opacity or color.A)};
end
function Utils.ConvertColorToFont(color,opacity)
	return KColor(color.R,color.G,color.B,(opacity or color.A));
end
function Utils.ConvertFontToColor(kcolor,opacity)
	return Color(kcolor.Red,kcolor.Green,kcolor.Blue,(opacity or kcolor.Alpha));
end
function Utils.GetColorByName(color_name)
	for _, color in pairs(mod.Colors) do
		if color.Name:lower() == color_name:lower() then return color.Value; end
	end
	return Color.Default;
end
function Utils.GetColorIndexByName(color_name)
	for i, color in pairs(mod.Colors) do
		if color.Name == color_name then return i; end
	end
	return 0;
end

-- Player/Character Utils
local random_player = {Name = "Random", Type = PlayerType.PLAYER_POSSESSOR, Achievement = nil, Sprite = {Anm2 = mod.Animations.Coop, Animation = "Main", Frame = 0,Sheets = {[1] = mod.Images.Blank}}};
function Utils.getUnlockedCharacters(no_mods,no_random)
	local characters = {mod.Characters[1]};
	local last_achievement = 0;
	for i,character in pairs(mod.Characters) do
		if character.Achievement and character.Achievement ~= last_achievement and Isaac.GetPersistentGameData():Unlocked(character.Achievement) then
			table.insert(characters,character);
		end
		last_achievement = character.Achievement;
	end
	if not no_mods then
		for i,character in pairs(mod.CharactersModded) do
			if not character.Achievement or (character.Achievement > 0 and character.Achievement ~= last_achievement and Isaac.GetPersistentGameData():Unlocked(character.Achievement)) then
				table.insert(characters,character);
			end
			last_achievement = character.Achievement;
		end
	end
	if not no_random and #characters > 1 then table.insert(characters,random_player); end
	return characters;
end

function Utils.getCharacterByType(player_type)
	for i,character in pairs(mod.Characters) do
		if character.Type == player_type then return character, i; end
	end
	for i,character in pairs(mod.CharactersModded) do
		if character.Type == player_type then return character, #mod.Characters + i; end
	end
	return {},-1;
end
function Utils.getCharacterByName(player_name)
	for i,character in pairs(mod.Characters) do
		if character.Name == player_name then return character, i; end
	end
	for i,character in pairs(CharactersModded) do
		if character.Name == player_name then return  character, #mod.Characters + i; end
	end
	return {},-1;
end
function Utils.GetPlayerID(player_entity) -- Taken from CustomHealthAPI
	if not player_entity then return "nil"; end
	local rng = player_entity:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B and player_entity:GetCollectibleRNG(2) or player_entity:GetCollectibleRNG(1);
	return ("UUID-" .. tostring(rng:GetSeed()));
end

function Utils.getMainPlayers()
	local players = {};
	for i = 1, game:GetNumPlayers(), 1 do
		if not mod.Twins[i] then
			table.insert(players,Isaac.GetPlayer(i - 1));
		end
	end
	return players;
end
function Utils.getMainPlayerIndex(player_entity)
	if player_entity == nil then return; end
	local players = Utils.getMainPlayers();
	local player_ID = Utils.GetPlayerID(player_entity);
	for i = 1, #players, 1 do
		if Utils.GetPlayerID(players[i]) == player_ID or Utils.GetPlayerID(Utils.getMainTwin(player_entity)) == player_ID then return i; end
	end
	return 0;
end
function Utils.getMainTwin(player_entity)
	if player_entity == nil then return; end
	for i = 1, game:GetNumPlayers(), 1 do
		if mod.Twins[i] then return Isaac.GetPlayer(i - 1), i; end
	end
	return nil,0;
end
function Utils.isMainTwin(player_entity)
	if player_entity == nil then return; end
	for i = 1, game:GetNumPlayers(), 1 do
		local player = Isaac.GetPlayer(i - 1);
		if mod.Twins[i] and Utils.GetPlayerID(player) == Utils.GetPlayerID(player_entity) then return true; end
	end
	return false;
end
function Utils.getPlayerTwins(player_entity)
	if player_entity == nil then return; end
	local player_twins = {};
	local player_index = Utils.getMainPlayerIndex(player_entity);
	for i = 1, game:GetNumPlayers(), 1 do
		if mod.Twins[i] == player_index then table.insert(player_twins,Isaac.GetPlayer(i - 1)); end
	end
	return player_twins;
end
function Utils.getMainPlayerByController(controller_index)
	local players = Utils.getMainPlayers();
	for i = 1, #players, 1 do
		if players[i].ControllerIndex == controller_index then return players[i], i; end
	end
	return nil,0;
end
function Utils.getPlayersByController(controller_index)
	local players = {};
	for i = 1, game:GetNumPlayers(), 1 do
		local player_entity = Isaac.GetPlayer(i - 1);
		if player_entity.ControllerIndex == controller_index then table.insert(players,player_entity); end
	end
	return players;
end
function Utils.getPlayerName(player_entity, player_index, name_type, custom_name, full_tainted)
	if not player_entity then return ""; end
	local player_type = player_entity:GetPlayerType();
	local character = Utils.getCharacterByType(player_type);
	if not character then return "???"; end
	local char_name = Utils.IsTainted(player_entity) and (full_tainted and character.Name or "T. " .. player_entity:GetName()) or character.Name;
	return name_type == 0 and "P" .. player_index or (name_type == 1 and char_name or custom_name);
end

function Utils.getHeadSprite(sprite, player_entity, scale) -- Taken from coopHUD *WIP*, credit to Srokks
	local isBaby = Utils.IsBaby(player_entity);
	local player_type = isBaby and player_entity.BabySkin or player_entity:GetPlayerType();
	if Utils.IsTwin(player_entity) then return nil; end
	if isBaby and player_type > 60 then
		player_type = 32;
	end
	local character_data = Utils.getCharacterByType(player_type) or {};
	if player_type > PlayerType.PLAYER_THESOUL_B then -- Modded Characters
		sprite = Sprite();
		if not character_data or not character_data.Sprite then 
			character_data.Sprite = {};
			local mod_sprite = EntityConfig.GetPlayer(player_type):GetModdedCoopMenuSprite();
			Utils.cloneSprite(mod_sprite,character_data.Sprite);
		end
		sprite:Load(character_data.Sprite.Anm2, true);
		if character_data.Sprite.Sheets then 
			for id,sheet in pairs(character_data.Sprite.Sheets) do
				mod_sprite:ReplaceSpritesheet(id,sheet);
			end
		end
		sprite:LoadGraphics();
		sprite:SetFrame(character_data.Sprite.Animation, character_data.Sprite.Frame);
		return sprite;
	elseif player_type >= 0 then
		if sprite == nil then
			sprite = Sprite();
			sprite:Load(mod.Animations.Coop, true);
			sprite:ReplaceSpritesheet((isBaby and 0 or 1), mod.Images.Blank); -- Hide other spritesheet
		end
		sprite.FlipY = player_type == PlayerType.PLAYER_LAZARUS2_B;
		sprite.Scale = scale or Vector.One;
		sprite:SetFrame('Main', player_type + 1); -- +1 because 0 is Frame Random
		sprite:LoadGraphics();
		return sprite;
	end
	return nil;
end

function Utils.IsTwin(player_entity)
	local player_type = player_entity:GetPlayerType();
	return player_type == PlayerType.PLAYER_THESOUL or player_type == PlayerType.PLAYER_ESAU or player_type == PlayerType.PLAYER_THESOUL_B or player_type == PlayerType.PLAYER_LAZARUS2_B or (player_entity:GetMainTwin() ~= nil and player_entity:GetMainTwin():GetName() ~= player_entity:GetName());
end
function Utils.IsBaby(player_entity)
	return player_entity.BabySkin > BabySubType.BABY_UNASSIGNED;
end
function Utils.IsIllusion(player_entity)
	return IllusionMod and IllusionMod.GetData(player_entity).IsIllusion;
end
function Utils.IsLost(player_entity)
	local player_type = player_entity:GetPlayerType();
	return player_type == PlayerType.PLAYER_THELOST or player_type == PlayerType.PLAYER_THELOST_B;
end
function Utils.IsForgotten(player_entity)
	local player_type = player_entity:GetPlayerType();
	return player_type == PlayerType.PLAYER_THEFORGOTTEN;
end
function Utils.IsKeeper(player_entity)
	local player_type = player_entity:GetPlayerType();
	return player_type == PlayerType.PLAYER_KEEPER or player_type == PlayerType.PLAYER_KEEPER_B;
end
function Utils.IsTemporary(player_entity)
	local player_type = player_entity:GetPlayerType()
	return Utils.isMainTwin(player_entity) and (Utils.IsForgotten(player_entity) or Utils.IsKeeper(player_entity) or Utils.IsIllusion(player_entity));
end
function Utils.IsTainted(player_entity)
	local player_type = player_entity:GetPlayerType();
	local player_config = EntityConfig.GetPlayer(player_type);
	return player_config and player_config:IsTainted();
end
function Utils.HasInventory(player_entity)
	local player_type = player_entity:GetPlayerType();
	return player_type == PlayerType.PLAYER_ISAAC_B or player_type == PlayerType.PLAYER_CAIN_B or player_type == PlayerType.PLAYER_BLUEBABY_B;
end
function Utils.AnyoneIsNotPlayerType(player_type)
	for i,ptype in pairs(mod.Players.Types) do
		if player_type ~= ptype then return true; end
	end
	return false;
end
function Utils.GetDevilPrice(player_entity,player_health,collectible_type)
	local price = 0;
	player_health = player_health or CustomHealthAPI and CustomHealthAPI.PersistentData.OverriddenFunctions.GetHearts(player_entity) or player_entity:GetHearts();
	local devil_price = player_entity:HasTrinket(TrinketType.TRINKET_JUDAS_TONGUE) and 1 or Isaac.GetItemConfig():GetCollectible(collectible_type).DevilPrice;
	if player_entity:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) or Utils.IsLost(player_entity) then price = PickupPrice.PRICE_SOUL;
	elseif player_entity:GetPlayerType() == PlayerType.PLAYER_KEEPER or player_entity:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then 
		price = (15 * devil_price) / (PlayerManager.GetNumCollectibles(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1);
	elseif player_health < 1 and not CustomHealthAPI.Helper.PlayerIsSoulHeartOnly(player_entity,true) then price = PickupPrice.PRICE_THREE_SOULHEARTS; else
		if devil_price == 1 then
			if player_entity:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then price = PickupPrice.PRICE_ONE_SOUL_HEART;
			else price = PickupPrice.PRICE_ONE_HEART; end
		else
			if player_entity:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then price = PickupPrice.PRICE_TWO_SOUL_HEARTS;
			elseif player_health < 2 then price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS;				
			else price = PickupPrice.PRICE_TWO_HEARTS end
		end
	end
	return price;
end

function Utils.CanPayPrice(player_entity,price)
	if price > 0 then
		if player_entity:HasTrinket(TrinketType.TRINKET_STORE_CREDIT) or player_entity:GetNumCoins() >= price then return true; else return false; end
	elseif price < 0 then
		player_health = {Red = (player_entity:GetHearts() / 2), Soul = (player_entity:GetSoulHearts() / 2)};
		
		if devil_price == PickupPrice.PRICE_ONE_HEART and player_health.Red > 0 or (devil_price == PickupPrice.PRICE_TWO_HEARTS and player_health.Red > 1 or (devil_price == PickupPrice.PRICE_THREE_SOULHEARTS and player_health.Soul > 2 or (devil_price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS and (player_health.Red > 1 and player_health.Soul > 1) or (devil_price == PickupPrice.PRICE_ONE_SOUL_HEART and player_health.Soul > 0 or (devil_price == PickupPrice.PRICE_TWO_SOUL_HEARTS and player_health.Soul > 1 or (devil_price == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART and (player_health.Red > 0 and player_health.Soul > 0) or (devil_price == PickupPrice.PRICE_SOUL or devil_price == PickupPrice.PRICE_SPIKES))))))) then return true; else return false; end
	end
	return true;
end

-- Font Utils
function Utils.UnloadFonts()
	for _, k in pairs(mod.Fonts) do
		for _, v in pairs(k) do
			v:Unload();
			v = nil;
		end
	end
	return {};
end
function Utils.LoadFonts()
	if mod.Fonts ~= nil then
		mod.Fonts = Utils.UnloadFonts();
	end
	for k, _ in pairs(mod.Registry.Modules) do
		mod.Fonts[k] = {};
		if mod.Config[k] and mod.Config[k].fonts then
			for e, f in pairs(mod.Config[k].fonts) do
				mod.Fonts[k][e], _ = Font(mod.Fnts[f]);
			end
		end
	end
end

-- Room/Grid Utils
function Utils.GetRoomID()
	return "Room-" .. tostring(game:GetLevel():GetCurrentRoomIndex());
end

function Utils.FindGridsInRadius(position,radius,grid_type) -- Vector, Number, GridEntityType. Radius is multiplied by Grid Size (40). Values of X.5 will do the next value up (i.e. 0.5 -> 1) but will skip corners. Radius of 0 only targets the grid position
	local grid_entities = {};
	local room = Game():GetRoom();
	if room == nil or position == nil then return nil; end
	local skip_corners = ((radius - math.floor(radius)) > 0);
	if not radius or radius < 0.5 then radius = 0.1; else radius = math.floor(radius); end
	local checkSize = (mod.GridSize * radius);
	for x = position.X - checkSize, position.X + checkSize, mod.GridSize do
		for y = position.Y - checkSize, position.Y + checkSize, mod.GridSize do
			if skip_corners and (x == position.X - checkSize or x == position.X + checkSize) and (y == position.Y - checkSize or y == position.Y + checkSize) then goto continue; end
			local grid_entity = room:GetGridEntityFromPos(Vector(x,y));
			if grid_entity ~= nil and (not grid_type or grid_entity:GetType() == grid_type) then
				table.insert(grid_entities,grid_entity);
			end
			::continue::
		end
	end
	return grid_entities;
end

function Utils.IsGridTypeRemovable(grid_type)
	if grid_type == GridEntityType.GRID_ROCKB or grid_type == GridEntityType.GRID_PIT or grid_type == GridEntityType.GRID_LOCK or grid_type == GridEntityType.GRID_WALL or grid_type == GridEntityType.GRID_DOOR or grid_type == GridEntityType.GRID_TRAPDOOR or grid_type == GridEntityType.GRID_STAIRS or grid_type == GridEntityType.GRID_PRESSURE_PLATE or grid_type == GridEntityType.GRID_TELEPORTER or grid_type == GridEntityType.GRID_PILLAR or grid_type == GridEntityType.GRID_GRAVITY or grid_type == GridEntityType.GRID_STATUE or grid_type == GridEntityType.GRID_ROCK_SS then return false end
	return true
end

function Utils.CheckGridIndex(room,grid_index)
	if not room or not grid_index then return false; end
	local entities = Isaac.FindInRadius(room:GetGridPosition(grid_index), (mod.GridSize / 4));
	local grid_entity = room:GetGridEntity(grid_index);
	if #entities > 0 then for _,entity in pairs(entities) do
		if entity.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE and entity:IsInvincible() then return false; end
	end end
	if grid_entity and grid_entity.CollisionClass > GridCollisionClass.COLLISION_NONE and not Utils.IsGridTypeRemovable(grid_entity:GetType()) then return false; end
	return true;
end

function Utils.GetGridTile(grid_index) -- Get Room Grid Row / Column by grid_index. Returns table array
	local room = Game():GetRoom();
	if room == nil or grid_index == nil then return nil; end
	return {(grid_index % room:GetGridWidth()),math.floor(grid_index / room:GetGridWidth())};
end

function Utils.GetSafeSpawnEntity(spawn_pos)
	local pathfinder_entity = game:Spawn(EntityType.ENTITY_GAPER,0,spawn_pos,Vector(0,0),nil,0,1):ToNPC();
	pathfinder_entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE;
	pathfinder_entity.Visible = false;
	pathfinder_entity.CanShutDoors = false;
	pathfinder_entity:SetPauseTime(2000);
	return pathfinder_entity; 
end

function Utils.CheckSafeSpawnPosition(start_pos, target_pos) -- Vector, Vector
	local room = game:GetRoom();
	local safe_pos = false;
	local index = room:GetGridIndex(target_pos);
	local pathfinder_entity = Utils.GetSafeSpawnEntity(target_pos);
	if pathfinder_entity:GetPathfinder():HasPathToPos(start_pos,true) and Utils.CheckGridIndex(room,index) then safe_pos = true; end -- Checks if it is behind Pits or unbreakable obstacles or is on top of an entity
	pathfinder_entity:Remove();
	return safe_pos;
end

function Utils.GetSafeSpawnPosition(start_pos, target_pos, grid_steps) -- Vector, Vector, Steps int[] [X,Y,Initial] Searches in a grid pattern (-1,1,2) -> Looks down 1 tile, then left 1, then down 1, etc
	local room = game:GetRoom();
	local room_boundary = {Utils.GetGridTile(room:GetGridIndex(room:GetTopLeftPos()))[1],Utils.GetGridTile(room:GetGridIndex(room:GetBottomRightPos()))[1]};
	local index = room:GetGridIndex(target_pos);
	local end_index = grid_steps[1] > 0 and room:GetGridSize() or 0;
	local step = grid_steps[3] and grid_steps[3] == 1 and Vector(grid_steps[1],0) or Vector(0,grid_steps[2]);
	local max_attempts = 10;
	local pathfinder_entity = Utils.GetSafeSpawnEntity(target_pos);
	for i = 1, max_attempts, 1 do
		if pathfinder_entity:GetPathfinder():HasPathToPos(start_pos,true) and Utils.CheckGridIndex(room,index) then break; end -- Checks if it is behind Pits or unbreakable obstacles or is on top of an entity
		
		local tile = Utils.GetGridTile(index);
		tile = Vector(tile[1],tile[2]);
		tile = tile + step;
		step = step.X == 0 and Vector(grid_steps[1],0) or Vector(0,grid_steps[2]);
		if tile.X < room_boundary[1] or tile.X > room_boundary[2] or i == max_attempts then -- Failed to find safe position
			pathfinder_entity.Position = target_pos;
			break;
		end
		if tile.Y > room:GetGridHeight() then tile.X = tile.X + grid_steps[1]; tile.Y = 0; elseif tile.Y < 0 then tile.X = tile.X + grid_steps[1]; tile.Y = room:GetGridHeight(); end

		index = room:GetGridIndexByTile(tile.X,tile.Y); -- IDK why REPENTAGON doesn't use Vector here, int[] is weird
		pathfinder_entity.Position = room:GetGridPosition(index);
	end
	local safe_pos = Vector(pathfinder_entity.Position.X,pathfinder_entity.Position.Y);
	pathfinder_entity:Remove();
	return safe_pos;
end