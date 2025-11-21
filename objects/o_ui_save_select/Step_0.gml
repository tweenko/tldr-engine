if global.console 
	exit

currently_naming = instance_exists(o_ui_naming)
if currently_naming {
    buffer = 2 
    exit
}

if state == 0 { // choose
	if selection < SAVE_SLOTS {
		soul_put(130, 144 + 90*selection)
		
		if InputPressed(INPUT_VERB.DOWN) {
			selection ++
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.UP) && selection > 0 {
			selection --
			audio_play(snd_ui_move)
		}
		
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			audio_play(snd_ui_select)
			state = 1
			buffer = 1
		}
	}
	else {
		if selection == SAVE_SLOTS soul_put(108-30, 390)
		if selection == SAVE_SLOTS+1 soul_put(280-30, 390)
		if selection == SAVE_SLOTS+2 soul_put(408-30, 390)
		if selection == SAVE_SLOTS+3 soul_put(108-30, 430)
		if selection == SAVE_SLOTS+4 soul_put(280-30, 430)
		if selection == SAVE_SLOTS+5 soul_put(408-30, 430)
		
		if InputPressed(INPUT_VERB.DOWN) && selection < SAVE_SLOTS + 3 {
			selection += 3
			audio_play(snd_ui_move)
			
			if !language && selection == SAVE_SLOTS + 4 {
				selection = SAVE_SLOTS + 3
			}
			if !ch_file && selection == SAVE_SLOTS + 3 {
				selection = SAVE_SLOTS + 5
			}
		}
		if InputPressed(INPUT_VERB.UP) {
			audio_play(snd_ui_move)
			selection -= 3
			if selection < SAVE_SLOTS {
				selection = SAVE_SLOTS - 1
			}
		}
		if InputPressed(INPUT_VERB.RIGHT) && (selection-SAVE_SLOTS) % 3 < 2 {
			audio_play(snd_ui_move)
			selection ++
			
			if !language && selection == SAVE_SLOTS + 4
				selection = SAVE_SLOTS + 5
			if !ch_file && selection == SAVE_SLOTS + 3
				selection = SAVE_SLOTS + 5
		}
		if InputPressed(INPUT_VERB.LEFT) && (selection-SAVE_SLOTS) % 3 > 0 {
			audio_play(snd_ui_move)
			selection --
			if !language && selection == SAVE_SLOTS + 4
				selection = SAVE_SLOTS + 3
			if !ch_file && selection == SAVE_SLOTS + 3
				selection = SAVE_SLOTS + 5
		}
			
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			if selection == SAVE_SLOTS {
				audio_play(snd_ui_select)
				
				state = 2
				subselection = 0
				msg_set(m_copy, 0)
			}
			if selection == SAVE_SLOTS + 1 {
				audio_play(snd_ui_select)
				state = 3
				subselection = 0
				msg_set(m_erase, 0)
			}
 			if selection == SAVE_SLOTS + 2 {
				room_goto(room_chapter_select)
				music_stop(0)
			}
			if selection == SAVE_SLOTS + 3 {
				audio_play(snd_ui_select)
				state = 4
				subselection = 0
				msg_set(m_chfile, 0)
			}
			if selection == SAVE_SLOTS + 4 {
                loc_switch_lang(, false)
                event_user(2)
                
                audio_play(snd_ui_select)
			}
			if selection == SAVE_SLOTS + 5 {
				game_end()
			}
			
			buffer = 1
		}
	}
}
if state == 1 {
	soul_put(180 - 30 + 180*selection_hor, 162 + selection*90)
	
	if InputPressed(INPUT_VERB.RIGHT) {
		selection_hor = 1
		audio_play(snd_ui_move)
	}
	if InputPressed(INPUT_VERB.LEFT) {
		selection_hor = 0
		audio_play(snd_ui_move)
	}
	if (InputPressed(INPUT_VERB.CANCEL) && buffer == 0) || InputPressed(INPUT_VERB.SELECT) && selection_hor == 1 && buffer == 0 {
		audio_play(snd_ui_cancel)
		
		selection_hor = 0
		buffer = 1
		state = 0
	}
	if InputPressed(INPUT_VERB.SELECT) && selection_hor == 0 && buffer == 0 { // load file
        if files[selection] != -1 {
            save_load(selection, global.chapter)
            
    		room_goto(save_get("room"))
            fader_fade(1, 0, 15)
        }
		else {
            currently_naming = true
            instance_create(o_ui_naming,,, depth - 10, {
                target_save_index: selection,
                caller: id
            })
        }
	}
}
	
