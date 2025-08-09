draw_set_font(loc_getfont("main"))
draw_set_color(white)

if bg != -1 {
	if bg == spr_ui_saveselect_door {
		draw_sprite_ext(spr_ui_saveselect_door, 0, 43*2,47*2, 4,4, 0, c_white, (.03 + (sin(o_world.frames/20) * .04)))
		draw_sprite_ext(spr_ui_saveselect_door, 0, 47*2,48*2, 4,4, 0, c_white, (.03 + (sin(o_world.frames/20) * .04)))
		draw_sprite_ext(spr_ui_saveselect_door, 0, 43*2,52*2, 4,4, 0, c_white, (.03 + (sin(o_world.frames/20) * .04)))
		draw_sprite_ext(spr_ui_saveselect_door, 0, 47*2,52*2, 4,4, 0, c_white, (.03 + (sin(o_world.frames/20) * .04)))
		draw_sprite_ext(spr_ui_saveselect_door, 0, 45*2,50*2, 4,4, 0, c_white, .25)
	}
	else if bg == spr_ui_saveselect_fountain {
		var ia = round_p(image_alpha,.02)
		var yy = -ia*80 + 40
		
		for (var i = 240 - 70 + 19; i > 0; i--) {
			var mag = (1 - i/(240-70+19)) * 1.3 * 6 * 2
			var xx = round(sin(i/8 + o_world.frames/35) * mag)
			
			draw_sprite_part_ext(spr_ui_saveselect_fountain, 0, 0, i, 320, 1, xx, i*2+yy-10-30, 2, 2, c_white, ia*.8)
			draw_sprite_part_ext(spr_ui_saveselect_fountain, 0, 0, i, 320, 1, -xx, i*2+yy-10-30, 2, 2, c_white, ia*.8)
		}
		
		draw_sprite_ext(spr_ui_saveselect_fountain_anim, o_world.frames/12, 0, 480-140+yy, 2, 2, 0, c_white, .46*ia)
		draw_sprite_ext(spr_ui_saveselect_fountain_anim, o_world.frames/12+.4, 0, 480-140+yy, 2, 2, 0, c_white, .56*ia)
		draw_sprite_ext(spr_ui_saveselect_fountain_anim, o_world.frames/12+.8, 0, 480-140+yy, 2, 2, 0, c_white, .7*ia)
	}
	else
		draw_sprite_ext(bg, 0, 0, 0, 1, 1, 0, c_white, 1)
}

if display_chapter {
	draw_text_transformed_shadow(16, 8, $"CHAPTER {global.chapter}", 2, 2, 0, 2, shadow)
}

var t = msg
if msg_time > 0 
	t = msg_temp
draw_text_transformed_shadow(80, 60, t, 2, 2, 0, 2, shadow)

