if yellow {
	sprite_index = spr_ex_ow_city_signcat_yellow
	draw_set_color(0xFF5ADA)
    
	draw_rectangle(x, y, (x + 39), (y + 39), false)
	if (dontdraw == false)
	    draw_sprite_part_parallax_scale(sprite_index, (siner / 8), (siner / 8), (siner / 8), 0.3, 1.5,,,25,25)
	if (dontdraw == false)
	    draw_sprite_part_parallax(sprite_index, (siner / 8), (siner / 3), (siner / 6), 1)
	draw_set_color(c_white)
}
else {
	draw_set_color(c_yellow)
	draw_rectangle(x, y, (x + 39), (y + 39), false)
	if (dontdraw == false)
	    draw_sprite_part_parallax_scale(sprite_index, (siner / 8), (siner / 8), (siner / 8), 0.3, 1.5,,,25,25)
	if (dontdraw == false)
	    draw_sprite_part_parallax(sprite_index, (siner / 8), (siner / 3), (siner / 6), 1)
	draw_set_color(c_white)
}