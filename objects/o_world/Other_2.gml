randomize() // make every instance of the game randomized
pal_swap_init_system(shd_pal_swapper) // load the palette swapper shader
save_init()

// the instances you will be using no matter what
instance_create(o_camera)
instance_create(o_window)
instance_create(o_dev_musiccontrol)
instance_create(o_fader)
instance_create(o_flash)

if !allow_incompatible_saves {
    var __v = (struct_exists(global.settings, "VERSION_SAVED") ? global.settings.VERSION_SAVED : "v0.0.0")
    if !__game_versions_compare(__v, GAME_LAST_COMPATIBLE_VERSION) {
        instance_create(o_dev_savewipe_prompt,,,, {
            message: "Your Save File was recorded\non an older version of the engine.\nIt's highly recommended to clear your SAVE DATA.\nThe game will be closed once you select an option.",
            fatal: true
        })
    }
}
if global.console_enabled && !instance_exists(o_dev_savewipe_prompt)
    instance_create(o_console)

{ // get window ready
	var divide = 540
	if display_get_width() < display_get_height()
		divide = 960
    
	window_scale = floor( min(display_get_width() - 100, display_get_height() - 100) / divide )
    fullscreen_scale = min(display_get_width(), display_get_height()) / divide
    
    borders_toggle(global.border_mode != BORDER_MODE.OFF)
    borders_window_resize()
    
    call_later(1, time_source_units_frames, function() {
        window_center()
    })
    
	application_surface_draw_enable(false)
}


enum WORLD_TYPE {
    DARK,
    LIGHT
}
global.world = WORLD_TYPE.DARK;

if instance_exists(o_dev_savewipe_prompt)
    exit
instance_create(o_ui_quit)

// -------------------------------- set up saves -------------------------------------
global.chapter = 1
global.time = 0

// load the default items
array_push(global.key_items, new item_key_cell_phone())

#region create the save entries
    // base player data
    save_entry("NAME", "PLAYER")
    save_entry("ROOM", room_test_main, undefined, function() { return room })
    save_entry("ROOM_NAME", "", function(_conv_data){ global.room_name = _conv_data }, function(){ return global.room_name })
    
    save_entry("TIME", global.time, function(_conv_data){ global.time = _conv_data }, function(){ return global.time })
    save_entry("CHAPTER", global.chapter, function(_conv_data){ global.chapter = _conv_data }, function(){ return global.chapter })
    save_entry("PLOT", 0)
    save_entry("MONEY", 0)
    save_entry("EXP", 0)
    
    save_entry("CRYSTAL", false)
    save_entry("COMPLETED", false)
    save_entry("COMPLETE_ROOM", "undefined")
    save_entry("COMPLETE_TIME", 0)
    
    // light world data
    save_entry("LW_NAME", loc("party_kris_name"))
    save_entry("LW_LV", 1)
    save_entry("LW_HP", 20)
    save_entry("LW_MAXHP", 20)
    save_entry("LW_MONEY", 0)
    save_entry("LW_SINCE_CHAPTER", undefined)
    
    save_entry("LW_WEAPON", 
        new item_w_lw_pencil(), 
        function(_conv_data){ global.lw_weapon = _conv_data }, 
        function(){ return save_export_constructed(global.lw_weapon) },
        function(_raw_data) { return save_import_constructed(_raw_data) }
    )
    save_entry("LW_ARMOR", 
        new item_a_lw_bandage(), 
        function(_conv_data){ global.lw_armor = _conv_data }, 
        function(){ return save_export_constructed(global.lw_armor) },
        function(_raw_data) { return save_import_constructed(_raw_data) }
    )
    save_entry("LW_ITEMS", 
        global.lw_items, 
        function(_conv_data){ global.lw_items = _conv_data }, 
        function(){ return save_export_constructed_array(global.lw_items) },
        function(_raw_data) { return save_import_constructed_array(_raw_data) }
    )
    
    // inventory
    save_entry("ITEMS", global.items, 
        function(_conv_data){ global.items = _conv_data }, 
        function(){ return save_export_constructed_array(global.items) },
        function(_raw_data) { return save_import_constructed_array(_raw_data) }
    )
    save_entry("KEY_ITEMS", global.key_items, 
        function(_conv_data){ global.key_items = _conv_data }, 
        function(){ return save_export_constructed_array(global.key_items) },
        function(_raw_data) { return save_import_constructed_array(_raw_data) }
    )
    save_entry("WEAPONS", global.weapons, 
        function(_conv_data){ global.weapons = _conv_data }, 
        function(){ return save_export_constructed_array(global.weapons) },
        function(_raw_data) { return save_import_constructed_array(_raw_data) }
    )
    save_entry("ARMORS", global.armors, 
        function(_conv_data){ global.armors = _conv_data }, 
        function(){ return save_export_constructed_array(global.armors) },
        function(_raw_data) { return save_import_constructed_array(_raw_data) }
    )
    save_entry("STORAGE", global.storage, 
        function(_conv_data){ global.storage = _conv_data }, 
        function(){ return save_export_constructed_array(global.storage) },
        function(_raw_data) { return save_import_constructed_array(_raw_data) }
    )
    
    // misc
    save_entry("SHOP_DATA", {})
    save_entry("MEMORIES", global.memories, function(_conv_data){ global.memories = _conv_data }, function(){ return global.memories })
    save_entry("WORLD", global.world, function(_conv_data){ global.world = _conv_data }, function(){ return global.world })
    
    save_entry("RECRUITS", global.recruits, 
        function(_conv_data){ global.recruits = _conv_data }, 
        function(){ return save_export_constructed_array(global.recruits) },
        function(_raw_data) { return save_import_constructed_array(_raw_data) }
    )
    save_entry("RECRUITS_LOST", global.recruits_lost, function(_conv_data){ global.recruits_lost = _conv_data }, function(){ return global.recruits_lost })
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
global.font_numbers_w = font_add_sprite_ext(spr_ui_numbers_wfont,"0123456789+-%/", false, 1);
global.font_numbers_g = font_add_sprite_ext(spr_ui_numbers_gfont,"0123456789+-%/", false, 1);

// create entries for the party stuff later since we must first apply their equipment
save_entry("PARTY_DATA", global.party, 
    function(_conv_data) { global.party = _conv_data },
    function() { return save_export_struct(global.party, ["weapon", "armor1", "armor2", "spells"]) },
    function(_raw_data) { return save_import_struct(_raw_data, ["weapon", "armor1", "armor2", "spells"]) }
)
save_entry("PARTY_NAMES", global.party_names, 
    function(_conv_data) { global.party_names = _conv_data },
    function() { return global.party_names },
)

music_stop_all()

save_reload()
save_load(global.save_slot)

// init the typer chars
typer_chars_init()

new ex_typer_gerson().__initialize()
// << initialize your typer chars here

room_goto_next()