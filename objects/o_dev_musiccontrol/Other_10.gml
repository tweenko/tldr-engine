/// @description update song
if music_target[slot] != -1{
	if __get_actual_music_asset(slot) != music_target[slot] { // only restart the song if the song is actually different
		audio_stop_sound(music_actual[slot])
        
		music_actual[slot] = audio_play(music_target[slot], loop[slot], gain[slot], pitch[slot],, AUDIO.MUSIC)
		audio_sound_gain(music_actual[slot], gain[slot], 0)
	}
}