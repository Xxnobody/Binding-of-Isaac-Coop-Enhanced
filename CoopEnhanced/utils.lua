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
		if type(value) == "table" then
			value = Utils.encodeData(value);
		end
		if type(value) == "userdata" then
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
		if type(key) == "string" then
			if tonumber(key) ~= nil then key = tonumber(key);
			elseif key:sub(-1) == "Y" then goto skip_decode;
			elseif key:sub(-1) == "X" then
				key = key:sub(1, -2);
				if type(data[key.."Y"]) ~= "number" then goto skip_decode; end
				value = Vector(value, data[key.."Y"]);
			end
		end
		if type(value) == "table" then
			value = Utils.decodeData(value);
		end
		new_data[key] = value;
		::skip_decode::
	end
	return new_data;
end

function Utils.GetLocalizedString(category, input, language)
	if not input or input:sub(1, 1) ~= "#" then return input; end
	language = type(language) == "number" and language or Language.ENGLISH;
	if REPENTOGON and category then
		input = Isaac.GetLocalizedString(category,input,language);
	else
		input = name:sub(2, -5):gsub("_", " "):lower():gsub("%f[%a].", string.upper);
	end
	return input;
end
function Utils.ClampFlow(min, max, val, step)
	min = min or -4294967295;
	max = max or 4294967295;
	step = step or 1;
	return val < min and Utils.ClampFlow(min,max,(max - ((min - val) - step)),step) or (val > max and Utils.ClampFlow(min,max,(min + ((val - max) - step)),step) or val);
end
function Utils.GetTableIndex(tbl, val)
	for i, v in pairs(tbl) do
		if v == val then return i end;
	end
	return 0;
end

function Utils.MergeTables(default, new_data, use_nil) -- Overwrites data in the default table with new data if the types are the same, otherwise default is used for that data point. When use_nil is set to true, it will also iterate the new data and add any values not in default.
	local new_output = {};
	if type(default) == "table" then
		for key, value in pairs(default) do
			local new_value = type(new_data) == "table" and new_data[key];
			if type(new_value) ~= type(value) then new_value = value;
			elseif type(new_value) == "table" then
				new_value = Utils.MergeTables(value, new_value, use_nil);
			end
			new_output[key] = new_value;
		end
		if use_nil and type(new_data) == "table" then
			for key, new_value in pairs(new_data) do
				if default[key] == nil then new_output[key] = new_value; end
			end
		end
	end
	return new_output;
end
function Utils.ShiftTable(tbl,step)
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
function Utils.Stringify(var, level)
	local output = "";
	level = (level or 0) + 1;
	if type(var) == "table" then
		output = output .. "{";
		for key, value in pairs(var) do
			output = output .. "\n" .. string.rep("\t", level) .. string.format("[%s] = ", key) .. Utils.Stringify(value, level) .. ",";
		end
		output = output .. "\n" .. string.rep("\t", level - 1) .. "}";
	elseif type(var) == "userdata" then
		if var.X then output = output .. "Vector(" .. var.X .. "," .. var.Y .. ")"; 
		elseif var.PlaybackSpeed then
			output = output .. "Sprite(Anm2 = '" .. var:GetFilename() .. "', Animation = '" .. var:GetAnimation() .. "', Frame = " .. var:GetFrame() .. ", Overlay Animation = '" .. var:GetOverlayAnimation() .. "', Overlay Frame = " .. var:GetOverlayFrame() .. ", Scale = Vector(" .. var.Scale.X .. ", " .. var.Scale.Y .. ") , Playing = " .. tostring(var:IsPlaying()) .. ", Finished = " .. tostring(var:IsFinished()) .. ")";
		end
	elseif type(var) == "function" then
		output = output .. "function(" .. tostring(var) .. ")";
	elseif type(var) == "string" then
		output = output .. "'" .. var .. "'";
	else
		output = output .. (var ~= nil and tostring(var) or "nil");
	end
	level = level - 1;
	return output;
end

function Utils.Clone(val)
	local new_tbl = {};
	if type(val) == "table" then
		for k, v in pairs(val) do
			if type(v) == "table" or type(v) == "userdata" then
				new_tbl[k] = Utils.Clone(v);
			else
				new_tbl[k] = v;
			end
		end
	elseif type(val) == "userdata" then
		if val.X then new_tbl = Vector(val.X + 0,val.Y + 0);
		elseif val.PlaybackSpeed then return Utils.CloneSprite(val);
		end
	elseif type(val) == "boolean" then
		return val and true or false;
	elseif type(val) == "number" then
		return val + 0;
	elseif type(val) == "string" then
		return val .. "";
	else
		return val;
	end
	return new_tbl;
