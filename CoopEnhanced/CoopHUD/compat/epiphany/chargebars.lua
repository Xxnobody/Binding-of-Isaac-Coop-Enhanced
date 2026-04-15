local M = {}
local mod = CoopEnhanced

-- Taken directly from Epiphany
local function RenderChargeBar(HUDSprite, charge, maxCharge, position)
	local chargePercent = math.min(charge / maxCharge, 1)

	if chargePercent == 1 then
		-- ChargedHUD:IsPlaying("StartCharged") and not
		if HUDSprite:IsFinished("Charged") or HUDSprite:IsFinished("StartCharged") then
			if not HUDSprite:IsPlaying("Charged") then
				HUDSprite:Play("Charged", true)
			end
		elseif not HUDSprite:IsPlaying("Charged") then
			if not HUDSprite:IsPlaying("StartCharged") then
				HUDSprite:Play("StartCharged", true)
			end
		end
	elseif chargePercent > 0 and chargePercent < 1 then
		if not HUDSprite:IsPlaying("Charging") then
			HUDSprite:Play("Charging")
		end
		local frame = math.floor(chargePercent * 100)
		HUDSprite:SetFrame("Charging", frame)
	elseif chargePercent == 0 and not HUDSprite:IsPlaying("Disappear") and not HUDSprite:IsFinished("Disappear") then
		HUDSprite:Play("Disappear", true)
	end

	HUDSprite:Render(position)
	HUDSprite:Update()
end

function M.EpiphanySamsonCharge(_, player, offset)
	if not mod.CoopHUD.isVisible or player:GetPlayerType() ~= Epiphany.PlayerType.SAMSON then return end

	local mainChargeBar = player:GetData().EP_Samson_MainChargeBar
	if not mainChargeBar then
		mainChargeBar = Sprite()
		mainChargeBar:Load("gfx/samson_charge_bar.anm2", true)
		mainChargeBar.PlaybackSpeed = 0.5
		player:GetData().EP_Samson_MainChargeBar = mainChargeBar
	end

	local samData = Epiphany.Character.SAMSON:GetSamsonState(player)
	local renderPos = Isaac.WorldToRenderPosition(player.Position) + offset + Vector(-11, -39)

	RenderChargeBar(mainChargeBar, samData.SlamCharge, samData.MaxSlamCharge, renderPos)
end



local bombWarning = Sprite()
bombWarning:Load("gfx/bomb_warning.anm2", true)
bombWarning:Play("Idle", true)
bombWarning.PlaybackSpeed = 0.5

local epsilon = 0.0001

function M.EpiphanyCainCharge(_, player, offset)
	if not mod.CoopHUD.isVisible
	or player:HasCollectible(Epiphany.Item.SHARP_ROCK.ID)
	or player:HasCurseMistEffect() and player:GetPlayerType() ~= Epiphany.PlayerType.CAIN then
		return
	end

	local THROWING_BAG = Epiphany.Item.THROWING_BAG

	local playerData = player:GetData().ThrowingBag

	if not playerData then
		playerData = {}
		player:GetData().ThrowingBag = playerData
	end

	local renderPos = Isaac.WorldToRenderPosition(player.Position) + offset

	if not playerData.OldQueuedItem then -- initialize the old queued item
		playerData.OldQueuedItem = player.QueuedItem
	end

	-- Render the bag sprite if we're holding an item
	local holdingItem = not playerData.OldQueuedItem.Item
		and player.QueuedItem.Item
		and player.QueuedItem.Item.Type ~= ItemType.ITEM_TRINKET

	if holdingItem and player.QueuedItem.Item.ID ~= CollectibleType.COLLECTIBLE_DADS_NOTE
		and player:HasCollectible(THROWING_BAG.ID)
	then
		playerData.OldQueuedItem = player.QueuedItem
		THROWING_BAG:CreateHodlingBagSprite(_, playerData, player.QueuedItem.Item.ID, true)
		player:AnimatePickup(playerData.BagPickupSprite)
	end

	if playerData.OldQueuedItem.Item and not player.QueuedItem.Item then
		playerData.OldQueuedItem = player.QueuedItem
	end

	-- Render the chargebar if we're charging a bag
	if Epiphany.GetSetting(Epiphany.Setting.ThrowingBagChargeBar) then
		local chargeBar = playerData.BagChargebar

		if not chargeBar then
			-- init charge bar if it doesn't exist
			chargeBar = Sprite()
			chargeBar:Load("gfx/chargebar.anm2", true)
			chargeBar.PlaybackSpeed = 0.5
			playerData.BagChargebar = chargeBar
		end

		local swingData = THROWING_BAG:GetPlayerSwingParams(player)

		if (swingData.SwingingDuration or 0) > epsilon then
			RenderChargeBar(chargeBar, swingData.SwingingDuration, THROWING_BAG:GetBagChargeTime(player), renderPos + Vector(0, 10))
		end


		-- Render bomb warning
		local hasBomb = false
		if (swingData.SwingingDuration or 0) > epsilon then
			for _, bag in pairs(swingData.SwingingBagRef) do
				if THROWING_BAG:GetSwingingBagData(bag) then
					local baggedBombs = THROWING_BAG:GetBagSwingParams(bag).BaggedBombs
					for _, bomb in pairs(baggedBombs) do
						if bomb:Exists() then
							hasBomb = true
							goto exit
						end
					end
				end
			end
		end
		::exit::

		if hasBomb then
			bombWarning.Color = Color(1, 1, 1)
		else
			bombWarning.Color = Color(1, 1, 1, 0)
		end
		bombWarning:Render(renderPos + Vector(0, 10), Vector.Zero, Vector.Zero)
		bombWarning:Update()
	end
end

return M
