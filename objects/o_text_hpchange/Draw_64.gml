draw_set_font(global.font_numbers_w)
if mode == TEXT_HPCHANGE_MODE.RECRUIT {
	draw_sprite_ext(loc_sprite("damage_recruit"), 0, 
		visual_x - (align == 1 ? sprite_get_width(loc_sprite("damage_recruit")) : 0), visual_y, 
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
		if mode == TEXT_HPCHANGE_MODE.PARTY {
			if draw > 0
				draw_set_color(c_lime)
			else if draw < 0
				draw_set_color(c_white)
		}
		else if mode == TEXT_HPCHANGE_MODE.ENEMY {
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
		if mode == TEXT_HPCHANGE_MODE.PERCENTAGE {
			if draw == "+100%" {
				var spr = __draw_to_sprite(draw, loc_sprite("damage_100"));
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
			var spr = __draw_to_sprite(draw);
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