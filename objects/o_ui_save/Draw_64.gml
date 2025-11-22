draw_set_font(loc_font("main"))

if page == 0 { // main menu
	var time = time_format(global.time)
	
    ui_dialoguebox_create(100 - size_increment, 106 - size_increment, 539-100 + size_increment*2, 308-106 + size_increment*2)
	draw_text_transformed(120, 120, save_get("name"), 2, 2, 0)
	
	draw_set_halign(fa_right)
	draw_text_transformed(522 - string_width(time)*2 - 32, 120, $"LV {global.chapter}", 2, 2, 0)
	draw_text_transformed(522, 120, time, 2,2, 0)
	
	draw_set_halign(fa_center)
	draw_text_transformed(320, 170, loc(global.room_name), 2, 2, 0)
	
	draw_set_halign(fa_left)

	for (var i = 0; i < array_length(m_buttons); ++i) {
		if !m_buttons[i].on 
			draw_set_color(c_gray)
		
		draw_text_transformed((i%2 == 0 ? 170 : 350), 220 + floor(i/2)*40, m_buttons[i].name, 2, 2, 0)
		draw_set_color(c_white)
	}

	draw_sprite_ext(spr_ui_soul, 0, (m_selection % 2 == 0 ? 170 : 350) - 28, 228 + floor(m_selection/2) * 40, 2, 2, 0, c_red, 1)
}
if page == 1 { // save menu
	if prog != 2 
		draw_sprite_ext(spr_pixel,0, 0, 0, 640, 480, 0, c_black, .8)
	
	ui_dialoguebox_create(68, 20, 573 - 68, 110 - 20)
	ui_dialoguebox_create(68, 132, 573 - 68, 438 - 132 - (prog == 1 ? 48 : 0))
	
	if prog == 1 
		draw_set_color(c_yellow)
	
	var time = time_format(global.time)
	
	draw_set_halign(fa_center)
	draw_text_transformed(320, 32, save_get("name"), 2, 2, 0)
	draw_text_transformed(320, 64, loc(global.room_name), 2, 2, 0)
	
	draw_set_halign(fa_left)
	draw_text_transformed(100, 32, $"LV {global.chapter}", 2, 2, 0)
	
	draw_set_halign(fa_right)
	draw_text_transformed(543, 32, time, 2, 2, 0)
	
	draw_set_color(c_white)
	
	var maxslots = 3
	var spacing = 112
	for (var i = 0; i < maxslots; ++i) {
		var space = 84
		if array_length(global.saves) <= i || global.saves[i] == -1 {
			if prog == 1 
				draw_set_color(c_dkgray)
			if i == s_selection {
				if prog != 1 
					draw_sprite_ext(spr_uisoul, 0, 235, 168 + i*space, 1, 1, 0, c_red, 1)
				draw_set_color(c_yellow)
			}
			
			draw_set_halign(fa_center)
			draw_text_transformed(320, 48 + i*space + spacing, loc("save_menu_new_file"), 2, 2, 0)
			
			draw_set_halign(fa_left)
			
			draw_set_color(c_white)
		}
		else {
			if prog != 2 
				time = time_format(save_s_get(i, "time"))
			
			if i == s_selection{
				if prog != 1 
					draw_sprite_ext(spr_uisoul, 0, 92, 152 + i*space, 1, 1, 0, c_red, 1)
				draw_set_color(c_yellow)
			}
			
			if prog == 1 && i == s_selection {
				draw_set_halign(fa_center)
				if prog!=2 draw_text_transformed(320, 48+  i*space+spacing, loc("save_menu_file_saved"), 2, 2, 0)
				draw_set_halign(fa_left)
			}
			else {
				if prog == 1 
					draw_set_color(c_dkgray)
				
				draw_set_halign(fa_center)
				if prog != 2 
					draw_text_transformed(320,32 + i*space + spacing, save_s_get(i, "name"), 2, 2, 0)
				if prog != 2 
					draw_text_transformed(320,64 + i*space + spacing, loc(save_s_get(i, "room_name")), 2, 2, 0)
				
				draw_set_halign(fa_left)
				if prog != 2 
					draw_text_transformed(124, 32 + i*space + spacing, $"LV {save_s_get(i, "chapter")}", 2, 2, 0)
				
				draw_set_halign(fa_right)
				if prog != 2 
					draw_text_transformed(543, 32 + i*space + spacing, time, 2, 2, 0)
				
				draw_set_halign(fa_left)
			}
			
			draw_set_color(c_white)
		}
		if prog != 1 || i < maxslots - 1 {
			draw_sprite_ext(spr_pixel, 0, 74, 104 + i*space + spacing, 493, 4, 0, c_white, 1)
			draw_sprite_ext(spr_pixel, 0, 74, 108 + i*space + spacing, 493, 2, 0, #9DA2C4, 1)
		}
	}
	
	draw_set_halign(fa_center)
	
	if s_selection == 3 {
		draw_sprite_ext(spr_uisoul, 0, 236, 402, 1, 1, 0, c_red, 1)
		draw_set_color(c_yellow)
	}
	if prog != 1 
		draw_text_transformed(320, 402 - 8, loc("save_menu_return"), 2, 2, 0)
	
	draw_set_color(c_white)
	draw_set_halign(fa_left)
	
	if prog == 2 {
		var yy = 70
		
		draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, .8)
		ui_dialoguebox_create(18, 108, 622 - 18, 372 - 108)
		
		// local save draw
		{
			draw_set_halign(fa_center)
			draw_text_transformed(320, 131 - 8, string(loc("save_menu_overwrite_query"), s_selection + 1), 2, 2, 0)
			draw_text_transformed(320, 173 - 8, save_s_get(s_selection, "name"), 2, 2, 0)
			draw_text_transformed(320, 203 - 8, loc(save_s_get(s_selection, "room_name")), 2, 2, 0)
			draw_set_halign(fa_left)
		
			draw_text_transformed(80, 173 - 8, $"LV {save_s_get(s_selection, "chapter")}", 2, 2, 0)
			draw_set_halign(fa_right)
			draw_text_transformed(557, 173 - 8, time_format(save_s_get(s_selection, "time")), 2, 2, 0)
			draw_set_halign(fa_left)
		}
		
		// overwrite save draw
		{
			draw_set_color(c_yellow)
		
			draw_set_halign(fa_center)
			draw_text_transformed(320, 173 - 8 + yy, save_get("name"), 2, 2, 0)
			draw_text_transformed(320, 203 - 8 + yy, loc(global.room_name), 2, 2, 0)
			draw_set_halign(fa_left)
		
			draw_text_transformed(80, 173 - 8 + yy, $"LV {save_get("chapter")}", 2, 2, 0)
			draw_set_halign(fa_right)
			draw_text_transformed(557, 173 - 8 + yy, time_format(global.time), 2, 2, 0)
			
			draw_set_halign(fa_left)
		}
		
		draw_set_color(c_white)
		if s_o_selection == 0 {
			draw_set_color(c_yellow)
			draw_sprite_ext(spr_uisoul, 0, 170 - 28, 332, 1, 1, 0, c_red, 1)
		}
		draw_text_transformed(170, 332 - 8, loc("save_menu_save"), 2, 2, 0)
		
		draw_set_color(c_white)
		if s_o_selection == 1 {
			draw_set_color(c_yellow)
			draw_sprite_ext(spr_uisoul, 0, 350 - 28, 332, 1, 1, 0, c_red, 1)
		}
		
		draw_text_transformed(350, 332 - 8, loc("save_menu_return"), 2, 2, 0)
		draw_set_color(c_white)
	}
}
if page == 2 { // storage
	draw_set_font(loc_font("main"))
	
	draw_set_color(c_white)
	draw_rectangle(40, 121, 600, 430, 0)
	draw_set_color(c_black)
	draw_rectangle(44, 124, 596, 274, 0)
	draw_rectangle(44, 279, 596, 426, 0)
	
	draw_rectangle(0, 0, 640, 120, 0)
	draw_set_color(c_white)
	
	var p = 0
	var desc = "---"
	if st_page == 0 {
		if st_selection[0] < array_length(global.items) 
			desc = item_get_desc(global.items[st_selection[0]])
	}
	else {
		if st_selection[1] < array_length(global.storage) && global.storage[st_selection[1]] != undefined 
			desc = item_get_desc(global.storage[st_selection[1]])
	}
	draw_text_ext_transformed(20, 20, desc, 16, 300, 2, 2, 0)
	
	draw_set_font(loc_font("enc"))
	draw_set_color((st_page == 0 ? c_gray : c_dkgray))
	draw_text_transformed(61, 141, loc("save_menu_s_pocket"), 1, 1, 0)
	draw_set_color((st_page == 1 ? c_gray : c_dkgray))
	draw_text_transformed(61, 291, loc("save_menu_s_storage"), 1, 1, 0)
	draw_text_ext_transformed(61, 361, string(loc("save_menu_s_page"), st_stpage + 1, st_maxstpage), 20, -1, 1, 1, 0)
	draw_set_color(c_white)
	
	for (var i = 0; i < item_get_maxcount(); ++i) { // pocket
		var txt = "---"
		if i < array_length(global.items) 
			txt = item_get_name(global.items[i])
		var xx = (i%2 == 0 ? 155 : 375)
		
		if p == st_page 
			draw_set_color((st_selection[p] == i ? c_yellow : c_white))
		else 
			draw_set_color((st_selection[p] == i ? c_yellow : c_gray))
		
		draw_text_transformed(xx, 145 + floor(i/2) * 20, txt, 1, 1, 0)
	}
	
	p = 1
	for (var i = st_stpage*12; i < 12 * (st_stpage+1); ++i) { // storage
		var txt = "---"
		if i < array_length(global.storage) && global.storage[i] != undefined
			txt = item_get_name(global.storage[i])
		var xx = (i % 2 == 0 ? 155 : 375)
		
		if p == st_page 
			draw_set_color((st_selection[p] == i ? c_yellow : c_white))
		else 
			draw_set_color(c_gray)
		
		draw_text_transformed(xx, 295 + floor((i - 12*st_stpage)/2) * 20, txt, 1, 1, 0)
	}
	
	draw_set_color(c_white)
	draw_sprite_ext(spr_ui_soul, 0, st_soulx, st_souly, 1, 1, 0, c_red, 1)
	
	if st_page == 1 {
		draw_sprite_ext(spr_ui_arrow_flat, 0, 40 + round(sine(5, 2)), 352, -2, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_arrow_flat, 0, 600 - round(sine(5, 2)), 352, 2, 2, 0, c_white, 1)
	}
}
if page == 4 {  // return to title
    ui_dialoguebox_create(100 - size_increment, 106 - size_increment, 539-100 + size_increment*2, 308-106 + size_increment*2)
    draw_text_transformed(170, 130, loc("save_menu_return_confirm"), 2, 2, 0)
    
    if return_selection == 0 && !fading_out
        draw_sprite_ext(spr_ui_soul, 0, 170 - 28, 268, 2, 2, 0, c_red, 1)
    draw_text_transformed(170, 260, loc("save_menu_return_yes"), 2, 2, 0)
    
    if return_selection == 1 && !fading_out
        draw_sprite_ext(spr_ui_soul, 0, 350 - 28, 268, 2, 2, 0, c_red, 1)
    draw_text_transformed(350, 260, loc("save_menu_return_no"), 2, 2, 0)
}