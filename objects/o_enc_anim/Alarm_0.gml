if music_isplaying(0) {
	music_pause(0)
}
if audio_sound_get_effect(0) != undefined
	audio_sound_reset_effect(0)
if audio_sound_get_effect(1) != undefined
	audio_sound_reset_effect(1)

o_camera.target = noone
audio_play(snd_tensionhorn,,, 1.1)

alarm[1] = 12

for (var i = 0; i < array_length(global.party_names); ++i) {
	var obj = party_get_inst(global.party_names[i])
	obj.is_in_battle = true
	
	array_push(save_pos,[obj.x, obj.y])
}