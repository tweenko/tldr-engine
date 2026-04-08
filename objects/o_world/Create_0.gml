frames = 0
volume_sfx = 1
volume_bgm = 1
volume_master = .6

gamepad = false
window_scale = 1

allow_incompatible_saves = false
incompatible_save_warning = false
incompatible_save_sleep = 0
incompatible_selection = -1
incompatible_soulx = 320
incompatible_soulx_target = 320
incompatible_end_cutscene = false
incompatible_alpha = 1
inst_dialogue = noone

progress = true
save_settings = true

sound_on_frame = -1

global.temp_choice = 0
global.typer_chars = {}
global.simplify_vfx = false
global.current_light = c_white
global.console = false
global.current_cutscene = noone

global.time = 0
global.states = {}
global.room_name = ""
global.menu_page = 0

global.player_moveable_global = true
global.border_mode = BORDER_MODE.OFF
global.console_enabled = true

global.party_limit = 3 // set to undefined for unlimited party members
global.slide_speed = 5

{ // emmiters
	emitter_sfx = audio_emitter_create();
	bus_sfx = audio_bus_create();
	audio_emitter_bus(emitter_sfx, bus_sfx);

	emitter_bgm = audio_emitter_create();
	bus_bgm = audio_bus_create();
	audio_emitter_bus(emitter_bgm, bus_bgm);
    
    // effects
    eff_reverb = audio_effect_create(AudioEffectType.Reverb1);
    eff_reverb.size = 0.7;
    eff_reverb.mix = 0.5
}
{ // settings
    save_settings_init()
    
    save_entry("SAVE_SLOT", 0 ,, function() { return global.save_slot; },, global.save_settings_recording, global.settings)
    
    save_entry("VOLUME_SFX", volume_sfx, 
        function(_raw) { audio_emitter_gain(o_world.emitter_sfx, _raw); },
        function() { return o_world.volume_sfx; },, 
        global.save_settings_recording, global.settings
    )
    save_entry("VOLUME_BGM", volume_bgm, 
        function(_raw) { audio_emitter_gain(o_world.emitter_bgm, _raw); },
        function() { return o_world.volume_bgm; },, 
        global.save_settings_recording, global.settings
    )
    save_entry("VOLUME_MASTER", volume_master, 
        function(_raw) { audio_master_gain(_raw); },
        function() { return o_world.volume_master; },, 
        global.save_settings_recording, global.settings
    )
    
    save_entry("SIMPLIFY_VFX", false ,,,, global.save_settings_recording, global.settings)
    save_entry("AUTO_RUN", false ,,,, global.save_settings_recording, global.settings)
    
    save_entry("CONTROLS_KEY", undefined, 
        function(_raw) { 
            if is_struct(_raw)
                InputBindingsImport(false, _raw); 
        },
        function() { return InputBindingsExport(false); },, 
        global.save_settings_recording, global.settings
    )
    save_entry("CONTROLS_GP", undefined, 
        function(_raw) { 
            if is_struct(_raw)
                InputBindingsImport(true, _raw); 
        },
        function() { return InputBindingsExport(true); },, 
        global.save_settings_recording, global.settings
    )
    
    save_entry("LANG", "en", 
        function(_raw) { global.loc_lang = _raw; },
        function() { return global.loc_lang; },, 
        global.save_settings_recording, global.settings
    )
    save_entry("VERSION_SAVED", GAME_VERSION ,, function() { return GAME_VERSION; },, global.save_settings_recording, global.settings)
    save_entry("BORDER_MODE", global.border_mode, 
        function(_raw) { global.border_mode = _raw; },
        function() { return global.border_mode; },, 
        global.save_settings_recording, global.settings
    )
    
    save_settings_load()
    if struct_exists(global.settings, "LANG")
        loc_load(global.settings.LANG)
}

// set up the inventory
global.items = []
global.key_items = []
global.weapons = []
global.armors = []

global.recruits = []
global.recruits_lost = []

global.storage = array_create(item_get_maxcount(ITEM_TYPE.STORAGE), undefined)

global.lw_items = []
global.lw_weapon = undefined
global.lw_armor = undefined