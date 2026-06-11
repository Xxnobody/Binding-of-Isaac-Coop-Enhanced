local mod = CoopEnhanced
local CoopHUD = CoopEnhanced.CoopHUD

local game = Game();
local Utils = mod.Utils;

function CoopHUD.FancyBossBar()
	if not FancyBossBar then return; end
	
	local bosses = {};
	local cleanHp = false;
	local appearAnim = "";
	local deathAnim = "";
	
	local BarSprites = {big = Utils.CloneSprite(FancyBossBar.bossBarsSprites["big"]),big = Utils.CloneSprite(FancyBossBar.bossBarsSprites["small"])};
	
	local shouldRenderBigIcon = function()
		if not HPBars then
			local room = game:GetRoom();
			return room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_BOSSRUSH or room:GetType() == RoomType.ROOM_CHALLENGE or game:GetLevel():GetStage() == LevelStage.STAGE8;
		end
		return true;
	end
	
	local shouldIgnoreBossEntity = function(ent)
		if HPBars then
			return HPBars:evaluateEntityIgnore(ent);
		end
		return ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or ent:HasEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP) or not ent:CanShutDoors();
	end
	
	local shouldRestrictBossCount = function()
		local room = game:GetRoom();
		if HPBars then
			return HPBars:isIgnoreMegaSatanFight() or (not HPBars.Config["DisplayWithSpidermod"] and HPBars:hasSpiderMod()) or (not HPBars.Config["ShowInMotherFight"] and room:GetBossID() == 88) or (not HPBars.Config["ShowInBeastFight"] and game:GetLevel():GetStage() == 13 and room:GetType() == RoomType.ROOM_DUNGEON) or room:GetBossID() == 83;
		else
			return room:GetBossID() == 55 or room:GetBossID() == 88 or room:GetBossID() == 83 or (game:GetLevel():GetStage() == 13 and room:GetType() == RoomType.ROOM_DUNGEON);
		end
	end
	
	local function GetFancyBossBar(id)
		id = id or shouldRenderBigIcon() and "big" or "small";
		return FancyBossBar.bossBarsSprites[id];
	end

	local function handleBossBarSprite()
		if not CoopHUD.Visible then return; end
		local bossBarSprite = GetFancyBossBar();

		if not shouldRestrictBossCount() then
			for _,ent in pairs(Isaac.GetRoomEntities()) do
				if ent:IsBoss() and not shouldIgnoreBossEntity(ent) and not bosses[ent.Index] then
					if REPENTOGON and ent.Type == EntityType.ENTITY_DOGMA then
						bossBarSprite:SetRenderFlags(AnimRenderFlags.STATIC);

						bossBarSprite:ReplaceSpritesheet(8, "gfx/ui/ui_bosshealthbarskull_dogma.png");
						bossBarSprite:ReplaceSpritesheet(9, "gfx/ui/ui_bosshealthbarskull_dogma.png", true);
					end
					bosses[ent.Index] = ent;
				end
			end
		end

		local sortedBosses = {} ---@type table<integer, Entity>
		for i, ent in pairs(bosses) do
			if not ent:Exists() or (HPBars and ent:IsDead()) or shouldIgnoreBossEntity(ent) then
				bosses[i] = nil;
			else
				table.insert(sortedBosses, ent);
				if ent.MaxHitPoints > 0 and not cleanHp then cleanHp = true; end
			end
		end
		table.sort(sortedBosses, function(a, b) return a.Index < b.Index end);

		if FancyBossBar.renderBossBar then bossBarSprite:Update(); end
		
		local function pickAppearAnim()
			if not (FancyBossBar.Config["RandomDisableGlitter"] and math.random(0, 1) == 1) then
				if FancyBossBar.Config["BarGlitter"] or (HPBars and not blackListedBarStyles[HPBars.Config["BarStyle"]]) then
					return "Appear";
				end
			end
			return "AppearWithoutGlitter";
		end
		
		if #sortedBosses > 0 and cleanHp then
			if not appearAnim then appearAnim = pickAppearAnim(); end

			if not FancyBossBar.renderBossBar then FancyBossBar.renderBossBar = true; end

			if not bossBarSprite:IsPlaying(appearAnim) and not bossBarSprite:IsFinished(appearAnim) then
				bossBarSprite:Play(appearAnim, true);
				if FancyBossBar.Config.DisableBarStartAnim then
					bossBarSprite:SetLastFrame();
				end
			end
		elseif #sortedBosses == 0 and FancyBossBar.renderBossBar then
			if not deathAnim then
				deathAnim = (FancyBossBar.Config["DisableDeathBarBlink"] or (FancyBossBar.Config["RandomDisableGlitter"] and math.random(0, 1) == 1)) and "DeathWithoutBlink" or "Death";
			end

			bossBarSprite:Play(deathAnim);
			appearAnim = nil;

			if bossBarSprite:IsFinished(deathAnim) then
				FancyBossBar.renderBossBar = false;
				FancyBossBar.forceBottomBossBarPosition = false;
				cleanHp = false;
				deathAnim = nil;
			end
		end
	end
	mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.LATE, handleBossBarSprite);
	
	FancyBossBar:RemoveCallback(ModCallbacks.MC_POST_HUD_RENDER, FancyBossBar.onRender)
	FancyBossBar:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, function(shadername) if not CoopHUD.Visible then FancyBossBar.onRender(shadername); end end)
	
	local function onRender()
		if CoopHUD.Visible and not FancyBossBar.forceBossBarDisable and FancyBossBar.renderBossBar then
			local screenSize = Utils.GetScreenDimensions().Max;
			local isTop = not FancyBossBar.Config["BossBarOnBottom"] and not FancyBossBar.forceBottomBossBarPosition;
			local yOffset = isTop and 10 or -14;

			local hudOffset = isRepentance and Options.HUDOffset or FancyBossBar.Config["HUDOffset"];
			local bar_sprite = GetFancyBossBar();

			if HPBars then
				if HPBars.Config["Sorting"] == "Vanilla" and (HPBars.Config["Position"] == "Top" or HPBars.Config["Position"] == "Bottom") and HPBars.Config["ShowIcons"] and not HPBars.Config["ShowCustomIcons"] then
					bar_sprite:Render(HPBars:getBarPosition(1) - Vector(7, 0), Vector.Zero, Vector.Zero);
				end
			else
				local edge_multi = isTop and 1 or -1;
				if mod.Config.CoopHUD.compat.FBB.auto_pad.enabled then
					local deals_anchor = mod.CoopHUD.Stats.Deals.Visible and mod.CoopHUD.Stats.Deals.Anchor or -1;
					local pickups_anchor = mod.CoopHUD.Misc.Pickups.Visible and mod.Config.CoopHUD.misc.pickups.anchor or -1;
					local wave_anchor = mod.CoopHUD.Misc.Wave.Visible and mod.Config.CoopHUD.misc.wave.anchor or -1;
					
					local deals_padding = mod.Config.CoopHUD.compat.FBB.auto_pad.stats * mod.Config.CoopHUD.stats.scale.Y;
					local pickups_padding = mod.Config.CoopHUD.compat.FBB.auto_pad.pickups * mod.Config.CoopHUD.misc.pickups.scale.Y;
					local wave_padding = mod.Config.CoopHUD.compat.FBB.auto_pad.wave * mod.Config.CoopHUD.misc.wave.scale.Y;
					
					local min_padding = 0;
					if (isTop and deals_anchor == 1) or deals_anchor == 0 then min_padding = min_padding + deals_padding; end
					if (isTop and pickups_anchor == 1) or pickups_anchor == 0 then min_padding = min_padding + pickups_padding; end
					if (isTop and wave_anchor == 1) or wave_anchor == 0 then min_padding = min_padding + wave_padding; end
					yOffset = yOffset + (min_padding * edge_multi);
				end
				
				local bar_offset = Vector(-61, yOffset);
				local pos = (Vector(screenSize.X / 2, isTop and 12 * hudOffset or screenSize.Y - 12 * hudOffset) + bar_offset + (mod.Config.CoopHUD.compat.FBB.offset * Vector(1,edge_multi)));
				bar_sprite:Render(pos, Vector.Zero, Vector.Zero);
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_RENDER, onRender);
end