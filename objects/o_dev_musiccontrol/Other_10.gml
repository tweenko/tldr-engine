/// @description update song
if playing[slot] != -1{
	if curplaying[slot] != playing[slot]{
		audio_stop_sound(curplaying[slot])
		playing_id[slot] = audio_play(playing[slot], loop[slot], gain[slot], pitch[slot],, AUDIO.MUSIC)
		audio_sound_gain(playing_id[slot], gain[slot] * volume_get(0), 0)
	}
	curplaying[slot] = playing[slot]
	curplaying_id[slot] = playing_id[slot]
}