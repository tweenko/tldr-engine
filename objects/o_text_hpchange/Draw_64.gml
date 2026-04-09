draw_set_font(global.font_numbers_w)
if mode == 3 {
	draw_sprite_ext(loc_sprite("enc_ui_spr_recruit"), 0, 
		visual_x - (align == 1 ? sprite_get_width(loc_sprite("enc_ui_spr_recruit")) : 0), visual_y, 
		2 - stretch, stretch * image_yscale, 
		0, c_white, image_alpha
	)
	draw_set_color(c_white)
	draw_set_font(global.font_numbers_g)
	draw_set_alpha(image_alpha)
	draw_set_halign(fa_center)
	
    if string_split(draw, "/")[0] != string_split(draw, "/")[1]
	   draw_text_transformed(visual_x + xoff, visual_y + 35, draw, 1, image_yscale, 0)
	
	draw_set_halign(fa_left)
	draw_set_alpha(1)
}
else {
	if is_real(draw) {
		if mode == 0 {
			if draw > 0
				draw_set_color(c_lime)
			else if draw < 0
				draw_set_color(c_white)
		}
		else if mode == 1{
			if draw > 0
				draw_set_color(c_lime)
			if draw < 0
				draw_set_color(merge_color(c_white, party_getdata(user, "color"), .5))
		}
		
		draw_set_alpha(image_alpha)
	    if align == 1 
			draw_set_halign(fa_right)
		
	    draw_text_transformed(visual_x + xoff, visual_y, abs(draw), 2 - stretch, stretch * image_yscale, 0)
		
	    draw_set_halign(fa_left)
		draw_set_alpha(1)
	}
	else {
		if mode == 2 {
			if draw == "+100%" {
				var spr = spr_ui_damage_100
				draw_sprite_ext(spr, 0, 
					visual_x - (align == 1 ? sprite_get_width(spr) : 0) + xoff, visual_y, 
					2 - stretch, stretch * image_yscale, 
					0, c_white, image_alpha
				)
			}
			else {
				draw_set_font(global.font_numbers_g)
				draw_set_color(c_white)
				draw_set_alpha(image_alpha)
			    if align == 1 
					draw_set_halign(fa_right)
				
			    draw_text_transformed(visual_x + xoff, visual_y, draw, 2-stretch, stretch * image_yscale, 0)
				
			    draw_set_halign(fa_left)
				draw_set_alpha(1)
			}
		}
		else {
			var spr = spr_ui_damage_miss
            
            if sprite_exists(asset_get_index(string(loc("enc_ui_spr_damage"), draw)))
                spr = asset_get_index(string(loc("enc_ui_spr_damage"), draw))
			
			draw_sprite_ext(spr, 0,
				visual_x - (align == 1 ? sprite_get_width(spr) : 0) + xoff, visual_y, 
				2 - stretch, stretch * image_yscale, 
				0, c_white, image_alpha
			)
		}
	}
}

if image_alpha <= 0 
	instance_destroy()