for (var i = 0; i < SAVE_SLOTS; ++i) {
	var s = selection
	if state == 2 || state == 21 || state == 22 // copy
		s = subselection
	if state == 3 || state == 31 || state == 32 // erase
		s = subselection
	if state == 4 || state == 41 // ch files
		s = subselection 
	
	var s_hor = selection_hor
	
	var col = white
	if s != i 
		col = dark
	
	if (state == 21 || state == 22) && i == copy_from // copy
		col = yellow
	if state == 32 && i == subselection // erase
		col = c_red
	
	{ // draw the box
		draw_sprite_ext(spr_pixel, 0, 106, 106+i*90, 426, 88, 0, c_black, .5)
	
		draw_sprite_ext(spr_pixel, 0, 106, 106+i*90, outline_thickness, 88, 0, col, 1)
		draw_sprite_ext(spr_pixel, 0, 106, 106+i*90, 428, outline_thickness, 0, col, 1)
		
		if outline_thickness == 4 {
			// recreate the weird visual bug from the bottom right corner
			draw_sprite_ext(spr_pixel, 0, 106+426, 106+i*90, 1, 86, 0, col, 1)
			draw_sprite_ext(spr_pixel, 0, 106, 106+i*90+86, 427, 1, 0, col, 1)
			draw_sprite_ext(spr_pixel, 0, 106+426+2, 106+i*90, 1, 88, 0, col, 1)
			draw_sprite_ext(spr_pixel, 0, 106, 106+i*90+86+2, 429, 1, 0, col, 1)
		}
		else{
			draw_sprite_ext(spr_pixel, 0, 106, 106+i*90, outline_thickness, 88, 0, col, 1)
			draw_sprite_ext(spr_pixel, 0, 106, 106+i*90, 428, outline_thickness, 0, col, 1)
			draw_sprite_ext(spr_pixel, 0, 106+428-outline_thickness, 106+i*90, outline_thickness, 88, 0, col, 1)
			draw_sprite_ext(spr_pixel, 0, 106, 106+i*90+88-outline_thickness, 428, outline_thickness, 0, col, 1)
		}
	}
	
	draw_set_color(col)
	
	if state == 4 || state == 41 { // ch files
		if files_prev[i] != -1 && files_prev[i].COMPLETED {
			draw_text_transformed_shadow(160, 120 + i*90, files_prev[i].NAME, 2, 2, 0, 2, shadow)
		
			if (state != 41) || s != i {
				draw_text_transformed_shadow(160, 154 + i*90, files_prev[i].COMPLETE_ROOM, 2, 2, 0, 2, shadow)
			}
			else {
				draw_set_color(white)
				if s_hor != 0 
					draw_set_color(dark)
				draw_text_transformed_shadow(180, 154 + i*90, "Start", 2, 2, 0, 2, shadow)
			
				draw_set_color(white)
				if s_hor!=1 
					draw_set_color(dark)
				draw_text_transformed_shadow(360, 154 + i*90, "Back", 2, 2, 0, 2, shadow)
			}
			
			draw_set_color(col)
			draw_set_halign(fa_right)
			draw_text_transformed_shadow(470, 120 + i*90, time_format(files_prev[i].COMPLETE_TIME), 2, 2, 0, 2, shadow)
			
			draw_set_halign(fa_left)
		}
		else {
			draw_text_transformed_shadow(160, 120 + i*90, "Completion FILE not found.", 2, 2, 0, 2, shadow)
			draw_text_transformed_shadow(160, 154 + i*90, "[Made on seeing credits.]", 2, 2, 0, 2, shadow)
		}
	}
	else {
		if files[i] != -1 {
			if state == 22 && s == i // copy
				draw_text_transformed_shadow(160, 120 + i*90, "Copy over this file?", 2, 2, 0, 2, shadow)
			else if state == 31 && s == i // erase (stg 1)
				draw_text_transformed_shadow(160, 120 + i*90, "Erase this file?", 2, 2, 0, 2, shadow)
			else if state == 32 && s == i { // erase (stg 2)
				draw_set_color(c_red)
				draw_text_transformed_shadow(160, 120 + i*90, "Really erase it?", 2, 2, 0, 2, shadow)
				draw_set_color(col)
			}
			else 
				draw_text_transformed_shadow(160, 120 + i*90, files[i].NAME, 2, 2, 0, 2, shadow)
		
			if (state != 1 && state != 22 && state != 31 && state != 32) || s != i {
				draw_text_transformed_shadow(160, 154 + i*90, files[i].ROOM_NAME, 2, 2, 0, 2, shadow)
			}
			else {
				if state == 22 { // copy
					draw_set_color(white)
					if s_hor != 0 
						draw_set_color(dark)
					
					draw_text_transformed_shadow(180, 154 + i*90, "Yes", 2, 2, 0, 2, shadow)
			
					draw_set_color(white)
					if s_hor != 1 
						draw_set_color(dark)
					draw_text_transformed_shadow(360, 154 + i*90, "No", 2, 2, 0, 2, shadow)
				}
				else if state == 31 { // erase (stg 1)
					draw_set_color(white)
					if s_hor != 0 
						draw_set_color(dark)
					draw_text_transformed_shadow(180, 154 + i*90, "Yes", 2, 2, 0, 2, shadow)
			
					draw_set_color(white)
					if s_hor != 1 
						draw_set_color(dark)
					draw_text_transformed_shadow(360, 154 + i*90, "No", 2, 2, 0, 2, shadow)
				}
				else if state == 32 { // erase (stg 2)
					draw_set_color(white)
					if s_hor != 0 
						draw_set_color(dark)
					draw_text_transformed_shadow(180, 154 + i*90, "Yes!", 2, 2, 0, 2, shadow)
			
					draw_set_color(white)
					if s_hor != 1 
						draw_set_color(dark)
					draw_text_transformed_shadow(360, 154 + i*90, "No!", 2, 2, 0, 2, shadow)
				}
				else {
					draw_set_color(white)
					if s_hor!=0 
						draw_set_color(dark)
					draw_text_transformed_shadow(180, 154 + i*90, "Continue", 2,2,0,2, shadow)
			
					draw_set_color(white)
					if s_hor!=1 
						draw_set_color(dark)
					draw_text_transformed_shadow(360, 154 + i*90, "Back", 2,2,0,2, shadow)
				}
			}
			draw_set_color(col)
		
			if (state != 22 && state != 31 && state != 32) || s != i {
				draw_set_halign(fa_right)
				draw_text_transformed_shadow(470, 120 + i*90, time_format(files[i].TIME), 2, 2, 0, 2, shadow)
				draw_set_halign(fa_left)
			}
		}
		else {
			draw_text_transformed_shadow(160, 120 + i*90, "[EMPTY]", 2, 2, 0, 2, shadow)
		
			if (state != 1 && state != 22) || s != i {
				draw_text_transformed_shadow(160, 154 + i*90, "------------", 2, 2, 0, 2, shadow)
			}
			else {
				if state == 22 {
					draw_set_color(white)
					if s_hor != 0 
						draw_set_color(dark)
					draw_text_transformed_shadow(180, 154 + i*90, "Yes", 2, 2, 0, 2, shadow)
			
					draw_set_color(white)
					if s_hor != 1 
						draw_set_color(dark)
					draw_text_transformed_shadow(360, 154 + i*90, "No", 2, 2, 0, 2, shadow)
				}
				else {
					draw_set_color(white)
					if s_hor != 0 
						draw_set_color(dark)
					draw_text_transformed_shadow(180, 154 + i*90, "Start", 2,2,0,2, shadow)
			
					draw_set_color(white)
					if s_hor != 1 
						draw_set_color(dark)
					draw_text_transformed_shadow(360, 154 + i*90, "Back", 2,2,0,2, shadow)
				}
			}
		
			draw_set_color(col)
		
			draw_set_halign(fa_right)
			draw_text_transformed_shadow(470, 120 + i*90, "--:--", 2,2,0,2, shadow)
			draw_set_halign(fa_left)
		}
	}
	
	draw_set_color(c_white)
}

if state < 2 { // main
	option_draw(108, 380, "Copy", SAVE_SLOTS)
	option_draw(280, 380, "Erase", SAVE_SLOTS+1)
	option_draw(408, 380, "Chapter Select", SAVE_SLOTS+2)
	if ch_file 
		option_draw(108, 420, $"Ch {global.chapter-1} Files", SAVE_SLOTS+3)
	if language 
		option_draw(280, 420, $"lang", SAVE_SLOTS+4)
	option_draw(408, 420, "End Program", SAVE_SLOTS+5)
}
else if state == 2 || state == 21 || state == 22 { //copy
	option_draw(108, 380,"Cancel", SAVE_SLOTS, subselection)
}
else if state == 3 || state == 31 || state == 32 { //erase
	option_draw(108, 380,"Cancel", SAVE_SLOTS, subselection)
}
else if state == 4 || state == 41 { //erase
	option_draw(108, 380, string("Don't Use Chapter {0} FILE", global.chapter - 1), SAVE_SLOTS, subselection)
}

draw_set_color(c_white)
draw_sprite_ext(spr_ui_soul, 0, soulx, souly, 2, 2, 0, c_red, 1)