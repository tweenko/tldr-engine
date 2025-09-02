var roll = 80 * menuroll
var __top_txt_len = 310

draw_set_font(loc_getfont("main"))

if !surface_exists(surf)
    surf = surface_create(640, 480)
surface_set_target(surf)
draw_clear_alpha(0, 0)

if !only_hp { // top
	draw_sprite_ext(spr_pixel, 0, 0, 0, 640, roll, 0, c_black, 1)
	draw_sprite_ext(spr_ui_menu_lb, selection, 20, 24 - 80 + roll, 2, 2, 0, c_white, 1)
	
	for (var i = 0; i < 4; ++i) {
	    draw_sprite_ext(spr_ui_menu_bt, i*2 + (selection == i ? 1 : 0), 120 + 100*i, 20 - 80 + roll, 2, 2, 0, c_white, 1)
		
		if selection == i && state == 0
			draw_sprite_ext(spr_ui_soul_small, 0, 128 + 100*i, 38 - 80 + roll, 2, 2, 0, c_red, 1)
	}
	draw_text_transformed(520, 20 - 80 + roll, string("D$ {0}", darkdollars), 2, 2, 0)
}
{ // bottom
	draw_sprite_ext(spr_pixel, 0, 0, 417 + 80 - roll, 640, 63, 0, c_black, 1)
	for (var i = 0; i < array_length(global.party_names); ++i) {
		var xoff = 319.5 + array_length(global.party_names) * -213/2
		var col = bcolor
		
		if i_pmselection == i && state == 3 && selection == 0 
			col = party_getdata(global.party_names[i], "color")
		if e_pmselection == i && selection == 1 && state > 0 
			col = party_getdata(global.party_names[i], "color")
		
		draw_sprite_ext(spr_pixel, 0, i*213 + xoff, 417 + 80 - roll, 213, 2, 0, col, 1)
		
		if (i == i_pmselection || i_mode == 1) && state == 3 && selection == 0
			draw_sprite_ext(spr_ui_menu_heart, 0, 18+213*i+xoff, 430+80-roll, 1, 1, 0, c_white, 1)
		else
			draw_sprite_ext(party_geticon(global.party_names[i]), 0, 12 + 213*i + xoff, 430 + 80-roll, 1, 1, 0, c_white, 1)
		
		var font = global.partyname_font_2
		
		if string_length(party_getname(global.party_names[i], false)) > 4
			font = global.partyname_font_1
		if string_length(party_getname(global.party_names[i], false)) > 5
			font = global.partyname_font_0
		
		draw_set_font(font)
		draw_text_transformed(51 + 213*i + xoff, 430 + 80 - roll, string_upper(party_getname(global.party_names[i], false)), 1, 1, 0)
		
		draw_set_font(global.font_ui_hp)
		draw_sprite_ext(spr_ui_hp_text, 0, 110 + 213*i + xoff, 441 + 80 - roll, 1, 1, 0, c_white, 1)
		
		draw_sprite_ext(spr_pixel, 0, 128 + 213*i + xoff, 441 + 80 - roll, 76, 9, 0, c_maroon, 1)
		draw_sprite_ext(spr_pixel, 0, 128 + 213*i + xoff, 441 + 80 - roll, 76*(party_getdata(global.party_names[i], "hp")/party_getdata(global.party_names[i], "max_hp")), 9, 0,party_getdata(global.party_names[i], "color"), 1)
		
		draw_set_halign(fa_right)
		if party_getdata(global.party_names[i], "hp") < 30 
			draw_set_color(c_yellow)
		
		draw_text_transformed(160 + 213*i + xoff, 428 + 80 - roll, string(party_getdata(global.party_names[i], "hp")), 1, 1, 0)
		draw_sprite_ext(spr_ui_hp_seperator, 0, 161 + 213*i + xoff, 428 + 80 - roll, 1, 1, 0, c_white, 1)
		draw_text_transformed(205 + 213*i + xoff, 428 + 80 - roll, party_getdata(global.party_names[i], "max_hp"), 1, 1, 0)
		
		draw_set_color(c_white)
		draw_set_halign(fa_left)
		draw_set_font(loc_getfont("main"))
		draw_set_alpha(min(partyreactiontimer[i],1))
		draw_set_color(c_white)
		
		if is_string(partyreaction[i]) 
			draw_text_transformed(213*i+xoff, 456, partyreaction[i], 1, 1, 0)
		draw_set_alpha(1)
	}
}	

