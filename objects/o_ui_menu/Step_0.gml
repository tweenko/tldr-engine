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
					if item_get_count(t) == ITEM_TYPE.CONSUMABLE
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
				
				if item_get_count(t) == ITEM_TYPE.CONSUMABLE
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
				var order = ["weapon", "armor1", "armor2"]
				
				var allow = true
				var customreaction = false
				
				if !is_undefined(arr_mod[e_selection]) {
					if e_pselection == 0 {
						if !array_contains(arr_mod[e_selection].weapon_whitelist, global.party_names[e_pmselection]) 
							allow = false
					}
					else {
						if array_contains(arr_mod[e_selection].armor_blacklist, global.party_names[e_pmselection]) 
							allow = false
					}
				}
				if allow // susie not allowing to touch her stuff
					&& is_undefined(arr_mod[e_selection]) 
					&& global.party_names[e_pmselection] == "susie" 
					&& !is_undefined(party_getdata("susie", order[e_pselection]))
				{
					allow = false
					customreaction = true
					item_menu_party_react("susie", loc("item_susie_comment"))
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
                    
                    item_deapply(prev_item, global.party_names[e_pmselection])
                    item_apply(arr_mod[e_selection], global.party_names[e_pmselection])
					
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
    if selection == 3 { // config
        if state == 1 { // config menu
            if InputPressed(INPUT_VERB.DOWN) {
                c_selection ++
                audio_play(snd_ui_move)
            }
            if InputPressed(INPUT_VERB.UP) {
                c_selection --
                audio_play(snd_ui_move)
            }
            c_selection = (c_selection + array_length(c_config)) % array_length(c_config)
            
            if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
                audio_play(snd_ui_select)
                buffer = 2
                
                switch c_config[c_selection].type {
                    case C_CONFIG_TYPE.SLIDER:
                        state = 2
                        break
                    case C_CONFIG_TYPE.BUTTON:
                        c_config[c_selection].call()
                        break
                    case C_CONFIG_TYPE.SWITCH:
                        var __tmp = false
                        if is_callable(c_config[c_selection].state)
                            __tmp = !c_config[c_selection].state()
                        else {
                            __tmp = !c_config[c_selection].state
                            c_config[c_selection].state = __tmp
                        }
                        
                        c_config[c_selection].call(__tmp)
                        break
                    case C_CONFIG_TYPE.SINGLE_SLIDER:
                        state = 4
                        break
                }
            }
            if InputPressed(INPUT_VERB.CANCEL) && buffer == 0 {
                audio_play(snd_ui_cancel_small)
                state = 0
                buffer = 1
            }
        }
        if state == 2 { // changing a slider
            if InputCheck(INPUT_VERB.LEFT) {
                c_config[c_selection].call(-.02)
                c_holdtimer ++
                
                if c_holdtimer % 3 == 0
                    audio_play(snd_noise)
            }
            else if InputCheck(INPUT_VERB.RIGHT) {
                c_config[c_selection].call(.02)
                c_holdtimer ++
                
                if c_holdtimer % 3 == 0
                    audio_play(snd_noise)
            }
            else 
                c_holdtimer = 0
            
            if (InputPressed(INPUT_VERB.SELECT) || InputPressed(INPUT_VERB.CANCEL)) && buffer == 0 {
                state = 1
                buffer = 1
                audio_play(snd_ui_select)
            }
        }
        if state == 3 { // controls
            var __inputdevice = InputPlayerGetDevice()
            if c_controls_changing {
                if keyboard_check_pressed(vk_escape) && buffer == 0 {
                    audio_play(snd_ui_cancel_small)
                    InputDeviceSetRebinding(__inputdevice, false)
                    
                    c_controls_changing = false
                    buffer = 1
                }
                if buffer == 0 {
                    if InputDeviceGetRebinding(__inputdevice) {
                        var _result = InputDeviceGetRebindingResult(__inputdevice);
                        if (_result != undefined) {
                            InputBindingSetSafe(InputDeviceIsGamepad(__inputdevice), c_controls[c_controls_selection], _result);
                            InputDeviceSetRebinding(__inputdevice, false);
                            
                            audio_play(snd_ui_cancel_small)
                            audio_play(snd_ui_select)
                            c_controls_changing = false
                            buffer = 1
                        }
                    }
                }
            }
            else {
                if InputPressed(INPUT_VERB.DOWN) {
                    c_controls_selection ++
                    audio_play(snd_ui_move)
                }
                if InputPressed(INPUT_VERB.UP) {
                    c_controls_selection --
                    audio_play(snd_ui_move)
                }
                c_controls_selection = (c_controls_selection + (array_length(c_controls) + 2)) % (array_length(c_controls) + 2)
                
                if InputPressed(INPUT_VERB.SELECT) && buffer == 0 {
                    audio_play(snd_ui_select)
                    
                    if c_controls_selection < array_length(c_controls) {
                        c_controls_changing = true
                        buffer = 2
                        
                        // start rebinding and ignore certain keys
                        var _ignoreArray = [
                            vk_alt, vk_capslock, vk_printscreen, 
                            vk_control, vk_enter, vk_shift, vk_tab,
                            vk_backspace, vk_subtract, vk_add, vk_equals,
                            
                            vk_f1, vk_f2, vk_f3, vk_f4, vk_f5, vk_f6, vk_f7, vk_f8, vk_f9, vk_f10, vk_f11, vk_f12, 
                            vk_escape, vk_insert, vk_delete, vk_home, vk_end, vk_pageup, vk_pagedown,
                            
                            gp_start, gp_home, gp_touchpadbutton, gp_select, 
                            gp_axislh, gp_axisrh, gp_axisrv, gp_axislv, 
                            gp_stickl, gp_stickr
                        ]
                        InputDeviceSetRebinding(__inputdevice, true, _ignoreArray)
                    }
                    else {
                    	if c_controls_selection == array_length(c_controls) {
                            c_controls_resetfade = 1
                            audio_play(snd_levelup)
                            
                            // reset the bindings
                            InputBindingsReset(InputDeviceIsGamepad(InputPlayerGetDevice()))
                        }
                        else {
                            buffer = 2
                            audio_play(snd_ui_cancel_small)
                            state = 1
                        }
                    }
                }
            }
        }
        if state == 4 { // single slider
            if InputPressed(INPUT_VERB.LEFT)
                c_config[c_selection].call(-1)
            else if InputPressed(INPUT_VERB.RIGHT)
                c_config[c_selection].call(1)
            
            if (InputPressed(INPUT_VERB.SELECT) || InputPressed(INPUT_VERB.CANCEL)) && buffer == 0 {
                state = 1
                buffer = 1
                audio_play(snd_ui_select)
            }
        }
    }
}

timer --
if timer <= 0 && only_hp 
	close = true

if buffer > 0 
	buffer --
if c_controls_resetfade > 0
    c_controls_resetfade -= .1

for (var i = 0; i < array_length(global.party_names); ++i) {
    if partyreactiontimer[i] > 0
		partyreactiontimer[i] -= .1
}