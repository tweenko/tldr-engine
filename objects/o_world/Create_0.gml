frames = 0
volume_a = .4
volume_bgm = .4

gamepad = false
windowsize = 1

sound_on_frame = -1
equip_style = 0 //modern

global.current_cutscene = noone
global.charmove_insts = array_create(10, undefined)
global.console = false
global.current_light = c_white

global.temp_choice = 0

{ // emmiters
	emitter_sfx = audio_emitter_create();
	bus_sfx = audio_bus_create();
	audio_emitter_bus(emitter_sfx, bus_sfx);

	emitter_music = audio_emitter_create();
	bus_music = audio_bus_create();
	audio_emitter_bus(emitter_music, bus_music);
}

// effects
eff_reverb = audio_effect_create(AudioEffectType.Reverb1);
eff_reverb.size = 0.7;
eff_reverb.mix = 0.5