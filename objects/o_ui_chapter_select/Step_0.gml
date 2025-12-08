yadd = lerp(yadd, 0, 0.2)
vtext_alpha = lerp(vtext_alpha, 1, .1)

if lock 
	exit
if global.console 
	exit

if state == -1 {
	if InputPressed(INPUT_VERB.DOWN) {
		sselection = 1
		audio_play(snd_ui_move)
	}
	else if InputPressed(INPUT_VERB.UP) {
		sselection = 0
		audio_play(snd_ui_move)
	}
	if InputPressed(INPUT_VERB.SELECT) {
		audio_play(snd_ui_select)
		if sselection == 0 {
			chapters[tselec-1].exec(id) // run the chapter start script
			lock = true
		}
		else {
			yadd = -80
            animate(0, 1, 20, anime_curve.linear, id, "alpha")
			
			state = 0
		}
	}
}
else {
	var total = array_length(chapters)
    
	if !musplayed && music_getplaying(0) != mus_drone {
		musplayed = true
		music_play(mus_drone, 0)
	}
	if InputPressed(INPUT_VERB.DOWN) && !confirming {
		if selection >= total + 1 {
			selection = 1
			audio_play(snd_ui_move)
		}
		else {
			selection ++
			
			audio_play(snd_ui_move)
			while selection < total + 1 && !is_struct(chapters[selection-1]) 
				selection++
		}
	}
	else if InputPressed(INPUT_VERB.UP) && !confirming {
		if selection > 1 {
			var save = selection
			selection --
			audio_play(snd_ui_move)
			
			while selection > 0 && !is_struct(chapters[selection-1]) 
				selection--
			if selection==0 
				selection=save
		}
		else {
			selection = total+1
			audio_play(snd_ui_move)
		}
	}

	if InputPressed(INPUT_VERB.RIGHT) && confirming {
		audio_play(snd_ui_move)
		confirmselection = 1
	}
	if InputPressed(INPUT_VERB.LEFT) && confirming {
		audio_play(snd_ui_move)
		confirmselection = 0
	}
	
	if languages {
		if InputPressed(INPUT_VERB.RIGHT) && selection == total+1 {
			horselection = 1
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.LEFT) && selection == total+1 {
			horselection = 0
			audio_play(snd_ui_move)
		}
	}
	else 
		if horselection != 0 
			horselection = 0
	
	if selection != total+1 && horselection != 0 
		horselection = 0

	if InputPressed(INPUT_VERB.SELECT) {
		if selection <= total {
			if is_struct(chapters[selection - 1]) {
				if confirming == true && confirmselection == 0{
					audio_play(snd_ui_select)
					chapters[selection - 1].exec(id)
					lock = true
				}
				else if confirming == true && confirmselection == 1 {
					confirming = false
					confirmselection = 0
				}
				else{
					confirming = true;
					audio_play(snd_ui_select)
				}
			}
			else
				audio_play(snd_ui_cant_select)
		}
        
		if selection == total + 1 {
            if horselection == 0
                game_end()
            else {
            	loc_switch_lang()
            }
        }
	}
	if InputPressed(INPUT_VERB.CANCEL) && confirming {
		confirming = false
		confirmselection = 0
		audio_play(snd_ui_cancel)
	}
}