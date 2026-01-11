if battle_state == BATTLE_STATE.MENU {
    var __defend_tp = 16
    if tp_constrict
        __defend_tp = 2
    
    if battle_menu == BATTLE_MENU.BUTTON_SELECTION {
        battle_menu_init = false
        
        if InputPressed(INPUT_VERB.RIGHT) {
            audio_play(snd_ui_move)
            party_button_selection[party_selection] ++
        }
        else if InputPressed(INPUT_VERB.LEFT) {
            audio_play(snd_ui_move)
            party_button_selection[party_selection] --
        }
        
        if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
            audio_play(snd_ui_select)
            battle_menu = party_buttons[party_selection][party_button_selection[party_selection]].press(__defend_tp)
            battle_menu_init = true
            
            if party_selection >= array_length(global.party_names) {
                __battle_state_advance()
                exit
            }
        }
        if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 && party_selection > 0 {
            var __selection = party_selection
            
            party_selection --
            while !(party_isup(global.party_names[party_selection]) 
                && !array_contains(party_busy, global.party_names[party_selection]) 
                && !array_contains(party_busy_internal, global.party_names[party_selection])
            ) {
                party_selection --
                if party_selection < 0 {
                    party_selection = __selection
                    break
                }
            }
            
            if array_length(action_queue) > 0 {
                array_pop(action_queue).cancel() // cancel the last action
            }
        }
        
        // cap navigation
        party_button_selection[party_selection] = cap_wraparound(party_button_selection[party_selection], array_length(party_buttons[party_selection]))
        
        if !instance_exists(inst_flavor) {
            inst_flavor = dialogue_start((flavor_seen ? "{instant}" : "") + enc_get_flavor(encounter_data) + "{stop}")
            inst_flavor.die_delay = 0
            flavor_seen = true
        }
    }
    else if battle_menu == BATTLE_MENU.ENEMY_SELECTION {
        var __delta_selection = 0
        var __button = party_buttons[party_selection][party_button_selection[party_selection]]
        
        if battle_menu_init {
            __enemy_highlight(party_enemy_selection[party_selection])
            battle_menu_init = false
        }
		
		if InputPressed(INPUT_VERB.UP) {
			audio_play(snd_ui_move)
			party_enemy_selection[party_selection] --
            
			__delta_selection = -1
		}
		else if InputPressed(INPUT_VERB.DOWN) {
			audio_play(snd_ui_move)
			party_enemy_selection[party_selection] ++
            
			__delta_selection = 1
		}
		
		// cap navigation
        party_enemy_selection[party_selection] = cap_wraparound(party_enemy_selection[party_selection], array_length(encounter_data.enemies))
		
		// skip to the next enemy if needed
		while !enc_enemy_isfighting(party_enemy_selection[party_selection]){
			party_enemy_selection[party_selection] += __delta_selection
			party_enemy_selection[party_selection] = cap_wraparound(party_enemy_selection[party_selection], array_length(encounter_data.enemies))
		}
		
        if InputPressed(INPUT_VERB.SELECT) && buffer == 0 { 
            audio_play(snd_ui_select)
            __button.menu_proceed()
            buffer = 1
            
            // reset enemy flashing
			__enemy_highlight_reset()
            
            if party_selection >= array_length(global.party_names) {
                __battle_state_advance()
                exit
            }
        }
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			__button.menu_cancel()
			buffer = 1
			
            // reset enemy flashing
			__enemy_highlight_reset()
		}
		
		// if we changed selection, update the enemies flashing
		if __delta_selection != 0
			__enemy_highlight(party_enemy_selection[party_selection])
    }
    
    // skip if the party member is busy at the moment
    while !(party_isup(global.party_names[party_selection]) 
        && !array_contains(party_busy, global.party_names[party_selection]) 
        && !array_contains(party_busy_internal, global.party_names[party_selection])
    ) {
        party_selection ++
    }
    
    // the sticks in the ui
    for (var i = 0; i < 3; ++i) {
	    ui_party_sticks[i] += .25
		if ui_party_sticks[i] > 0 
            ui_party_sticks[i] *= 1.03
		if ui_party_sticks[i] > 20 
            ui_party_sticks[i] = 0
	}
}
else if battle_state == BATTLE_STATE.EXEC {
    if !exec_init {
        action_queue = __order_action_queue()
        exec_init = true
    }
    if !__check_waiting() {
        if array_length(action_queue) > 0 {
            var action = action_queue[0]
            array_delete(action_queue, 0, 1) // dequeue the action
            
            action.perform(action_queue)
        }
        else 
            __battle_state_advance()
    }
}
else if battle_state == BATTLE_STATE.DIALOGUE {
    if !__check_waiting() {
        if !dialogue_init {
            __call_enc_event("ev_pre_dialogue")
            
            animate(0, .75, 15, "linear", o_eff_bg, "fade")
            turn_objects = array_create(array_length(encounter_data.enemies), noone)
    		for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
    			if !enc_enemy_isfighting(i)
    				continue
    			
    			// create turn objects feed the information to them
    			array_set(turn_objects, i, instance_create(encounter_data.enemies[i].turn_object,,,, {
    				enemy_index: i, 
    				enemy_struct: encounter_data.enemies[i]
    			}))
    			
    			var xx = encounter_data.enemies[i].actor_id.x - guipos_x()
    			var yy = encounter_data.enemies[i].actor_id.y - guipos_y()
    			
    			if encounter_data.enemies[i].dia_bubble_offset[2] == 0 {
    				xx -= encounter_data.enemies[i].actor_id.sprite_xoffset
    				yy -= encounter_data.enemies[i].actor_id.myheight/2
    			}
    			else {
    				xx += encounter_data.enemies[i].dia_bubble_offset[0]
    				yy += encounter_data.enemies[i].dia_bubble_offset[1]
    			}
    			
    			var text = encounter_data.enemies[i].dialogue
    			if is_callable(text)
    				text = text(i)
                
                
    			
    			if is_string(text) {
    				var inst = instance_create(o_ui_enemydialogue, xx*2, yy*2, DEPTH_ENCOUNTER.UI, {text})
    				inst.spr = encounter_data.enemies[i].dia_bubble_sprites
    				
    			    array_push(dialogueinstances, inst)
    			}
    		}
            
            __call_enc_event("ev_dialogue")
            
            // choose turn targets
            turn_targets = encounter_data._target_calculation()
    		for (var i = 0; i < array_length(global.party_names); ++i) {
    		    if array_contains(turn_targets, global.party_names[i]) {
                    if encounter_data.display_target {
    				    var o = party_get_inst(global.party_names[i])
                        instance_create(o_enc_target, o.x, o.s_get_middle_y(), o.depth-10)
                    }
    			}
    			else {
    				var o = party_get_inst(global.party_names[i])
    				animate(o.darken, .5, 15, "linear", o, "darken")
    			}
    		}
    		
    		dialogue_init = true
        }
    }
}

// destroy flavor text when not in the selection screen
if (battle_state != BATTLE_STATE.MENU || battle_menu != BATTLE_MENU.BUTTON_SELECTION) && instance_exists(inst_flavor)
    instance_destroy(inst_flavor)

ui_main_lerp = lerp(ui_main_lerp, 1, .5)
// do party ui lerping
for (var i = 0; i < array_length(global.party_names); i ++) {
    if i == party_selection 
        party_ui_lerp[i] = lerp(party_ui_lerp[i], 1, .5)
    else
        party_ui_lerp[i] = lerp(party_ui_lerp[i], 0, .5)
}

if buffer > 0
    buffer --