randomize() // make every instance of the game randomized
pal_swap_init_system(shd_pal_swapper) // load the palette swapper shader

// the instances you will be using no matter what
instance_create(o_camera)
instance_create(o_window)
instance_create(o_dev_musiccontrol)
instance_create(o_fader)

if !allow_incompatible_saves {
    var __v = (struct_exists(global.settings, "VERSION_SAVED") ? global.settings.VERSION_SAVED : "v0.0.0")
    if !__engine_versions_compare(__v, ENGINE_LAST_COMPATIBLE_VERSION) {
        progress = false
        incompatible_save_warning = true
        incompatible_save_sleep = 20
    }
}
{ // get window ready
	var divide = 480
	if display_get_width() < display_get_height() {
		divide = 640
	}
	windowsize = floor(min(display_get_width()-100, display_get_height()-100) / divide)

	window_set_size(640*windowsize, 480*windowsize)
	display_set_gui_maximize(windowsize, windowsize);
	application_surface_draw_enable(false);
	window_center();
}

enum WORLD_TYPE {
    DARK,
    LIGHT
}
global.world = WORLD_TYPE.DARK // 0 for dark, 1 for light
global.charmove_insts = array_create(party_getpossiblecount() + 10, undefined)

if progress { // set up saves
    instance_create(o_ui_quit)

	global.chapter = 1
	global.time = 0

	// get saves ready
	global.save_slot = global.settings.SAVE_SLOT
	global.save = {
		NAME:			"PLAYER",
		ROOM:			room_test_main,
		ROOM_NAME:		"",
		TIME:			global.time,
		PARTY_DATA:		undefined, // set later
		PARTY_NAMES:	undefined, // set later
		CHAPTER:		global.chapter,
		PLOT:			0,
        MONEY:          0,
        EXP:            0,
		
		LW_NAME:	"Kris",
		LW_LV:		1,
		LW_HP:		20,
		LW_MAXHP:	20,
		LW_MONEY:	7,
		LW_ITEMS:	global.lw_items,
		LW_SINCE_CHAPTER: 0,
        LW_WEAPON: undefined,
		LW_ARMOR:	undefined,
		
		//inventory
		ITEMS:		global.items,
		KEY_ITEMS:	global.key_items,
		WEAPONS:	global.weapons,
		ARMORS:		global.armors,
		STORAGE:	global.storage,
	
		STATES:				global.states,
		RECRUITS:			global.recruits,
		RECRUITS_LOST:		global.recruits_lost,
		WORLD:				global.world,
		
		CRYSTAL:		false,
		COMPLETED:		false,
		COMPLETE_ROOM:	"undefined",
		COMPLETE_TIME:	0,
	}
    
    party_init()
    global.party_names = [   // <-- if you wish to change the default team members, change them here
        "kris", "susie", "ralsei"
    ]
    party_apply_equipment()
    
    // load the fonts
    event_user(0)
	global.font_ui_hp = font_add_sprite_ext(spr_ui_hpfont, "1234567890-", true, 2);
	global.font_numbers_w = font_add_sprite_ext(spr_ui_numbers_wfont,"0123456789+-%/",false, 1);
	global.font_numbers_g = font_add_sprite_ext(spr_ui_numbers_gfont,"0123456789+-%/",false, 1);
    
    // load the default items
    array_push(global.key_items, new item_key_cell_phone())
    global.save.PARTY_DATA = global.party
    global.save.PARTY_NAMES = global.party_names
    
	global.saves = save_read_all() // saves saved on device
	if global.saves[global.save_slot] != -1 
		global.save = global.saves[global.save_slot]
    
    save_load(global.save_slot)
}

if progress
    room_goto_next()