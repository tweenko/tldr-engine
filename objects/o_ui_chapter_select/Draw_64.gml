if !surface_exists(surf) 
	surf = surface_create(640, 480)

if state == -1 {
	surface_set_target(surf){
		draw_clear_alpha(0, 0)
		draw_set_font(loc_font("main"))
		
		draw_set_halign(fa_center)
		draw_set_alpha(alpha)
		draw_text_transformed(320, 220+yadd, txt, 2, 2, 0)
	
		if sselection == 0 {
			draw_sprite_ext(spr_ui_soul, 0, 320 - string_width(yes) - 26, 260+8 + yadd, 2, 2, 0, c_red, alpha)
			draw_set_color(c_yellow)
		}
		draw_text_transformed(320, 260 + yadd, yes, 2, 2, 0)
		
		draw_set_color(c_white)
		if sselection == 1 {
			draw_sprite_ext(spr_ui_soul, 0, 320 - string_width(no) - 26,300+8 + yadd, 2, 2, 0, c_red, alpha)
			draw_set_color(c_yellow)
		}
		draw_text_transformed(320, 300 + yadd, no, 2, 2, 0)
		draw_set_color(c_white)
	
		draw_set_halign(fa_left)
	}
	surface_reset_target()
}
else {
	surface_set_target(surf) {
		draw_clear_alpha(0, 0)
	
		var total = array_length(chapters)

		draw_set_font(loc_font("main"))
		draw_set_alpha(alpha)

		for (var i = 0; i < array_length(chapters); ++i) {
			if selection == i+1 
				draw_set_color(c_yellow)
			else if !is_struct(chapters[i]) 
				draw_set_color(c_gray)
			else 
				draw_set_color(c_white)
	
			draw_sprite_ext(spr_pixel, 0, 0, 62 + 60*i - yadd, 640, 2, 0, #2B2B2B, alpha)
	
			if i+1 == selection && !confirming {
				draw_sprite_ext(spr_ui_soul, 0, 20, 24 + 60*i + yadd, 2, 2, 0, c_red, alpha)
			}
			
			draw_set_font(font_main)
		    draw_text_transformed(50, 24 - 8 + i*60 + yadd, "Chapter " + string(i + 1), 2, 2, 0)
			draw_set_font(loc_font("main"))
			
			for (var j = 0; j < SAVE_SLOTS; ++j) {
				if save_chs[i]!=-1 && save_chs[i][j]!=-1 && save_chs[i][j][1] {
					draw_sprite_ext(spr_ui_chs_star, 0,
						185, 20 + 12*j + i*60 + yadd,
						1, 1, 0, c_white, alpha
					)
				}
			}
			
			if confirming && i+1==selection {
				draw_set_color(c_white)
				
				if confirmselection == 0 {
					draw_sprite_ext(spr_ui_soul, 0, 
						264-16-12 - (loc_getlang()=="ja" ? 16 : 0), 24 + i*60 + yadd,
						2, 2, 0, c_red, alpha
					);
					draw_set_color(c_yellow)
				}
				
				draw_text_transformed(264 - (loc_getlang()=="ja" ? 16 : 0), 24-8+i*60+yadd, loc("chapter_select_play"), 2, 2, 0)
				draw_set_color(c_white)
				
				if confirmselection == 1 { 
					draw_sprite_ext(spr_ui_soul, 0, 
						414 - 16 - 12 + (loc_getlang()=="ja" ? 12 : 0), 24 + i*60 + yadd, 
						2, 2, 0, c_red, alpha
					)
					draw_set_color(c_yellow)
				}
				
				draw_text_transformed(414 + (loc_getlang()=="ja" ? 12 : 0), 24-8+i*60+yadd, loc("chapter_select_donot"), 2, 2, 0)
				draw_set_color(c_yellow)
			}
			else {
				draw_set_halign(fa_center)
				
				var title = !is_struct(chapters[i]) ? "- -" : chapters[i].name
				draw_text_transformed(360, 24-8 + i*60 + yadd, title, 2, 2, 0)
				draw_set_halign(fa_left)
			}
	
			if !is_struct(chapters[i])
				draw_sprite_ext(spr_ui_chs_defafult, 0, 553, 10+i*60+yadd, 2, 2, 0, draw_get_color(), alpha)
			else
				draw_sprite_ext(chapters[i].icon, 0, 553, 10+i*60+yadd, 2, 2, 0, draw_get_color(), alpha)
		}
		
		draw_set_color(c_white)
		draw_set_alpha(alpha)
		draw_set_halign(fa_left)
		
		if languages {
			if selection == total+1 && horselection == 0 {
				draw_set_color(c_yellow)
				draw_sprite_ext(spr_ui_soul, 0, 210 - 30 + horselection, 442, 2, 2, 0, c_red, alpha)
			}
			draw_text_transformed(210, 440-6+yadd, "Quit", 2, 2, 0)
			draw_set_color(c_white)
			
			if selection == total+1 && horselection == 1 {
				draw_set_color(c_yellow)
				draw_sprite_ext(spr_ui_soul, 0, 350-30 + horselection, 442, 2, 2, 0, c_red, alpha)
			}
		
			draw_set_font(font_main_ja)
			draw_text_transformed(350, 440 - 6 + yadd, loc("chapter_select_lanswitch"), 2, 2, 0)
			draw_set_font(loc_font("main"))
		}
		else {
			draw_set_halign(fa_center)
			
			if selection == total+1 && horselection == 0 {
				draw_set_color(c_yellow)
				draw_sprite_ext(spr_ui_soul, 0, 320 - string_width(loc("chapter_select_quit")) - 30, 442, 2, 2, 0, c_red, alpha)
			}
			draw_text_transformed(320, 440-6 + yadd, loc("chapter_select_quit"), 2, 2, 0)
		}
		
		draw_set_alpha(alpha * vtext_alpha)
		draw_set_halign(fa_right)
		draw_set_color(c_white)
		
        var __xoff = 569 - possible_chapters * 10
        var __yoff = 410 + 26
        for (var i = 0; i < possible_chapters; ++i) {
			for (var j = 0; j < SAVE_SLOTS; ++j) {
    			if save_chs[i] != -1 && save_chs[i][j] != -1 && save_chs[i][j][1]
                    draw_sprite_ext(spr_ui_chs_crystal, 0, __xoff + i*20, __yoff + 10*j + yadd, 1, 1, 0, c_white, alpha)
                else
                    draw_sprite_ext(spr_pixel, 0, __xoff + i*20 - 2, __yoff - 1 + j*10 + yadd, 4, 4, 0, c_dkgray, alpha)
    		}
		}
		
  
		draw_set_alpha(1)
		draw_set_color(c_white)
		draw_set_halign(fa_left)
	}
	surface_reset_target()
}

surface_set_target(surf) {
	draw_set_valign(fa_bottom)
	draw_set_font(loc_font("main"))
	draw_set_alpha(vtext_alpha)
	draw_set_color(c_gray)
	
	var t = (string_width(copyright_text) > 0 ? copyright_text+"\n" : "")
	draw_text_transformed(16, 466, $"{t}{gamename} {version_text}", 1, 1, 0)
	
	draw_set_alpha(1)
	draw_set_color(c_white)
	draw_set_valign(fa_top)
}
surface_reset_target()

draw_surface_ext(surf, 
	trans_shrink * 640/3, 0, 
	1 - trans_shrink / 1.5, 1 - trans_shrink / 4,
	0, c_white, 1 - trans_shrink
)