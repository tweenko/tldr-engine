if !surface_exists(surf) 
	surf = surface_create(640, 480)

surface_set_target(surf) {
	draw_clear_alpha(0, 0)

	var spells = []
	if battle_state == "menu" {
		// sort the spells
		spells = array_clone(party_getdata(global.party_names[selection], "spells"))
		for (var i = 0; i < array_length(struct_get(bonus_actions, global.party_names[selection])); ++i) {
		    array_insert(spells, i, struct_get(bonus_actions, global.party_names[selection])[i])
		}
	}
	
	// create the surface for the buttons
	for (var i = 0; i < array_length(buttonsurf); ++i) {
	    if !surface_exists(buttonsurf[i]) 
			buttonsurf[i] = surface_create(211,33)
	}
	
	draw_sprite_ext(spr_pixel, 0, 0, 417 - 92+80 - roll, 640, 156, 0, c_black, 1)
	draw_sprite_ext(spr_pixel, 0, 0, 417 - 92+80 - roll, 640, 2, 0, bcolor, 1)
	
	// draw the ui for each of the party members
	for (var i = 0; i < array_length(global.party_names); ++i) {
		var xoff = 319.5 + array_length(global.party_names) * -213/2
		var col = bcolor
		var off = 32
		
		draw_set_color(c_white)
		if selection == i 
			col = party_getdata(global.party_names[i], "color")
		
		draw_sprite_ext(spr_pixel, 0, i*213 + xoff, 325 + 80 - roll - off*pmlerp[i], 213, 70, 0, c_black, 1)
		draw_sprite_ext(spr_pixel, 0, i*213 + xoff, 325 + 80 - roll - off*pmlerp[i], 213, 2, 0, col, 1)
		draw_sprite_ext(spr_pixel, 0, i*213 + xoff, 325+37 + 80 - roll - off*pmlerp[i], 213, 2, 0, col, 1)
		
		if selection == i {
			draw_sprite_ext(spr_pixel, 0, i*213 + xoff + 211, 325 + 80 - roll - off*pmlerp[i], 2, 69, 0, col, 1)
			draw_sprite_ext(spr_pixel, 0, i*213 + xoff, 325 + 80 - roll - off*pmlerp[i], 2, 69, 0, col, 1)
		}
		if char_state[i] == CHAR_STATE.IDLE {
            var __icon = party_geticon(global.party_names[i])
            if pm_hurt[i] > 0
                __icon = party_geticon_hurt(global.party_names[i])
            
            draw_sprite_ext(__icon, 0, 12 + 213*i + xoff, 430 - 94 + 80 - roll - off*pmlerp[i], 1, 1, 0, c_white, 1)
        }
		else
			draw_sprite_ext(spr_ui_enc_icons_command, __state_to_icon(char_state[i]), 12 + 213*i + xoff, 430 - 94 + 80 - roll - off*pmlerp[i], 1, 1, 0, party_getdata(global.party_names[i], "iconcolor"), 1)
		
		var font = global.font_name[0]
		
		if string_length(party_getname(global.party_names[i], false)) > 4
			font = global.font_name[1]
		if string_length(party_getname(global.party_names[i], false)) > 5
			font = global.font_name[2]
		
		draw_set_font(font)
		draw_text_transformed(51 + 213*i + xoff, 430 - 94 + 80 - roll - off*pmlerp[i], string_upper(party_getname(global.party_names[i], false)), 1, 1, 0)
		
		var hpp = party_getdata(global.party_names[i], "hp") / party_getdata(global.party_names[i], "max_hp")
		draw_sprite_ext(spr_ui_hp_text, 0, 110 + 213*i + xoff, 441 - 94 + 80 - roll - off*pmlerp[i], 1, 1, 0, c_white, 1)
		draw_sprite_ext(spr_pixel, 0, 128 + 213*i + xoff, 441 - 94 + 80 - roll - off*pmlerp[i], 76, 9, 0, c_maroon, 1)
		draw_sprite_ext(spr_pixel, 0, 128 + 213*i + xoff, 441 - 94 + 80 - roll - off*pmlerp[i], 76*max(0, hpp), 9, 0, party_getdata(global.party_names[i], "color"), 1)
		
		draw_set_font(global.font_ui_hp)
		draw_set_halign(fa_right)
		
		if party_getdata(global.party_names[i], "hp") <= 30 
			draw_set_color(c_yellow)
		if !party_isup(global.party_names[i]) 
			draw_set_color(c_red)
		
		draw_text_transformed(160 + 213*i + xoff, 428 - 94 + 80 - roll - off*pmlerp[i], string(party_getdata(global.party_names[i], "hp")), 1, 1, 0)
		draw_sprite_ext(spr_ui_hp_seperator, 0, 161 + 213*i + xoff, 428 - 94 + 80 - roll - off*pmlerp[i], 1, 1, 0, c_white, 1)
		draw_text_transformed(205 + 213*i + xoff, 428 - 94 + 80 - roll - off*pmlerp[i], party_getdata(global.party_names[i], "max_hp"), 1, 1, 0)
		
		draw_set_halign(fa_left)
		draw_set_color(c_white)
		draw_set_font(loc_font("main"))
		draw_set_alpha(1)
	}
	
	// dialogue box (ui box)
	draw_sprite_ext(spr_pixel, 0, 0, 363 + 80 - roll, 640, 156, 0, c_black, 1)
	draw_sprite_ext(spr_pixel, 0, 0, 362 + 80 - roll, 640, 3, 0, bcolor, 1)
 	for (var i = 0; i < array_length(global.party_names); ++i) {
		if pmlerp[i] > .1 && battle_state == "menu" {
			surface_set_target(buttonsurf[i]) {
				var xoff = 319.5 + array_length(global.party_names) * -213/2
				var off = 32
				
				draw_clear_alpha(0, 0)
				draw_set_color(c_black)
				
				draw_rectangle(2, 30 * (1-pmlerp[i]), 2+211, 30, 0)
				
				draw_set_color(bcolor)
				draw_rectangle(2, 30, 2+210, 33, 0)
				
				draw_set_color(c_white)
				
				// image indexes
				var btns = ["fight", "power", "item", "spare", "defend"]
				if can_act[i]
					btns[1] = "act"
				
				gpu_set_colorwriteenable(1, 1, 1, 0)
				for (var j = 0; j < 3; ++j) {
					draw_set_color(merge_color(party_getdata(global.party_names[i], "color"), c_black, uisticks[j]/20))
					var xxoff = uisticks[j] * 2
				    draw_rectangle(0 + xxoff, 0, 1 + xxoff, 29, 0)
				    draw_rectangle(210 - xxoff, 0, 211 - xxoff, 29, 0)
				}
				
				draw_set_alpha(1)
				draw_set_color(c_white)
				
				for (var j = 0; j < array_length(btns); ++j) {
                    var __spr = asset_get_index(string(loc("enc_ui_spr_buttons"), btns[j]))
                    
					draw_sprite_ext(spr_pixel, 0, 2 + 193 - array_length(btns)*35 + j*35, 1, 31, 25, 0, c_black, 1)
					draw_sprite_ext(__spr, (bt_selection[selection] == j && i == selection ? 1 : 0), 2 + 193 - array_length(btns)*35 + j*35, 1, 1, 1, 0, c_white, 1)
					
					if i == selection && __bt_highlight(j, global.party_names[i]) && bt_selection[selection] != j {
						gpu_set_fog(true, c_white, 0, 1)
						draw_sprite_ext(__spr, 1, 2 + 193 - array_length(btns)*35 + j*35, 1, 1, 1, 0, c_white, .5 + sine(8, .3))
						gpu_set_fog(false, 0, 0, 0)
					}
				}
				
				gpu_set_colorwriteenable(1, 1, 1, 1)
			}
			surface_reset_target()
			
			draw_surface(buttonsurf[i], 213*i + xoff, 332 + 80 - roll)
		}
	}
	
	// draw the menu ui
	if battle_state == "menu" {
		draw_set_font(loc_font("main"))
		
		// enemy selector
		if state == 1 && (bt_selection[selection] == 0 || bt_selection[selection] == 3 || (bt_selection[selection] == 1 && can_act[selection])) || (bt_selection[selection] == 2 && state == 3) || (!can_act[selection] && bt_selection[selection] == 1 && spells[actselection[selection]].use_type == 2 && state == 3) {
			draw_text_transformed(424, 364, loc("enc_ui_label_hp"), (global.loc_lang == "en" ? 2 : 1), 1, 0)
			draw_text_transformed(524, 364, loc("enc_ui_label_mercy"), (global.loc_lang == "en" ? 2 : 1), 1, 0)
			
			for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
				if !enc_enemy_isfighting(i)
					continue
				
				var col1 = c_white
				var col2 = c_white
				var tired = encounter_data.enemies[i].tired
				var spare = encounter_data.enemies[i].mercy >= 100
				var status_eff = encounter_data.enemies[i].status_effect
				
				// set the enemy name colors
				if tired && spare {
					col1 = c_yellow;
					col2 = merge_color(c_aqua, c_blue, 0.3)
				}
				else if tired {
					col1 = merge_color(c_aqua, c_blue, 0.3);
					col2 = merge_color(c_aqua, c_blue, 0.3)
				}
				else if spare {
					col1 = c_yellow;
					col2 = c_yellow
				}
				
			    draw_text_transformed_color(80, 375 + 30*i, encounter_data.enemies[i].name, 2, 2, 0, col1, col2, col2, col1, 1)
				
				// draw the soul as an indicator
				if fightselection[selection] == i 
					draw_sprite_ext(spr_uisoul, 0, 55, 385 + 30*i, 1, 1, 0, c_red, 1)
				if tired {
					draw_sprite_ext(spr_ui_enc_tiredmark, 0, 80 + string_width(encounter_data.enemies[i].name)*2 + 42, 385 + 30*i, 1, 1, 0, c_white, 1)
					if status_eff == "" 
						status_eff = "(Tired)"
				}
				if spare
					draw_sprite_ext(spr_ui_enc_sparestar, 0, 60+string_width(encounter_data.enemies[i].name)*2 + 42, 385 + 30*i, 1, 1,0 , c_white, 1)
					
				if status_eff != "" {
					draw_set_color(c_gray)
					draw_text_transformed(100 + string_width(encounter_data.enemies[i].name)*2 + 42, 375 + 30*i, status_eff, 2, 2, 0)
					draw_set_color(c_white)
				}
				
				var hppercent = encounter_data.enemies[i].hp / encounter_data.enemies[i].max_hp
				var mercypercent = encounter_data.enemies[i].mercy
		
				draw_sprite_ext(spr_pixel, 0, 420, 380 + 30*i, 81, 16, 0, c_maroon, 1)
				draw_sprite_ext(spr_pixel, 0, 420, 380 + 30*i, 81*hppercent, 16, 0, c_lime, 1)
				draw_set_color(c_white); 
				draw_text_transformed(424, 380 + 30*i, string("{0}%", round(hppercent * 100)), 2, 1, 0)
		
				draw_sprite_ext(spr_pixel, 0, 520, 380 + 30*i, 81, 16, 0, merge_color(c_orange, c_red, 0.5), 1)
				
				draw_set_color(c_maroon); 
                if encounter_data.enemies[i].can_spare {
                    draw_sprite_ext(spr_pixel, 0, 520, 380 + 30*i, 81 * (mercypercent/100), 16, 0, c_yellow, 1)
				    draw_text_transformed(524, 380 + 30*i, string("{0}%", round(mercypercent)), 2, 1, 0)
                }
                else {
                	draw_line_width(520 - 1, 380 + i*30, 600, 380 + i*30 + 15, 2)
                    draw_line_width(520 - 1, 380 + i*30 + 15, 600, 380 + (i * 30), 2)
                }
				draw_set_color(c_white)
			}
		}
		
		// party action enemy selector
		if !can_act[selection] && bt_selection[selection] == 1 && spells[actselection[selection]].use_type == 2 && state == 4 { 
			var longestx = 0
			
			for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
				if !enc_enemy_isfighting(i)
					continue
			    longestx = max(string_width(encounter_data.enemies[i].name)*2, longestx)
			}
			
			draw_text_transformed(524, 364, loc("enc_ui_label_mercy"), (global.loc_lang == "en" ? 2 : 1), 1, 0)
			for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
				if !enc_enemy_isfighting(i)
					continue
				
				var col1 = c_white
				var col2 = c_white
				var tired = encounter_data.enemies[i].tired
				var spare = encounter_data.enemies[i].mercy >= 100
				
				if tired && spare {
					col1 = c_yellow;
					col2 = merge_color(c_aqua, c_blue, 0.3)
				}
				else if tired {
					col1 = merge_color(c_aqua, c_blue, 0.3);
					col2 = merge_color(c_aqua, c_blue, 0.3)
				}
				else if spare {
					col1 = c_yellow; 
					col2 = c_yellow
				}
				
			    draw_text_transformed_color(80, 375 + 30*i, encounter_data.enemies[i].name, 2, 2, 0, col1, col2, col2, col1, 1)
				if partyactselection[selection] == i 
					draw_sprite_ext(spr_uisoul, 0, 55, 385 + 30*i, 1, 1, 0, c_red, 1)
				
				if tired 
					draw_sprite_ext(spr_ui_enc_tiredmark, 0, 80 + string_width(encounter_data.enemies[i].name)*2 + 42, 385 + 30*i, 1, 1, 0, c_white, 1)
				if spare 
					draw_sprite_ext(spr_ui_enc_sparestar, 0, 60 + string_width(encounter_data.enemies[i].name)*2 + 42, 385 + 30*i, 1, 1, 0, c_white, 1)
				
				var mercypercent = encounter_data.enemies[i].mercy
				var desc = item_get_desc(spells[actselection[selection]], ITEM_DESC_TYPE.PARTY_ACTION)
                
				if is_instanceof(spells[actselection[selection]], item_s_defaultaction) // change the description if it's the default action
                    && encounter_data.enemies[i].acts_special_desc != desc 
					desc = encounter_data.enemies[i].acts_special_desc
				
				draw_set_color(merge_color(party_getdata(global.party_names[selection], "color"), c_white, .5))
				draw_text_transformed(80 + longestx + 62, 375 + 30*i, desc, 2, 2, 0)
				draw_set_color(c_white)
		
				draw_sprite_ext(spr_pixel, 0, 520, 380 + 30*i, 81, 16, 0, merge_color(c_orange, c_red, 0.5), 1)
				
				draw_set_color(c_maroon); 
                if encounter_data.enemies[i].can_spare {
                    draw_sprite_ext(spr_pixel, 0, 520, 380 + 30*i, 81 * (mercypercent/100), 16, 0, c_yellow, 1)
				    draw_text_transformed(524, 380 + 30*i, string("{0}%", round(mercypercent)), 2, 1, 0)
                }
                else {
                	draw_line_width(520 - 1, 380 + i*30, 600, 380 + i*30 + 15, 2)
                    draw_line_width(520 - 1, 380 + i*30 + 15, 600, 380 + (i * 30), 2)
                }
				draw_set_color(c_white)
			}
		}
		
		// act selector
		if state == 2 && (bt_selection[selection] == 1) && can_act[selection] {
			var acts = __act_sort()
			for (var i = 0; i < array_length(acts); ++i) {
				var cando = true
				var txt = acts[i].name
				var add = 0
				
				if array_length(acts[i].party)>0 || acts[i].party == -1 {
					add = array_length(acts[i].party)
					
					if acts[i].party == -1 {
						for (var j = 1; j < array_length(global.party_names); ++j) {
							if !party_isup(global.party_names[j]) 
								cando = false
						    draw_sprite_ext(party_geticon(global.party_names[j]), 0, (i % 2 == 1 ? 230 : 0) + 30*j - 1, 375 + 30 * floor(i/2), 1, 1, 0, c_white, 1)
						}
						
						add = array_length(global.party_names) - 1
					}
					else {
						for (var j = 0; j < add; ++j) {
							var name = acts[i].party[j]
							if !party_isup(name) 
								cando = false
							
						    draw_sprite_ext(party_geticon(name), 0, 30 + (i % 2 == 1 ? 230 : 0) + 30 * j - 1, 375 + 30 * floor(i/2), 1, 1, 0, c_white, 1)
						}
					}
				}
				
				if i == actselection[selection] 
					draw_sprite_ext(spr_uisoul, 0, 10 + (i % 2 == 1 ? 230 : 0), 385 + 30 * floor(i/2), 1, 1, 0, c_red, 1)
			
				// draw the act tp cost if applicable
				draw_set_color(c_orange)
				if struct_exists(acts[actselection[selection]], "tp_cost") && acts[actselection[selection]].tp_cost > 0 
					draw_text_ext_transformed(500, 440, string("{0}% TP", acts[actselection[selection]].tp_cost), 15, 70, 2, 2, 0)
				
                draw_set_color(c_white)
                if struct_exists(acts[i], "color") {
                    if is_callable(acts[i].color) 
                        draw_set_color(acts[i].color())
                    else
                        draw_set_color(acts[i].color)
			    }
                
				if struct_exists(acts[i], "tp_cost") && acts[i].tp_cost > 0 {
					if tp < acts[i].tp_cost 
						draw_set_color(c_gray)
				}
				if !cando 
					draw_set_color(c_gray)
				
				draw_text_transformed(30 + (i % 2 == 1 ? 230 : 0) + add*30, 375 + 30 * floor(i/2), txt, 2, 2, 0)
				draw_set_color(c_white)
			}
			
			// draw the act description if applicable
			if struct_exists(acts[actselection[selection]], "desc") && is_string(acts[actselection[selection]].desc) {
				draw_set_color(c_gray)
				draw_text_ext_transformed(500, 375, acts[actselection[selection]].desc, 15, 70, 2, 2, 0)
				draw_set_color(c_white)
			}
		}
		
		// item selector
		if state == 1 && (bt_selection[selection] == 2) {
			var items = __item_sort()
			for (var i = itempage[selection]*6; i < min(array_length(items), 6 + itempage[selection]*6); ++i) {
				var txt = item_get_name(items[i])
			    
				if i == itemselection[selection] 
					draw_sprite_ext(spr_uisoul, 0, 10 + (i % 2 == 1 ? 230 : 0), 385 + 30 * floor(i/2) - 90 * itempage[selection], 1, 1, 0, c_red, 1)
			    draw_text_transformed(30 + (i % 2 == 1 ? 230 : 0), 375 + 30 * floor(i/2) - 90 * itempage[selection], txt, 2, 2, 0)
			}
			// draw the item description if applicable
			if is_string(item_get_desc(items[itemselection[selection]], ITEM_DESC_TYPE.SHORTENED)){
				draw_set_color(c_gray)
				draw_text_ext_transformed(500, 375, item_get_desc(items[itemselection[selection]], ITEM_DESC_TYPE.SHORTENED), 15, 70, 2, 2, 0)
				draw_set_color(c_white)
			}
			
			// item pages
			if item_get_count(ITEM_TYPE.CONSUMABLE) > 6 && itemselection[selection] < 6 {
				draw_sprite_ext(spr_ui_arrow_down, 0, 470, 446 + round(sine(12,3)), 1, 1, 0, c_white, 1)
			}
			else if item_get_count(ITEM_TYPE.CONSUMABLE) > 6{
				draw_sprite_ext(spr_ui_arrow_up, 0, 470, 382 + round(sine(12,3)), 1, 1, 0, c_white, 1)
			}
		}
			
		// spell selector
		if state == 1 && (bt_selection[selection] == 1) && !can_act[selection] {
			for (var i = spellpage[selection] * 6; i < min(array_length(spells), 6 + spellpage[selection]*6); ++i) {
				var txt = item_get_name(spells[i])
				
			    if i == actselection[selection] 
					draw_sprite_ext(spr_uisoul, 0, 10 + (i%2 == 1 ? 230 : 0), 385 + 30 * floor(i/2) - 90*spellpage[selection], 1, 1, 0, c_red, 1)
				
                draw_set_color(c_white)
                
				if tp < spells[i].tp_cost 
					draw_set_color(c_gray)
				else if struct_exists(spells[i], "color") {
                    if is_callable(spells[i].color) 
                        draw_set_color(spells[i].color())
                    else
                        draw_set_color(spells[i].color)
			    }
				
			    draw_text_transformed(30 + (i % 2 == 1 ? 230 : 0), 375 + 30 * floor(i/2) - 90*spellpage[selection], txt, 2, 2, 0)
				draw_set_color(c_white)
			}
			if is_string(item_get_desc(spells[actselection[selection]], ITEM_DESC_TYPE.SHORTENED)) {
				draw_set_color(c_gray)
				draw_text_ext_transformed(500, 375, item_get_desc(spells[actselection[selection]], ITEM_DESC_TYPE.SHORTENED), 15, 70, 2, 2, 0)
				draw_set_color(c_white)
			}
			
			// draw the tp cost if applicable
			draw_set_color(c_orange)
			if spells[actselection[selection]].tp_cost > 0 
				draw_text_ext_transformed(500, 440, string("{0}% TP", spells[actselection[selection]].tp_cost), 15, 70, 2, 2, 0)
			draw_set_color(c_white)
			
			// pages
			if array_length(spells) > 6 && actselection[selection] < 6{
				draw_sprite_ext(spr_ui_arrow_down, 0, 470, 446 + round(sine(12, 3)), 1, 1, 0, c_white, 1)
			}
			else if array_length(spells) > 6{
				draw_sprite_ext(spr_ui_arrow_up, 0, 470, 382 + round(sine(12, 3)), 1, 1, 0, c_white, 1)
			}
		}
		
		// item use (party)
		if state == 2 && (bt_selection[selection] == 2 || (!can_act[selection] && bt_selection[selection] == 1 && spells[actselection[selection]].use_type == 0)) {
			for (var i = 0; i < array_length(global.party_names); ++i) {
			    draw_text_transformed(80, 375 + 30*i,party_getname(global.party_names[i]), 2, 2, 0)
				
				if itemuserselection[selection] == i 
					draw_sprite_ext(spr_uisoul, 0, 55, 385 + 30*i, 1, 1, 0, c_red, 1)
					
				var hppercent = party_getdata(global.party_names[i], "hp") / party_getdata(global.party_names[i], "max_hp")
				draw_sprite_ext(spr_pixel, 0, 400, 380 + 30*i, 101, 16, 0, c_maroon, 1)
				draw_sprite_ext(spr_pixel, 0, 400, 380 + 30*i, 101*hppercent, 16, 0, c_lime, 1)
			}
		}
	}

	{ // tp bar
		var tpxx = tproll - 80
		var full = false
		
        if !surface_exists(tp_surf)
            tp_surf = surface_create(640, 480)
        
        surface_set_target(tp_surf) {
            draw_clear_alpha(0,0)
            
    		draw_sprite_ext(spr_ui_enc_tpbar_caption, 0, 10 + tpxx, 77, 2, 2, 0, c_white, 1)
    		
    		draw_set_font(loc_font("main"))
    		draw_set_color(c_white)
    		
    		if ceil(tplerp) >= 100 {
    			full = true
    			
    			draw_set_color(c_yellow)
    			draw_text_transformed(10 + tpxx, 118, "M", 2, 2, 0)
    			draw_text_transformed(14 + tpxx, 138, "A", 2, 2, 0)
    			draw_text_transformed(18 + tpxx, 158, "X", 2, 2, 0)
    		}
    		else {
    			draw_text_transformed(8 + tpxx, 110, round(tplerp2), 2, 2, 0)
    			draw_text_transformed(13 + tpxx, 135, "%", 2, 2, 0)
    		}
        }
        surface_reset_target()
        
        draw_surface(tp_surf, 0, 0)
        draw_set_alpha(tp_glow_alpha)
        gpu_set_blendmode(bm_add)
        for (var i = 0; i < 360; i += 45) {
            
            draw_surface(tp_surf, lengthdir_x(2, i), lengthdir_y(2, i))
        }
        gpu_set_blendmode(bm_normal)
        draw_set_alpha(1)
		
        var __c_unfilled = c_red
        var __c_filled = (!full ? c_orange : c_yellow)
        var __c_outline = c_white
        
        if tp_constrict {
            __c_unfilled = c_blue
            
            __c_filled = merge_color(c_blue, c_teal, 0.5)
            if full
                __c_filled = merge_color(c_teal, __c_filled, 0.5)
        }
        
        draw_sprite_ext(spr_ui_enc_tpbar, (tp_constrict ? 2 : 1), 38 + tpxx, 40, 1, 1, 0, c_white, 1)
        
		if tplerp2 < tplerp {
			draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
				0, (100-tplerp) / 100 * 187, 
				18, tplerp/100 * 187, 41 + tpxx,
				46 + (100-tplerp)/100 * 187,
				1, 1, __c_unfilled, 1
			)
			draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
				0, (100-tplerp2)/100 * 187,
				18, tplerp2/100 * 187, 
				41 + tpxx, 46 + (100-tplerp2)/100 * 187,
				1, 1, __c_filled, 1)
			
			if !full {
				draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
					0, (100-tplerp)/100 * 187,
					18, 2,
					41 + tpxx, 46 + (100-tplerp)/100 * 187,
					1, 1, __c_outline, 1
				)
			}
		}
		else {
			draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
				0, (100-tplerp2)/100 * 187,
				18, tplerp2/100 * 187, 
				41 + tpxx, 46 + (100-tplerp2)/100 * 187,
				1, 1, __c_outline, 1
			)
			draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
				0, (100-tplerp)/100 * 187, 
				18, tplerp/100 * 187,
				41 + tpxx, 46 + (100-tplerp)/100 * 187,
				1, 1, __c_filled ,1
			)
			
			if !full {
				draw_sprite_part_ext(spr_ui_enc_tpfilling, 0,
					0, (100-tplerp2)/100 * 187,
					18, 2, 
					41 + tpxx, 46 + (100-tplerp2)/100 * 187,
					1, 1, __c_outline, 1
				)
			}
		}
        
        draw_sprite_ext(spr_ui_enc_tpfilling, 0, 41 + tpxx, 46, 1, 1, 0, c_white, tp_glow_alpha)
	}

}
surface_reset_target()

draw_surface(surf, 0, 0)