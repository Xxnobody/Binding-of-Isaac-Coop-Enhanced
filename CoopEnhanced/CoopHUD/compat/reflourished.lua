local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;
local game = Game();

function CoopHUD.Reflourished()
	if not IsaacReflourished then return; end
	
	local last_wave = 0;
	local wavebar_animation = "gfx/ui/boss_rush_bar2.anm2";
	local function BossCounter(misc_data)
		if not mod.Config.CoopHUD.misc.wave.background or not misc_data["Wave"] then return; end
		local sprite = misc_data["Wave"][1].Sprite or nil;
		local data = misc_data["Wave"][1].Data or nil;
		if sprite and data and data.Type == "bossrush" then
			if not mod.Config.CoopHUD.mods.REFLOURISHED.boss_counter.enabled then
				if sprite:GetFilename() ~= mod.Animations.Waves then sprite:Load(mod.Animations.Waves, true); end
				return;
			end
			data.Animated = true;
			data.Pos = data.Pos + Vector(30,10); --Needs to be offset due to how the anim2 file sets positions
			if data.Wave.Current == 0 or Game():GetRoom():IsAmbushDone() then data.Text = nil; end
			if data.Text then data.Text.Pos.Y = data.Text.Pos.Y - 6; end
			if sprite:GetFilename() ~= wavebar_animation then sprite:Load(wavebar_animation, true); end
			if data.Wave.Current ~= last_wave then
				last_wave = data.Wave.Current;
				if data.Wave.Current == 1 then sprite:Play("Stage1");
				elseif data.Wave.Current % (data.Wave.Max//5) == 0 and not Game():GetRoom():IsAmbushDone() then
					sprite:Play(("Stage" .. ((data.Wave.Current//(data.Wave.Max//5)) + 1)), true);
				end
			elseif data.Wave.Current == data.Wave.Max and Game():GetRoom():IsAmbushDone() then
				if sprite:GetAnimation() ~= "Break" then sprite:Play("Break", true); elseif sprite:IsFinished("Break") then data.Animated = false; end
			end
		end
	end
	
	local function ExcitedTimer()
		local excitedEffect = Isaac.GetNullItemIdByName("RF I'm Excited")
		local anyPlayerHasExcited = false;
		local playerTimers = {};
		local fadeAlpha = {};

		local timer = Sprite();
		timer:Load("gfx/excited pill timer.anm2",true);
		timer:SetFrame("Default", 0);
		
		local function RenderTimer(player_entity)
			local player_data = CoopHUD.getDataFromEntity(player_entity);
			if not mod.Config.CoopHUD.mods.REFLOURISHED.excited_timer.enabled or not player_data then return; end
			local controller_index = player_entity.ControllerIndex;
			local cooldown = playerTimers[controller_index];
			local seconds = math.ceil((cooldown / 30 % 30));
			
			local config = mod.Config.CoopHUD.mods.REFLOURISHED.excited_timer;
			
			local isMapDown = CoopHUD.IsPlayerMapDown[controller_index];
			
			local isVisible = config.display == 3 and (seconds <= 9 or seconds > 26) or (config.display == 0 or (config.display == 1 and isMapDown) or (config.display == 2 and not isMapDown));
			if not isVisible then return; end
			
			local showSeconds = IsaacReflourished:GetSettingsValue("ExcitedTimerShowSeconds") == 2;
			local displayPos = IsaacReflourished:GetSettingsValue("ExcitedTimerDisplayPos");
			fadeAlpha[controller_index] = fadeAlpha[controller_index] or 0;

			if config.display == 3 then
				fadeAlpha[controller_index] =  CoopHUD.IsPlayerMapDown[controller_index] and math.min(config.opacity, fadeAlpha[controller_index] + config.fade_speed) or math.max(0, fadeAlpha[controller_index] - config.fade_speed);
			else
				fadeAlpha[controller_index] = config.opacity;
			end
			if fadeAlpha[controller_index] <= 0 then return; end

			local pos = (config.anchor == 0 or not player_data) and Isaac.WorldToScreen(player_entity.Position) + config.offset + Vector(-1, -41) or player_data.Edge.Pos + ((config.offset + CoopHUD.Positions.Trinket[1] + Vector(16,0)) * player_data.Edge.Multipliers)
			if displayPos and displayPos == 2 then
				pos = pos + Vector(-13, 45);
			end
			local timerFrame = 15 - math.floor(seconds / 2);

			if Game():GetRoom():IsMirrorWorld() and config.anchor == 0 then
				local midPos = Isaac.GetScreenWidth() / 2;
				local diff = midPos - pos.X;
				pos = Vector(midPos + diff, pos.Y) + Vector(-2, -2);
			end

			timer.Scale = config.scale;
			timer:SetFrame("Default", timerFrame);
			timer.Color = Color(1, 1, 1, fadeAlpha[controller_index]);  -- set icon transparency
			timer:Render(pos);

			local color = KColor(1, 1, 1, fadeAlpha[controller_index] * 0.8);  -- slightly lower alpha for text
			if showSeconds then
				mod.Fonts.CoopHUD.timer:DrawStringScaled(tostring(seconds), pos.X + 5, pos.Y + 2, 0.75, 0.75, color, 0, false);
			end
		end

		mod.Registry.AddCallback(mod.Callbacks.HUD_POST_PLAYER_RENDER, function()
			if not anyPlayerHasExcited or RoomTransition.GetTransitionMode() ~= 0 then return; end
			for _, player_entity in pairs(PlayerManager.GetPlayers()) do
				if playerTimers[player_entity.ControllerIndex] then
					RenderTimer(player_entity);
				end
			end
		end);

		local function UsePill(_, effect, player_entity, flags)
			playerTimers[player_entity.ControllerIndex] = 600;
			anyPlayerHasExcited = true;
		end
		mod:AddCallback(ModCallbacks.MC_USE_PILL, UsePill, PillEffect.PILLEFFECT_IM_EXCITED);

		local function NewGame(_,isContinued)
			anyPlayerHasExcited = false;
			playerTimers = {};
			fadeAlpha = {};
		end
		mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, NewGame);

		local function Countdown(_,player_entity)
			if not anyPlayerHasExcited then return; end
			local cooldown = playerTimers[player_entity.ControllerIndex];
			if not cooldown then return; end

			if cooldown <= 0 then
				playerTimers[player_entity.ControllerIndex] = nil;
				local playersHaveExcited = false;
				for _, player_entity in pairs(PlayerManager.GetPlayers()) do
					if playerTimers[player_entity.ControllerIndex] and playerTimers[player_entity.ControllerIndex] > 0 then
						playersHaveExcited = true;
					end
				end
				if not playersHaveExcited then anyPlayerHasExcited = false; end
				return;
			end

			playerTimers[player_entity.ControllerIndex] = math.max(0, cooldown - 1);
		end
		mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Countdown);

		local function CleanTable(_,player_entity)
			local controller_index = player_entity.ControllerIndex;
			if playerTimers[controller_index] then playerTimers[controller_index] = nil; end
			if fadeAlpha[controller_index] then fadeAlpha[controller_index] = nil; end
		end
		mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, CleanTable, EntityType.ENTITY_PLAYER);
	end
	
	mod:AddCallback(IsaacReflourished.SaveManager.SaveCallbacks.POST_DATA_LOAD, function()
		local save_data = IsaacReflourished.SaveManager.GetDeadSeaScrollsSave();
		if save_data and save_data.Toggles and save_data.Toggles["ExcitedTimerEnabled"] then ExcitedTimer(); end
		if mod.Config.CoopHUD.mods.REFLOURISHED.boss_counter.enabled then
			if save_data and save_data.Toggles then save_data.Toggles["bossRushWaveCounterEnabled"] = false; end
			mod.Registry.AddCallback(mod.Callbacks.HUD_POST_MISC_UPDATE, BossCounter);
		end
	end);
end