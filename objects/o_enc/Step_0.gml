// the general battle ui naviagation and execution
if battle_state == "menu" {
	var items = __item_sort()
	var spells = array_clone(party_getdata(global.party_names[selection], "spells"))
	for (var i = 0; i < array_length(struct_get(bonus_actions, global.party_names[selection])); ++i) { // add the actions aside from s-action or alike
	    array_insert(spells, i, struct_get(bonus_actions, global.party_names[selection])[i])
	}
	
	var updateglowing_enemy = function(selec = fightselection[selection]) {
		for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
			if !enc_enemy_isfighting(i)
				continue
			if selec == i
				encounter_data.enemies[i].actor_id.flashing = true
			else
				encounter_data.enemies[i].actor_id.flashing = false
		}
	}
	var updateglowing_party = function() {
		for (var i = 0; i < array_length(global.party_names); ++i) {
			if itemuserselection[selection] == i
				party_get_inst(global.party_names[i]).flashing = true
			else
				party_get_inst(global.party_names[i]).flashing = false
		}
	}
	
	if state == 0 { // button selector
		if InputPressed(INPUT_VERB.LEFT) {
			bt_selection[selection]--
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.RIGHT) {
			bt_selection[selection]++
			audio_play(snd_ui_move)
		}
		
		// cap the selection
		if bt_selection[selection] < 0 bt_selection[selection]=4
		if bt_selection[selection] > 4 bt_selection[selection]=0
		
		// press the buttons
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			if bt_selection[selection] == 4 {
				// set the party sprite to defend
				party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "defend")
				party_get_inst(global.party_names[selection]).image_index = 0
				party_get_inst(global.party_names[selection]).image_speed = 1
				
				char_state[selection] = 4
				selection ++
				
				state = 0
				tp += 16
				
				audio_play(snd_ui_select)
			}
			else if bt_selection[selection] == 2 {
				if array_length(items) > 0 {
					state ++
					buffer = 1
					dialogue_autoskip = true
					
					instance_clean(menutext)
					audio_play(snd_ui_select)
				}
				else 
					audio_play(snd_ui_cant_select)
			}
			else {
				state ++
				buffer = 1
				dialogue_autoskip = true
				if (bt_selection[selection] == 0 
					|| bt_selection[selection] == 3 
					|| (bt_selection[selection] == 1 && can_act[selection])) 
				{
					updateglowing_enemy()
				}
				
				instance_clean(menutext)
				audio_play(snd_ui_select)
			}
		}
		
		// set up skipping characters that should be busy (ignored)
		var iignore = []
		if !array_equals(ignore, []) 
			array_copy(iignore, 0, ignore, 0, array_length(ignore))
		if !array_equals(ignore, []) 
			array_sort(iignore, true)
		if array_equals(ignore,[]) 
			iignore[0] = 0
		
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 && selection > 0 {
			selection --
			buffer = 1
			
			while array_contains(ignore, selection) {
				if char_state[selection] != -1 {
					char_state[selection] = -1
					
					// set the sprite back to the idle sprite
					party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "idle")
					party_get_inst(global.party_names[selection]).image_speed = 1
				}
				array_delete(ignore, array_get_index(ignore, selection), 1)
				selection --
			}
			while !party_isup(global.party_names[selection]) {
				if char_state[selection] != -1 {
					char_state[selection] = -1;
					
					// set the sprite back to the idle sprite
					party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "idle")
					party_get_inst(global.party_names[selection]).image_speed = 1
				}
				selection --
			}
			
			// if i was together with somebody performing an action, free them as well
			if is_array(together_with[selection]) {
				if !array_equals(together_with[selection], []) {
					for (var i = 0; i < array_length(together_with[selection]); ++i) {
					    char_state[i] = -1;
						
						// set the sprite back to the idle one
						party_get_inst(global.party_names[i]).sprite_index = enc_getparty_sprite(i, "idle")
						party_get_inst(global.party_names[i]).image_speed = 1
						
						array_delete(ignore, array_get_index(ignore, together_with[i]), 1)
					}
					together_with[selection]=[]
				}
			}
			else {
				var i = together_with[selection]
				char_state[i] = -1;
				
				party_get_inst(global.party_names[i]).sprite_index = enc_getparty_sprite(i, "idle")
				party_get_inst(global.party_names[i]).image_speed = 1
				
				array_delete(ignore, array_get_index(ignore, together_with), 1)
				together_with[selection] = []
			}
			
			// if i was selecting an item, make sure it isn't used anymore
			if char_state[selection] == 2
				array_pop(items_using)
			// if i was using magic, return the tp i spent
			if char_state[selection] == 5 && !can_act[selection] && tp_upon_spell[selection] != -1 {
				tp = tp_upon_spell[selection]
				array_set(tp_upon_spell, selection, -1)
			}
			// if i was acting and used tp, return the tp i spent
			if char_state[selection] == 1 && can_act[selection] && tp_upon_spell[selection] != -1 {
				tp = tp_upon_spell[selection]
				array_set(tp_upon_spell, selection, -1)
			}
			
			// return the tp if i was defending
			if char_state[selection] == 4
				tp -= 16
			
			// get back to being idle
			char_state[selection] = -1
			party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "idle")
			party_get_inst(global.party_names[selection]).image_speed = 1
		}
	}
	else if state == 1 && (bt_selection[selection] == 0 // enemy selector
			|| bt_selection[selection] == 3 
			|| (bt_selection[selection] == 1 && can_act[selection])
		) || (bt_selection[selection] == 2 && state == 3) 
		|| (!can_act[selection] 
			&& bt_selection[selection] == 1 
			&& spells[actselection[selection]].use_type == 2 
			&& state == 3
	){
		var eselectordelta = 1
        var __changed = false
		
		if InputPressed(INPUT_VERB.UP) {
			fightselection[selection] --
			audio_play(snd_ui_move)
			eselectordelta = -1
            __changed = true
		}
		if InputPressed(INPUT_VERB.DOWN) {
			fightselection[selection] ++
			audio_play(snd_ui_move)
			eselectordelta = 1
            __changed = true
		}
		
		// cap this
		if fightselection[selection] > array_length(encounter_data.enemies) - 1
			fightselection[selection] = 0
		if fightselection[selection] < 0 
			fightselection[selection] = array_length(encounter_data.enemies) - 1
		
		// skip to the next enemy if needed
		while !enc_enemy_isfighting(fightselection[selection]){
			fightselection[selection] += eselectordelta
			
			if fightselection[selection] > array_length(encounter_data.enemies) - 1
				fightselection[selection] = 0
			if fightselection[selection] < 0
				fightselection[selection] = array_length(encounter_data.enemies) - 1
		}
		
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			state --
			buffer = 1
			
			for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
				if !enc_enemy_isfighting(i)
					continue
			    encounter_data.enemies[i].actor_id.flashing = false
			}
			
			if bt_selection[selection] == 2
				state = 1
			if bt_selection[selection] == 1 && !can_act[selection]
				state = 1
		}
		
		// if we moved, update the enemies flashing
		if __changed {
			for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
				if !enc_enemy_isfighting(i)
					continue
				
			    if fightselection[selection] == i
					encounter_data.enemies[i].actor_id.flashing = true
				else
					encounter_data.enemies[i].actor_id.flashing = false
			}
		}
		
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			if bt_selection[selection] == 0 { // attack, enemy selected
				char_state[selection] = 0
				state = 0 // continue
				
				for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
					if !enc_enemy_isfighting(i)
						continue
					encounter_data.enemies[i].actor_id.flashing = false
				}
				
				// set the sprite accoredingly
				party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "attackready")
				party_get_inst(global.party_names[selection]).image_speed = 1
				selection ++
				
				audio_play(snd_ui_select)
			}
			else if bt_selection[selection] == 1 && can_act[selection] { // act, enemy selected. act selection incoming
				state ++ // advance to the next depth of the act menu
				buffer = 1
				
				audio_play(snd_ui_select)
			}
			else if bt_selection[selection] == 1 && !can_act[selection] { // power, spell selected
				party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "spellready")
				party_get_inst(global.party_names[selection]).image_speed = 1
				
				// save the tp amount we used
				array_set(tp_upon_spell, selection, tp)
				tp = tp_clamp(tp)
				tp -= spells[actselection[selection]].tp_cost
				
				char_state[selection] = 5
				selection ++
				state = 0
				audio_play(snd_ui_select)
				
				// make the enemies stop flashing
				for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
					if !enc_enemy_isfighting(i)
						continue
					encounter_data.enemies[i].actor_id.flashing = false
				}
			}	
			else if bt_selection[selection] == 3 { // spare, enemy selected
				char_state[selection] = 3
				selection ++
				state = 0
				
				audio_play(snd_ui_select)
				
				// make the enemies stop flashing
				for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
					if !enc_enemy_isfighting(i)
						continue
					
					encounter_data.enemies[i].actor_id.flashing = false
				}
			}
			else if bt_selection[selection] == 2 { // items, item selected
				party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "itemready")
				party_get_inst(global.party_names[selection]).image_speed = 1
				char_state[selection] = 2
				
				array_push(items_using, item_get_name(items[itemselection[selection]]))
				
				selection ++
				state = 0
				buffer = 1
				audio_play(snd_ui_select)
				
				// make the highlighted stop flashing
				for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
					if !enc_enemy_isfighting(i)
						continue
					encounter_data.enemies[i].actor_id.flashing = false
				}
			}
		}
	}
	else if !can_act[selection] // power menu
		&& bt_selection[selection] == 1 
		&& spells[actselection[selection]].use_type == 2 
		&& state == 4
	{
		var eselectordelta = 1
        var changed = false
		
		if InputPressed(INPUT_VERB.UP) {
			partyactselection[selection] --; 
			audio_play(snd_ui_move);
			eselectordelta = -1
            changed = true
		}
		if InputPressed(INPUT_VERB.DOWN) {
			partyactselection[selection] ++; 
			audio_play(snd_ui_move);
			eselectordelta = 1
            changed = true
		}
		
		// cap
		if partyactselection[selection] > array_length(encounter_data.enemies) - 1
			partyactselection[selection] = 0
		if partyactselection[selection] < 0
			partyactselection[selection] = array_length(encounter_data.enemies) - 1
		
		// skip the enemies that aren't fighting anymore
		while !enc_enemy_isfighting(partyactselection[selection]) {
			partyactselection[selection] += eselectordelta
			
			if partyactselection[selection] > array_length(encounter_data.enemies) - 1
				partyactselection[selection] = 0
			if partyactselection[selection] < 0
				partyactselection[selection] = array_length(encounter_data.enemies) - 1
		}
		
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			state --
			buffer = 1
			for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
				if !enc_enemy_isfighting(i)
					continue
				
			    encounter_data.enemies[i].actor_id.flashing = false
			}
			
			if bt_selection[selection] == 1 && !can_act[selection] 
				state = 1
		}
		
		if changed {
			for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
				if !enc_enemy_isfighting(i)
					continue
					
			    if partyactselection[selection] == i
					encounter_data.enemies[i].actor_id.flashing = true
				else
					encounter_data.enemies[i].actor_id.flashing = false
			}
		}
		
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "actready")
			party_get_inst(global.party_names[selection]).image_speed = 1
			
			char_state[selection] = 1
			selection ++
			state = 0
			buffer = 1
			
			audio_play(snd_ui_select)
			
			for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
				if !enc_enemy_isfighting(i)
					continue
				
				encounter_data.enemies[i].actor_id.flashing = false
			}
		}
	}
	
	if state == 2 && bt_selection[selection] == 1 && can_act[selection] { // act selector
		var acts = __act_sort()
		
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			state--
			buffer = 1
			
			updateglowing_enemy()
		}
		
		// movement
		if InputPressed(INPUT_VERB.RIGHT) && actselection[selection] < array_length(acts) - 1 {
			actselection[selection] ++
			if actselection[selection] % 2 == 0
				actselection[selection] -= 2 
			
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.DOWN) && actselection[selection] < array_length(acts) - 2 {
			actselection[selection] += 2;
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.LEFT) && actselection[selection] > 0 {
			actselection[selection] -- 
			if actselection[selection] % 2 == 1
				actselection[selection] += 2
			audio_play(snd_ui_move)
		}
		else if InputPressed(INPUT_VERB.LEFT) && actselection[selection] == 0 && array_length(acts) > 1 {
			actselection[selection] = 1; 
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.UP) && actselection[selection] > 1 {
			actselection[selection] -= 2; 
			audio_play(snd_ui_move)
		}
		
		// cap
		if actselection[selection] < 0
			actselection[selection] = array_length(acts) - 1
		if actselection[selection] > array_length(acts) - 1
			actselection[selection] = 0
		
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			var cando = 1
			
			var ii = actselection[selection]
			if array_length(acts[ii].party) > 0 || acts[ii].party == -1 {
				var add = array_length(acts[ii].party)
				
				if acts[ii].party == -1 {
					together_with[selection] = []
					
					if struct_exists(acts[ii], "tp_cost") && tp < acts[ii].tp_cost 
						cando=false
					if cando {
						for (var j = 1; j < array_length(global.party_names); ++j) {
							if !party_isup(global.party_names[j]) 
								cando=false
						}
						char_state[selection] = 1
						
						for (var j = 1; j < array_length(global.party_names); ++j) {
							var me = j
							array_push(ignore, me)
							
							party_get_inst(global.party_names[me]).sprite_index = enc_getparty_sprite(me, "actready")
							party_get_inst(global.party_names[me]).image_speed = 1
							char_state[me]=1
							
							array_push(together_with[selection], me)
						}
					}
				}
				else {
					for (var j = 0; j < add; ++j) {
						if !party_isup(acts[ii].party[j]) 
							cando=false
					}
					if cando {
						char_state[selection] = 1
						
						for (var j = 0; j < add; ++j) {
							var me = array_get_index(global.party_names, acts[ii].party[j])
						    array_push(ignore, me)
						
							party_get_inst(global.party_names[me]).sprite_index = enc_getparty_sprite(me, "actready")
							party_get_inst(global.party_names[me]).image_speed = 1
							char_state[me] = 1
							
							array_push(together_with[selection], me)
						}
					}
				}
			}
			
			if struct_exists(acts[ii], "tp_cost") && tp < acts[ii].tp_cost 
				cando = false
			if cando {
				char_state[selection] = 1
				
				for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
					if !enc_enemy_isfighting(i)
						continue
					
					encounter_data.enemies[i].actor_id.flashing = false
				}
				
				if struct_exists(acts[ii], "tp_cost") && acts[ii].tp_cost > 0 {
					array_set(tp_upon_spell, selection, tp)
					tp = tp_clamp(tp)
					tp -= acts[ii].tp_cost
				}
				else {
					array_set(tp_upon_spell, selection, tp)
				}
				
				party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "actready")
				party_get_inst(global.party_names[selection]).image_speed = 1
				
				selection ++
				state = 0
				buffer = 1
				
				audio_play(snd_ui_select)
			}
		}
	}
	if state == 1 && bt_selection[selection] == 2 { // item selector
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			state --
			buffer=1
		}
		
		if InputPressed(INPUT_VERB.RIGHT) && itemselection[selection] < array_length(items) - 1 {
			itemselection[selection] ++; 
			if itemselection[selection] % 2 == 0
				itemselection[selection]-=2
			
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.DOWN) && itemselection[selection] < array_length(items) - 2 {
			itemselection[selection] += 2; 
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.LEFT) && itemselection[selection] > 0 {
			itemselection[selection] --; 
			if itemselection[selection] % 2 == 1
				itemselection[selection] += 2
			
			audio_play(snd_ui_move)
		}
		else if InputPressed(INPUT_VERB.LEFT) && itemselection[selection] == 0 && array_length(items) > 1 {
			itemselection[selection] = 1; 
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.UP) && itemselection[selection] > 1 {
			itemselection[selection] -= 2; 
			audio_play(snd_ui_move)
		}
		
		// cap
		if itemselection[selection] < 0
			itemselection[selection] = array_length(items) - 1
		if itemselection[selection] > array_length(items)-1
			itemselection[selection] = 0
		if itemselection[selection] > 5
			itempage[selection] = 1
		else
			itempage[selection] = 0
		
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			if items[itemselection[selection]].use_type == 0 {
				state = 2
				buffer = 1
				
				audio_play(snd_ui_select)
				
				updateglowing_party()
			}
			else if items[itemselection[selection]].use_type == 1 {
				party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "itemready")
				party_get_inst(global.party_names[selection]).image_speed = 1
				char_state[selection] = 2
				
				array_push(items_using, item_get_name(items[itemselection[selection]]))
				
				selection ++
				state = 0
				buffer = 1
				
				audio_play(snd_ui_select)
			}
			else if items[itemselection[selection]].use_type == 2 {
				state = 3
				buffer = 1
				
				audio_play(snd_ui_select)
				
				updateglowing_enemy()
			}
		}
	}
	if state == 1 && bt_selection[selection] == 1 && !can_act[selection] { // spell selector
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			state --; 
			buffer = 1
		}
		
		// movement
		if InputPressed(INPUT_VERB.RIGHT) && actselection[selection] < array_length(spells) - 1 {
			actselection[selection]++; 
			if actselection[selection] % 2 == 0 {
				actselection[selection] -= 2
			} 
			
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.DOWN) && actselection[selection] < array_length(spells) - 2 {
			actselection[selection] += 2; 
			
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.LEFT) && actselection[selection] > 0 {
			actselection[selection] --; 
			if actselection[selection] % 2 == 1 {
				actselection[selection] += 2
			} 
			
			audio_play(snd_ui_move)
		}
		else if InputPressed(INPUT_VERB.LEFT) && actselection[selection] == 0 && array_length(spells) > 1 {
			actselection[selection] = 1; 
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.UP) && actselection[selection] > 1 {
			actselection[selection] -= 2 
			audio_play(snd_ui_move)
		}
		
		// cap
		if actselection[selection] < 0
			actselection[selection] = array_length(spells) - 1
		if actselection[selection] > array_length(spells) - 1
			actselection[selection] = 0
		if actselection[selection] > 5 
			spellpage[selection] = 1
		else
			spellpage[selection] = 0
		
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 && tp >= spells[actselection[selection]].tp_cost {
			if spells[actselection[selection]].use_type == ITEM_USE.INDIVIDUAL {
				state = 2
				buffer = 1
				
				audio_play(snd_ui_select)
				
				updateglowing_party()
			}
			else if spells[actselection[selection]].use_type == ITEM_USE.EVERYONE {
				party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "spellready")
				party_get_inst(global.party_names[selection]).image_speed = 1
				
                char_state[selection] = 5
				
				array_set(tp_upon_spell, selection, tp)
				tp = tp_clamp(tp)
				tp -= spells[actselection[selection]].tp_cost
				
				selection ++
				state = 0
				buffer = 1
				
				audio_play(snd_ui_select)
			}
			else if spells[actselection[selection]].use_type == ITEM_USE.ENEMY {
				if spells[actselection[selection]].is_party_act 
					state = 4
				else 
					state = 3
				
				buffer = 1
				
				audio_play(snd_ui_select)
				updateglowing_enemy(partyactselection[selection])
			}
		}
	}
	if state == 2 && (bt_selection[selection] == 2 || (!can_act[selection] && bt_selection[selection] == 1 && spells[actselection[selection]].use_type == 0)) { // item chooser
		var delta = false
		
		if InputPressed(INPUT_VERB.UP){
			itemuserselection[selection] -- 
			audio_play(snd_ui_move)
			delta = 1
		}
		if InputPressed(INPUT_VERB.DOWN){
			itemuserselection[selection] ++;
			audio_play(snd_ui_move)
			delta = 1
		}
		
		if itemuserselection[selection] < 0
			itemuserselection[selection] = array_length(global.party_names) - 1
		if itemuserselection[selection] > array_length(global.party_names) - 1
			itemuserselection[selection] = 0
		
		if delta 
			updateglowing_party()
		
		if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
			state -- 
			buffer = 1
			for (var i = 0; i < array_length(global.party_names); ++i) {
				party_get_inst(global.party_names[i]).flashing = false
			}
		}
		if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
			if bt_selection[selection] == 1 && spells[actselection[selection]].use_type == 0 {
				party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "spellready")
				party_get_inst(global.party_names[selection]).image_speed = 1
				char_state[selection] = 5
				
				array_set(tp_upon_spell, selection, tp)
				tp = tp_clamp(tp)
				tp -= spells[actselection[selection]].tp_cost
				
				selection ++
				state = 0
				buffer = 1
				
				audio_play(snd_ui_select)
				for (var i = 0; i < array_length(global.party_names); ++i) {
					party_get_inst(global.party_names[i]).flashing = false
				}
			}
			else {
				party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, "itemready")
				party_get_inst(global.party_names[selection]).image_speed = 1
				char_state[selection] = 2
				
				array_push(items_using, item_get_name(items[itemselection[selection]]))
				
				selection ++
				state = 0
				buffer = 1
				
				audio_play(snd_ui_select)
				for (var i = 0; i < array_length(global.party_names); ++i) {
					party_get_inst(global.party_names[i]).flashing = false
				}
			}
		}
	}
	
	// skip over the busy members
	if !array_equals(ignore, []) {
		while array_contains(ignore,selection) 
			selection++
	}
	
	if selection <= array_length(global.party_names) - 1 {
		while !party_isup(global.party_names[selection]) {
			selection ++
			
			if selection > array_length(global.party_names) - 1 
				break
		}
	}
	for (var i = 0; i < 3; ++i) {
	    uisticks[i] += .25
		if uisticks[i] > 0 uisticks[i] *= 1.03
		if uisticks[i] > 20 uisticks[i] = 0
	}

	if state == 0 { //create text if not exists
		if !instance_exists(menutext) {
			var pre = "{yspace(14)}"
			
			if dialogue_autoskip pre += "{instant}"
			menutext = instance_create(o_text_typer, 30, 376, DEPTH_ENCOUNTER.UI,{
				text: pre + encounter_data.flavor + "{stop}", 
				gui: true, 
				caller: id,
				destroy_caller: true
			})
		}
	}
	if selection > array_length(global.party_names) - 1 {
		tp = tp_clamp(tp)
		battle_state = "exec"
		instance_clean(menutext)
	}
}

