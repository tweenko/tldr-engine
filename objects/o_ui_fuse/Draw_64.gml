draw_set_font(loc_font("main"))

if !confirmation {
	draw_set_color(c_black)
	draw_rectangle(0, 0, 640, 120, 0)
	draw_set_color(c_white)

	var txt = "---"
	if is_struct(items[selection]) && is_struct(items[selection].result)
		txt = item_get_desc(items[selection].result, ITEM_DESC_TYPE.FULL)
	
	draw_text_ext_transformed(20, 20, txt, 16, 300, 2, 2, 0)
}

draw_rectangle(30, 130, 610, 406, 0)
draw_set_color(c_black)
draw_rectangle(34, 134, 606, 402, 0)
draw_set_color(c_white)

draw_text_transformed(114, 140, "Result", 2, 2, 0)
draw_text_transformed(330, 140, "Ingredients", 2, 2, 0)

for (var i = 0; i < array_length(items); ++i) {
	if i >= floor(selection/2) * 2 && i < floor(selection/2) * 2 + 2 {
		draw_set_color(c_white)
		
		draw_rectangle(90, 179 + 100*(i - floor(selection/2)*2), 550, 181 + 100 * (i-floor(selection/2) * 2), 0)
		
		if exists[i].result {
			if selection == i 
				draw_set_color(c_yellow)
			else 
				draw_set_color(c_white)
		}
		else 
			draw_set_color(c_gray)
			
		draw_text_transformed(110, 190 + 100*  (i-floor(selection/2) * 2), item_get_name(items[i].result), 2, 2, 0)
		
		draw_set_color(c_white)
		for (var j = 0; j < array_length(items[i].ingredients); ++j) {
			if exists[i].ingredients[j]
				draw_set_color(c_white)
			else 
				draw_set_color(c_gray)
			
			draw_text_transformed(330, 190 + 40*j + 100 * (i-floor(selection/2) * 2), item_get_name(items[i].ingredients[j]), 2, 2, 0)
			draw_set_color(c_white)
		}
	}
}

if array_length(items) > 2 && !confirmation {
	draw_sprite_ext(spr_ui_arrow_flat, 0, 32 + round(sine(5,2)), 268, -2, 2, 0, c_white, 1)
	draw_sprite_ext(spr_ui_arrow_flat, 0, 610 - round(sine(5,2)), 268, 2, 2, 0, c_white, 1)
}

draw_set_color(c_white)
draw_set_halign(fa_right)

draw_text_transformed(588, 354, $"Page {floor(selection/2) + 1} / {floor((array_length(items) - 1) / 2) * 2}", 1, 2, 0)

draw_set_halign(fa_left)

if confirmation {
	draw_set_color(c_black)
	draw_rectangle(0, 375, 640, 480, 0)
	draw_set_color(c_white)
	draw_rectangle(0, 375, 640, 378, 0)
	draw_text_transformed(60, 400, "Really fuse it?", 2, 2, 0)
	
	if c_selection==0 {
		draw_set_color(c_yellow)
	}
	draw_text_transformed(380, 400, "Yes", 2, 2, 0)
	draw_set_color(c_white)
	
	if c_selection == 1 {
		draw_set_color(c_yellow)
	}
	draw_text_transformed(480, 400, "No", 2, 2, 0)
	draw_set_color(c_white)
}
draw_sprite_ext(spr_uisoul, 0, soulx, souly + 8, 1, 1, 0, c_red, 1)