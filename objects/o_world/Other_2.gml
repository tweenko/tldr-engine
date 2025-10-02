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

if progress { // don't load if there are problems with the save
    party_init()
    for (var i = 0; i < array_length(global.party_names); i ++) {
        item_apply(party_getdata(global.party_names[i], "weapon"), global.party_names[i])
        item_apply(party_getdata(global.party_names[i], "armor1"), global.party_names[i])
        item_apply(party_getdata(global.party_names[i], "armor2"), global.party_names[i])
    }
}

pal_swap_init_system(shd_pal_swapper)

if progress
    instance_create(o_ui_quit)

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
if progress { // fonts
    event_user(0)
    
	global.font_ui_hp = font_add_sprite_ext(spr_ui_hpfont, "1234567890-", true, 2);
	
	global.font_numbers_w = font_add_sprite_ext(spr_ui_numbers_wfont,"0123456789+-%/",false,1);
	global.font_numbers_g = font_add_sprite_ext(spr_ui_numbers_gfont,"0123456789+-%/",false,1);
}

global.items = []
global.key_items = [
    new item_key_cell_phone() 
]
global.weapons = []
global.armors = []

global.recruits = []
global.recruits_lost = []

global.storage = array_create(item_get_maxcount(ITEM_TYPE.STORAGE), undefined)

global.lw_items = []
global.lw_weapon = undefined
global.lw_armor = undefined

global.states = {}

enum WORLD_TYPE {
    DARK,
    LIGHT
}
global.world = WORLD_TYPE.DARK // 0 for dark, 1 for light

if progress { // saves
	global.chapter = 2
	global.time = 0

	// get saves ready
	global.save_slot = global.settings.SAVE_SLOT
	global.save = {
		NAME:			"PLAYER",
		ROOM:			room_test_main,
		ROOM_NAME:		"",
		TIME:			global.time,
		PARTY_DATA:		global.party,
		PARTY_NAMES:	global.party_names,
		CHAPTER:		0,
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
	global.saves = save_read_all() // saves saved on device
    
	if global.saves[global.save_slot] != -1 
		global.save = global.saves[global.save_slot]
}
if progress
    save_load(global.save_slot)

global.charmove_insts = array_create(party_getpossiblecount() + 10, undefined)
randomize()

if progress
    room_goto_next()