// the party executes commands
if battle_state == "exec" {
	// initially calculate and queue the execution of commands
	if !exec_calculated {
		var review_queue_states = [1, 2, 5, 4, 3, 0] // the original order: act, item, magic, (defend), spare, attack
		
		var localcharstates = array_clone(char_state)
		var alreadyfighting = false
		
		fighters = []
		
		for (var i = 0; i < array_length(review_queue_states); ++i) {
			for (var j = 0; j < array_length(global.party_names); ++j) {
				if localcharstates[j] == review_queue_states[i]
					&& review_queue_states[2] != 4 // not defend
					&& review_queue_states[i] != -1
				{
					var record = true
					
					if is_array(together_with[j]) {
						if !array_equals(together_with[j],[]) {
							for (var v = 0; v < array_length(together_with[j]); ++v) {
								var me = together_with[j][v]
								localcharstates[me] = -1;
							}
						}
					}
					else {
						var v = together_with[j]
						localcharstates[v] = -1;
					}
						
					if localcharstates[j] == 0 {
						array_push(fighters, global.party_names[j])
						array_push(fighterselection, fightselection[j])
					}
					
					if localcharstates[j] == 0 && !alreadyfighting || localcharstates[j] != 0
						ds_queue_enqueue(exec_queue, [review_queue_states[i], j])
					if localcharstates[j] == 0 && !alreadyfighting
						alreadyfighting = true
				}
			}
		}
		exec_calculated = true
	}
	
	// do the next queued command
	if is_undefined(exec_current) {
		if ds_queue_size(exec_queue) > 0 {
			exec_current = ds_queue_dequeue(exec_queue)
			var user = exec_current[1] // index
			
			if exec_current[0] == 0 { // fight
				instance_create(o_enc_fight,,,, {
					caller: id, 
					depth: depth-1, 
					fighting: fighters, 
					fighterselection,
				})
				exec_wait = true
			}
			else if exec_current[0] == 1 && can_act[user] { // act
				if enc_enemy_isfighting(fightselection[user]) {
					var act_execer = encounter_data.enemies[fightselection[user]].acts[actselection[user]].exec
					
					// set the party sprite accordingly
					var o = party_get_inst(global.party_names[user])
					o.sprite_index = enc_getparty_sprite(user, "act")
					o.image_index = 0
					o.image_speed = 1
					
					// free the members we were doing the act together
					if is_array(together_with[user]) {
						if !array_equals(together_with[user], []) {
							for (var i = 0; i < array_length(together_with[user]); ++i) {
							    char_state[i] = -1;
								party_get_inst(global.party_names[i]).sprite_index = enc_getparty_sprite(i, "act")
								party_get_inst(global.party_names[i]).image_index = 0
								party_get_inst(global.party_names[i]).image_speed = 1
								
								array_delete(ignore, array_get_index(ignore, together_with[i]), 1)
							}
						}
					}
					else {
						var i = together_with[user]
						
						char_state[i] = -1;
						party_get_inst(global.party_names[i]).sprite_index = enc_getparty_sprite(i, "act")
						party_get_inst(global.party_names[i]).image_index = 0
						party_get_inst(global.party_names[i]).image_speed = 1
						
						array_delete(ignore, array_get_index(ignore, together_with), 1)
					}
				
					// perform the act
					if is_array(act_execer)
						script_execute_ext(act_execer[0], act_execer, 1)
					else
						script_execute(act_execer, encounter_data.enemies[fightselection[user]].slot, user)
				}
			}
			else if exec_current[0] == 1 && !can_act[user] { // special act
				if enc_enemy_isfighting(partyactselection[user]) {
					var act_execer = encounter_data.enemies[partyactselection[user]].acts_special
					var __default_action = 0
					
					if struct_exists(act_execer, global.party_names[user]){
						act_execer = struct_get(act_execer, global.party_names[user])
						var o = party_get_inst(global.party_names[user])
						o.sprite_index = enc_getparty_sprite(user, "act")
						o.image_index = 0
						o.image_speed = 1
				
						if struct_exists(act_execer, "exec")
							script_execute(act_execer.exec, 
								encounter_data.enemies[partyactselection[user]].slot, 
								encounter_data.enemies[partyactselection[user]].actor_id, 
								global.party_names[user]
							)
						else 
							__default_action = true
					
					}
					else 
						__default_action = true
					
					if __default_action
						encounter_scene_dialogue($"* Default {party_getname(global.party_names[user])} Action")
				}
			}
			else if exec_current[0] == 2 { // item
				var items = item_get_array(0)
				var o = party_get_inst(global.party_names[itemuserselection[user]])
				
				cutscene_create()
				
				cutscene_set_variable(o_enc, "exec_wait", true)
				cutscene_set_partysprite(user, "itemuse")
				
				cutscene_sleep(4)
				cutscene_dialogue(string("* {0} used the {1}!", 
					party_getname(global.party_names[user]), 
					string_upper(item_get_name(items[itemselection[user]]))), 
					"{stop}", false
				)
				
				// only continue when the item use animation is finished
				cutscene_wait_until(function(index){
					return party_get_inst(global.party_names[index]).sprname == "idle"
				}, [user])
				cutscene_func(function(user){
					o_enc.char_state[user] = -1
				}, [user])
				
				// actually use the said item
				cutscene_func(item_use, [items[itemselection[user]], itemselection[user], global.party_names[itemuserselection[user]]])
				cutscene_sleep(30)
				
				cutscene_func(instance_destroy, [o_ui_dialogue])
				cutscene_set_variable(o_enc, "exec_wait", false)
				cutscene_play()	
			}
			else if exec_current[0] == 3 { // spare
				exec_wait = true
				
				var o = party_get_inst(global.party_names[user]) // get party object
				o.sprite_index = enc_getparty_sprite(user, "spare")
				o.image_index = 0
				o.image_speed = 1
				
				var enemy = encounter_data.enemies[fightselection[user]] // get enemy struct
				
				// find other enemies if the target is not fighting
				var alternative = -1
				if !enc_enemy_isfighting(fightselection[user]) {
					for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
					    if !enc_enemy_isfighting(i) 
							continue
						if encounter_data.enemies[i].mercy >= 100 {
							alternative = i 
							break
						}
					}
					if alternative == -1 {
						for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
						    if !enc_enemy_isfighting(i) 
								continue
								
							alternative = i
							break
						}
					}
				}
				if alternative != -1 // reassign enemy struct if the enemy target is changed
					enemy = encounter_data.enemies[alternative]
				else
					alternative = fightselection[user]
				
				// spare animation cutscene
				var enemyo = enemy.actor_id // get enemy object
				cutscene_create()
				
				if enemy.mercy >= 100 { // spare
					cutscene_dialogue(string("* {0} spared {1}!", party_getname(global.party_names[user]), enemy.name), "{stop}", false)
					cutscene_wait_until(function(index){
						return party_get_inst(global.party_names[index]).sprname == "idle"
					}, [user])
					
					cutscene_func(function(user){
						o_enc.char_state[user] = -1
					}, [user])
					
                    cutscene_spare_enemy(alternative)
                    
					cutscene_sleep(30)
					cutscene_func(instance_destroy, [o_ui_dialogue])
					cutscene_set_variable(o_enc, "exec_wait", false)
				}
				else { // cant spare
					var txt = "* {0} spared {1}!{br}{resetx}* But its name wasn't {col(y)}YELLOW{col(w)}..."
					
					if enemy.tired {
						var tgt_spell = -1
						var spellowner = ""
						for (var i = 0; i < array_length(global.party_names); ++i) { // if party has a person who can use a mercy spell
						    for (var j = 0; j < array_length(party_getdata(global.party_names[i], "spells")); ++j) {
							    if party_getdata(global.party_names[i], "spells")[j].is_mercyspell {
									tgt_spell = party_getdata(global.party_names[i], "spells")[j]
									spellowner = party_getname(global.party_names[i])
									break
								}
							}
							if is_struct(tgt_spell) {
								break
							}
						}
						if is_struct(tgt_spell) { // if mercyspell exists
							txt += "{p}{c}* (Try using "+spellowner+"'s {col("+color_to_string(tgt_spell.color)+")}"+string_upper(item_get_name(tgt_spell))+"{col(white)}!)"
						}
					}
					cutscene_dialogue(string(txt, party_getname(global.party_names[user]), enemy.name),, true)
					cutscene_set_variable(o_enc, "exec_wait", false)
				}
				
				cutscene_play()	
			}
			else if exec_current[0] == 5 { // spell
				var selected = fightselection[user]
				var o = party_get_inst(global.party_names[user])
				var spells = array_clone(party_getdata(global.party_names[user], "spells"))
				
                // find other enemies if the target is not fighting
				if !enc_enemy_isfighting(selected) {
					for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
					    if enc_enemy_isfighting(i) {
                            selected = i
                            break
                        }
					}
				}
                
				for (var i = 0; i < array_length(struct_get(bonus_actions, global.party_names[user])); ++i) {
				    array_insert(spells, i, struct_get(bonus_actions, global.party_names[user])[i])
				}
				if spells[actselection[user]].use_type == 0 {
					selected = itemuserselection[user]
				}
			
				cutscene_create()
				cutscene_set_variable(o_enc, "exec_wait", true)
				cutscene_set_partysprite(user, "spell")
				cutscene_sleep(4)
                item_use(spells[actselection[user]], user, selected)
				cutscene_func(function(user) {
					o_enc.char_state[user] = -1
				}, [user])
				
				cutscene_sleep(1)
				cutscene_wait_until(function(){
					return !o_enc.exec_waiting
				})
				cutscene_set_variable(o_enc, "exec_wait", false)
				cutscene_play()	
			}
		}
		else{
			battle_state = "dialogue"
		}
	}
	else {
		if !exec_wait {
			// if not defending, go back to the idle sprite
			if char_state[exec_current[1]] != 4 {
				char_state[exec_current[1]] = -1;
				party_get_inst(global.party_names[exec_current[1]]).sprite_index = enc_getparty_sprite(exec_current[1], "idle")
				party_get_inst(global.party_names[exec_current[1]]).image_index = 0
				party_get_inst(global.party_names[exec_current[1]]).image_speed = 1
				
				if is_array(together_with[exec_current[1]]) {
					if !array_equals(together_with[exec_current[1]], []) {
						for (var i = 0; i < array_length(together_with[exec_current[1]]); ++i) {
							var me = together_with[exec_current[1]][i]
						    char_state[me] = -1;
							party_get_inst(global.party_names[me]).sprite_index = enc_getparty_sprite(me, "idle")
							party_get_inst(global.party_names[me]).image_speed = 1
						}
						together_with[exec_current[1]] = []
					}
				}
				else {
					var i = together_with[exec_current[1]]
					
					char_state[i] = -1;
					party_get_inst(global.party_names[i]).sprite_index = enc_getparty_sprite(i, "idle")
					party_get_inst(global.party_names[i]).image_speed = 1
					
					together_with[exec_current[1]] = []
				}
			}
			
			var stillfighting = false
			for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
			    if enc_enemy_isfighting(i) {
					stillfighting = true; 
					break
				}
			}
			if !stillfighting {
				battle_state = "win"
			}
			
			exec_current = undefined
		}		
	}
}

