# Co-op Enhanced
A comprehensive mod for The Binding of Isaac: Repentance that revamps Co-op in fun or needed ways. 

## Features
Here are each modules features. Each module can be totally disabled by the main Coop Enhanced config.
### Co-op HUD
	* Renders all vanilla HUD (active items, hearts, pocket items, and trinkets) in a standard position for all four players.
	* Press a keybind (H by default) or button combo on P1's controller to switch between Co-Op HUD and the default HUD.
	* Efficient Rendering code with caches and a configurable Refresh rate.
	* A plethora of settings are available for Items, Players, Stats, Pickups, Difficulty, Monster Waves, Twins, and more.
	* Collectible Display with plenty of options to track which player has what.
	* Customizable Font's for virtually every text HUD available.
	* Angel/Devil/Planetarium/Greed Machine/Library chances - with customizable positions.
	* Many HUD options can be set to show only when the Map button is/isn't held down, to help clear some clutter from the screen when not needed.
	* Player colors, Player heads, and Player naming, with many color options to choose from. Use a command to set yourself a custom name.
	* Hearts system utilizes Custom Health API to allow for more compatibility with other mods that use it and for more options.
	* Tons of API functions and callbnacks for other mods to give compatability.
	* Extremely customizable!
### Co-op Labels
	* Give characters labels to help find them on the screen.
	* Grants the ability to Tint characters and tears as well.
	* Plenty of options to help differentiate your character from others.
	* API callbacks to edit Labels on the fly.
### Co-op Marks
	* Adds Completion mark trackers to the Pausse screen for each player.
	* Vanilla-like, meaning they don't appear when no marks have been completed and work near-exact to the vanilla marks.
	* Configurable names and colors, and a few other cool options.
	* API callbacks to add/remove marks for mod makers.
### Co-op Treasures 
	* Treasure Rooms now will spawn a pedestal for every player.
	* Several options to customize your experience. (e.g. Make pedestals be assigned to players and stop others from grabbing your items, Set whether dead players spawn pedestals, Choose how pedestals are assigned, etc.)
	* Collectibles are seed accurate, meaning if you replay a seed all players will have the same items they did each replay. Works with rerolling, Chaos, Glitched Crown, etc.
	* Assigned pedestals will show the label of which player owns what, and will have the appropriate price (if playing Tainted Keeper).
	* Works with many room types, all of which are togglable/assignment configurable: Treasure Rooms, Silver Rooms (Greed Mode), Libraries, Planetariums, Angel Deals, Devil Deals, Secret Rooms, Super Secret Rooms, and Ultra Secret rooms. (By default only treasure rooms are enabled)
	* Smart Item Pedestal placement that checks if an area in a room is accessible and clear to help prevent placing pedestals in the void/wall, and clear rocks and other grid entities as needed.
	* API functions for mods to add room types, or callbacks to change room data depending on type/variant.
### Co-op Extras
	* Automatic Pricing! Items will have their prices adjusted according to whichever player is closest. Works with Devil Deals/Black Markets/Treasure Rooms and more, for characters like The Keeper, Lost, Blue Baby, etc. No more making everything expensive because one player is Tainted Keeper.
	* Ghost Player Flight! With custom options to prevent ghost players from grabbing pickups from areas they normally couldn't reach, stop them from opening chests, or even remove the ability to body block enemies (they're ghosts after all).
	* Greed Mode Revive Machine! Adds a revive machine to the Greed Mode shop that appears near the center on every floor after the first. (Not sure why this isn't vanilla)
### Co-op Fixes
	* A small Fullscreen tweak that resets the window to 0,0 and refreshes the screen whenever you start/restart a game. 
	* Fixes an issue where Co-op is prevented from starting due to the game sometimes incrementing the Room Visits counter too many times on first join. Configurable amount of room visits. (You can set room visits maximum to 0 to allow starting Co-op at any point in the run as long as it's the floor's starting room)
	* Fixes an issue where changing controller order before rejoining a game () or even just rejoining a game) could cause all characters to become the same. This tries to prevent that and prevent health loss due to your character being changed to another without red health or vice versa. Doesn't always work and needs more testing. If it doesn't work for you, several commands to change player type/health/items are available (see below).
	* API callbacks for each fix are available.

