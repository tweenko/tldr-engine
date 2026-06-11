if dialogue_overlay {
    state = -1
    if !instance_exists(o_ui_dialogue)
        instance_destroy()
    
    exit
}

if state == 0 {
	if InputPressed(INPUT_VERB.DOWN) {
		if selection < array_length(options)-1 {
			selection ++
			audio_play(snd_ui_move)
		}
	}
	else if InputPressed(INPUT_VERB.UP) {
		if selection > 0 {
			selection --
			audio_play(snd_ui_move)
		}
	}
	
	if InputPressed(INPUT_VERB.CANCEL) || InputPressed(INPUT_VERB.SPECIAL) {
		global.menu_page = selection
		instance_destroy()
	}
	
	if InputPressed(INPUT_VERB.SELECT) {
		if selection == 0 {
			if item_get_count(ITEM_TYPE.LIGHT) == 0 {
                exit
            }
            
		}
        if selection == 2 {
            if !phone_can_use {
                phone_cant_cutscene()
                instance_destroy()
                
                exit
            }
        }
        
        state = options[selection].state
        audio_play(snd_ui_select)
		exit
	}
}
if state == 1 {
	if InputPressed(INPUT_VERB.DOWN){
		i_selection ++
		
		if i_selection > item_get_count(ITEM_TYPE.LIGHT)-1
			i_selection = item_get_count(ITEM_TYPE.LIGHT)-1
		else
			audio_play(snd_ui_move)
	}
	else if InputPressed(INPUT_VERB.UP){
		i_selection --
		
		if i_selection < 0
			i_selection = 0
		else
			audio_play(snd_ui_move)
	}
		
	if InputPressed(INPUT_VERB.SELECT){
		state = 2
		audio_play(snd_ui_select)
		ip_selection = 0
		exit
	}
	
	if InputPressed(INPUT_VERB.CANCEL){
		if i_selection != selection {
			audio_play(snd_ui_move)
		}
		i_selection = 0
		state = 0
		exit
	}
}
if state == 2 {
	if InputPressed(INPUT_VERB.RIGHT) {
		ip_selection ++
		
		if ip_selection > 2
			ip_selection = 2
		else
			audio_play(snd_ui_move)
	}
	else if InputPressed(INPUT_VERB.LEFT) {
		ip_selection --
		
		if ip_selection < 0
			ip_selection = 0
		else
			audio_play(snd_ui_move)
	}
	
	if InputPressed(INPUT_VERB.SELECT) {
		var _item = item_get_array(ITEM_TYPE.LIGHT)[i_selection]
		
		audio_play(snd_ui_select)
		
		if ip_selection == 0 {
			item_use(_item, i_selection, 0)
		}
		else if ip_selection == 1 {
			dialogue_start(item_get_desc(_item, ITEM_DESC_TYPE.FULL))
		}
		else if ip_selection == 2 {
			_item.throw_scripts.execute_code(i_selection)
		}
		
		dialogue_overlay = true
		exit
	}
	
	if InputPressed(INPUT_VERB.CANCEL) {
		if ip_selection != i_selection {
			audio_play(snd_ui_move)
		}
		state = 1
		exit
	}
}
if state == 3 {
    if InputPressed(INPUT_VERB.CANCEL){
		audio_play(snd_ui_move)
		state = 0
		exit
	}
}
if state == 4 {
	if !array_equals(phone_numbers, []) {
	    if InputPressed(INPUT_VERB.DOWN){
			c_selection ++
		
			if c_selection < array_length(phone_numbers) - 1
				audio_play(snd_ui_move)
		}
		else if InputPressed(INPUT_VERB.UP){
			c_selection --
		
			if c_selection > 0
				audio_play(snd_ui_move)
		}
	
		c_selection = clamp(c_selection, 0, array_length(phone_numbers) - 1)
    
	    if InputPressed(INPUT_VERB.SELECT) {
	        phone_numbers[c_selection].cutscene()
	        dialogue_overlay = true
        
	        exit
	    }
	}
    if InputPressed(INPUT_VERB.CANCEL){
		if c_selection != selection {
			audio_play(snd_ui_move)
		}
		state = 0
		exit
	}
}