// turn preperation and enemy dialogue writer
if battle_state == "dialogue" {
	if dialogue_init {
		// fade the bg
		do_animate(0, .75, 15, "linear", o_eff_bg, "fade")
		
		for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
			if !enc_enemy_isfighting(i)
				continue
			
			// create turn objects feed the information to them
			array_set(turn_objects, i, instance_create(encounter_data.enemies[i].turn_object,,,, {
				enemy_index: i, 
				enemy_struct: encounter_data.enemies[i]
			}))
			with turn_objects[i] 
				event_user(0) // initialize them
			
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
			if struct_exists(encounter_data.enemies[i],"ev_dialogue") && is_callable(encounter_data.enemies[i].ev_dialogue)
				encounter_data.enemies[i].ev_dialogue() // call the enemies' dialogue event
			
			if is_string(text) {
				var inst = instance_create(o_ui_enemydialogue, xx*2, yy*2, DEPTH_ENCOUNTER.UI, {text})
				inst.spr = encounter_data.enemies[i].dia_bubble_sprites
				
			    array_push(dialogueinstances, inst)
			}
		}
        
        // choose turn targets
        turn_targets = encounter_data._target_calculation()
		for (var i = 0; i < array_length(global.party_names); ++i) {
		    if array_contains(turn_targets, global.party_names[i]) {
                if encounter_data.display_target {
				    var o = party_get_inst(global.party_names[i])
                    instance_create(o_enc_target, o.x, o.y - o.myheight/2, o.depth-10)
                }
			}
			else {
				var o = party_get_inst(global.party_names[i])
				do_animate(0, .5, 15, "linear", o, "darken")
			}
		}
		
		dialogue_init = false
	}
	
	var move_on = true
	for (var i = 0; i < array_length(dialogueinstances); ++i) {
	    if instance_exists(dialogueinstances[i]) {
			move_on = false; 
			break
		}
	}
	
	if move_on
		battle_state = "turn"
}

