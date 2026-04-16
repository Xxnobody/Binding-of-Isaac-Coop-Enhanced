![Alt text](logo.png?raw=true "")

A comprehensive mod for The Binding of Isaac: Repentance that revamps Co-op in fun and needed ways. 

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
	* Extremely customizable with tons of options for everything!
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
	* Ghost Player Flight! With custom options to prevent ghost players from grabbing pickups from areas they normally couldn't reach, stop them from opening chests, disallow them from buying stuff, or even remove the ability to body block enemies (they are ghosts after all).
	* Greed Mode Revive Machine! Adds a revive machine to the Greed Mode shop that appears near the center on every floor after the first. (Not sure why this isn't vanilla)
	* Sacrifice Room Revives! Dead players can no be revived in Sacrifice Rooms by a living player using it. There's a (configurable) compounding percent chance to revive the closes dead player every sacrifice payed.
### Co-op Fixes
	* A small Fullscreen tweak that resets the window to 0,0 and refreshes the screen whenever you start/restart a game. 
	* Fixes an issue where Co-op is prevented from starting due to the game sometimes incrementing the Room Visits counter too many times on first join. Configurable amount of room visits. (You can set room visits maximum to 0 to allow starting Co-op at any point in the run as long as it's the floor's starting room)
	* Fixes an issue where changing controller order before rejoining a game (or even just rejoining a game) could cause all characters to become the same. This tries to prevent that and prevent health loss due to your character being changed to another without red health or vice versa. Doesn't always work and needs more testing. If it doesn't work for you, several commands to change player type/health/items are available (see below). This also fixes the HUD not loading for players beyond P1, so disable that option in Isaac Reflourished if you have it.
	* API callbacks for each fix are available.

## Commands
	Many Co-op focused commands are included, which can be utilized by opening the console [`]. Most commands start with 'coop' and give autofill recommendations as you type.
	See the Wiki for every command and its various options.

## Built-in Mod Support
Several mods have been given built in support for most features:
- Angel Beggars (https://steamcommunity.com/sharedfiles/filedetails/?id=1832381849): Support for Angel Deal Coop Treasure generation.
- Divided-Void (https://steamcommunity.com/sharedfiles/filedetails/?id=2900644381): Full HUD support with extra features and customization options.
- Enhanced Boss Bars (https://steamcommunity.com/sharedfiles/filedetails/?id=2635267643): HUD support with auto-padding for HUD elements.
- Edith (Restored) (https://steamcommunity.com/sharedfiles/filedetails/?id=3552120418): Some HUD support.
- Epiphany (https://steamcommunity.com/sharedfiles/filedetails/?id=3012430463): Some HUD support (Needs Testing).
- Fiend Folio (https://steamcommunity.com/sharedfiles/filedetails/?id=3012430463): Some HUD support (Needs Testing).
- Jericho (https://steamcommunity.com/sharedfiles/filedetails/?id=3207962098): HUD support (Needs Testing).
- Library Chance (https://steamcommunity.com/sharedfiles/filedetails/?id=3534359537): HUD support, with Custom calculations.
- Library Expanded (https://steamcommunity.com/sharedfiles/filedetails/?id=2917917616): HUD support, Coop Treasure also has support for all of its various Library layouts.
- Low Firerate Bar (https://steamcommunity.com/sharedfiles/filedetails/?id=3387673993): HUD support.
- Isaac Reflourished (https://steamcommunity.com/sharedfiles/filedetails/?id=https://steamcommunity.com/sharedfiles/filedetails/?id=3655824749): HUD support for I'm Excited timer and Boss Rush Wave Bar (Disable the boss Rush Bar in Reflourished config or you'll see double). Also supports Reflourished Book Library chance increase from Library Chance HUD.
- Martha of Bethany (https://steamcommunity.com/sharedfiles/filedetails/?id=2987653166): Some HUD support.
- Mei (https://steamcommunity.com/sharedfiles/filedetails/?id=842051906): Some HUD support.
- Nemesis (https://steamcommunity.com/sharedfiles/filedetails/?id=2501339433): Some HUD support.
- Revelations (https://steamcommunity.com/sharedfiles/filedetails/?id=2880387531): Some HUD support.
- Samael (https://steamcommunity.com/sharedfiles/filedetails/?id=3897795840): Some HUD support.
- Zodiac Planetariums (https://steamcommunity.com/sharedfiles/filedetails/?id=2516129211): Support for Planetarium Coop Treasure generation.


## Known Incompatibilites
Most mods that don't ad HUD elements, change Coop Ghosts, or alter Treasure Rooms are compatible. Otherwise compatability is dubious. Here's a list of known Incompatible mods (that won't get compatibility or already contain all the features found within).
- Coop Commands: (https://steamcommunity.com/sharedfiles/filedetails/?id=2657359273): Most are in this mod.
- Coop Completion Marks(https://steamcommunity.com/sharedfiles/filedetails/?id=3346134460): Already in this mod.
- Coop Found HUD or similar (https://steamcommunity.com/sharedfiles/filedetails/?id=3162170417): Already in this mod.
- Co-op Fixes (https://steamcommunity.com/sharedfiles/filedetails/?id=2787563175): All features in this mod.
- Coop Label Mods or similar (https://steamcommunity.com/sharedfiles/filedetails/?id=2519553756): Already in this mod.
- Co-op Ghosts can fly now! (https://steamcommunity.com/sharedfiles/filedetails/?id=2526550159): Already in this mod.
- Coop HUD Mods: Co-op HUD+ (https://steamcommunity.com/sharedfiles/filedetails/?id=3229942849), coopHUD 'WIP' (https://steamcommunity.com/sharedfiles/filedetails/?id=2731267631).
- Coop Treasure Mods like True Co-op Treasure Rooms (https://steamcommunity.com/sharedfiles/filedetails/?id=1686448496), True Co-Op Boss Items (https://steamcommunity.com/sharedfiles/filedetails/?id=1688922073), Fair Co-Op Items (https://steamcommunity.com/sharedfiles/filedetails/?id=2678027825), Better Coop Item Pedestals (https://steamcommunity.com/sharedfiles/filedetails/?id=2491785532): ALl of their features are added in some way by this mod.
- Extended Coop (https://steamcommunity.com/sharedfiles/filedetails/?id=3656165860): All features already in this mod.
- Visible Lost Health (https://steamcommunity.com/sharedfiles/filedetails/?id=2497320263) and Visible Holy Mantles (https://steamcommunity.com/sharedfiles/filedetails/?id=2673481744): IDK what IS compatible with these, but they don't support CustomHealthAPI so no deal.

## Mod Support
I've attempted to make the mod as future proof and compatible as possible, adding various API implementations and avoiding hard-coded values where I could. Many mods have built-in support but many more do not. A lot of other mods won't need support added for this mod, but many large mods most likely will. Isaac modding is a headache at the best of times and the API lacks a lot of features, so compatibility will usually have to added by this mod or the other. I'm open to adding compatibility to many mods where possible, but it's easier to accomplish this when other mods use global variables. Some mods cannot be made compatible just due to the way they're written unfortunately.

#### HUD Rendering
Due to how Isaac HUD coding works, the original HUD is required to be hidden to render custom ones. Mod creators that add HUD elements tend to check if the HUD is visible before rendering their sprites, and so with Co-op HUD enabled, modded HUD elements almost always won't render. Support for this mod is as easy as adding an extra check to see if the Co-op Enhanced HUD is enabled. Adding 'if CoopEnhanced ~= nil and CoopEnhanced.CoopHUD.IsVisible' to any HUD visibility checks makes your mod compatible with the Co-op HUD rendering. If your mod adds custom HUD rendering and/or other features that don't render well with the Co-op HUD or if you would like a mod to have extra options when loaded along side Co-op Enhanced then please reach out and I can tweak things as needed.

#### Completion Marks
Repentogon adds a lot of features when it comes to Completion Marks but I'm pretty sure Mod's that add their own will require extra implementation to appear for the Coop Marks. I've added API callbacks to try and give modders the ability to add their own but this needs further testing.

#### Treasure Pedestals
Due to how some treasure rooms are laid out, the item pedestals may end up having weird/inaccessible placement. I've put many safety checks in to try and avoid this, but some rooms just need to be manually edited. There are API functions/callbacks added to do this and can be easily implemented with 10 minutes of work.

## Required Mods
Some mods are required to get the full experience, some are just required.
#### Repentogon (https://steamcommunity.com/sharedfiles/filedetails/?id=3127536138)
- API extender.
- Isaac modding API is limited WITH Repentogon, so it's necessary.
- Has special installation instructions, see their page for more information.
#### CustomHealthAPI (https://steamcommunity.com/sharedfiles/filedetails/?id=3699546779)
- Techinically you need a mod that uses CustomHealthAPI. Mods like Repentance Plus (https://steamcommunity.com/sharedfiles/filedetails/?id=2627014611) or Restored Hearts (https://steamcommunity.com/sharedfiles/filedetails/?id=3476266920) come with it prepackaged.
- Alternatively (and recommendedly) you can use my standalone version (see optional dependencies), which fixes some issues with the API and gives it additional features that this mod utilizes.
#### Enhanced Boss Bars (https://steamcommunity.com/sharedfiles/filedetails/?id=2635267643)
- Needed to display boss hp bars
#### MinimapAPI (https://steamcommunity.com/sharedfiles/filedetails/?id=1978904635)
- Needed to display minimap

## Acknowledgements
#### _Kilburn
- Lead developer of Antibirth (The Goat)
- Code from reHUD, which was used for screen positioning.

#### wofsauge (https://steamcommunity.com/id/Wofsauge, https://github.com/wofsauge) 
- TBoI Lua API Documentation (https://wofsauge.github.io/IsaacDocs/rep/index.html)

#### Repentogon Team (https://repentogon.com/index.html)
- Seriously, Isaac modding is so limited, and I hate LUA, but Repentogon was a lifesaver and saved probably dozens of hours of work. So thank you!

#### Kona (https://steamcommunity.com/id/Konoca)
- Co-op HUD+ (https://steamcommunity.com/sharedfiles/filedetails/?id=3229942849) was used in several ways to aid in development.

#### Srokks (https://steamcommunity.com/id/srokks)
- coopHUD *WIP* (https://steamcommunity.com/sharedfiles/filedetails/?id=2731267631) was used to aid in development.

## Issues
All issues should either be reported here in the Issues tab, or by posting on the Steam Page. Please include:
	* Console logs (Required)
	* How to replicate the bug
	* Any mods that contributed to the bug