## Commands
	Many Co-op focused commands are included, which can be utilized by opening the console [`]. Most commands start with 'coop' and give autofill recommendations as you type.
	Here are the available commands added by each module and their respective options.
	['coop players print all']: Prints data to the console about each player (including twins) that can be used for all coop commands.
	['coop players print main']: Prints data to the console about each player (including twins) that can be used for all coop commands.

## Mod Support
I've attempted to make the mod as future proof and compatible as possible, adding various API implementations and avoiding hard-coded values where I could. Many mods have built-in support but many more do not. A lot of other mods won't need support added for this mod, but many large mods most likely will. Isaac modding is a headache at the best of times and the API lacks a lot of features, so compatibility will usually have to added by this mod or the other. I'm open to adding compatibility to many mods where possible, but it's easier to accomplish this when other mods use global variables. Some mods cannot be made compatible just due to the way they're written unfortunately.

#### HUD Rendering
Due to how Isaac HUD coding works, the original HUD is required to be hidden to render custom ones. Mod creators that add HUD elements tend to check if the HUD is visible before rendering their sprites, and so with Co-op HUD enabled, modded HUD elements almost always won't render. Support for this mod is as easy as adding an extra check to see if the Co-op Enhanced HUD is enabled. Adding 'if CoopEnhanced ~= nil and CoopEnhanced.CoopHUD.IsVisible' to any HUD visibility checks makes your mod compatible with the Co-op HUD rendering. If your mod adds custom HUD rendering and/or other features that don't render well with the Co-op HUD or if you would like a mod to have extra options when loaded along side Co-op Enhanced then please reach out and I can tweak things as needed.

#### Completion Marks
Repentagon adds a lot of features when it comes to Completion Marks but I'm pretty sure Mod's that add their own will require extra implementation to appear for the Coop Marks. I've added API callbacks to try and give modders the ability to add their own but this needs further testing.

#### Treasure Pedestals
Due to how some treasure rooms are layed out, the item pedestals may end up having weird/inaccessible placement. I've put many safety checks in to try and avoid this, but some rooms just need to be manually edited. There are API functions/callbacks to do this and can be easily implemented with 10 minutes of work.

## Required Mods
Some mods are required to get the full experience, some are just required.
#### Repentogon (https://steamcommunity.com/sharedfiles/filedetails/?id=3127536138)
- API extender.
- Isaac modding API is limited WITH Repentogon, so it's neccessary.
#### CustomHealthAPI (https://steamcommunity.com/sharedfiles/filedetails/?id=3699546779)
- Techinically you need a mod that uses CustomHealthAPI. Mods like Repentance Plus (https://steamcommunity.com/sharedfiles/filedetails/?id=2627014611) or Restored Hearts (https://steamcommunity.com/sharedfiles/filedetails/?id=3476266920) come with it prepackaged.
- Alternatively (and recommendedly) you can use my standalone version (see optional dependencies), which fixes some issues with the API and gives it additional features that this mod utilizes.
#### Enhanced Boss Bars (https://steamcommunity.com/sharedfiles/filedetails/?id=2635267643)
- Needed to display boss hp bars
#### MinimapAPI (https://steamcommunity.com/sharedfiles/filedetails/?id=1978904635)
- Needed to display minimap

## Acknowledgements
_Kilburn
- Lead developer of Antibirth
- Code from reHUD, which was used for screen positioning.

wofsauge (https://steamcommunity.com/id/Wofsauge, https://github.com/wofsauge) 
- TBoI Lua API Documentation (https://wofsauge.github.io/IsaacDocs/rep/index.html)

Kona (https://steamcommunity.com/id/Konoca)
- Co-op HUD+ (https://steamcommunity.com/sharedfiles/filedetails/?id=3229942849) was used in several ways to aid in development.

Srokks (https://steamcommunity.com/id/srokks)
- coopHUD *WIP* (https://steamcommunity.com/sharedfiles/filedetails/?id=2731267631) was used to aid in development.

## Issues
All issues should either be reported here in the Issues tab, or by posting on the Steam Page. Please include:
	* Console logs (Required)
	* How to replicate the bug
	* Any mods that contributed to the bug