// the enemy turn
if battle_state == "turn" {
	if !turn_init {
		for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
			if enc_enemy_isfighting(i) {
				// call the turn event for the enemies
				if struct_exists(encounter_data.enemies[i],"ev_turn") && is_callable(encounter_data.enemies[i].ev_turn)
					encounter_data.enemies[i].ev_turn()
			}
		}
		instance_destroy(o_enc_target)
		
		mybox = instance_create(o_enc_box)
		mysoul = instance_create(o_enc_soul, 
			get_leader().x, get_leader().y - get_leader().myheight/2, 
			DEPTH_ENCOUNTER.ACTORS
		)
		
		turn_init = true
		turn_timer = 0
	}
	else if !instance_exists(mybox) {
		battle_state = "post_turn"
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
		}
		turn_timer++
		
		var move_on=true
		for (var i = 0; i < array_length(turn_objects); ++i) {
			if !enc_enemy_isfighting(i){continue}
			if instance_exists(turn_objects[i]) move_on=false
		}
		if move_on {
			mybox.alarm[0]=1
			mysoul.alarm[0]=1
			turn_goingback=true
		}
	}
	else if turn_goingback {
		// idk why it's not an animation :(
		if instance_exists(o_eff_bg) && o_eff_bg.fade > 0
			o_eff_bg.fade-=.05
	}
}