if selection == 0 { // items
	if state > 0 {
		var opt = ["USE", "TOSS", "KEY"]
		var draw_text_shadow = function(xx,yy, sstring, color = c_white) {
			draw_set_color(bcolor)
		    draw_text_transformed(xx+2, yy+2, sstring, 2, 2, 0)
			draw_set_color(color)
		    draw_text_transformed(xx, yy, sstring, 2, 2, 0)
		}
		
		draw_set_font(loc_getfont("main"))
		ui_dialoguebox_create(68, 88, 572-68, 362-88)
		
		// the three options at the top
		for (var i = 0; i < 3; ++i) {
		    var col = c_white
			if state > 1 && i_pselection == i
				col = c_orange
			else if state > 1
				col = c_gray
			
			draw_text_transformed_color(180 + 120*i, 110, opt[i], 2, 2, 0, col, col, col, col, 1)
			if i == i_pselection && state == 1 
				draw_sprite_ext(spr_uisoul, 0, 155 + 120*i, 120, 1, 1, 0, c_red, 1)
		}
		
		if i_pselection == 2 { // key
			for (var i = 0; i < item_get_count(ITEM_TYPE.KEY); ++i) {
				if i == i_selection && state == 2 
					draw_sprite_ext(spr_uisoul, 0, 120 + (i % 2 == 1 ? 210 : 0), 160 + floor(i/2) * 30, 1, 1, 0, c_red, 1)
				draw_text_shadow(146 + (i%2 == 1 ? 210 : 0), 152 + floor(i/2) * 30, item_get_name(global.key_items[i]), (state == 1 ? c_gray : c_white))
			}
		}
		else { // other
			for (var i = 0; i < item_get_count(); ++i) {
				if i == i_selection && state == 2 
					draw_sprite_ext(spr_uisoul, 0, 120 + (i % 2 == 1 ? 210 : 0), 160 + floor(i/2) * 30, 1, 1, 0, c_red, 1)
				draw_text_shadow(146 + (i%2 == 1 ? 210 : 0), 152 + floor(i/2) * 30, item_get_name(global.items[i]), (state == 1 ? c_gray : c_white))
			}
		}
		
		if state == 2 || state == 3 {
			var arr = global.items
			if i_pselection == 2 
				arr = global.key_items
			
			draw_set_color(c_black)
			draw_rectangle(0, 0, 640, 79, 0)
			draw_set_color(c_white)
			
			var txt = item_get_desc(arr[i_selection],0)
			if i_pselection == 1 && state == 3
				txt = string("Really throw away the\n{0}?", item_get_name(arr[i_selection]))
			
			draw_text_ext_transformed(20, 10, txt, 16, __top_txt_len, 2, 2, 0)
		}
	}
}
if selection == 1 { // equip
	if state > 0 {
		draw_set_font(loc_getfont("main"))
		
		ui_dialoguebox_create(58, 88, 583 - 58, 413 - 88)
		draw_text_transformed(135, 107,party_getname(global.party_names[e_pmselection],false), 2, 2, 0)
		
		for (var i = 0; i < array_length(global.party_names); ++i) {
			var c = (i == e_pmselection ? c_white : #666666)
			if i == e_pmselection && state == 1 {
				draw_sprite_ext(spr_ui_soul_arrows, o_world.frames/30 * 2, 108 + 50*i, 142, 1, 1, 0, c_red, 1)
			}
		    draw_sprite_ext(party_geticon_ow(global.party_names[i]),0, 90 + 50*i, 160, 2, 2, 0, c, 1)
		}
		
		draw_set_color(c_white)
		draw_rectangle(270, 90, 275, 220, 0)
		draw_rectangle(62, 221, 580, 226, 0)
		draw_rectangle(323, 226, 328, 408, 0)
		
		draw_sprite_ext(spr_ui_menu_cchar, 0, 118, 86, 2, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_menu_cstats, 0, 116, 216, 2, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_menu_cequipped, 0, 376, 86, 2, 2, 0, c_white, 1)
		
		if e_pselection==0
			draw_sprite_ext(spr_ui_menu_cweapons, 0, 372, 216, 2, 2, 0, c_white, 1)
		else 
			draw_sprite_ext(spr_ui_menu_carmors, 0, 372, 216, 2, 2, 0, c_white, 1)
		
		var delta = 0 // 1 for worse and 2 for better
		var order = ["attack", "defense", "magic"]
		
		var arr = global.weapons
		if e_pselection > 0
			arr = global.armors
		
		var arr_mod = []
		array_copy(arr_mod, 0, arr, 0, array_length(arr))
		array_insert(arr_mod, 0, undefined)
		
		var stats = [
			["Attack:", party_getdata(global.party_names[e_pmselection], "attack"), spr_ui_menu_icon_sword],
			["Defense:", party_getdata(global.party_names[e_pmselection], "defense"), spr_ui_menu_icon_armor],
			["Magic:", party_getdata(global.party_names[e_pmselection], "magic"), spr_ui_menu_icon_magic],
		]
		var equipment = [
			party_getdata(global.party_names[e_pmselection], "weapon"),
			party_getdata(global.party_names[e_pmselection], "armor1"),
			party_getdata(global.party_names[e_pmselection], "armor2"),
		]
		
		for (var i = 0; i < array_length(equipment); ++i) {
			if state == 3 && i == e_pselection {
				if !is_undefined(arr_mod[e_selection]) && !is_undefined(arr_mod[e_selection].effect) {
					array_push(stats, [arr_mod[e_selection].effect.text, 0, arr_mod[e_selection].effect.sprite])
                    
					if !is_undefined(equipment[i]) && !is_undefined(equipment[i].effect) {
						if arr_mod[e_selection].effect.text != equipment[i].effect.text
							delta = 2
					}
					else
						delta = 2
				}
				else {
					array_push(stats, ["(No ability.)", 0, -1])
					if !is_undefined(equipment[i])
						delta = 1
				}
			}
			else {
			    if !is_undefined(equipment[i]) && !is_undefined(equipment[i].effect)
					array_push(stats, [equipment[i].effect.text, 0, equipment[i].effect.sprite])
				else
					array_push(stats, ["(No ability.)", 0, -1])
			}
		}
		for (var i = 0; i < array_length(stats); ++i) {
			var off = 27
			
			if i > 2 
				draw_set_color(c_orange) 
			else 
				draw_set_color(c_white)
			
		    if sprite_exists(stats[i][2]) 
				draw_sprite_ext(stats[i][2], 0, 74, 236 + i*off + (i > 2 ? 2 : 0), 2, 2, 0, draw_get_color(), 1)
			
			if stats[i][0] == "(No ability.)" 
				draw_set_color(c_dkgray) 
			else 
				draw_set_color(c_white)
			
			if state == 3 && i != 3 + e_pselection && i > 2
				draw_set_color(c_dkgray)
			if i == e_pselection + 3 {
				if delta == 1 // if the new one is considered worse
					draw_set_color(c_red)
				if delta == 2 // if the new one is considered comperable or better
					draw_set_color(c_yellow)
			}
			
			draw_text_transformed(100, 230 + i*off, stats[i][0], 2, 2, 0)
			
			var txt = stats[i][1]
			var delta_stats = {
				attack: 0,
				magic: 0,
				defense: 0,
			}
			if state == 3 && i < 3 {
				var prev_item = equipment[e_pselection]
				
				if !is_undefined(prev_item){
					if struct_exists(prev_item.stats, order[i]) 
						struct_set(delta_stats, order[i], struct_get(delta_stats, order[i]) - struct_get(prev_item.stats, order[i]))
				}
				if !is_undefined(arr_mod[e_selection]){
					if struct_exists(arr_mod[e_selection].stats, order[i]) 
						struct_set(delta_stats, order[i], struct_get(delta_stats, order[i]) + struct_get(arr_mod[e_selection].stats, order[i]))
				}
				
				if struct_get(delta_stats,order[i]) != 0 {
					txt = string("{0}({2}{1})", stats[i][1] + struct_get(delta_stats,order[i]),struct_get(delta_stats,order[i]), (struct_get(delta_stats,order[i]) >= 0 ? "+" : ""))
					
					if struct_get(delta_stats, order[i]) >= 0 
						draw_set_color(c_yellow)
					else 
						draw_set_color(c_red)
				}
			}
			
			if i < 3 
				draw_text_transformed(230, 230 + i*off, txt, 2, 2, 0)
		}
		
		var equipped = [
			[party_getdata(global.party_names[e_pmselection], "s_icon_weapon"), party_getdata(global.party_names[e_pmselection], "weapon")],
			[spr_ui_menu_armor1, party_getdata(global.party_names[e_pmselection], "armor1")],
			[spr_ui_menu_armor2, party_getdata(global.party_names[e_pmselection], "armor2")],
		]
		for (var i = 0; i < array_length(equipped); ++i) {
			if e_pselection == i && state == 2
				draw_sprite_ext(spr_uisoul, 0, 308, 122 + i*30, 1, 1, 0, c_red, 1)
			else
				draw_sprite_ext(equipped[i][0], 0, 302, 118 + 30*i, 2, 2, 0, c_white, 1)
			
			var txt = ""
			var icon = undefined
			
			draw_set_color(c_white)
			if is_undefined(equipped[i][1]) {
				txt = "(Nothing)"; 
				draw_set_color(c_dkgray)
			}
			else {
				txt=struct_get(equipped[i][1], "name")[0];
				icon=struct_get(equipped[i][1], "icon")
			}
			draw_text_transformed(365, 112 + 30*i, txt, 2, 2, 0)
			
			if !is_undefined(icon) 
				draw_sprite_ext(icon, 0, 343, 118 + 30*i, 2, 2, 0, c_white, 1)
		}
		
		if state == 2 {
			draw_set_color(c_black)
			draw_rectangle(0, 0, 640, 79, 0)
			draw_set_color(c_white)
			if !is_undefined(equipped[e_pselection][1]) {
				var txt = item_get_desc(equipped[e_pselection][1], 0)
				draw_text_ext_transformed(20, 10, txt, 16, __top_txt_len, 2, 2, 0)
			}
		}
		draw_set_color(c_white)
		if state == 3 {
			draw_set_color(c_black)
			draw_rectangle(0, 0, 640, 79, 0)
			
			draw_set_color(c_white)
			if !is_undefined(arr_mod[e_selection]) {
				var txt=item_get_desc(arr_mod[e_selection], 0)
				draw_text_ext_transformed(20, 10, txt, 16, __top_txt_len, 2, 2, 0)
			}
		}
		
		// draw the equipment names
		for (var i = e_move; i < min(array_length(arr_mod), e_move+6); ++i) {
			var txt = ""
			if !is_undefined(arr_mod[i]) {
				txt = item_get_name(arr_mod[i])
				if e_pselection == 0 {
					if !array_contains(arr_mod[i].weapon_whitelist, global.party_names[e_pmselection]) 
						draw_set_color(c_gray)
				}
				else {
					if array_contains(arr_mod[i].armor_blacklist, global.party_names[e_pmselection]) 
						draw_set_color(c_gray)
				}
			}
			else {
				txt = "---------"
				draw_set_color(c_dkgray)
			}
			
		    draw_text_transformed(384, 230 + (i - e_move) * 27, txt, 2, 2, 0)
			if i == e_selection && state == 3 
				draw_sprite_ext(spr_uisoul, 0, 344, 240 + (i - e_move) * 27, 1, 1, 0, c_red, 1)
			
			var icon = undefined
			if !is_undefined(arr_mod[i]) 
				icon = struct_get(arr_mod[i],"icon")
			if !is_undefined(icon) 
				draw_sprite_ext(icon, 0, 363, 236 + (i-e_move)*27, 2, 2, 0, draw_get_color(), 1)
			draw_set_color(c_white)
		}
		
		// the page arrows
		if array_length(arr_mod) > 6 && state == 3 {
			draw_set_color(c_dkgray)
			draw_rectangle(555, 259, 560, 378, 0)
			draw_set_color(c_white)
			
			var add = lerp(0, 120-5, e_move / (array_length(arr_mod)-6))
			draw_rectangle(555, 259 + add, 560, 259 + 5 + add, 0)
			
			if e_move < array_length(arr_mod) - 6
				draw_sprite_ext(spr_ui_arrow_down, 0, 551, 385 + round(sine(12, 3)), 1, 1, 0, c_white, 1)
			if e_move > 0
				draw_sprite_ext(spr_ui_arrow_up, 0, 551, 234 + round(sine(12, -3)), 1, 1, 0, c_white, 1)
		}
	}
}
if selection == 2 { // power
	if state > 0 {
		draw_set_font(loc_getfont("main"))
		ui_dialoguebox_create(58, 88, 583 - 58, 413 - 88)
		
		draw_text_transformed(130, 112-7, party_getname(global.party_names[p_pmselection], false), 2, 2, 0)
		for (var i = 0; i < array_length(global.party_names); ++i) {
			var c = (i == p_pmselection ? c_white : #666666)
			if i == p_pmselection && state == 1 {
				draw_sprite_ext(spr_ui_soul_arrows, o_world.frames/30 * 2, 108 + 50*i, 141, 1, 1, 0, c_red, 1)
			}
		    draw_sprite_ext(party_geticon_ow(global.party_names[i]),0, 90+50*i, 160, 2, 2, 0, c, 1)
		}
		
		draw_set_color(c_white)
		draw_rectangle(62, 216, 580, 221, 0)
		draw_rectangle(294, 220, 299, 408, 0)
		
		draw_sprite_ext(spr_ui_menu_cchar, 0, 124, 84, 2, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_menu_cstats, 0, 124, 210, 2, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_menu_cspells, 0, 380, 210, 2, 2, 0, c_white, 1)
		
		draw_text_ext_transformed(320, 105, "LV" + string(party_getdata(global.party_names[p_pmselection], "lv")) + " " + party_getdata(global.party_names[p_pmselection], "desc"), 16, 126, 2, 2, 0)
		
		var stats = [
			["Attack:", party_getdata(global.party_names[p_pmselection], "attack"), spr_ui_menu_icon_sword],
			["Defense:", party_getdata(global.party_names[p_pmselection], "defense"), spr_ui_menu_icon_armor],
			["Magic:", party_getdata(global.party_names[p_pmselection], "magic"), spr_ui_menu_icon_magic],
		]
		
		if struct_exists(party_nametostruct(global.party_names[p_pmselection]), "power_stats") {
			for (var i = 0; i < array_length(party_getdata(global.party_names[p_pmselection], "power_stats")); ++i) {
			    array_push(stats, party_getdata(global.party_names[p_pmselection], "power_stats")[i])
			}
		}
		
		for (var i = 0; i < array_length(stats); ++i) {
			var off = 25
			var txt = ""
			
			if stats[i] == "???" {
				txt = "???"
				draw_set_color(c_dkgray) 
			}
			else {
				txt = stats[i][0]
				draw_set_color(c_white)
				
				if sprite_exists(stats[i][2]) 
					draw_sprite_ext(stats[i][2], 0, 74, 236 + i*off, 2, 2, 0, draw_get_color(), 1)
			}
			
			draw_text_xfit(100, 230 + i*off, txt, 220, 2, 2)
			
			if stats[i] != "???" {
				// add custom ones here if needed
				if stats[i][0] == "Guts:"
					|| stats[i][0] == "Fluffiness" 
				{
					for (var j = 0; j < stats[i][1]; ++j) {
					    draw_sprite_ext(stats[i][2], 0, (stats[i][0] == "Guts:" ? 190 : 230)+20*j, 236+i*off, 2, 2, 0, c_white, 1)
					}
				}
				else {
					draw_text_transformed(230, 230 + i*off, stats[i][1], 2, 2, 0)
				}
			}
		}
		
		draw_set_color(c_gray)
		draw_sprite_ext(spr_ui_menu_ctp, 0, 340, 225, 1, 1, 0, c_white, 1)
		
		for (var i = 0; i < array_length(party_getdata(global.party_names[p_pmselection], "spells")); ++i) {
		    draw_text_transformed(340, 230 + i*25, string("{0}%", party_getdata(global.party_names[p_pmselection], "spells")[i].tp_cost), 2, 2, 0)
		    draw_text_transformed(410, 230 + i*25, item_get_name(party_getdata(global.party_names[p_pmselection], "spells")[i]), 2, 2, 0)
			
			if i == p_selection && state == 2
				draw_sprite_ext(spr_uisoul, 0, 320, 240 + i*25, 1, 1, 0, c_red, 1)
		}
		
		draw_set_color(c_white)
		
		if state == 2 {
			draw_set_color(c_black)
			draw_rectangle(0, 0, 640, 79, 0)
			draw_set_color(c_white)
			
			if !is_undefined(party_getdata(global.party_names[p_pmselection], "spells")[p_selection]){
				var txt = item_get_desc(party_getdata(global.party_names[p_pmselection],"spells")[p_selection], 0)
				draw_text_ext_transformed(20, 10, txt, 16, __top_txt_len, 2, 2, 0)
			}
		}
	}
}
if selection == 3 && state > 0 { // config
    draw_set_font(loc_getfont("main"))
    ui_dialoguebox_create(58, 88, 583 - 58, 413 - 88)
    
    if state == 1 || state == 2 {
        draw_text_transformed(270, 100, "CONFIG", 2, 2, 0)
        draw_sprite_ext(spr_soul, 0, 152, 168 + c_selection*35, 1, 1, 0, c_red, 1)
        
        for (var i = 0; i < array_length(c_config); i ++) {
            if c_selection == i && state == 2
                draw_set_color(c_yellow)
            
            draw_text_transformed(170, 150 + i*35, c_config[i].name, 2, 2, 0)
            
            // draw the value to the right
            switch c_config[i].type {
                case C_CONFIG_TYPE.BUTTON:
                    break
                case C_CONFIG_TYPE.SLIDER:
                    draw_text_transformed(430, 150 + i*35, c_config[i].display(), 2, 2, 0)
                    break
                case C_CONFIG_TYPE.SWITCH:
                    var __txt = "ON"
                    if is_callable(c_config[i].state) {
                        var __tmp = c_config[i].state()
                        __txt = (__tmp ? "ON" : "OFF")
                    }
                    else
                        __txt = (c_config[i].state ? "ON" : "OFF")
                    
                    draw_text_transformed(430, 150 + i*35, __txt, 2, 2, 0)
                    break
            }
            
            draw_set_color(c_white)
            
            }
        }
    else if state == 3 {
        draw_text_transformed(105, 100, "Function", 2, 2, 0)
        draw_text_transformed(325, 100, "Key", 2, 2, 0)
        
        draw_sprite_ext(spr_soul, 0, 88, 156 + 28 * c_controls_selection, 1, 1, 0, c_red, 1)
        for (var i = 0; i < array_length(c_controls); i ++) {
            if c_controls_selection == i {
                draw_set_color(c_aqua)
                if c_controls_changing
                    draw_set_color(c_red)
            }
            
            draw_text_transformed(105, 140 + 28*i, InputVerbGetExportName(c_controls[i]), 2, 2, 0)
            draw_text_transformed(325, 140 + 28*i, input_binding_to_string(InputBindingGet(InputDeviceIsGamepad(InputPlayerGetDevice()), c_controls[i]), false), 2, 2, 0)
            
            draw_set_color(c_white)
        }
        
        if c_controls_selection == array_length(c_controls)
            draw_set_color(merge_color(c_aqua, c_yellow, c_controls_resetfade))
        draw_text_transformed(105, 140 + 28*i, "Reset to default", 2, 2, 0)
        draw_set_color(c_white)
        
        i ++
        
        if c_controls_selection == array_length(c_controls) + 1
            draw_set_color(c_aqua)
        draw_text_transformed(105, 140 + 28*i, "Finish", 2, 2, 0)
        draw_set_color(c_white)
    }
}

draw_set_color(c_white)
draw_set_alpha(1)
draw_set_halign(fa_left)
draw_set_valign(fa_top)

surface_reset_target()
draw_surface_ext(surf, 0, 0, 1, 1, 0, c_white, 1)