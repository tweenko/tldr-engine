if dialogue_overlay {
    state = -1
    if !instance_exists(o_ui_dialogue)
        instance_destroy()
    
    exit
}

if state == 0 {
	if InputPressed(INPUT_VERB.DOWN) {
		selection ++
		audio_play(snd_ui_move)
	}
	else if InputPressed(INPUT_VERB.UP) {
		selection --
		audio_play(snd_ui_move)
	}
	if selection > array_length(options)-1
		selection = 0
	if selection < 0 
		selection = array_length(options)-1
	
	if InputPressed(INPUT_VERB.CANCEL) || InputPressed(INPUT_VERB.SPECIAL) {
		instance_destroy()
	}
	
	if InputPressed(INPUT_VERB.SELECT) {
		if selection == 0 {
			if item_get_count(ITEM_TYPE.LIGHT) == 0 {
				audio_play(snd_ui_cant_select)
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
		i_selection++
		audio_play(snd_ui_move)
	}
	else if InputPressed(INPUT_VERB.UP){
		i_selection--
		audio_play(snd_ui_move)
	}
	
	if i_selection > item_get_count(ITEM_TYPE.LIGHT)-1
		i_selection = item_get_count(ITEM_TYPE.LIGHT)-1
	if i_selection < 0
		i_selection = 0
		
	if InputPressed(INPUT_VERB.SELECT){
		state = 2
		audio_play(snd_ui_select)
		ip_selection = 0
		exit
	}
	
	if InputPressed(INPUT_VERB.CANCEL){
		state = 0
		exit
	}
}
if state == 2 {
	if InputPressed(INPUT_VERB.RIGHT) {
		ip_selection++
		audio_play(snd_ui_move)
	}
	else if InputPressed(INPUT_VERB.LEFT) {
		ip_selection--
		audio_play(snd_ui_move)
	}
	
	if ip_selection > 2
		ip_selection = 2
	if ip_selection < 0
		ip_selection = 0
	
	if InputPressed(INPUT_VERB.SELECT) {
		var _item = item_get_array(ITEM_TYPE.LIGHT)[i_selection]
		
		audio_play(snd_ui_select)
		
		if ip_selection == 0 {
			item_use(_item, i_selection, 0)
		}
		else if ip_selection == 1{
			dialogue_start(item_get_desc(_item, ITEM_DESC_TYPE.FULL))
		}
		else if ip_selection == 2{
			_item.throw_scripts.execute_code(i_selection)
		}
		
		dialogue_overlay = true
		exit
	}
	
	if InputPressed(INPUT_VERB.CANCEL) {
		state = 1
		exit
	}
}
if state == 3 {
    if InputPressed(INPUT_VERB.CANCEL){
		state = 0
		exit
	}
}
if state == 4 {
    if InputPressed(INPUT_VERB.DOWN){
		c_selection ++
		audio_play(snd_ui_move)
	}
	else if InputPressed(INPUT_VERB.UP){
		c_selection --
		audio_play(snd_ui_move)
	}
    c_selection = clamp(c_selection, 0, array_length(phone_numbers) - 1)
    
    if InputPressed(INPUT_VERB.SELECT) {
        phone_numbers[c_selection].cutscene()
        dialogue_overlay = true
        
        exit
    }
    if InputPressed(INPUT_VERB.CANCEL){
		state = 0
		exit
	}
}