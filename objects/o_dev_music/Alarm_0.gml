if audio_exists(mus) 
	music_play(mus, slot, loop, gain, pitch)
if mus == noone
	music_stop(slot)