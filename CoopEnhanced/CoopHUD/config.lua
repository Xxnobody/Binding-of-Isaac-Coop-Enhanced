local mod = CoopEnhanced;
local CoopHUD = CoopEnhanced.CoopHUD;

local Utils = mod.Utils;

mod.CoopHUD.DefaultConfig = {
	CMD = "hud",
	offset = Vector(0,0),
	player_sync = "Global",
	
	toggle_hud = {
		key = Keyboard.KEY_H,
		button = 1,
		coop_only = false,
		pause_display = false,
	},
	renderer = {
		callback = 5,
		priority = 3,
		refresh = 3,
	},
	active = {
		colors = false,
		bar_colors = false,
		book_correction_offset = Vector(0,-3),
		book_charge_outline = true,
		[0] = {
			opacity = 1,
			offset = Vector(0,0),
			scale = Vector(1, 1),
			chargebar = {
				offset = Vector(0, 0),
				scale = Vector(1, 1),
				invert = false,
				mirror = true,
				display = true,
			},
		},
		[1] = {
			opacity = 1,
			offset = Vector(0,0),
			scale = Vector(0.5, 0.5),
			chargebar = {
				offset = Vector(0, 0),
				scale = Vector(1, 1),
				invert = false,
				mirror = true,
				display = false,
			},
		},
	},
	trinket = {
		colors = false,
		[0] = {
			offset_w_pockets = true,
			opacity = 1,
			offset = Vector(0,0),
			scale = Vector(0.5, 0.5),
		},
		[1] = {
			offset_w_pockets = true,
			opacity = 1,
			offset = Vector(0,0),
			scale = Vector(0.5, 0.5),
		},
	},
	pocket = {
		display = 0,
		colors = false,
		bar_colors = false,
		[0] = {
			opacity = 1,
			offset = Vector(0, 0),
			scale = Vector(0.5, 0.5),
			cardfronts = true,
			text = {
				display = 0,
				opacity = 1,
				offset = Vector(0, 0),
				scale = Vector(0.75, 0.75),
			},
		},
		[1] = {
			opacity = 1,
			offset = Vector(0, 0),
			scale = Vector(0.5, 0.5),
			cardfronts = false,
			text = {
				display = 3,
				opacity = 1,
				offset = Vector(0, 0),
				scale = Vector(0.75, 0.75),
			},
		},
		[2] = {
			opacity = 1,
			offset = Vector(0, 0),
			scale = Vector(0.5, 0.5),
			cardfronts = false,
			text = {
				display = 3,
				opacity = 1,
				offset = Vector(0, 0),
				scale = Vector(0.75, 0.75),
			},
		},
		[3] = {
			opacity = 1,
			offset = Vector(0, 0),
			scale = Vector(0.25, 0.25),
			cardfronts = false,
			text = {
				display = 3,
				opacity = 1,
				offset = Vector(0, 0),
				scale = Vector(0.5, 0.5),
			},
		},
		chargebar = {
			display = true,
			invert = false,
			mirror = true,
			offset = Vector(0, 0),
			scale = Vector(0.5, 0.5)
		}
	},
	
	players = {
		[1] = {
			color = Utils.GetColorIndexByName("Red"),
			name = "",
			type = 0
		},
		[2] = {
			color = Utils.GetColorIndexByName("Blue"),
			name = "",
			type = 0
		},
		[3] = {
			color = Utils.GetColorIndexByName("Green"),
			name = "",
			type = 0
		},
		[4] = {
			color = Utils.GetColorIndexByName("Yellow"),
			name = "",
			type = 0
		},
		mirrored_offset = Vector(35, 0),
		heads = {
			display = false,
			opacity = 1,
			offset = Vector(0, 0),
			scale = Vector(1, 1),
			item_offset = Vector(0, 16),
			sync = {
				color = false,
				scale = false
			}
		},
		names = {
			display = true,
			head_offset = true,
			opacity = 1,
			offset = Vector(0, 16),
			scale = Vector(1, 1),
		},
		twins = {
			offset = Vector(15, 45),
			scale = Vector(0.75, 0.75),
			offset_w_pockets = false,
		},
		menu = {
			display = 1,
			distance = 1,
			fade = 1,
			opacity = 1,
			max = 2,
			offset = Vector(0, 0),
			scale = Vector(1, 1),
			rel_offset = Vector(20, 0),
			circle = false,
			rel_invert = false,
		}
	},
	health = {
		opacity = 1,
		hearts_per_row = 6,
		offset = Vector(0,0),
		scale = Vector(1,1),
		space = Vector(12,10),
		ignore_curse = false,
		invert = true,
		snap = {false,false,false,false},
		twin = {
			snap = false,
			offset = Vector(0,0)
		},
	},
	stats = {
		display = 0,
		ghosts = false,
		library_chance = false,
		greed_display = true,
		opacity = 0.5,
		offset = Vector(0, 0),
		rel_offset = Vector(0, 0),
		twin_offset = Vector(40, 0),
		lowered_offset = Vector(6, 6),
		scale = Vector(1, 1),
		mirrored_offset = Vector(0, 0),
		deals = {
			anchor = 0,
			display = 0,
		},
		text = {
			offset = Vector(0, 0),
			scale = Vector(1, 1),
			colors = true,
			update = {
				duration = 5,
				offset = Vector(0, 0)
			}
		}
	},
	misc = {
		pickups = {
			anchor = 0,
			display = 0,
			scale = Vector(1, 1),
			offset = Vector(0, 0),
			text_offset = Vector(0, 0),
		},
		difficulty = {
			anchor = 0,
			display = 0,
			scale = Vector(1, 1),
			offset = Vector(0, 0),
			text_offset = Vector(0, 0),
		},
		wave = {
			anchor = 0,
			display = 0,
			background = true,
			opacity = 0.5,
			scale = Vector(1, 1),
			text_scale = Vector(1, 1),
			offset = Vector(0, 0),
			text_offset = Vector(0, 0),
		},
		timer = {
			anchor = 1,
			display = 1,
			opacity = 0.5,
			scale = Vector(1, 1),
			offset = Vector(0, 0),
		},
		extra = {
			anchor = 1,
			display = 1,
			opacity = 0.5,
			scale = Vector(1, 1),
			offset = Vector(0, 0),
		},
	},
	
	inventory = {
		special = {
			display = 0,
			anchor = 0,
			opacity = 1,
			offset = Vector(0, 0),
			scale = Vector(0.75,0.5),
			space = Vector(12, 12),
			offset_w_pockets = false,
			ignore_curse = false,
			result_display = true,
			result_opacity = 1,
			result_offset = Vector(0, 0),
			result_scale = Vector(0.5,0.5),
		},
		items = {
			display = 1,
			anchor = 0,
			direction = 3,
			invert_direction = Vector(0,0),
			colors = false,
			dead = false,
			offset_w_pockets = false,
			offset_w_twins = true,
			offset = Vector(0,0),
			twin_offset = Vector(10,5),
			twins_offset = Vector(20,35),
			space = Vector(20,10),
			scale = Vector(0.5,0.5),
			opacity = 0.75,
			max_grid = Vector(1,6),
			max = 6,
		},
	},
	banner = {
		display = true,
		anchor = 1,
		speed = 0.5,
		duration = 2,
		offset = Vector(0, 0),
		scale = Vector(1, 1),
		name = {
			offset = Vector(0, 0),
			scale = Vector(1, 1),
			box_width = 10,
			centered = true,
		},
		description = {
			offset = Vector(0, 0),
			scale = Vector(1, 1),
			box_width = 10,
			centered = true,
		},
		curse = {
			offset = Vector(0, 0),
			scale = Vector(1, 1),
			box_width = 10,
			centered = true,
		}
	},
	fonts = {
		banners = 'upheaval',
		curse = 'teammeatfont10',
		description = 'pftempestasevencondensed',
		lives = 'pftempestasevencondensed',
		misc = 'pftempestasevencondensed',
		pickups = 'pftempestasevencondensed',
		players = 'terminus',
		pocket = 'pftempestasevencondensed',
		stats = 'luaminioutlined',
		timer = 'pftempestasevencondensed',
	},
	mods = {
		ANIMATEDPICKUPS = {
			enabled = false,
		},
		DIVOID = {
			display = 0,
			opacity = 1,
			colorize = 1,
			color = 1,
			color_extra = 2,
			max_charge = 3,
			offset = Vector(0, 0),
			enabled = true,
		},
		EBB = {
			auto_pad = true,
		},
		EID = {
			display = 0,
		},
		EPIPHANY = {
			hud_element_pos = Vector(50, 42),
		},
		LOWFIRERATEBAR = {
			offset = Vector(15, -35),
		},
		mAPI = {
			pos = Vector(30, 10),
			frame = Vector(30, 40),
			override = true,
		},
		REFLOURISHED = {
			excited_timer = {
				enabled = true,
				display = 0,
				anchor = 0,
				scale = Vector(1, 1),
				offset = Vector(0, 0),
				opacity = 0.7,
				fade_speed = 0.1,
			},
			boss_counter = {
				enabled = true,
				offset = Vector(10, 0),
				text_offset = Vector(3, -1),
			}
		},
	}
};

function mod.CoopHUD.ResetConfig()
	mod.Config.CoopHUD = Utils.cloneTable(mod.CoopHUD.DefaultConfig);
end
if mod.Config.CoopHUD == nil then mod.CoopHUD.ResetConfig(); end

if ModConfigMenu == nil then return; end

CoopHUD.MCM = {};
CoopHUD.MCM.title = "Co-op HUD";
CoopHUD.MCM.categories = {
	general = 'General',
	players = 'Players',
	health = 'Health',
	active = 'Actives',
	pocket = 'Pockets',
	trinket = 'Trinket',
	inventory = 'Inventory',
	stats = 'Stats',
	misc = 'Misc.',
	banner = 'Banners',
	fonts = 'Fonts',
	mods = 'Mods',
};

local dir = CoopHUD.Directory .. 'config.';

require(dir..'general');
require(dir..'players');
require(dir..'health');
require(dir..'active');
require(dir..'pocket');
require(dir..'trinket');
require(dir..'inventory');
require(dir..'stats');
require(dir..'misc');
require(dir..'banner');
require(dir..'fonts');
