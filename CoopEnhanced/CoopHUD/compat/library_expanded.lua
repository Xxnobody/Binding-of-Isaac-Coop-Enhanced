local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

function CoopHUD.LibraryExpanded()
	if not LibraryExpanded then return; end
	local WEIRD_BOOK = LibraryExpanded.Item.WEIRD_BOOK;

	local function RenderWeirdbook(sprite,item_data,sprite_data,player_entity)
		local run_save = SaveHelper.RunSave(LibraryExpanded);
		local path = "";
		if not LibraryExpanded:IsPlayerDying(player_entity) and not player_entity:IsDead() and run_save.MimickedBooks then
			local player_save = LibraryExpanded:PlayerRunSave(player_entity);
			if not player_save.CurrentDisplayedBook or (run_save.MimickedBooks and player_save.CurrentDisplayedBook ~= run_save.MimickedBooks[player_save.BookIndex]) then
				WEIRD_BOOK:LoadCurrentBookSprite(player_entity);
			end
			local book = WEIRD_BOOK:GetChosenBook(player_entity);
			path, _ = WEIRD_BOOK:GetFileNameFromBook(book);
		else
			path = (run_save.MimickedBooks and WEIRD_BOOK:GetChosenBook(player_entity).GfxFileName or Isaac.GetItemConfig():GetCollectible(item_data.Item.ID).GfxFileName);
		end
		sprite_data.Sheets[0],sprite_data.Sheets[1],sprite_data.Sheets[2] = path,path,path;
	end

	CoopHUD.Item.Active.Special[WEIRD_BOOK.ID] = function(sprite,item_data,sprite_data,player_entity)
		RenderWeirdbook(sprite,item_data,sprite_data,player_entity);
	end
end