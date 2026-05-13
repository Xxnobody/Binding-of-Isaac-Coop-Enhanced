local mod = CoopEnhanced
local CoopHUD = CoopEnhanced.CoopHUD

local Uils = mod.Utils

function CoopHUD.Epiphany()
	if not Epiphany then return end
	
	local function renderGlowSprite(player_save, inventory, renderPos, i)
		local glowSprite = Sprite()
		glowSprite:Load("gfx/ui/tarnished_isaac_hud.anm2", true)
		glowSprite:ReplaceSpritesheet(1, "gfx/ui/generic_glow_32.png")
		glowSprite:LoadGraphics()
		glowSprite:SetFrame("Icon", 0)

		if (player_save.BD_BONUS_BLIGHT and player_save.BD_BONUS_BLIGHT >= 1 and inventory.items[i+1] ~= nil)
		or inventory.items[i+1] == Epiphany.Item.BLIGHTED_DICE.BLIGHT then
			glowSprite.Color = Color(1, .8, .6, -- Set transparency and colour
				math.sin(Game():GetFrameCount()/10)/3 + 1
			)
			glowSprite:Render(renderPos)
		end
	end

	local function renderBlightSprite(pEntity, player_save, inventory, renderPos, i)
		local rotTarget = Epiphany.Character.ISAAC:FindRotTarget(pEntity)
		local rotTargetFound = false

		local blightSprite = Sprite()
		blightSprite:Load("gfx/ui/tarnished_isaac_hud.anm2", true)
		blightSprite:ReplaceSpritesheet(1, "gfx/items/collectibles/blight.png")
		blightSprite:LoadGraphics()
		blightSprite:SetFrame("Icon", 0)

		if (not rotTargetFound) and rotTarget and inventory.items[i+1] == rotTarget then
			player_save.BD_ROT_BUILDUP = player_save.BD_ROT_BUILDUP or 0
			local rotPercentage = player_save.BD_ROT_BUILDUP / Epiphany.Character.ISAAC.ROT_CAP

			player_save.BlightWhiteOffset = player_save.BlightWhiteOffset or 0
			player_save.BlightWhiteOffset = math.max(0, player_save.BlightWhiteOffset-0.02)

			blightSprite.Color = Color(1, 1, 1, -- Set transparency and colour
				(math.sin(Game():GetFrameCount()/10)/4 + 1)*rotPercentage + player_save.BlightWhiteOffset,
				player_save.BlightWhiteOffset, player_save.BlightWhiteOffset, player_save.BlightWhiteOffset
			)
			blightSprite:Render(renderPos)
			rotTargetFound = true
		end
	end
	
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

	local function EpiphanySamsonCharge(_, player, offset)
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

	local function EpiphanyCainCharge(_, player, offset)
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

	local function EpiphanyIsaacFunc(pEntity, _, edge_indexed, edge_multipliers)
		if pEntity:GetPlayerType() ~= Epiphany.PlayerType.ISAAC then return end

		local position = edge_indexed + (mod.Config.CoopHUD.inventory.special.pos * edge_multipliers)

		-- Code taken from Epiphany, modified to work with render and config system
		Epiphany.Character.ISAAC:HandleInventoryRotation(pEntity)

		local numColumns = 4
		local player_save = Epiphany:PlayerRunSave(pEntity)
		local inventory, inventorySprites = Epiphany.Character.ISAAC:GetInventory(pEntity)

		for i = 0, inventory.cap - 1 do
			local renderPos = position + (mod.Config.CoopHUD.inventory.special.spacing * Vector(i % numColumns, i // numColumns))

			renderGlowSprite(player_save, inventory, renderPos, i)

			inventorySprites[i + 1]:Render(renderPos)

			renderBlightSprite(pEntity, player_save, inventory, renderPos, i)
		end

		local selected = inventory.selected - 1
		Epiphany.Character.ISAAC.SpriteFrame:Render(
			position + (mod.Config.CoopHUD.inventory.special.spacing * Vector(selected % numColumns, selected // numColumns))
		)
	end

	local function EpiphanyHudHelper(player_entity, _, edges, edge_multipliers)
		for _, v in pairs(HudHelper.HUD_ELEMENTS) do
			if v.Condition(player_entity) and v.Name ~= "TR Isaac Inventory" then
				v.OnRender(player_entity, edges + (mod.Config.CoopHUD.compat.EPIPHANY.hud_element_pos * edge_multipliers))
			end
		end
	end
	
	local function GetHeartSprite(heartSprite, goldenSprite, overlaySprite)
		return {
			heart = heartSprite,
			golden = goldenSprite,
			overlay = overlaySprite,
		}
	end

	local function EpiphanyLostHealth(hearts, pEntity, _)
		if not CoopHUD.isVisible or Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN > 0 then return end
		if pEntity:IsDead() or pEntity:IsCoopGhost() or pEntity:GetPlayerType() ~= Epiphany.PlayerType.LOST then return end

		hearts[1].heart:Load("gfx/ui/lost_health_hud.anm2", true)
		hearts[1].heart:SetFrame("Idle", 0)

		if pEntity:GetData().EP_ShouldHaveMantleCostume then
			hearts[1].heart:SetFrame("Idle", 1)
		end
	end

	local function EpiphanyKeeperHealth(hearts, pEntity, _)
		if not CoopHUD.isVisible or Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN > 0 then return end
		if pEntity:IsDead() or pEntity:IsCoopGhost() or pEntity:GetPlayerType() ~= Epiphany.PlayerType.KEEPER then return end

		local function createSprite()
			local MoneyHealthHud = Sprite()
			MoneyHealthHud:Load("gfx/ui/money_health_hud.anm2", true)
			MoneyHealthHud:SetFrame("HUD", 0)
			MoneyHealthHud.Color = Color(1, 1, 1)
			if pEntity:GetSoulHearts() == 1 then
				local interval = (math.ceil((Game():GetFrameCount() + 1) / 45) * 45 - (Game():GetFrameCount() + 1))
				local alpha = math.max((interval - 30) / 15, 0)
				MoneyHealthHud.Color = Color(1, 1, 1, 1, alpha / 2)
			else
				if pEntity:GetData().TRK_HPFlashEpoch and Game():GetFrameCount() - pEntity:GetData().TRK_HPFlashEpoch <= 5 then
					MoneyHealthHud.Color = Color(1, 1, 1, 1, 0.25, 0.25, 0.25)
				end
			end
			return MoneyHealthHud
		end

		local COIN_MAX_LOSS = 20

		local Money = pEntity:GetNumCoins()
		local MoneyByDollar = math.floor(math.max(Money - 1, 0) / 100)
		local MoneyByDollarMod = math.max(Money - 1, 0) % 100
		local MoneyByDDime = math.floor(MoneyByDollarMod / COIN_MAX_LOSS)
		if Money == 0 then
			FullGoldHeart = 0
			HalfGoldHeart = 1
		else
			FullGoldHeart = 1
			HalfGoldHeart = 0
		end
		local MoneyInCash = {
			{ HalfGoldHeart, "Half Gold Heart" },
			{ FullGoldHeart, "Full Gold Heart" },
			{ MoneyByDollar, "Dollars" },
			{ MoneyByDDime, "Double Dimes" },
		}

		for i = 1, #hearts, 1 do
			hearts[i] = nil
		end

		for i = 1, #MoneyInCash do
			for _ = 1, MoneyInCash[i][1] do
				local heart = createSprite()
				heart:SetFrame("HUD", i)
				table.insert(hearts, GetHeartSprite(heart, nil, nil))
			end
		end
		for _ = 1, pEntity:GetBrokenHearts() do
			local heart = createSprite()
			if pEntity:HasCollectible(416) then
				heart:SetFrame("HUD", 8)
			else
				heart:SetFrame("HUD", 7)
			end
			table.insert(hearts, GetHeartSprite(heart, nil, nil))
		end
		local heart = createSprite()
		local player_save = Epiphany:PlayerRunSave(pEntity)
		if player_save.TRK_HPMantle and player_save.TRK_HPMantle == true then
			heart:SetFrame("HUD", 6)
		else
			heart:SetFrame("HUD", 5)
		end
		table.insert(hearts, GetHeartSprite(heart, nil, nil))
	end

	local function EpiphanyMultitool(misc, _, _, _)
		local run_save = Epiphany:RunSave()

		if run_save["MultitoolCount"] and run_save["MultitoolCount"] < 1 then
			return
		end
		if run_save["HUDDifference"] then
			misc[4].Anim = "gfx/ui/multitoolhud.anm2";
		end
	end
end