// get ready to go back on the loop
if battle_state == "post_turn" {
	for (var i = 0; i < array_length(global.party_names); ++i) { // heal party members, reset their sprites
	    // if defending, or anything else for that matter, just go back to being idle
		party_get_inst(global.party_names[i]).sprite_index = enc_getparty_sprite(i, "idle")
		party_get_inst(global.party_names[i]).image_index = 0
		party_get_inst(global.party_names[i]).image_speed = 1
		
		char_state[i] = -1
		
		if party_getdata(global.party_names[i], "is_down") {
			party_heal(global.party_names[i], round(party_getdata(global.party_names[i], "max_hp") * .13))
		}
		if !array_contains(turn_targets, global.party_names[i]) { // if i wasn't target, stop being dimmed
			do_animate(.5 ,0, 15, "linear", party_get_inst(global.party_names[i]), "darken")
		}
	}
	{ //set the flavor text
		var maxprio = -infinity
		var flav = []
		
		for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
			if enc_enemy_isfighting(i) {
				if struct_exists(encounter_data.enemies[i], "ev_post_turn") && is_callable(encounter_data.enemies[i].ev_post_turn)
					encounter_data.enemies[i].ev_post_turn()
				
				var a = encounter_data.enemies[i].flavor(i)
				if a.priority > maxprio {
					flav = [];
					maxprio = a.priority
					array_push(flav, a.text)
				}
				else if a.priority == maxprio 
					array_push(flav, a.text)
			}
		}
		if array_length(flav) > 0 {
			encounter_data.flavor = flav[irandom(array_length(flav)-1)]
		}
	}
	
	event_user(0) // reset variable values
}

