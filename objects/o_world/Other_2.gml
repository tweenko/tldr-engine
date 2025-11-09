randomize() // make every instance of the game randomized
pal_swap_init_system(shd_pal_swapper) // load the palette swapper shader

// the instances you will be using no matter what
instance_create(o_camera)
instance_create(o_window)
instance_create(o_dev_musiccontrol)
instance_create(o_fader)
instance_create(o_flash)

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

if !progress 
    exit
instance_create(o_ui_quit)

// -------------------------------- set up saves -------------------------------------
global.chapter = 1
global.time = 0

// get saves ready
global.save_slot = global.settings.SAVE_SLOT
global.save_recording = []
global.save = {}
#region create the save entries
    // base player data
    save_entry("NAME", "PLAYER")
    save_entry("ROOM", room_test_main, undefined, function() { return room })
    save_entry("ROOM_NAME", "", function(_raw_data){ global.room_name = _raw_data }, function(){ return global.room_name })
    
    save_entry("TIME", global.time, function(_raw_data){ global.time = _raw_data }, function(){ return global.time })
    save_entry("CHAPTER", global.chapter, function(_raw_data){ global.chapter = _raw_data }, function(){ return global.chapter })
    save_entry("PLOT", 0)
    save_entry("MONEY", 0)
    save_entry("EXP", 0)
    
    save_entry("CRYSTAL", false)
    save_entry("COMPLETED", false)
    save_entry("COMPLETE_ROOM", "undefined")
    save_entry("COMPLETE_TIME", 0)
    
    // light world data
    save_entry("LW_NAME", "Kris")
    save_entry("LW_LV", 1)
    save_entry("LW_HP", 20)
    save_entry("LW_MAXHP", 20)
    save_entry("LW_MONEY", 0)
    save_entry("LW_SINCE_CHAPTER", 0)
    
    save_entry("LW_WEAPON", 
        undefined, 
        function(_raw_data){ global.lw_weapon = save_inv_single_import(_raw_data) }, 
        function(){ return save_inv_single_export(global.lw_weapon) }
    )
    save_entry("LW_ARMOR", 
        undefined, 
        function(_raw_data){ global.lw_armor = save_inv_single_import(_raw_data) }, 
        function(){ return save_inv_single_export(global.lw_armor) }
    )
    save_entry("LW_ITEMS", 
        global.lw_items, 
        function(_raw_data){ global.lw_items = save_inv_import(_raw_data) }, 
        function(){ return save_inv_export(global.lw_items) }
    )
    
    // inventory
    save_entry("ITEMS", global.items, 
        function(_raw_data){ global.items = save_inv_import(_raw_data) }, 
        function(){ return save_inv_export(global.items) }
    )
    save_entry("KEY_ITEMS", global.key_items, 
        function(_raw_data){ global.key_items = save_inv_import(_raw_data) }, 
        function(){ return save_inv_export(global.key_items) }
    )
    save_entry("WEAPONS", global.weapons, 
        function(_raw_data){ global.weapons = save_inv_import(_raw_data) }, 
        function(){ return save_inv_export(global.weapons) }
    )
    save_entry("ARMORS", global.armors, 
        function(_raw_data){ global.armors = save_inv_import(_raw_data) }, 
        function(){ return save_inv_export(global.armors) }
    )
    save_entry("STORAGE", global.storage, 
        function(_raw_data){ global.storage = save_inv_import(_raw_data) }, 
        function(){ return save_inv_export(global.storage) }
    )
    
    // misc
    save_entry("STATES", global.states, function(_raw_data){ global.states = _raw_data }, function(){ return global.states })
    save_entry("WORLD", global.world, function(_raw_data){ global.world = _raw_data }, function(){ return global.world })
    
    save_entry("RECRUITS", global.recruits, 
        function(_raw_data){ global.recruits = save_inv_import(_raw_data) }, 
        function(){ return save_inv_export(global.recruits) }
    )
    save_entry("RECRUITS_LOST", global.recruits_lost, function(_raw_data){ global.recruits_lost = _raw_data }, function(){ return global.recruits_lost })
#endregion

// if you wish to add new save entries, please add them here ⌄⌄⌄⌄⌄⌄⌄⌄

// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

// create entries for the party stuff later since we must first apply their equipment
save_entry("PARTY_DATA", global.party, 
    function(_raw_data) { global.party = save_party_import(_raw_data) },
    function() { return save_party_export(global.party) }
)
save_entry("PARTY_NAMES", global.party_names, 
    function(_raw_data) { global.party_names = _raw_data },
    function() { return global.party_names }
)

global.saves = save_read_all() // saves saved on device
if global.saves[global.save_slot] != -1 
    global.save = global.saves[global.save_slot]
save_load(global.save_slot)

// init the typer chars
typer_chars_init()
// << initialize your typer chars here

room_goto_next()