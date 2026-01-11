if tp_constrict
    tp_defend = 2
else 
    tp_defend = 16

if battle_state == BATTLE_STATE.MENU {
    if battle_menu == BATTLE_MENU.BUTTON_SELECTION {
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
            battle_menu = party_buttons[party_selection][party_button_selection[party_selection]].press()
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
            battle_menu_enemy_proceed()
            
            buffer = 1
            if party_selection >= array_length(global.party_names) {
                __battle_state_advance()
                exit
            }
        }
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			battle_menu_enemy_cancel()
			buffer = 1
		}
		
		// if we changed selection, update the enemies flashing
		if __delta_selection != 0
			__enemy_highlight(party_enemy_selection[party_selection])
    }
    else if battle_menu == BATTLE_MENU.INV_SELECTION {
        var __button = party_buttons[party_selection][party_button_selection[party_selection]]
        
        var list = battle_menu_inv_list
        var selection_var_name = battle_menu_inv_var_name
        var selection_operate = battle_menu_inv_var_operate
        
        var selected_item_index = variable_instance_get(self, selection_var_name)[party_selection]
        selected_item_index = clamp(selected_item_index, 0, array_length(list)-1)
        
        // four direction ui movement
        if InputPressed(INPUT_VERB.RIGHT) && selected_item_index < array_length(list) - 1 {
            selected_item_index ++
			if selected_item_index % 2 == 0
				selected_item_index -= 2
			
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.DOWN) && selected_item_index < array_length(list) - 2 {
			selected_item_index += 2
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.LEFT) && selected_item_index > 0 {
			selected_item_index -= 1
			if selected_item_index % 2 == 1
				selected_item_index += 2
			audio_play(snd_ui_move)
		}
		else if InputPressed(INPUT_VERB.LEFT) && selected_item_index == 0 && array_length(list) > 1 {
			selected_item_index -= 1
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.UP) && selected_item_index > 1 {
			selected_item_index -= 2
			audio_play(snd_ui_move)
		}
        
        selection_operate(cap_wraparound(selected_item_index, array_length(list)), true)
        
        if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
            battle_menu_inv_proceed(list[selected_item_index])
            
            buffer = 1
            if party_selection >= array_length(global.party_names) {
                __battle_state_advance()
                exit
            }
        }
        if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
            battle_menu_inv_cancel()
            buffer = 1
        }
    }
    else if battle_menu == BATTLE_MENU.PARTY_SELECTION {
        var __moved = true
		if InputPressed(INPUT_VERB.UP) {
			audio_play(snd_ui_move)
			party_ally_selection[party_selection] --
		}
		else if InputPressed(INPUT_VERB.DOWN) {
			audio_play(snd_ui_move)
			party_ally_selection[party_selection] ++
		}
        else
            __moved = false
		
		// cap navigation
        party_ally_selection[party_selection] = cap_wraparound(party_ally_selection[party_selection], array_length(global.party_names))
		
        if InputPressed(INPUT_VERB.SELECT) && buffer == 0 { 
            audio_play(snd_ui_select)
            battle_menu_party_proceed()
            
            buffer = 1
            if party_selection >= array_length(global.party_names) {
                __battle_state_advance()
                exit
            }
        }
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			battle_menu_party_cancel()
			buffer = 1
		}
		
		// if we changed selection, update the enemies flashing
		if __moved
			__ally_highlight(party_ally_selection[party_selection])
    }
    
    // skip if the party member is busy at the moment
    while party_selection < array_length(global.party_names)
        && !(party_isup(global.party_names[party_selection]) 
            && !array_contains(party_busy, global.party_names[party_selection]) 
            && !array_contains(party_busy_internal, global.party_names[party_selection])
        )
    {
        party_selection ++
    }
    if party_selection >= array_length(global.party_names) {
        __battle_state_advance()
        exit
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
        if buffer == 0 {
            if array_length(action_queue) > 0 {
                var action = action_queue[0]
                array_delete(action_queue, 0, 1) // dequeue the action
                
                action.perform(action_queue)
            }
            else 
                __battle_state_advance()
        }
    }
    else 
        buffer = 2
}
else if battle_state == BATTLE_STATE.DIALOGUE {
    if !pre_dialogue_init {
        __call_enc_event("ev_pre_dialogue")
        pre_dialogue_init = true
    }
    if !__check_waiting() {
        if !dialogue_init {
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
    			
    			var text = encounter_data.enemies[i].dialogue
    			if is_callable(text)
    				text = text(i)
    			
    			if is_string(text) || is_array(text) {
                    var inst = actor_dialogue_create(text, encounter_data.enemies[i].actor_id,,, {
                        spr: encounter_data.enemies[i].dia_bubble_sprites
                    }, encounter_data.enemies[i].dia_bubble_off_x, encounter_data.enemies[i].dia_bubble_off_y, encounter_data.enemies[i].dia_bubble_off_type) 
    			    array_push(inst_dialogues, inst)
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
        
        var move_on = true
    	for (var i = 0; i < array_length(inst_dialogues); ++i) {
    	    if instance_exists(inst_dialogues[i]) {
    			move_on = false
    			break
    		}
    	}
        
    	if move_on && win_condition()
            battle_state = BATTLE_STATE.WIN
    	else if move_on {
            with o_enc_target
                instance_destroy()
    		__battle_state_advance()
        }
    }
}
else if battle_state == BATTLE_STATE.TURN {
    if !turn_init {
		mybox = instance_create(o_enc_box)
		mysoul = instance_create(o_enc_soul, 
			get_leader().x, get_leader().s_get_middle_y(), 
			DEPTH_ENCOUNTER.SOUL
		)
        
        for (var i = 0; i < array_length(turn_objects); ++i) {
            if instance_exists(turn_objects[i]) {
                // call the box created event for turn objects
                with turn_objects[i] {
                    event_user(2)
                }
            }
        }
        
        if tp_constrict
            o_enc_soul.inst_aura = instance_create(o_enc_soul_aura, 
                o_enc_soul.x, o_enc_soul.y, 
                DEPTH_ENCOUNTER.SOUL
            )
        
        __call_enc_event("ev_turn")
		
		turn_init = true
		turn_timer = 0
	}
	else if !instance_exists(mybox) {
        if win_condition()
            battle_state = BATTLE_STATE.WIN
        else
		  __battle_state_advance()
	}
	else if !mybox.is_transitioning {
		if turn_timer == 0 {
			for (var i = 0; i < array_length(turn_objects); ++i) {
				if instance_exists(turn_objects[i]) {
					// call the turn start event for the turn objects
					with turn_objects[i] {
						event_user(1)
					}
				}
			}
            for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
    			if enc_enemy_isfighting(i) {
    				// call the turn start event for the enemies
    				if is_callable(encounter_data.enemies[i].ev_turn_start)
    					encounter_data.enemies[i].ev_turn_start()
    			}
    		}
            if is_callable(encounter_data.ev_turn_start)
                encounter_data.ev_turn_start()
		}
		turn_timer ++
		
		var move_on = true
		for (var i = 0; i < array_length(turn_objects); ++i) {
			if !enc_enemy_isfighting(i) continue
			if instance_exists(turn_objects[i]) move_on = false
		}
		if move_on {
			mybox.__close()
			mysoul.alarm[0] = 1
            
            animate(o_eff_bg.fade, 0, 20, anime_curve.linear, o_eff_bg, "fade")
		}
	}
}
else if battle_state == BATTLE_STATE.POST_TURN {
    if !post_turn_init {
        __call_enc_event("ev_post_turn")
        post_turn_init = true
    }
    
    if !waiting {
        for (var i = 0; i < array_length(global.party_names); ++i) { // heal party members and un-dim them
            // if defending, or anything else for that matter, just go back to being idle
            enc_party_set_battle_sprite(global.party_names[i], "idle")
            
            party_state[i] = PARTY_STATE.IDLE
            
            if !array_contains(turn_targets, global.party_names[i]) // if i wasn't target, stop being dimmed
                animate(party_get_inst(global.party_names[i]).darken, 0, 15, anime_curve.linear, party_get_inst(global.party_names[i]), "darken")
       	    if !party_isup(global.party_names[i])
                party_heal(global.party_names[i], round(party_getdata(global.party_names[i], "max_hp") * .13))
        }
        
        var flav = encounter_data.flavor
        if is_callable(flav)
            flavor = flav()
        else 
            flavor = flav
       	
        { // reset variable values
            flavor_seen = false
            exec_init = false
            dialogue_init = false
            turn_init = false
            
            party_state = array_create(array_length(global.party_names), PARTY_STATE.IDLE)
            party_button_selection = array_create(array_length(global.party_names), 0)
            party_enemy_selection = array_create(array_length(global.party_names), 0)
            party_act_selection = array_create(array_length(global.party_names), 0)
            party_item_selection = array_create(array_length(global.party_names), 0)
            party_spell_selection = array_create(array_length(global.party_names), 0)
            party_ally_selection = array_create(array_length(global.party_names), 0)
            
            party_busy_internal = []
            party_selection = 0
            
            action_queue = []
            
            battle_menu = BATTLE_MENU.BUTTON_SELECTION
            battle_menu_init = false
        }
        
        if win_condition()
            battle_state = BATTLE_STATE.WIN
        else
            __battle_state_advance()
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