// copy
if state == 2 {
	if subselection < SAVE_SLOTS {
		soul_put(130, 144 + 90*subselection)
		
		if InputPressed(INPUT_VERB.DOWN) {
			audio_play(snd_ui_move)
			subselection ++
		}
		if InputPressed(INPUT_VERB.UP) && subselection > 0 {
			audio_play(snd_ui_move)
			subselection --
		}
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			if files[subselection] != -1 {
				audio_play(snd_ui_select)
				msg_set(m_copyto, 0)
				copy_from = subselection
				buffer = 1
				state = 21
			}
			else {
				msg_set(m_copyempty)
				buffer = 1
				copy_from = 0
			}
		}
	}
	else {
		if subselection == SAVE_SLOTS 
			soul_put(108-30, 390)
		if InputPressed(INPUT_VERB.UP) {
			audio_play(snd_ui_move)
			subselection = SAVE_SLOTS - 1
		}
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			audio_play(snd_ui_select)
			state = 0
			subselection = 0
			buffer = 1
			
			msg_set(m_main, 0)
		}
	}
	
	if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
		audio_play(snd_ui_cancel)
		
		state = 0
		subselection = 0
		buffer = 1
		msg_set(m_main, 0)
	}
}
if state == 21 {
	if subselection < SAVE_SLOTS{
		soul_put(130, 144 + 90*subselection)
		
		if InputPressed(INPUT_VERB.DOWN) {
			audio_play(snd_ui_move)
			subselection ++
		}
		if InputPressed(INPUT_VERB.UP) && subselection > 0 {
			audio_play(snd_ui_move)
			subselection --
		}
		
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			if subselection == copy_from {
				msg_set(m_copycant, 0)
				buffer = 1
			}
			else if files[subselection] == -1 {
				audio_play(snd_ui_scary)
				state = 0
				buffer = 1
			
				save_write(subselection, files[copy_from])
				event_user(0)
				
				copy_from = 0
				copy_to = 0
			
				msg_set(m_main, 0)
				msg_set(m_copysuccess)
			}
			else {
				audio_play(snd_ui_select)
				copy_to = subselection
				
				state = 22
				msg_set(m_copy_overwritewarn, 0)
				buffer = 1
				selection_hor = 0
			}
		}
	}
	else {
		if subselection == SAVE_SLOTS 
			soul_put(108-30,390)
		
		if InputPressed(INPUT_VERB.UP) {
			audio_play(snd_ui_move)
			subselection = SAVE_SLOTS - 1
		}
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			audio_play(snd_ui_select)
			state = 2
			subselection = copy_from
			copy_from = 0
			buffer = 1
			msg_set(m_copy, 0)
		}
	}
	
	if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
		audio_play(snd_ui_cancel)
		
		state = 2
		subselection = copy_from
		copy_from = 0
		buffer = 1
		msg_set(m_copy, 0)
	}
}
if state == 22 {
	soul_put(180 - 30 + 180*selection_hor, 162 + subselection*90)
	
	if InputPressed(INPUT_VERB.RIGHT) {
		audio_play(snd_ui_move)
		selection_hor = 1
	}
	if InputPressed(INPUT_VERB.LEFT) {
		audio_play(snd_ui_move)
		selection_hor = 0
	}
	if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 || InputPressed(INPUT_VERB.SELECT) && selection_hor == 1 && buffer == 0 {
		audio_play(snd_ui_cancel)
		
		selection_hor = 0
		state = 21
		buffer = 1
		
		msg_set(m_copyto)
	}
	if InputPressed(INPUT_VERB.SELECT) && selection_hor == 0 && buffer == 0 {
		audio_play(snd_ui_scary)
		state = 0
		buffer = 1
			
		save_write(subselection, files[copy_from])
		event_user(0)
			
		copy_from = 0
		copy_to = 0
		
		msg_set(m_main, 0)
		msg_set(m_copysuccess)
	}
}

