# Co-Op HUD+
A mod for The Binding of Isaac: Repentence that changes the HUD to better display information when playing with multiple people. This mod is based on CoopEnhanced by Srokks, which is no longer being updated.

This mod is currently a work-in-progress, please report all issues under "Issues".

## Features
* Renders active items, hearts, pocket items, and trinkets in a readable position for all four players
* Stats for all four players displayed relative to their character info (P1 and P3 on left, P2 and P4 on right)
* Player color coding (P1 Blue, P2 Red, P3 Green, P4 Yellow)
* Press H to switch between Co-Op HUD+ and the default HUD
* Timer always shown at the top of the screen
* Tainted Isaac Inventory correctly displayed for all players
* Tainted ??? Poop Spells correctly displayed for all players
* Tainted Cain Bag of Crafting correctly displayed for all players
* Entirely customizable!

## Required Mods
* MinimapAPI (https://steamcommunity.com/sharedfiles/filedetails/?id=1978904635)
	* Needed to display minimap
* Enhanced Boss Bars (https://steamcommunity.com/sharedfiles/filedetails/?id=2635267643)
	* Needed to display boss hp
* Repentogon (https://steamcommunity.com/sharedfiles/filedetails/?id=3127536138)
	* API extender
	* Heads up! This mod can not be installed like a normal mod. Please read the mod description for more info.

## Customization
The placement of almost everything can be changed within `CoopEnhanced_config.lua`. More info in wiki.

## Acknowledgements
Srokks (https://steamcommunity.com/id/srokks)
*  CoopEnhanced (https://steamcommunity.com/sharedfiles/filedetails/?id=2731267631) was used to aid in development, specifically:
	* How to overhaul HUD
	* How to create objects in Lua (I literally have never used Lua outside of CC: Tweaked)
	* Item animation file
	* Bethany & T. Bethany charge bar color
	* Stat placement
	* Coin, Key, Bomb, etc. placement

wofsauge (https://steamcommunity.com/id/Wofsauge, https://github.com/wofsauge) 
* TBoI Lua API Documentation (https://wofsauge.github.io/IsaacDocs/rep/index.html)
* reHUD (https://steamcommunity.com/sharedfiles/filedetails/?id=1906405707) was used to aid in development, specifically:
	* Top-Centered Timer

_Kilburn
* Lead developer of Antibirth mod
* Code of theirs was used in reHUD, which I made use of

The Modding of Isaac Discord server (https://discord.gg/KbevtvgD4z)
* Very helpful community
