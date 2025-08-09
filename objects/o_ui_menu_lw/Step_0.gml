if state == 0 {
	if input_check_pressed("down") {
		selection ++
		audio_play(snd_ui_move)
	}
	else if input_check_pressed("up") {
		selection --
		audio_play(snd_ui_move)
	}
	if selection > array_length(options)-1
		selection = 0
	if selection < 0 
		selection = array_length(options)-1
	
	if input_check_pressed("cancel") || input_check_pressed("menu"){
		instance_destroy()
	}
	
	if input_check_pressed("confirm"){
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
	if input_check_pressed("down"){
		i_selection++
		audio_play(snd_ui_move)
	}
	else if input_check_pressed("up"){
		i_selection--
		audio_play(snd_ui_move)
	}
	
	if i_selection > item_get_count(6)-1
		i_selection = item_get_count(6)-1
	if i_selection < 0
		i_selection = 0
		
	if input_check_pressed("confirm"){
		state = 2
		audio_play(snd_ui_select)
		ip_selection = 0
		exit
	}
	
	if input_check_pressed("cancel"){
		state = 0
		exit
	}
}
if state == 2{
	if input_check_pressed("right"){
		ip_selection++
		audio_play(snd_ui_move)
	}
	else if input_check_pressed("left"){
		ip_selection--
		audio_play(snd_ui_move)
	}
	
	if ip_selection > 2
		ip_selection = 2
	if ip_selection < 0
		ip_selection = 0
	
	if input_check_pressed("confirm"){
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
	
	if input_check_pressed("cancel"){
		state = 1
		exit
	}
}