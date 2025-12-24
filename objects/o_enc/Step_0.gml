if battle_state == BATTLE_STATE.MENU {
    var __defend_tp = 16
    if tp_constrict
        __defend_tp = 2
    
    if ui_menu_state == 0 {
        if InputPressed(INPUT_VERB.RIGHT) {
            audio_play(snd_ui_move)
            party_button_selection[party_selection] ++
        }
        else if InputPressed(INPUT_VERB.LEFT) {
            audio_play(snd_ui_move)
            party_button_selection[party_selection] --
        }
        
        party_button_selection[party_selection] = (party_button_selection[party_selection] + array_length(party_buttons[party_selection])) % array_length(party_buttons[party_selection])
    }
    
    if party_selection < array_length(global.party_names) {
        for (var i = 0; i < array_length(global.party_names); i ++) {
            if i == party_selection {
                party_ui_lerp[i] = lerp(party_ui_lerp[i], 1, .5)
            }
            else {
                party_ui_lerp[i] = lerp(party_ui_lerp[i], 0, .5)
            }
        }
    }
    
    for (var i = 0; i < 3; ++i) {
	    ui_party_sticks[i] += .25
		if ui_party_sticks[i] > 0 
            ui_party_sticks[i] *= 1.03
		if ui_party_sticks[i] > 20 
            ui_party_sticks[i] = 0
	}
}

ui_main_lerp = lerp(ui_main_lerp, 1, .5)