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

progress = true

sound_on_frame = -1

global.current_cutscene = noone
global.charmove_insts = []
global.console = false
global.current_light = c_white

global.temp_choice = 0
global.typer_chars = {}
global.simplify_vfx = false
global.time = 0
global.states = {}
global.room_name = ""

global.player_moveable_global = true
global.border_mode = BORDER_MODE.OFF

{ // emmiters
	emitter_sfx = audio_emitter_create();
	bus_sfx = audio_bus_create();
	audio_emitter_bus(emitter_sfx, bus_sfx);

	emitter_music = audio_emitter_create();
	bus_music = audio_bus_create();
	audio_emitter_bus(emitter_music, bus_music);
    
    // effects
    eff_reverb = audio_effect_create(AudioEffectType.Reverb1);
    eff_reverb.size = 0.7;
    eff_reverb.mix = 0.5
}

// load settings
global.settings = {
    SAVE_SLOT: 0,

    VOLUME_SFX: volume_sfx,
    VOLUME_BGM: volume_bgm,
    VOLUME_MASTER: volume_master,
    
    SIMPLIFY_VFX: false,
    AUTO_RUN: false,
    
    CONTROLS_KEY: {},
    CONTROLS_GP: {},
    
    LANG: "en",
    VERSION_SAVED: ENGINE_VERSION,
    BORDER_MODE: global.border_mode
}

save_settings_load()
if struct_exists(global.settings, "LANG")
    loc_load(global.settings.LANG)

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