/// @description Trigger Exit
event_inherited()
triggered = false

with target {
	s_override = false
	dir = DIR.DOWN
	sliding = false
}

audio_stop_sound(snd)