if confirmation {
	soulx = lerp(soulx, 380 + 100*c_selection - 30, .6)
	souly = lerp(souly, 400, .6)
}
else {
	soulx = lerp(soulx, 110 - 30, .6)
	souly = lerp(souly, 190 + 100*(selection % 2), .6)
}

if !confirmation {
	if InputPressed(INPUT_VERB.DOWN) && selection % 2 < 1 && selection < array_length(items)-1 {
		selection ++
	}
	if InputPressed(INPUT_VERB.UP) && selection % 2 > 0 {
		selection --
	}
	if InputPressed(INPUT_VERB.RIGHT) {
		if floor(selection / 2) < floor((array_length(items)-1) / 2){
			selection += 2
		}
		else {
			selection = selection % 2
		}
	}
	if InputPressed(INPUT_VERB.LEFT) {
		if floor(selection / 2) > 0 {
			selection -= 2
		}
		else {
			selection = selection %  2+ floor((array_length(items)-1) / 2) * 2
		}
	}
	
	if selection < 0 
		selection = 0
	if selection > array_length(items)-1 
		selection = array_length(items)-1

	if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
		if exists[selection].result {
			confirmation = 1
			buffer = 1
		}
		else{
			audio_play(snd_ui_cant_select)
		}
	}
	if InputPressed(INPUT_VERB.CANCEL) 
		instance_destroy()
}
else {
	if InputPressed(INPUT_VERB.RIGHT) 
		c_selection = 1
	if InputPressed(INPUT_VERB.LEFT) 
		c_selection = 0
	if InputPressed(INPUT_VERB.CANCEL) 
		confirmation = 0
	if InputPressed(INPUT_VERB.SELECT){
		dialogue_start(item_add(items[selection].result))
		instance_destroy()
	}
}

if buffer > 0 
	buffer --