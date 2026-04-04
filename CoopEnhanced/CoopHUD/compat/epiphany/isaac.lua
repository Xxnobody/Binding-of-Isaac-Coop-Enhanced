local M = {}
local mod = CoopEnhanced
local CoopHUD = CoopEnhanced.CoopHUD

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


function M.EpiphanyIsaacFunc(pEntity, _, edge_indexed, edge_multipliers)
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

return M
