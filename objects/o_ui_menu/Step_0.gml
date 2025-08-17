if global.console 
	exit
menuroll = lerp(menuroll, (close ? 0 : 1), .4)

if menuroll < .1 && close 
	instance_destroy()

if !only_hp {
	if state == 0 {
		if (InputPressed(INPUT_VERB.SPECIAL) || InputPressed(INPUT_VERB.CANCEL)) && !close 
			close = true
		
		if InputPressed(INPUT_VERB.RIGHT) {
			selection ++
			audio_play(snd_ui_move)
		}
		if InputPressed(INPUT_VERB.LEFT) {
			selection--
			audio_play(snd_ui_move)
		}
		
		if selection < 0
			selection = 3
		if selection > 3
			selection = 0
		
		if InputPressed(INPUT_VERB.SELECT) {
			state = 1; 
			buffer = 1
			
			audio_play(snd_ui_select);
		}
	}
	
	if selection == 0 { // item
		if state == 1 { // submenu selector
			if InputPressed(INPUT_VERB.RIGHT) {
				i_pselection ++; 
				audio_play(snd_ui_move)
			}
			if InputPressed(INPUT_VERB.LEFT) {
				i_pselection --; 
				audio_play(snd_ui_move)
			}
			
			if i_pselection < 0
				i_pselection = 2
			if i_pselection > 2
				i_pselection = 0
			
			if InputPressed(INPUT_VERB.CANCEL) {
				state = 0
				audio_play(snd_ui_cancel_small)
			}
			if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
				if i_pselection < 2 {
					// if we can even open the item menu
					if array_length(global.items) > 0 {
						state = 2
						buffer = 1
						audio_play(snd_ui_select)
					}
					else
						audio_play(snd_ui_cant_select)
				}
				else {
					// if we can even open the key item menu
					if array_length(global.key_items) > 0 {
						state = 2; 
						buffer = 1
						audio_play(snd_ui_select); 
					}
					else
						audio_play(snd_ui_cant_select)
				}
			}
		}
		if state == 2 { // use, toss, key
			var arr = global.items
			if i_pselection == 2 
				arr = global.key_items
			var t = (i_pselection==2 ? 1 : 0)
			
			if InputPressed(INPUT_VERB.RIGHT) {
				i_selection ++; 
				if i_selection % 2 == 0
					i_selection -= 2
				audio_play(snd_ui_move)
			}
			if InputPressed(INPUT_VERB.DOWN) && i_selection < item_get_count(t) - 2 {
				i_selection += 2; 
				audio_play(snd_ui_move)
			}
			if InputPressed(INPUT_VERB.LEFT) && i_selection > 0 {
				i_selection--; 
				if i_selection % 2 == 1
					i_selection+=2
				audio_play(snd_ui_move)
			}
			else if InputPressed(INPUT_VERB.LEFT) && i_selection == 0 && item_get_count(t) > 1 {
				i_selection = 1; 
				audio_play(snd_ui_move)
			}
			if InputPressed(INPUT_VERB.UP) && i_selection > 1 {
				i_selection -= 2; 
				audio_play(snd_ui_move)
			}
			
			if i_selection < 0
				i_selection = item_get_count(t) - 1
			if i_selection > item_get_count(t) - 1
				i_selection = 0
			
			if InputPressed(INPUT_VERB.CANCEL){
				state = 1
				audio_play(snd_ui_cancel_small)
			}
			if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
				if i_pselection == 2 {
					item_use(global.key_items[i_selection], i_selection, 0)
					if item_get_count(t) == 0
						state = 1
					
					if i_selection > item_get_count(t) - 1 
						i_selection = item_get_count(t) - 1
				}
				else {
					if arr[i_selection].can_use {
						state = 3; 
						buffer = 1;
						i_mode = arr[i_selection].use_type
						
						audio_play(snd_ui_select);
					}
					if i_pselection == 1 
						i_mode = 1
				}
			}
		}
		if state == 3 { // choose party member / confirm action
			var t = (i_pselection == 2 ? 1 : 0)
			
			if InputPressed(INPUT_VERB.RIGHT) && i_mode != 1 {
				i_pmselection ++
				audio_play(snd_ui_move)
			}
			if InputPressed(INPUT_VERB.LEFT) && i_mode != 1 {
				i_pmselection --
				audio_play(snd_ui_move)
			}
			
			if i_pmselection < 0 
				i_pmselection = array_length(global.party_names) - 1
			if i_pmselection > array_length(global.party_names) - 1
				i_pmselection = 0
			
			if InputPressed(INPUT_VERB.CANCEL) {
				state = 2
				i_mode = 0
				audio_play(snd_ui_cancel_small)
			}
			if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
				if i_pselection == 0 {
					state = 2;
					i_mode = 0
					
					// use the item and apply the reaction
					item_menu_reaction(global.items[i_selection], i_pmselection)
					item_use(global.items[i_selection], i_selection, global.party_names[i_pmselection])
				}
				if i_pselection == 1 {
					state = 2;
					i_mode = 0
					
					if global.items[i_selection].throw_scripts.can {
						item_delete(i_selection)
						audio_play(snd_ui_cancel);
					}
					else
						global.items[i_selection].throw_scripts.execute_code()
				}
				
				if item_get_count(t) == 0
					state = 1
				if i_selection > item_get_count(t) - 1
					i_selection = item_get_count(t) - 1
			}
		}
	}
	if selection == 1 { // equip
		if state == 1 { // character selector
			if InputPressed(INPUT_VERB.RIGHT) {
				e_pmselection ++; 
				audio_play(snd_ui_move)
			}
			if InputPressed(INPUT_VERB.LEFT) {
				e_pmselection --; 
				audio_play(snd_ui_move)
			}
			
			if e_pmselection < 0
				e_pmselection = array_length(global.party_names) - 1
			if e_pmselection > array_length(global.party_names) - 1
				e_pmselection = 0
			
			if InputPressed(INPUT_VERB.CANCEL) {
				state = 0
				audio_play(snd_ui_cancel_small)
			}
			if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
				state ++
				buffer = 1
				audio_play(snd_ui_select)
			}
		}
		if state == 2 { // equipment type selector
			if InputPressed(INPUT_VERB.DOWN){
				e_pselection ++; 
				audio_play(snd_ui_move)
			}
			if InputPressed(INPUT_VERB.UP){
				e_pselection --; 
				audio_play(snd_ui_move)
			}
			
			if e_pselection < 0
				e_pselection = 2
			if e_pselection > 2
				e_pselection = 0
			
			if InputPressed(INPUT_VERB.CANCEL) {
				state = 1
				audio_play(snd_ui_cancel_small)
			}
			if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
				state ++
				buffer = 1
				audio_play(snd_ui_select)
			}
		}
		if state == 3 { // list
			var arr = item_get_array(e_pselection > 0 ? 3 : 2)
			var arr_mod = []
			array_copy(arr_mod, 0, arr, 0, array_length(arr)) 
			array_insert(arr_mod, 0, undefined)
			
			if InputRepeat(INPUT_VERB.DOWN) && e_selection < array_length(arr_mod) - 1 {
				e_selection ++ 
				if e_selection > e_move + 5 && e_selection < array_length(arr_mod)
					e_move++
				
				audio_play(snd_ui_move); 
			}
			if InputRepeat(INPUT_VERB.UP) && e_selection > 0 {
				e_selection -- 
				if e_selection < e_move && e_selection >= 0
					e_move --
				
				audio_play(snd_ui_move); 
			}
			
			if e_selection < 0 {
				e_selection = 0
				e_move = 0
			}
			if e_selection > array_length(arr_mod) - 1 {
				e_selection = array_length(arr_mod) - 1
				e_move = max(array_length(arr_mod) - 6, 0)
			}
			if e_move < 0
				e_move = 0
			if e_move > array_length(arr_mod) - 6
				e_move = max(array_length(arr_mod) - 6, 0)
			
			if InputPressed(INPUT_VERB.CANCEL) {
				state = 2
				audio_play(snd_ui_cancel_small)
			}
			if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
				var equipment = [
					party_getdata(global.party_names[e_pmselection], "weapon"),
					party_getdata(global.party_names[e_pmselection], "armor1"),
					party_getdata(global.party_names[e_pmselection], "armor2"),
				]
				var order=["weapon", "armor1", "armor2"]
				
				var allow = true
				var customreaction = false
				
				if !is_undefined(arr_mod[e_selection]) {
					if e_pselection == 0 {
						if !array_contains(arr_mod[e_selection].weapon_whitelist, global.party_names[e_pmselection]) 
							allow = false
					}
					else{
						if array_contains(arr_mod[e_selection].armor_blacklist, global.party_names[e_pmselection]) 
							allow = false
					}
				}
				if allow 
					&& is_undefined(arr_mod[e_selection]) 
					&& global.party_names[e_pmselection] == "susie" 
					&& !is_undefined(party_getdata("susie", order[e_pselection]))
				{
					allow = false
					customreaction = true
					item_menu_party_react("susie", "Hey, hands off!")
				}
				
				if allow {
					state = 2
					buffer = 1
					
					var prev_item = equipment[e_pselection]
					if !is_undefined(arr_mod[e_selection]) {
						item_menu_reaction(arr_mod[e_selection], e_pmselection)
						item_use(arr_mod[e_selection], e_selection - 1, global.party_names[e_pmselection])
						if is_undefined(equipment[e_pselection]) 
							item_delete(e_selection-1, (e_pselection>0 ? 3 : 2))
						else 
							item_set(equipment[e_pselection], e_selection-1, (e_pselection>0 ? 3 : 2))
						party_setdata(global.party_names[e_pmselection], order[e_pselection], arr_mod[e_selection])
					}
					else {
						if !is_undefined(equipment[e_pselection]) {
							item_add(equipment[e_pselection], (e_pselection>0 ? 3 : 2))
							party_setdata(global.party_names[e_pmselection], order[e_pselection], undefined)
						}
					}
					
					if !is_undefined(prev_item) {
						var structnames = struct_get_names(prev_item.stats)
						for (var i = 0; i < array_length(structnames); ++i) {
							party_subtractdata(global.party_names[e_pmselection], structnames[i], struct_get(prev_item.stats, structnames[i]))
						}
					}
					
					if !is_undefined(arr_mod[e_selection]) {
						var structnames2 = struct_get_names(arr_mod[e_selection].stats)
						for (var i = 0; i < array_length(structnames2); ++i) {
						    party_adddata(global.party_names[e_pmselection], structnames2[i], struct_get(arr_mod[e_selection].stats, structnames2[i]))
						}
					}
					
					audio_play(snd_equip)
				}
				else {
					audio_play(snd_ui_cant_select)
					if !customreaction 
						item_menu_reaction(arr_mod[e_selection], e_pmselection)
				}
			}
		}
	}
	if selection == 2 { // power
		if state == 1 { // character selector
			if InputPressed(INPUT_VERB.RIGHT) { 
				p_pmselection++; 
				audio_play(snd_ui_move)
			}
			if InputPressed(INPUT_VERB.LEFT) { 
				p_pmselection--; 
				audio_play(snd_ui_move)
			}
			
			if p_pmselection < 0 
				p_pmselection = array_length(global.party_names) - 1
			if p_pmselection > array_length(global.party_names) - 1
				p_pmselection = 0
			
			if InputPressed(INPUT_VERB.CANCEL) {
				state = 0
				audio_play(snd_ui_cancel_small)
			}
			if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
				state ++
				buffer = 1
				audio_play(snd_ui_select)
			}
		}
		if state == 2 { // spell list
			var arr = party_getdata(global.party_names[p_pmselection], "spells")
			
			if InputPressed(INPUT_VERB.DOWN) { 
				p_selection++; 
				audio_play(snd_ui_move)
			}
			if InputPressed(INPUT_VERB.UP) { 
				p_selection--; 
				audio_play(snd_ui_move)
			}
			
			if InputPressed(INPUT_VERB.CANCEL) {
				state = 1
				audio_play(snd_ui_cancel_small)
			}
			
			if p_selection < 0
				p_selection = array_length(arr) - 1
			if p_selection > array_length(arr) - 1
				p_selection = 0
		}
	}
}

timer --
if timer <= 0 && only_hp 
	close = true

if buffer > 0 
	buffer --
for (var i = 0; i < array_length(global.party_names); ++i) {
    if partyreactiontimer[i] > 0
		partyreactiontimer[i] -= .1
}