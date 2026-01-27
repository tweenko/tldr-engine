if state == NAMING_STATE.NAMING {
    soul_update = true
    
    if InputPressed(INPUT_VERB.RIGHT)
        __selection_move(0, 1)
    else if InputPressed(INPUT_VERB.LEFT)
        __selection_move(0, -1)
    else if InputPressed(INPUT_VERB.UP)
        __selection_move(-1, 0)
    else if InputPressed(INPUT_VERB.DOWN)
        __selection_move(1, 0)
    else
    	soul_update = false
    
    if InputPressed(INPUT_VERB.SELECT) {
        if selection[0] == keyboard_back_pos[0] && selection[1] == keyboard_back_pos[1] // back
            __cancel()
        else if selection[0] == keyboard_end_pos[0] && selection[1] == keyboard_end_pos[1] { // end
            if string_length(name) > 0
                state = NAMING_STATE.TRANS_CONFIRM
        }
        else if string_length(name) < keyboard_maxchars
            name += keyboard[selection[0]][selection[1]]
    }
    else if InputPressed(INPUT_VERB.CANCEL) {
        __cancel()
    }
    
    if soul_update {
        soulx = __determine_soul_x(selection[0], selection[1])
        souly = __determine_soul_y(selection[0], selection[1])
        
        soul_update = false
    }
    
    soulx_display = round_p(lerp(soulx_display, soulx, .5), 1)
    souly_display = round_p(lerp(souly_display, souly, .5), 1)
    
    if keyboard_alpha < 1
        keyboard_alpha += .1
}
else if state == NAMING_STATE.TRANS_CONFIRM {
    if keyboard_alpha > 0
        keyboard_alpha -= .1
    else {
        state = NAMING_STATE.CONFIRM
        __create_text(loc("naming_menu_txt_confirm"))
    }
}
else if state == NAMING_STATE.CONFIRM {
    name_angle = random(4)
    
    if name_trans < 1
        name_trans += .025
    if confirm_alpha < 1
        confirm_alpha += .1
    
    if InputPressed(INPUT_VERB.RIGHT)
        confirm_selection = 1
    else if InputPressed(INPUT_VERB.LEFT)
        confirm_selection = 0
    
    switch confirm_selection {
        default:
            confirm_soulx = 320
            break
        case 0:
            confirm_soulx = 231
            break
        case 1:
            confirm_soulx = 400
            break
    }
    confirm_soulx_display = round_p(lerp(confirm_soulx_display, confirm_soulx, .5), 1)
    
    if InputPressed(INPUT_VERB.SELECT) {
        if confirm_selection == 0 { // no
            state = NAMING_STATE.NAMING
            name_trans = 0
            name_angle = 0
            confirm_alpha = 0
        }
        else if confirm_selection == 1 { // yes
            state = NAMING_STATE.START_SAVE
            flash_fade(0, 1, 60)
            audio_play(snd_dtrans_lw)
            music_stop_all()
            alarm[0] = 100
        }
    }
}
else if state == NAMING_STATE.START_SAVE {
    name_angle = random(4)
    if confirm_alpha < 1
        confirm_alpha -= .1
}