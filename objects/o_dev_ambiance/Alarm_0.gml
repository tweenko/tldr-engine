if instance_exists(get_leader()){
	get_leader().stepsounds = footsteps
	get_leader().stepsoundprefix = footstepsoundprefix
}

if reverb {
	if audio_sound_get_effect() != o_world.eff_reverb
		audio_sound_set_effect(o_world.eff_reverb)
	if audio_sound_get_effect(1) != eff_gain
		audio_sound_set_effect(eff_gain,1)
}
else {
	if audio_sound_get_effect() != undefined
		audio_sound_reset_effect()
	if audio_sound_get_effect(1) != undefined
		audio_sound_reset_effect(1)
}