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
	
	if InputPressed(INPUT_VERB.CANCEL) || InputPressed(INPUT_VERB.SPECIAL){
		instance_destroy()
	}
	
	if InputPressed(INPUT_VERB.SELECT){
		if selection == 0 {
			if item_get_count(6) == 0{
				audio_play(snd_ui_cant_select)
				exit
			}
			state = 1
			audio_play(snd_ui_select)
		}
		exit
	}
}
if state == 1{
	if InputPressed(INPUT_VERB.DOWN){
		i_selection++
		audio_play(snd_ui_move)
	}
	else if InputPressed(INPUT_VERB.UP){
		i_selection--
		audio_play(snd_ui_move)
	}
	
	if i_selection > item_get_count(6)-1
		i_selection = item_get_count(6)-1
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
if state == 2{
	if InputPressed(INPUT_VERB.RIGHT){
		ip_selection++
		audio_play(snd_ui_move)
	}
	else if InputPressed(INPUT_VERB.LEFT){
		ip_selection--
		audio_play(snd_ui_move)
	}
	
	if ip_selection > 2
		ip_selection = 2
	if ip_selection < 0
		ip_selection = 0
	
	if InputPressed(INPUT_VERB.SELECT){
		var _item = item_get_array(6)[i_selection]
		
		audio_play(snd_ui_select)
		
		if ip_selection == 0{
			item_use(_item, i_selection, 0)
		}
		else if ip_selection == 1{
			dialogue_start(item_get_desc(_item))
		}
		else if ip_selection == 2{
			_item.throw_scripts.execute_code(i_selection)
		}
		
		instance_destroy()
		exit
	}
	
	if InputPressed(INPUT_VERB.CANCEL){
		state = 1
		exit
	}
}