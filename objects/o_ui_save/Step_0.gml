if global.console 
	exit

if page == 0 { // main menu
	if input_check_pressed("left") && m_selection % 2 > 0
		m_selection --
	if input_check_pressed("right") && m_selection % 2 < 1
		m_selection ++
	if input_check_pressed("down") && m_selection < 2
		m_selection += 2
	if input_check_pressed("up") && m_selection > 1
		m_selection -= 2
	
	if m_selection > 3 
		m_selection = 3
	if m_selection < 0 
		m_selection = 0
	
	if input_check_pressed("confirm") && buffer == 0 {
		page = m_buttons[m_selection].page
		if page != -1 
			audio_play(snd_ui_select)
		
		buffer = 1
		prog = 0
		
		if page == 2 {
			st_page = 0
			
			var xx = (st_selection[st_page] % 2 == 0 ? 155 : 375)
			st_soulx = xx - 15
			st_souly = 145 + floor(st_selection[st_page]/2)*20 + 3
		}
	}
	if input_check_pressed("cancel") && buffer == 0{
		instance_destroy()
	}
}
if page == 1 { // save menu
	if prog == 0 {
		if input_check_pressed("down")
			s_selection ++
		if input_check_pressed("up")
			s_selection --
		
		if s_selection > 4 
			s_selection = 4
		if s_selection < 0 
			s_selection = 0
	
		if input_check_pressed("confirm") && s_selection < 3 && buffer == 0 {
			if s_selection != global.save_slot && global.saves[s_selection] != -1 
				prog = 2
			else {
				save_update_pc(s_selection)
				save_set(s_selection)
				
				audio_play(snd_save)
				prog ++
			}
			buffer = 1
		}
		if input_check_pressed("cancel") && buffer == 0 || s_selection == 3 && input_check_pressed("confirm") && buffer == 0 {
			prog = 0
			buffer = 1
			page = 0
		}
	}
	if prog == 1 {
		if (input_check_pressed("confirm") || input_check_pressed("cancel")) && buffer == 0
			instance_destroy()
	}
	if prog == 2 {
		if input_check_pressed("left") 
			s_o_selection=0
		if input_check_pressed("right") 
			s_o_selection=1
		
		if input_check_pressed("confirm") && buffer == 0 {
			if s_o_selection == 0 {
				save_update_pc(s_selection)
				save_set(s_selection)
				audio_play(snd_save)
				
				prog = 1
			}
			else 
				prog = 0
			
			buffer = 1
		}
		if input_check_pressed("cancel") && buffer == 0 {
			prog = 0
			buffer = 1
		}
	}
}
if page == 2 { // storage
	var xx = (st_selection[st_page] % 2 == 0 ? 155 : 375)
	st_soulx = lerp(st_soulx, xx-15, .6)
	st_souly = lerp(st_souly, (st_page == 0 ? 145 : 295) + floor((st_selection[st_page] - (st_page == 1 ? 12 * st_stpage : 0)) / 2)*20 + 3, .6)
	
	if input_check_pressed("left") && st_selection[st_page] % 2 > 0 
		st_selection[st_page] --
	else if input_check_pressed("left") && st_selection[st_page] % 2 == 0 && st_page == 1 {
		st_stpage = (st_stpage - 1) % st_maxstpage
		
		st_selection[st_page] -= 11
		if st_selection[st_page] < 0 
			st_selection[st_page] += 12 * st_maxstpage
	}
	
	if input_check_pressed("right") && st_selection[st_page] % 2 < 1
		st_selection[st_page] ++
	else if input_check_pressed("right") && st_selection[st_page] % 2 == 1 && st_page == 1 {
		st_stpage = (st_stpage + 1) % st_maxstpage
		
		st_selection[st_page] += 11
		if st_selection[st_page] >= 12 * st_maxstpage
			st_selection[st_page] -= 12 * st_maxstpage
	}
	
	if input_check_pressed("down") && st_selection[st_page] < item_get_maxcount()-2 + (st_page == 1 ? 12 * st_stpage : 0)
		st_selection[st_page] += 2
	if input_check_pressed("up") && st_selection[st_page] > 1 + (st_page == 1 ? 12 * st_stpage : 0)
		st_selection[st_page] -= 2
	
	if input_check_pressed("confirm") && buffer == 0 {
		if st_page == 0 
			st_page = 1
		else {
			audio_play(snd_ui_select)
			
			var i1 = undefined
			var i2 = undefined
			if st_selection[0] < array_length(global.items) 
				i1 = global.items[st_selection[0]]
			if st_selection[1] < array_length(global.storage) && global.storage[st_selection[1]] != undefined 
				i2 = global.storage[st_selection[1]]
			
			if !is_undefined(i1)
				item_set(i1,st_selection[1], 5)
			else 
				item_delete(st_selection[1], 5)
			
			if !is_undefined(i2)
				item_set(i2,st_selection[0], 0)
			else 
				item_delete(st_selection[0])
			
			st_page = 0
		}
	}
	if input_check_pressed("cancel") && buffer == 0 {
		if st_page == 0 {
			page = 0
			buffer = 1
		}
		else {
			st_page = 0
			buffer = 1
		}
	}
}
if page == -1 {
	instance_destroy()
}

if buffer > 0 
	buffer--