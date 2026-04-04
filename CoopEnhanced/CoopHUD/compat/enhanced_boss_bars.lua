local mod = CoopEnhanced
local CoopHUD = CoopEnhanced.CoopHUD

function CoopHUD.EnhancedBossBars()
	if not HPBars then return; end
	
	HPBars.getBarPosition = function(_,bossCount)
		local screenCenter = HPBars:getScreenSize();
		local barPadding = HPBars.Config.BarPadding;
		
		local deals_anchor = mod.CoopHUD.Stats.Deals.Visible and mod.CoopHUD.Stats.Deals.Anchor or -1;
		local pickups_anchor = mod.CoopHUD.Misc.Pickups.Visible and mod.Config.CoopHUD.misc.pickups.anchor or -1;
		local wave_anchor = mod.CoopHUD.Misc.Wave.Visible and mod.Config.CoopHUD.misc.wave.anchor or -1;
		
		if HPBars.Config.Position == "Bottom" then
			local barSize = HPBars.barSizes.horizontal[math.min(bossCount, 10)];
			if mod.Config.CoopHUD.mods.EBB.auto_pad then
				local min_padding = 0;
				if deals_anchor == 0 then min_padding = min_padding + (mod.Config.CoopHUD.stats.scale.Y * 17); end
				if pickups_anchor == 0 then min_padding = min_padding + (mod.Config.CoopHUD.misc.pickups.scale.Y * 17); end
				if wave_anchor == 0 then min_padding = min_padding + (mod.Config.CoopHUD.misc.wave.scale.Y * 17); end
				return Vector(screenCenter.X / 2 - (bossCount * barSize) / 2 - ((bossCount - 1) * barPadding),screenCenter.Y - math.max(min_padding,HPBars.Config.ScreenPadding));
			else
				return Vector(screenCenter.X / 2 - (bossCount * barSize) / 2 - ((bossCount - 1) * barPadding),screenCenter.Y - HPBars.Config.ScreenPadding);
			end
		elseif HPBars.Config.Position == "Top" then
			local barSize = HPBars.barSizes.horizontal[math.min(bossCount, 10)];
			if mod.Config.CoopHUD.mods.EBB.auto_pad then
				local min_padding = 0;
				if deals_anchor == 1 then min_padding = min_padding + (mod.Config.CoopHUD.stats.scale.Y * 17); end
				if pickups_anchor == 1 then min_padding = min_padding + (mod.Config.CoopHUD.misc.pickups.scale.Y * 17); end
				if wave_anchor == 1 then min_padding = min_padding + (mod.Config.CoopHUD.misc.wave.scale.Y * 17); end
				return Vector(screenCenter.X / 2 - (bossCount * barSize) / 2 - ((bossCount - 1) * barPadding),math.max(min_padding,HPBars.Config.ScreenPadding));
			else
				return Vector(screenCenter.X / 2 - (bossCount * barSize) / 2 - ((bossCount - 1) * barPadding),HPBars.Config.ScreenPadding);
			end
		elseif HPBars.Config.Position == "Left" then
			local barSize = HPBars.barSizes.vertical[math.min(bossCount, 10)];
			return Vector(math.max(25,HPBars.Config.ScreenPadding) * 2,screenCenter.Y / 2 + (bossCount * barSize) / 2 + ((bossCount - 1) * barPadding));
		else
			local barSize = HPBars.barSizes.vertical[math.min(bossCount, 10)];
			return Vector(screenCenter.X - math.max(25,HPBars.Config.ScreenPadding) * 2,screenCenter.Y / 2 + (bossCount * barSize) / 2 + ((bossCount - 1) * barPadding));
		end
	end
end