end
function Utils.CloneSprite(sprite,sprite_data)
	if not sprite then return; end
	if not sprite_data and REPENTOGON then return sprite:Copy(); end
	sprite_data = sprite_data or {};
	sprite_data.Anm2 = sprite_data.Anm2 or sprite:GetFilename();
	sprite_data.Animation = sprite_data.Animation or (sprite:GetAnimation():len() > 0 and sprite:GetAnimation() or sprite:GetDefaultAnimation());
	sprite_data.Frame = sprite_data.Frame or sprite:GetFrame();
	sprite_data.Sheets = sprite_data.Sheets or {};
	
	local new_sprite = Sprite(sprite_data.Anm2, true);
	
	if REPENTOGON then
		for i,layer in pairs(sprite:GetAllLayers()) do
			sprite_data.Sheets[i] = sprite_data.Sheets[i] or layer:GetSpritesheetPath();
		end
	end
	
	if sprite_data.Sheets then 
		for id,sheet in pairs(sprite_data.Sheets) do
			new_sprite:ReplaceSpritesheet(id,sheet);
		end
	end
	sprite_data.Frame = math.max(0,sprite_data.Frame);
	new_sprite:LoadGraphics();
	new_sprite:SetFrame(sprite_data.Animation, sprite_data.Frame);
	return new_sprite;
end

function Utils.CleanupName(name)
	return string.gsub(name,"_"," "):lower():gsub("(%a)([%w_']*)",function(f,r) return f:upper()..r:lower(); end);
end

-- Game Utilities
function Utils.IsPauseMenuOpen()
	return (REPENTOGON ~= nil and game:IsPauseMenuOpen() or game:IsPaused()) or Utils.IsMCMenuOpen() or Utils.IsDSSMenuOpen();
end
function Utils.IsMCMenuOpen()
	return ModConfigMenu ~= nil and ModConfigMenu.IsVisible;
end
function Utils.IsDSSMenuOpen()
	return DeadSeaScrollsMenu ~= nil and DeadSeaScrollsMenu.IsOpen();
end

function Utils.IsActiveItem(collectible_type)
	if not collectible_type or collectible_type == CollectibleType.COLLECTIBLE_NULL then return; end
	return Isaac.GetItemConfig():GetCollectible(collectible_type).Type == ItemType.ITEM_ACTIVE;
end

