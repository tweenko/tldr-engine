if tp_constrict
    tp_defend = 2
else 
    tp_defend = 16

// call the initializer event
if !encounter_init {
    __call_enc_event("ev_init")
    encounter_init = true
}

if battle_state == BATTLE_STATE.MENU {
    if !party_menu_init {
        party_menu_init = true
        __call_enc_event("ev_party_turn")
    }
    
    if battle_menu == BATTLE_MENU.BUTTON_SELECTION {
        if InputPressed(INPUT_VERB.RIGHT) {
            audio_play(snd_ui_move)
            party_button_selection[party_selection] ++
        }
        else if InputPressed(INPUT_VERB.LEFT) {
            audio_play(snd_ui_move)
            party_button_selection[party_selection] --
        }
        
        // cap navigation
        party_button_selection[party_selection] = cap_wraparound(party_button_selection[party_selection], array_length(party_buttons[party_selection]))
        
        if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
            party_buttons[party_selection][party_button_selection[party_selection]].press()
            
            if party_selection >= array_length(global.party_names) || party_selection < 0 {
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
        
        if !instance_exists(inst_flavor) {
            turn_flavor ??= enc_get_flavor(encounter_data)
            
            inst_flavor = dialogue_start((flavor_seen ? "{instant}" : "") + turn_flavor + "{stop}")
            inst_flavor.die_delay = 0
            flavor_seen = true
        }
    }
    else if battle_menu == BATTLE_MENU.ENEMY_SELECTION {
        var __delta_selection = 1 // set to 1 instead of 0 so the enemies are cycled when the menu is open
        var __moved = false
        var __button = party_buttons[party_selection][party_button_selection[party_selection]]
		
		if InputPressed(INPUT_VERB.UP) {
			audio_play(snd_ui_move)
			party_enemy_selection[party_selection] --
            
			__delta_selection = -1
            __moved = true
		}
		else if InputPressed(INPUT_VERB.DOWN) {
			audio_play(snd_ui_move)
			party_enemy_selection[party_selection] ++
            
			__delta_selection = 1
            __moved = true
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
        }
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			battle_menu_enemy_cancel()
			buffer = 1
		}
		
		// if we changed selection, update the enemies flashing
		if __moved
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
        if selected_item_index > 5
			array_set(variable_instance_get(self, battle_menu_inv_page_var_name), party_selection, 1)
		else
			array_set(variable_instance_get(self, battle_menu_inv_page_var_name), party_selection, 0)
        
        selection_operate(cap_wraparound(selected_item_index, array_length(list)), true)
        
        if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
            battle_menu_inv_proceed(list[selected_item_index])
            buffer = 1
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
            battle_menu_party_proceed()
            buffer = 1
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
    while (party_selection < array_length(global.party_names) && party_selection >= 0)
        && !(party_isup(global.party_names[party_selection]) 
            && !array_contains(party_busy, global.party_names[party_selection]) 
            && !array_contains(party_busy_internal, global.party_names[party_selection])
        )
    {
        party_selection ++
    }
    if party_selection >= array_length(global.party_names) || party_selection < 0 {
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
    else if !__check_waiting() {
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
        buffer = 2
    }
    if !__check_waiting() && buffer == 0 {
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
    			
    			if (is_string(text) && text != "") || (is_array(text) && array_length(text) > 0) {
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
        
    	if move_on {
            with o_enc_target
                instance_destroy()
    		__battle_state_advance()
        }
    }
}
else if battle_state == BATTLE_STATE.TURN {
    if !pre_turn_init {
        __call_enc_event("ev_turn")
        buffer = 2
        
        pre_turn_init = true
    }
    else if buffer == 0 && !__check_waiting() {
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
    		
    		turn_init = true
    		turn_timer = 0
    	}
    	else if !instance_exists(mybox) {
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
            __call_enc_event("ev_turn_start")
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
}
else if battle_state == BATTLE_STATE.POST_TURN {
    if !post_turn_init {
        turn_count ++
        
        __call_enc_event("ev_post_turn")
        post_turn_init = true
        buffer = 2
    }
    if !__check_waiting() && buffer == 0 {
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
       	
        event_user(1)
        __battle_state_advance()
    }
}
else if battle_state == BATTLE_STATE.WIN {
    if !win_screen_init {
        __call_enc_event("win")
        win_screen_init = true
        buffer = 2
    }
    if !win_init && !__check_waiting() && buffer == 0 {
        var __exp = 0
        var __dd = earned_money + global.chapter * tp / 4
        var __dd_mod = 1
        
		for (var i = 0; i < array_length(global.party_names); ++i) {
		    party_state[i] = PARTY_STATE.IDLE
			
			if party_getdata(global.party_names[i], "is_down") {
				party_setdata(global.party_names[i], "hp", round(party_getdata(global.party_names[i], "max_hp") * .12))
                party_setdata(global.party_names[i], "is_down", false)
            }
            
			enc_party_set_battle_sprite(global.party_names[i], "victory", 0, 1)
            
            if !is_undefined(party_getdata(global.party_names[i], "weapon")) && struct_exists(party_getdata(global.party_names[i], "weapon").stats_misc, "money_modifier")
                __dd_mod += party_getdata(global.party_names[i], "weapon").stats_misc.money_modifier
            if !is_undefined(party_getdata(global.party_names[i], "armor1")) && struct_exists(party_getdata(global.party_names[i], "armor1").stats_misc, "money_modifier")
                __dd_mod += party_getdata(global.party_names[i], "armor1").stats_misc.money_modifier
            if !is_undefined(party_getdata(global.party_names[i], "armor2")) && struct_exists(party_getdata(global.party_names[i], "armor2").stats_misc, "money_modifier")
                __dd_mod += party_getdata(global.party_names[i], "armor2").stats_misc.money_modifier
		}
        
        __dd *= __dd_mod
        __dd = round(__dd)
        
        event_user(1)
        party_selection = -1
        
        // move the tp bar out of the way
        animate(0, -80, 10, anime_curve.circ_out, inst_tp_bar, "x_offset")
        
		cutscene_create()
        if win_dialogue_show
		  cutscene_dialogue(string(loc("enc_win"), __exp, __dd) + win_message)
        cutscene_set_variable(self, "win_hide_ui", true)
		cutscene_sleep(5)
        
        global.save.EXP += __exp
        global.save.MONEY += __dd
		
        cutscene_func(instance_destroy, [self])
        cutscene_func(instance_destroy, [inst_tp_bar])
		cutscene_set_variable(o_eff_bg, "destroy", true)
		cutscene_func(music_fade, [1, 0, 15])
        
        // move the party members and the enemies to where they need to be
		for (var i = 0; i < array_length(global.party_names); ++i) {
			var o = party_get_inst(global.party_names[i])
			
            cutscene_animate(o.x, save_pos[i][0], 12, "linear", o, "x")
		    cutscene_animate(o.y, save_pos[i][1], 12, "linear", o, "y")
		}
        for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
            if is_struct(encounter_data.enemies[i]) {
                var o = encounter_data.enemies[i].actor_id
                var a = marker_get("enemy_defeated", encounter_data.enemies[i].defeat_marker)
                
                if !is_undefined(a) && instance_exists(o) {
                    cutscene_animate(o.x, a.x, 12, "linear", o, "x")
                    cutscene_animate(o.y, a.y, 12, "linear", o, "y")
                }
            }
		}
		
        cutscene_sleep(12)
        // inform the actors they are no longer in a battle
		for (var i = 0; i < array_length(global.party_names); ++i) {
			var o = party_get_inst(global.party_names[i])
		    cutscene_set_variable(o, "is_in_battle", false)
		}
        for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
            if is_struct(encounter_data.enemies[i]) && instance_exists(encounter_data.enemies[i].actor_id) {
                var o = encounter_data.enemies[i].actor_id
                cutscene_set_variable(o, "is_in_battle", false)
            }
		}
		
        cutscene_set_variable(o_camera, "target", get_leader())
		cutscene_set_variable(get_leader(), "moveable_battle", true)
        
        if music_isplaying(0) {
            cutscene_func(music_resume, [0])
            cutscene_func(music_fade, [0, 1])
        }
        
        // make the party follow/not follow again
        for (var i = 0; i < array_length(save_follow); i ++) {
            cutscene_set_variable(party_get_inst(global.party_names[i]), "follow", save_follow[i])
        }
        
        cutscene_func(function() { // reset the battle music slot
            music_slot_reset(1)
        })
		cutscene_play()
        
        win_init = true
    }
}

// destroy flavor text when not in the selection screen
if (battle_state != BATTLE_STATE.MENU || battle_menu != BATTLE_MENU.BUTTON_SELECTION) && instance_exists(inst_flavor)
    instance_destroy(inst_flavor)

if !win_hide_ui
    ui_main_lerp = lerp(ui_main_lerp, 1, .5)
else
    ui_main_lerp = lerp(ui_main_lerp, 0, .5)

// do party ui lerping
for (var i = 0; i < array_length(global.party_names); i ++) {
    if i == party_selection 
        party_ui_lerp[i] = lerp(party_ui_lerp[i], 1, .5)
    else
        party_ui_lerp[i] = lerp(party_ui_lerp[i], 0, .5)
}

if buffer > 0
    buffer --