if active && get_leader()._checkmove() {
	timer ++
	
	if timer % 30 == 0 {
		timer_sec --
	}
	
	if timer_sec == 0 {
		active = false
		if onscreen(id) 
            audio_play(snd_noise,,,,1)
	}
}