function Utils.GetHeartTypes()
	if not CustomHealthAPI then return mod.HeartTypes; end
	local health_types = {};
	for name,info in pairs(CustomHealthAPI.PersistentData.HealthDefinitions) do
		local total = info.MaxHP and info.MaxHP > 0 and info.MaxHP or (info.AnimationName ~= nil and (type(info.AnimationName) == "table" and #info.AnimationName > 0 and #info.AnimationName or 1) or (info.AnimationNames ~= nil and (type(info.AnimationNames) == "table" and #info.AnimationNames > 0 and #info.AnimationNames or 1)));
		table.insert(health_types,{Name = name, Total = total, Order = (info.SortOrder or 0)});
	end
	table.sort(health_types,function (a,b) return a.Name < b.Name end);
	return health_types;
end

function Utils.GetHeartAmount(heart_subtype)
	if not heart_subtype or heart_subtype > HeartSubType.HEART_ROTTEN then return 0; end
	if heart_subtype == HeartSubType.HEART_FULL or heart_subtype == HeartSubType.HEART_SOUL or heart_subtype == HeartSubType.HEART_BLACK or heart_subtype == HeartSubType.HEART_SCARED or heart_subtype == HeartSubType.HEART_BLENDED then return 2; else return 1; end
end

function Utils.GetHealthType(pickup_entity,heart_subtype)
	if CustomHealthAPI and CustomHealthAPI.Library.GetPickupType then return CustomHealthAPI.Library.GetPickupType(pickup_entity); end
	heart_subtype = heart_subtype or (pickup_entity ~= nil and pickup_entity.SubType or nil);
	if heart_subtype and heart_subtype <= HeartSubType.HEART_ROTTEN then 
		if heart_subtype == HeartSubType.HEART_FULL or heart_subtype == HeartSubType.HEART_HALF or heart_subtype == HeartSubType.HEART_DOUBLEPACK or heart_subtype == HeartSubType.HEART_SCARED or heart_subtype == HeartSubType.HEART_ROTTEN then return mod.HealthTypes.RED;
		elseif heart_subtype == HeartSubType.HEART_SOUL or heart_subtype == HeartSubType.HEART_HALF_SOUL or heart_subtype == HeartSubType.HEART_BLACK then return mod.HealthTypes.SOUL;
		elseif heart_subtype == HeartSubType.HEART_BONE then return mod.HealthTypes.CONTAINER;
		elseif heart_subtype == HeartSubType.HEART_ETERNAL or heart_subtype == HeartSubType.HEART_GOLDEN then return mod.HealthTypes.OVERLAY;
		end
	end
	return nil;
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
	return Color(Utils.ClampFlow(0,1,color.R + shift,0.1),Utils.ClampFlow(0,1,color.G + shift,0.1),Utils.ClampFlow(0,1,color.B + shift,0.1),color.A);
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

-- Player Manager Utils
function Utils.GetPlayers()
	if REPENTOGON then return PlayerManager.GetPlayers(); end
	local players = {};
	for i = 1, game:GetNumPlayers(), 1 do
		local player_entity = Isaac.GetPlayer(i - 1);
		if player_entity then table.insert(players,player_entity); end
	end
	return players;
end
function Utils.AnyoneIsPlayerType(player_type)
	if REPENTOGON then return PlayerManager.AnyoneIsPlayerType(player_type); end
	for i,ptype in pairs(mod.Players.Types) do
		if player_type == ptype then return true; end
	end
	return false;
end
function Utils.AnyoneIsNotPlayerType(player_type)
	for i,ptype in pairs(mod.Players.Types) do
		if player_type ~= ptype then return true; end
	end
	return false;
end
function Utils.AnyoneHasCollectible(collectible_type)
	if REPENTOGON then return PlayerManager.AnyoneHasCollectible(collectible_type); end
	for i,player_entity in pairs(Utils.GetPlayers()) do
		if player_entity:HasCollectible(collectible_type) then return true; end
	end
	return false;
end
function Utils.AnyoneHasTrinket(trinket_type)
	if REPENTOGON then return PlayerManager.AnyoneHasTrinket(trinket_type); end
	for i,player_entity in pairs(Utils.GetPlayers()) do
		if player_entity:HasTrinket(trinket_type) then return true; end
	end
	return false;
end
function Utils.FirstPlayerByType(player_type)
	if REPENTOGON then return PlayerManager.FirstPlayerByType(player_type); end
	for i,ptype in pairs(mod.Players.Types) do
		if player_type == ptype then return Isaac.GetPlayer(i - 1); end
	end
	return nil;
end
function Utils.FirstPlayerNotType(player_type)
	for i,ptype in pairs(mod.Players.Types) do
		if player_type ~= ptype then return Isaac.GetPlayer(i - 1); end
	end
	return nil;
end
function Utils.GetNumCollectibles(collectible_type)
	if REPENTOGON then return PlayerManager.GetNumCollectibles(collectible_type); end
	local total = 0;
	for i,player_entity in pairs(Utils.GetPlayers()) do
		if player_entity:HasCollectible(collectible_type) then total = total + 1; end
	end
	return total;
end
function Utils.CanStartTrueCoop()
	return (REPENTOGON ~= nil and Isaac.CanStartTrueCoop()) or not Game():GetStateFlag(GameStateFlag.STATE_BOSSPOOL_SWITCHED);
end
function Utils.IsCoopPlay()
	return (mod.Players.Total + mod.GetJoiningTotal()) > 1;
end

-- Character data utils
 -- Add Modded Character data (Name, Type, Unlock Achievement ID (ID if one exists, nil for none, 0 to represent not unlocked, -ID for non existent achievments), Hidden (Won't show in character select), Tainted (is player type tainted version), Parent (player type of paract character (i.e. Dark Judas = Judas, Tainted Isaac = Isaac, etc)), Sprite Data (Can be a Sprite or a table))
 -- - Sprite data can include Spritesheet data, so if you wish to change a spritesheet add it to Sheets as [sheet_id] = "path/to/png" (i.e. Sheets = {[0] = "Blank.png"})
function Utils.AddCharacter(name,player_type,achievement,hidden,tainted,parent,sprite)
	if REPENTOGON == nil then return; end
	local sprite_data = sprite;
	if sprite.PlaybackSpeed then sprite_data = {Anm2 = sprite:GetFilename(), Frame = 0, Animation = name, Sheets = {}}; end
	local character_entry = {Name = name, Type = (player_type or -1), Achievement = achievement, Hidden = hidden, Tainted = tainted, Parent = parent, Sprite = sprite_data};
	table.insert(mod.Characters,character_entry);
	table.sort(mod.Characters,function (a,b) return a.Type < b.Type end);
end
function Utils.EditCharacter(character_search,edits) -- Character search can be name (String) or Player Type (Number)
	local index = type(character_search) == "string" and Utils.GetCharacterIndexByName(character_search) or (type(character_search) == "number" and Utils.GetCharacterIndexByType(character_search));
	local character = mod.Characters[index];
	if not character then return; end
	mod.Characters[index] = Utils.MergeTables(character,edits,true);
end
function Utils.RemoveCharacter(character_search,remove_subcharacters) -- Character search can be name (String) or Player Type (Number), Remove sub characters removes all characters who use the search character as a parent. Returns true if any characters were removed.
	local character_entry = Utils.Clone(type(character_search) == "string" and Utils.GetCharacterByName(character_search) or type(character_search) == "number" and Utils.GetCharacterByType(character_search));
	local success = false;
	for i,character in pairs(mod.Characters) do
		if (remove_subcharacters and character_entry ~= nil and character.Parent == character_entry.Type) or (type(character_search) == "string" and character.Name == character_search) or (type(character_search) == "number" and character.Type == character_search) then
			table.remove(mod.Characters,i);
			success = true;
			if not remove_subcharacters then break; end
		end
	end
	return success;
end
function Utils.GetCharacterByType(player_type)
	if REPENTOGON then
		for i,character in pairs(mod.Characters) do
			if character.Type == player_type then return character, i; end
		end
	end
	return nil;
end
function Utils.GetCharacterByName(player_name)
	if REPENTOGON then
		for i,character in pairs(mod.Characters) do
			if character.Name == player_name then return character, i; end
		end
	end
	return nil;
end
function Utils.GetCharacterIndexByType(player_type)
	if REPENTOGON then
		for i,character in pairs(mod.Characters) do
			if character.Type == player_type then return i; end
		end
	end
	return -1;
end
function Utils.GetCharacterIndexByName(player_name)
	if REPENTOGON then
		for i,character in pairs(mod.Characters) do
			if character.Name == player_name then return i; end
		end
	end
	return -1;
end
function Utils.GetUnlockedCharacters(no_mods,no_random)
	if not REPENTOGON then return {}; end
	local characters = {};
	for i,character in pairs(mod.Characters) do
		if no_mods and i >= PlayerType.NUM_PLAYER_TYPES then break; end
		if Utils.IsCharacterUnlocked(character) then table.insert(characters,character); end
	end
	if not no_random and #characters > 0 then table.insert(characters,{Name = "Random", Type = PlayerType.PLAYER_POSSESSOR, Achievement = nil, Sprite = {Anm2 = mod.Animations.Coop, Animation = "Main", Frame = 0,Sheets = {[1] = mod.Images.Blank}}}); end -- Insert Random player last
	return characters;
end
function Utils.IsCharacterUnlocked(character)
	if not character.Hidden and (not character.Achievement or (character.Achievement > 0 and REPENTOGON and Isaac.GetPersistentGameData():Unlocked(character.Achievement))) then
		return true;
	end
	return false;
end

-- Player Utils
function Utils.GetPlayerID(player_entity) -- Taken from CustomHealthAPI
	if not player_entity or not player_entity.GetPlayerType then return "nil"; end
	local rng = player_entity:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B and player_entity:GetCollectibleRNG(2) or player_entity:GetCollectibleRNG(1);
	return ("UUID-" .. tostring(rng:GetSeed()));
end
function Utils.GetPlayerByID(player_id)
	for i,player_entity in pairs(Utils.GetPlayers()) do
		local player_entity = Isaac.GetPlayer(i - 1);
		if Utils.GetPlayerID(player_entity) == player_id then return player_entity; end
	end
	return nil;
end

function Utils.GetMainPlayers()
	local players = {};
	for i = 1, game:GetNumPlayers(), 1 do
		if not mod.Players.Twins[i] then
			table.insert(players,Isaac.GetPlayer(i - 1));
		end
	end
	return players;
end
function Utils.GetMainPlayerIndex(player_entity)
	if player_entity == nil then return; end
	local player_ID = Utils.GetPlayerID(player_entity);
	for i,player in pairs(Utils.GetMainPlayers()) do
		if Utils.GetPlayerID(player) == player_ID or Utils.GetPlayerID(Utils.GetMainTwin(player_entity)) == player_ID then return i; end
	end
	return 0;
end
function Utils.GetMainPlayerByIndex(player_index)
	if player_index == nil then return; end
	local players = Utils.GetMainPlayers();
	return players and players[player_index] or nil;
end
function Utils.GetMainTwin(player_entity,ignoreTemp)
	if player_entity == nil then return; end
	local player_ID = Utils.GetPlayerID(player_entity);
	for i = 1, game:GetNumPlayers(), 1 do
		local player = Isaac.GetPlayer(i - 1);
		if mod.Players.Twins[i] and Utils.GetPlayerID(Isaac.GetPlayer(mod.Players.Twins[i] - 1)) == player_ID and (not ignoreTemp or not Utils.IsTemporary(player)) then return player, i; end
	end
	return nil,0;
end
function Utils.IsMainTwin(player_entity)
	if player_entity == nil then return; end
	for i = 1, game:GetNumPlayers(), 1 do
		local player = Isaac.GetPlayer(i - 1);
		if mod.Players.Twins[i] and Utils.GetPlayerID(player) == Utils.GetPlayerID(player_entity) then return true; end
	end
	return false;
end
function Utils.GetPlayerTwins(player_entity)
	if player_entity == nil then return; end
	local player_twins = {};
	local player_index = Utils.GetMainPlayerIndex(player_entity);
	for i = 1, game:GetNumPlayers(), 1 do
		if mod.Players.Twins[i] == player_index then table.insert(player_twins,Isaac.GetPlayer(i - 1)); end
	end
	return player_twins;
end
function Utils.GetMainPlayerByController(controller_index)
	local players = Utils.GetMainPlayers();
	for i = 1, #players, 1 do
		if players[i].ControllerIndex == controller_index then return players[i], i; end
	end
	return nil,0;
end
function Utils.GetPlayerByController(controller_index)
	for i,player_entity in pairs(Utils.GetPlayers()) do
		if player_entity.ControllerIndex == controller_index then return player_entity; end
	end
	return nil;
end
function Utils.GetPlayersByController(controller_index)
	local players = {};
	for i,player_entity in pairs(Utils.GetPlayers()) do
		if player_entity.ControllerIndex == controller_index then table.insert(players,player_entity); end
	end
	return players;
end
function Utils.GetPlayerName(player_entity, player_index, name_type, custom_name, full_tainted)
	local char_name = "";
	if name_type == mod.NameTypes.CHARACTER then
		local player_type = player_entity:GetPlayerType();
		local character = Utils.GetCharacterByType(player_type);
		char_name = Utils.IsTainted(player_type) and (full_tainted and character and character.Name or (player_entity and "T." .. player_entity:GetName() or "")) or (character and character.Name or (player_entity and player_entity:GetName() or ""));
		local lang = Language ~= nil and Language.ENGLISH or -1;
		char_name = char_name:len() > 0 and Utils.GetLocalizedString("players", char_name, lang) or "";
	end
	return name_type == mod.NameTypes.PLAYER and "P" .. player_index or (name_type == mod.NameTypes.CHARACTER and char_name or custom_name);
end

function Utils.GetHeadSprite(sprite, player_entity, player_type) -- Taken from coopHUD *WIP*, credit to Srokks, modified by xxnobody
	local isBaby = Utils.IsBaby(player_entity);
	player_type = player_type or player_entity ~= nil and (isBaby and player_entity.BabySkin or player_entity:GetPlayerType()) or -1;
	if isBaby and player_type > 60 then
		player_type = 32;
	end
	local character_data = Utils.GetCharacterByType(player_type) or {};
	local mod_anim = "gfx/ui/coop_menu.anm2";
	if player_type > PlayerType.PLAYER_THESOUL_B then -- Modded Characters
		sprite = Sprite();
		local mod_sprite = EntityConfig.GetPlayer(player_type):GetModdedCoopMenuSprite();
		if not character_data or not character_data.Sprite then 
			character_data.Sprite = {};
			Utils.CloneSprite(mod_sprite,character_data.Sprite);
		end
		if character_data.Sprite and character_data.Sprite.Anm2 then 
			sprite:Load(character_data.Sprite.Anm2, true);
			if character_data.Sprite.Sheets then 
				for id,sheet in pairs(character_data.Sprite.Sheets) do
					mod_sprite:ReplaceSpritesheet(id,sheet);
				end
			end
			sprite:LoadGraphics();
			sprite:SetFrame(character_data.Sprite.Animation, character_data.Sprite.Frame);
		end
	elseif player_type >= 0 then
		if sprite == nil then
			sprite = Sprite();
			sprite:Load(mod.Animations.Coop, true);
			sprite:ReplaceSpritesheet(1, mod.Images.Blank); -- Hide Baby spritesheet
		end
		local frame = player_type + 1; -- +1 because 0 is Frame Random
		local animation = "Main";
		if sprite:GetFilename() ~= mod_anim and Utils.HasTwin(player_type) and ((player_entity and player_entity.GetOtherTwin and mod.CoopTwins.IsTwin and mod.CoopTwins.IsTwin(player_entity)) or player_type == PlayerType.PLAYER_LAZARUS2_B) then
			sprite:Load(mod_anim,true);
			animation = "Twins";
			if player_type == PlayerType.PLAYER_JACOB then frame = 0;
			elseif player_type == PlayerType.PLAYER_ESAU then frame = 1;
			elseif player_type == PlayerType.PLAYER_JACOB_B then frame = 2;
			elseif player_type == PlayerType.PLAYER_JACOB2_B then frame = 3;
			elseif player_type == PlayerType.PLAYER_THEFORGOTTEN then frame = 4;
			elseif player_type == PlayerType.PLAYER_THESOUL then frame = 5;
			elseif player_type == PlayerType.PLAYER_THESOUL_B then frame = 6;
			elseif player_type == PlayerType.PLAYER_LAZARUS2 then frame = 7;
			elseif player_type == PlayerType.PLAYER_LAZARUS2_B then frame = 8;
			end
		end
		sprite:SetFrame(animation, frame);
		sprite:LoadGraphics();
	end
	CoopEnhanced.Registry:ExecuteCallback(CoopEnhanced.Callbacks.POST_HEAD_SPRITE,sprite);
	return sprite;
end

function Utils.GetPrice(player_entity,collectible_type,isDevil)
	local price = 0;
	local player_type = (player_entity ~= nil and player_entity:GetPlayerType()) or PlayerType.PLAYER_POSSESSOR;
	local item_config = Isaac.GetItemConfig():GetCollectible(collectible_type);
	
	if isDevil then
		local player_health = player_entity and ((CustomHealthAPI and CustomHealthAPI.Helper.GetRedCapacity(player_entity) or (player_entity:GetEffectiveMaxHearts())) / 2) or 0;
		local devil_price = (player_entity ~= nil and player_entity:HasTrinket(TrinketType.TRINKET_JUDAS_TONGUE) and 1) or item_config.DevilPrice;
		if player_entity and player_entity:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) or Utils.IsLost(player_type) then
			price = PickupPrice.PRICE_SOUL;
		elseif Utils.IsKeeper(player_type) then 
			price = (15 * devil_price) / (Utils.GetNumCollectibles(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1);
		elseif (player_health < 1 or player_type == PlayerType.PLAYER_THESOUL) and player_type ~= PlayerType.PLAYER_BLUEBABY then
			price = PickupPrice.PRICE_THREE_SOULHEARTS;
		else
			if devil_price == 1 then
				if player_type == PlayerType.PLAYER_BLUEBABY then price = PickupPrice.PRICE_ONE_SOUL_HEART;
				else price = PickupPrice.PRICE_ONE_HEART; end
			else
				if player_type == PlayerType.PLAYER_BLUEBABY then price = PickupPrice.PRICE_TWO_SOUL_HEARTS;
				elseif player_health < 2 then price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS;				
				else price = PickupPrice.PRICE_TWO_HEARTS end
			end
		end
	else
		price = item_config.ShopPrice / (Utils.GetNumCollectibles(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1);;
	end
	return price;
end

function Utils.CanPayPrice(player_entity,price)
	if price > 0 then
		if player_entity:HasTrinket(TrinketType.TRINKET_STORE_CREDIT) or player_entity:GetNumCoins() >= price then return true; else return false; end
	elseif price < 0 then
		local player_health = {Red = ((CustomHealthAPI and CustomHealthAPI.Helper.GetRedCapacity(player_entity) or (player_entity:GetEffectiveMaxHearts())) / 2), Soul = ((CustomHealthAPI and CustomHealthAPI.Helper.GetTotalSoulHP(player_entity) or (player_entity:GetBlackHearts() + player_entity:GetSoulHearts())) / 2)};
		
		if player_health.Red > 0 and (price == PickupPrice.PRICE_ONE_HEART or price == PickupPrice.PRICE_TWO_HEARTS or price == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART or price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS) or (player_health.Soul > 0 and (price == PickupPrice.PRICE_ONE_SOUL_HEART or price == PickupPrice.PRICE_TWO_SOUL_HEARTS or price == PickupPrice.PRICE_THREE_SOULHEARTS) or (price == PickupPrice.PRICE_SOUL and (Utils.IsLost(player_entity:GetPlayerType()) or player_entity:HasTrinket(TrinketType.TRINKET_YOUR_SOUL)) or (price == PickupPrice.PRICE_SPIKES))) then return true; else return false; end
	end
	return true;
end

function Utils.IsPlayerDying(player_entity) -- Taken from LibraryExpanded
	return player_entity:GetSprite():GetAnimation():sub(-#"Death") == "Death";
end

-- Player Types
function Utils.IsPlayerType(entity,player_type) -- Useful for checking if is player and player_type all at once
	if not entity then return false; end
	local player_entity = entity.Type == EntityType.ENTITY_PLAYER and (entity.BabySkin ~= nil and entity or entity:ToPlayer()) or nil;
	return player_entity ~= nil and player_entity:GetPlayerType() == player_type;
end
function Utils.IsBaby(player_entity)
	if not REPENTOGON or not player_entity then return false; end
	return player_entity.BabySkin ~= BabySubType.BABY_UNASSIGNED;
end
function Utils.IsIllusion(player_entity)
	return IllusionMod ~= nil and IllusionMod.GetData(player_entity).IsIllusion;
end
function Utils.IsTemporary(player_entity)
	local player_type = player_entity:GetPlayerType()
	return Utils.IsMainTwin(player_entity) and (Utils.IsForgotten(player_type) or Utils.IsKeeper(player_type) or Utils.IsIllusion(player_entity));
end
function Utils.HasTwin(player_type)
	return player_type == PlayerType.PLAYER_THEFORGOTTEN or player_type == PlayerType.PLAYER_THESOUL or player_type == PlayerType.PLAYER_THEFORGOTTEN_B or player_type == PlayerType.PLAYER_THESOUL_B or player_type == PlayerType.PLAYER_ESAU or player_type == PlayerType.PLAYER_JACOB or player_type == PlayerType.PLAYER_JACOB_B or player_type == PlayerType.PLAYER_LAZARUS2_B;
end
function Utils.IsTwin(player_type)
	return player_type == PlayerType.PLAYER_THESOUL or player_type == PlayerType.PLAYER_ESAU or player_type == PlayerType.PLAYER_THESOUL_B or player_type == PlayerType.PLAYER_LAZARUS2_B;
end
function Utils.IsTainted(player_type)
	if not REPENTOGON then return player_type >= PlayerType.PLAYER_ISAAC_B and player_type <= PlayerType.PLAYER_THESOUL_B; end
	local player_config = EntityConfig.GetPlayer(player_type);
	return player_config ~= nil and player_config:IsTainted();
end
function Utils.IsLost(player_type)
	return player_type == PlayerType.PLAYER_THELOST or player_type == PlayerType.PLAYER_THELOST_B;
end
function Utils.IsForgotten(player_type)
	return player_type == PlayerType.PLAYER_THEFORGOTTEN;
end
function Utils.IsKeeper(player_type)
	return player_type == PlayerType.PLAYER_KEEPER or player_type == PlayerType.PLAYER_KEEPER_B;
end
function Utils.HasInventory(player_type)
	return player_type == PlayerType.PLAYER_ISAAC_B or player_type == PlayerType.PLAYER_CAIN_B or player_type == PlayerType.PLAYER_BLUEBABY_B;
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

function Utils.FindGridsInRadius(position,radius,grid_type,room) -- Vector, Number, GridEntityType, Room. Radius is multiplied by Grid Size (40). Values of X.5 will do the next value up (i.e. 0.5 -> 1) but will skip corners. Radius of 0 only targets the grid position
	local grid_entities = {};
	room = room or game:GetRoom();
	if room == nil or position == nil then return nil; end
	local skip_corners = ((radius - math.floor(radius)) > 0);
	if not radius or radius < 0.5 then return {room:GetGridEntityFromPos(position)}; else radius = math.floor(radius); end
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
	if grid_type == GridEntityType.GRID_ROCKB or grid_type == GridEntityType.GRID_PIT or grid_type == GridEntityType.GRID_LOCK or grid_type == GridEntityType.GRID_WALL or grid_type == GridEntityType.GRID_DOOR or grid_type == GridEntityType.GRID_TRAPDOOR or grid_type == GridEntityType.GRID_STAIRS or grid_type == GridEntityType.GRID_PRESSURE_PLATE or grid_type == GridEntityType.GRID_TELEPORTER or grid_type == GridEntityType.GRID_PILLAR or grid_type == GridEntityType.GRID_GRAVITY or grid_type == GridEntityType.GRID_STATUE or grid_type == GridEntityType.GRID_ROCK_SS then return false; end
	return true;
end

function Utils.CheckGridIndex(grid_index,room)
	room = room or game:GetRoom();
	if not grid_index then return; end
	local entities = Isaac.FindInRadius((room:GetGridPosition(grid_index) + Utils.VectorFrom(mod.GridSize / 2)), (mod.GridSize / 4));
	for _,entity in pairs(entities) do
		if entity.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE and entity.Visible then return false; end
	end
	local grid_entity = room:GetGridEntity(grid_index);
	if grid_entity and grid_entity.CollisionClass > GridCollisionClass.COLLISION_NONE and not Utils.IsGridTypeRemovable(grid_entity:GetType()) then return false; end
	return true;
end

function Utils.GetGridTile(grid_index,room) -- Get Room Grid Row / Column by grid_index, Room. Returns table array
	room = room or game:GetRoom();
	if room == nil or grid_index == nil then return; end
	return {(grid_index % room:GetGridWidth()),math.floor(grid_index / room:GetGridWidth())};
end

function Utils.GetSafeSpawnEntity(spawn_pos)
	local pathfinder_entity = game:Spawn(EntityType.ENTITY_GAPER,0,spawn_pos,Vector.Zero,nil,0,1):ToNPC();
	pathfinder_entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE;
	pathfinder_entity.Visible = false;
	pathfinder_entity.CanShutDoors = false;
	pathfinder_entity.SizeMulti = Utils.VectorFrom(0.5);
	pathfinder_entity.SpriteScale = Utils.VectorFrom(0.5);
	if REPENTOGON then pathfinder_entity:SetPauseTime(2000); else pathfinder_entity:AddMidasFreeze(EntityRef(Isaac.GetPlayer(0)), 2000); end
	return pathfinder_entity; 
end

function Utils.CheckSafeSpawnPosition(start_pos, target_pos, room) -- Vector, Vector, Room
	room = room or game:GetRoom();
	local safe_pos = false;
	local index = room:GetGridIndex(target_pos);
	local pathfinder_entity = Utils.GetSafeSpawnEntity(target_pos);
	local pathfinder = pathfinder_entity.Pathfinder;
	if pathfinder:HasPathToPos(start_pos,true) and Utils.CheckGridIndex(index,room) then safe_pos = true; end -- Checks if it is behind Pits or unbreakable obstacles or is on top of an entity
	pathfinder_entity:Remove();
	return safe_pos;
end

function Utils.GetSafeSpawnPosition(start_pos, target_pos, grid_steps, room) -- Vector, Vector, Steps int[] [X,Y,Initial], Room. Searches in a grid pattern (-1,1,2) -> Looks down 1 tile, then left 1, then down 1, etc
	room = room or game:GetRoom();
	local room_boundary = {Utils.GetGridTile(room:GetGridIndex(room:GetTopLeftPos()))[1],Utils.GetGridTile(room:GetGridIndex(room:GetBottomRightPos()))[1]};
	local index = room:GetGridIndex(target_pos);
	local end_index = grid_steps[1] > 0 and room:GetGridSize() or 0;
	local step = grid_steps[3] == 1 and {grid_steps[1],0} or {0,grid_steps[2]};
	local max_attempts = 10;
	local pathfinder_entity = Utils.GetSafeSpawnEntity(target_pos);
	for i = 1, max_attempts, 1 do
		if pathfinder_entity.Pathfinder:HasPathToPos(start_pos,true) and Utils.CheckGridIndex(index,room) then break; end -- Checks if it is behind/on Pits or unbreakable obstacles or is on top of an entity
		
		local tiles = Utils.GetGridTile(index);
		tiles[1] = tiles[1] + step[1];
		tiles[2] = tiles[2] + step[2];
		if tiles[1] < room_boundary[1] or tiles[1] > room_boundary[2] or i == max_attempts then -- Failed to find safe position, return starting target position
			pathfinder_entity.Position = target_pos;
			break;
		end
		step = step[1] == 0 and {grid_steps[1],0} or {0,grid_steps[2]};
		if tiles[2] > room:GetGridHeight() then tiles[1] = tiles[1] + grid_steps[1]; tiles[2] = 1; elseif tiles[2] < 1 then tiles[1] = tiles[1] + grid_steps[1]; tiles[2] = room:GetGridHeight(); end

		index = room:GetGridIndexByTile(tiles); -- IDK why REPENTOGON doesn't use Vector here, int[] is weird
		pathfinder_entity.Position = room:GetGridPosition(index);
	end
	local safe_pos = Utils.Clone(pathfinder_entity.Position);
	pathfinder_entity:Remove();
	return safe_pos;
end

function Utils.GetSafeSpawnPositionInRadius(player_pos, target_pos, radius, room) -- Vector, Vector, Number, Room. Searches in a grid pattern left -> right then down
	room = room or game:GetRoom();
	local skip_corners = ((radius - math.floor(radius)) > 0);
	if not radius or radius < 0.5 then radius = 0.1; else radius = math.floor(radius); end
	local checkSize = (mod.GridSize * radius);
	local start_pos = Vector(target_pos.X - checkSize, target_pos.Y - checkSize);
	local index = room:GetGridIndex(start_pos);
	local pathfinder_entity = Utils.GetSafeSpawnEntity(start_pos);
	for x = target_pos.X - checkSize, target_pos.X + checkSize, mod.GridSize do
		for y = target_pos.Y - checkSize, target_pos.Y + checkSize, mod.GridSize do
			if pathfinder_entity.Pathfinder:HasPathToPos(player_pos,true) and Utils.CheckGridIndex(index,room) then break; end -- Checks if it is behind/on Pits or unbreakable obstacles or is on top of an entity
			index = room:GetGridIndex(Vector(x,y));
			local pos = room:GetGridPosition(index);
			
			if skip_corners and (x == target_pos.X - checkSize or x == target_pos.X + checkSize) and (y == target_pos.Y - checkSize or y == target_pos.Y + checkSize) then goto continue; end

			pathfinder_entity.Position = pos;
			::continue::
		end
	end
	local safe_pos = Utils.Clone(pathfinder_entity.Position);
	pathfinder_entity:Remove();
	return safe_pos;
end