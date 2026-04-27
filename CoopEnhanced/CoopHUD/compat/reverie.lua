local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;

function CoopHUD.Reverie()
	if not Reverie then return; end
	local Players = CuerLib.Players;
	local SatoriB = Reverie.Players.SatoriB;
	local SeijaB = Reverie.Players.SeijaB;
	local barWidthScale = 1;
	local barOriginOffset = 0;
	local renderAddiction = 0;
	local barAlpha = 1;
	
	local function RenderAddictionBar (player_entity)
		if (not Game():GetHUD():IsVisible() and not CoopHUD.IsVisible()) or Game():GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) then return; end

		local spr = SatoriB.AddictionBarSpr;
		local hudOffset = Options.HUDOffset;
		local x = 80 + 20 * hudOffset;
		local y = 40 + 12 * hudOffset;

		local pos = Vector(x, y) + (mod.Config.CoopHUD.compat.REVERIE.addictbar.offset * mod.Config.CoopHUD.compat.REVERIE.addictbar.scale);
		local unitLength = 5;
		local addiction = SatoriB:GetAddiction(player_entity);
		local showGradutionCount = math.max(6, math.abs(addiction) * 1.2) + 6;

		local targetAlpha = 0.8;
		for p, player in ipairs(Players.GetPlayers()) do
			local position = Isaac.WorldToScreen(player.Position);
			if (position:DistanceSquared(pos) < 6400) then
				targetAlpha = 0.2;
			end
		end

		local targetScale = showGradutionCount / 12
		local targetOriginOffset = 0;
		if (addiction < 0) then
			targetOriginOffset = 30-6 * unitLength / barWidthScale;
		else
			targetOriginOffset = 6 * unitLength / barWidthScale - 30;
		end
		barWidthScale = (barWidthScale + (targetScale - barWidthScale) * 0.2) * mod.Config.CoopHUD.compat.REVERIE.addictbar.scale.X;
		barOriginOffset = barOriginOffset + (targetOriginOffset - barOriginOffset) * 0.2;
		renderAddiction = renderAddiction + (addiction - renderAddiction) * 0.2;
		barAlpha = (barAlpha + (targetAlpha - barAlpha) * 0.2) * mod.Config.CoopHUD.compat.REVERIE.addictbar.opacity;

		local maxGraduationCount = math.floor(6 * barWidthScale);
		local originPos = pos + Vector(barOriginOffset, 0);

		spr.Color = Color(1, 1, 1, barAlpha);
		spr:RenderLayer(0, pos);

		-- Bar.
		local sign = 1;
		spr.Color = Color(0.5, 0.5, 0.5, barAlpha);
		if (renderAddiction < 0) then
			sign = -1;
			spr.Color = Color(1, 0.5, 0.8, barAlpha);
		end
		local abs = math.max(1,math.abs(renderAddiction * unitLength) / barWidthScale);
		spr.Scale = Vector(-sign * abs, 1) * mod.Config.CoopHUD.compat.REVERIE.addictbar.scale;
		spr:RenderLayer (3, originPos);
		spr.Scale = Vector.One * mod.Config.CoopHUD.compat.REVERIE.addictbar.scale;
		spr.Color = Color(1, 1, 1, barAlpha);
		-- Graduations.
		for i = -maxGraduationCount, maxGraduationCount do
			spr:RenderLayer (1, pos - Vector(unitLength * i / barWidthScale, 0));
		end
		-- Origin.
		spr:RenderLayer (2, originPos);
	end
	
	local function onRender()
		local localIndex = CuerLib.NetCoop.GetLocalPlayerIndex();
		local player;
		if (localIndex < 0) then -- Single Player.
			player = Game():GetPlayer(0);
		else -- Net Coop.
			player = Game():GetPlayer(localIndex);
		end
		if (player and player:GetPlayerType() == SatoriB.Type) then
			RenderAddictionBar(player);
		end
		
		if (player and player:GetPlayerType() == SeijaB.Type) then
			local font = Reverie.GetFont("SEIJAB_UPGRADE");
			local hudOffset = Options.HUDOffset;
		
			local x = 35 + 20 * hudOffset;
			local y = 40 + 12 * hudOffset;
			local pos = Vector(x, y) + (mod.Config.CoopHUD.compat.REVERIE.quality.offset * mod.Config.CoopHUD.compat.REVERIE.quality.scale);
				
			SeijaB.Quality4Sprite.Scale = mod.Config.CoopHUD.compat.REVERIE.quality.scale;
			SeijaB.Quality4Sprite:Render(pos);
			font:DrawStringScaledUTF8(SeijaB:GetUpgradeLevel(player), pos.X + 8, pos.Y - 7, mod.Config.CoopHUD.compat.REVERIE.quality.scale.X, mod.Config.CoopHUD.compat.REVERIE.quality.scale.Y, KColor.White, 0, false)
			if (EID) then
				if EID.player and EID.player:GetPlayerType() == SeijaB.Type then
					EID:addTextPosModifier("SeijaB HUD", Vector(0,18))
				else
					EID:removeTextPosModifier("SeijaB HUD")
				end
			end
		end
	end
	mod:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.LATE, onRender);
end