// do the fight end animation and such
if battle_state == "win" {
	tproll = lerp(tproll, 0, .5)
	if hideui
		roll = lerp(roll, -40, .4)
	
	if !wininit {
        var __exp = 0
        var __dd = earned_money + global.chapter * tp / 4
        var __dd_mod = 1
        
		for (var i = 0; i < array_length(global.party_names); ++i) {
		    char_state[i] = -1
			
			if party_getdata(global.party_names[i], "is_down") {
				party_setdata(global.party_names[i], "hp", round(party_getdata(global.party_names[i], "max_hp") * .12))
                party_setdata(global.party_names[i], "is_down", false)
            }
            
			party_get_inst(global.party_names[i]).sprite_index = enc_getparty_sprite(i, "victory")
			party_get_inst(global.party_names[i]).image_index = 0
			party_get_inst(global.party_names[i]).image_speed = 1
            
            if !is_undefined(party_getdata(global.party_names[i], "weapon")) && struct_exists(party_getdata(global.party_names[i], "weapon").stats_misc, "money_modifier")
                __dd_mod += party_getdata(global.party_names[i], "weapon").stats_misc.money_modifier
            if !is_undefined(party_getdata(global.party_names[i], "armor1")) && struct_exists(party_getdata(global.party_names[i], "armor1").stats_misc, "money_modifier")
                __dd_mod += party_getdata(global.party_names[i], "armor1").stats_misc.money_modifier
            if !is_undefined(party_getdata(global.party_names[i], "armor2")) && struct_exists(party_getdata(global.party_names[i], "armor2").stats_misc, "money_modifier")
                __dd_mod += party_getdata(global.party_names[i], "armor2").stats_misc.money_modifier
		}
        
        __dd *= __dd_mod
        __dd = round(__dd)
		
		cutscene_create()
		cutscene_dialogue(string("* You won!{br}{resetx}* Got {0} EXP and {1} D$.", __exp, __dd))
		cutscene_set_variable(id, "hideui", true)
		cutscene_sleep(4)
        
        global.save.EXP += __exp
        global.save.MONEY += __dd
		
        cutscene_func(instance_destroy, [id])
		cutscene_set_variable(o_eff_bg, "destroy", true)
		cutscene_func(music_fade, [1])
		for (var i = 0; i < array_length(global.party_names); ++i) {
			var o = party_get_inst(global.party_names[i])
			
		    cutscene_anim(o.x, savepos[i][0], 12, "linear", function(v,o) {
				o.x = v
			}, o)
		    cutscene_anim(o.y, savepos[i][1], 12, "linear", function(v,o) {
				o.y = v
			}, o)
		}
        for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
            if is_struct(encounter_data.enemies[i]) {
                var o = encounter_data.enemies[i].actor_id
                var a = marker_getpos("enemy_defeated", encounter_data.enemies[i].defeat_marker)
                
                if !is_undefined(a) && instance_exists(o) {
                    cutscene_animate(o.x, a.x, 12, "linear", o, "x")
                    cutscene_animate(o.y, a.y, 12, "linear", o, "y")
                }
            }
		}
		
        cutscene_sleep(12)
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
		
        cutscene_set_variable(o_camera, "target", o_actor_kris)
		cutscene_set_variable(get_leader(), "moveable_battle", true)
		
        cutscene_party_follow(true)
		cutscene_play()
	}
	wininit = true
}
else {
	tproll = lerp(tproll, 80, .5)
	roll = lerp(roll, 80, .5)
}

for (var i = 0; i < array_length(global.party_names); ++i) {
	pmlerp[i] = lerp(pmlerp[i], (selection==i ? 1 : 0), .5)
}
if buffer > 0 
	buffer --

tplerp = lerp(tplerp, tp, .3)
tplerp2 = lerp(tplerp2, tp, .8)