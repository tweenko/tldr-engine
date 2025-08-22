party_init()
pal_swap_init_system(shd_pal_swapper)

instance_create(o_camera)
instance_create(o_window)
instance_create(o_dev_musiccontrol)
instance_create(o_fader)

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
{ // fonts
	global.partyname_font_0 = font_add_sprite_ext(spr_ui_partyname_font, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890/", true, -1);
	global.partyname_font_1 = font_add_sprite_ext(spr_ui_partyname_font, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890/", true, 0);
	global.partyname_font_2 = font_add_sprite_ext(spr_ui_partyname_font, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890/", true, 1);
	
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
global.storage = array_create(item_get_maxcount(ITEM_TYPE.STORAGE), undefined)
global.lw_items = []

global.lw_weapon = undefined
global.lw_armor = undefined

global.states = {}
global.world = 0 // 0 for dark, 1 for light

{ //saves
	global.chapter = 2
	global.time = 0

	//load settings
	global.settings = {
		SAVE_SLOT: 0,
	}
	save_settings_load()

	//get saves ready
	global.save_slot = global.settings.SAVE_SLOT
	global.save = {
		NAME:			"PLAYER",
		ROOM:			room_test_main,
		ROOM_NAME:		"TEST ROOM",
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
		LW_ARMOR:	new item_a_silvercard(),
		
		//inventory
		ITEMS:		global.items,
		KEY_ITEMS:	global.key_items,
		WEAPONS:	global.weapons,
		ARMORS:		global.armors,
		STORAGE:	global.storage,
	
		STATES:				global.states,
		RECRUITS:			{},
		RECRUIT_PROGRESS:	{},
		RECRUITS_LOST:		[],
		WORLD:				global.world,
		
		CRYSTAL:		false,
		COMPLETED:		false,
		COMPLETE_ROOM:	"Test Room [Chapter 0 END]",
		COMPLETE_TIME:	2395820396,
	}
	global.saves = save_read_all() //saves saved on device
	
	if global.saves[global.save_slot] != -1 
		global.save = global.saves[global.save_slot]
}

save_load(global.save_slot)
loc_load(LOC_FILES)

item_add(new item_lw_shit(), ITEM_TYPE.LIGHT)

global.charmove_insts = array_create(party_getpossiblecount() + 10, undefined)

randomize()
room_goto_next()