// erase
if state == 3 {
	if subselection < SAVE_SLOTS {
		soul_put(130, 144 + 90*subselection)
		
		if InputPressed(INPUT_VERB.DOWN) {
			audio_play(snd_ui_move)
			subselection ++
		}
		if InputPressed(INPUT_VERB.UP) && subselection > 0 {
			audio_play(snd_ui_move)
			subselection --
		}
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			if files[subselection] != -1 {
				audio_play(snd_ui_select)
				
				buffer = 1
				state = 31
				msg_set(m_erase_warn1, 0)
			}
			else {
				msg_set(m_eraseempty)
				buffer = 1
				copy_from = 0
			}
		}
	}
	else {
		if subselection == SAVE_SLOTS 
			soul_put(108-30, 390)
		if InputPressed(INPUT_VERB.UP) {
			audio_play(snd_ui_move)
			subselection = SAVE_SLOTS-1
		}
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			audio_play(snd_ui_select)
			state = 0
			subselection = 0
			buffer = 1
			
			msg_set(m_main, 0)
		}
	}
	if InputPressed(INPUT_VERB.CANCEL) {
		audio_play(snd_ui_cancel)
		state = 0
		subselection = 0
		buffer = 1
		msg_set(m_main, 0)
	}
}
if state == 31 {
	soul_put(180 - 30 + 180*selection_hor, 162 + subselection*90)
	
	if InputPressed(INPUT_VERB.RIGHT) {
		audio_play(snd_ui_move)
		selection_hor = 1
	}
	if InputPressed(INPUT_VERB.LEFT) {
		audio_play(snd_ui_move)
		selection_hor = 0
	}
	if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 || InputPressed(INPUT_VERB.SELECT) && selection_hor == 1 && buffer == 0 {
		selection_hor = 0
		state = 3
		buffer = 1
		
		audio_play(snd_ui_cancel)
		threat ++
		
		msg_set(m_erase, 0)
	}
	if InputPressed(INPUT_VERB.SELECT) && selection_hor == 0 && buffer == 0 {
		audio_play(snd_ui_select)
		
		state = 32
		buffer = 1
		selection_hor = 0
		msg_set(m_erase_warn2, 0)
	}
}
if state == 32 {
	soul_put(180 - 30 + 180*selection_hor, 162 + subselection*90)
	
	if InputPressed(INPUT_VERB.RIGHT) {
		audio_play(snd_ui_move)
		selection_hor = 1
	}
	if InputPressed(INPUT_VERB.LEFT) {
		audio_play(snd_ui_move)
		selection_hor = 0
	}
	if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 || InputPressed(INPUT_VERB.SELECT) && selection_hor == 1 && buffer == 0 {
		selection_hor = 0
		state = 3
		buffer = 1
		audio_play(snd_ui_cancel)
		threat ++
		
		msg_set(m_erase, 0)
	}
	if InputPressed(INPUT_VERB.SELECT) && selection_hor == 0 && buffer == 0 {
		audio_play(snd_ui_scary)
		state = 0
		buffer = 1
		selection_hor = 0
		
		save_delete(subselection)
		event_user(0)
		
		subselection = 0
		
		msg_set(m_main, 0)
		msg_set(m_erasesuccess)
	}
}
	
// ch files
if state == 4 {
	if subselection < SAVE_SLOTS {
		soul_put(130, 144 + 90*subselection)
		
		if InputPressed(INPUT_VERB.DOWN) {
			audio_play(snd_ui_move)
			subselection ++
		}
		if InputPressed(INPUT_VERB.UP) && subselection > 0 {
			audio_play(snd_ui_move)
			subselection --
		}
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			if files_prev[subselection] != -1 && files_prev[subselection].COMPLETED {
				audio_play(snd_ui_select)
				buffer = 1
				state = 41
				
				msg_set(m_chfileconfirm, 0)
			}
			else {
				audio_play(snd_ui_cant_select)
				buffer = 1
				copy_from = 0
			}
		}
	}
	else {
		if subselection == SAVE_SLOTS 
			soul_put(108 - 30, 390)
		if InputPressed(INPUT_VERB.UP) {
			audio_play(snd_ui_move)
			subselection = SAVE_SLOTS - 1
		}
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			audio_play(snd_ui_select)
			state = 0
			subselection = 0
			buffer = 1
			
			msg_set(m_main, 0)
		}
	}
	
	if InputPressed(INPUT_VERB.CANCEL) {
		audio_play(snd_ui_cancel)
		state = 0
		subselection = 0
		buffer = 1
		msg_set(m_main, 0)
	}
}
if state == 41 {
	soul_put(180 - 30 + 180*selection_hor, 162 + subselection*90)
	
	if InputPressed(INPUT_VERB.RIGHT) {
		audio_play(snd_ui_move)
		selection_hor = 1
	}
	if InputPressed(INPUT_VERB.LEFT) {
		audio_play(snd_ui_move)
		selection_hor = 0
	}
	if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 || InputPressed(INPUT_VERB.SELECT) && selection_hor == 1 && buffer == 0 {
		selection_hor = 0
		state = 4
		buffer = 1
		audio_play(snd_ui_cancel)
		
		msg_set(m_chfile, 0)
	}
	if InputPressed(INPUT_VERB.SELECT) && selection_hor == 0 && buffer == 0 {
		audio_play(snd_ui_select)
        
        save_load(subselection, global.chapter - 1) // load the previous chapter
        room_goto(save_get("room"))
        fader_fade(1, 0, 15)
	}
}

if buffer > 0 
	buffer --
if msg_time > 0 
	msg_time --

if image_alpha < .5 
	image_alpha = lerp(image_alpha, .5, .15)