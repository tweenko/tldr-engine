draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, .75)
draw_set_font(loc_font("main"))

for (var i = 0; i < array_length(item_list); i++) {
	var i_name = item_name(item_list[i], i)
	if selection == i 
		draw_sprite_ext(spr_ui_soul, 0, 10, 10 * (1 + (i * 2)) + 5 - scroll, 1, 1, 0, c_red, 1)
	
	var col = c_white
	if array_contains(item_blocked, i) 
		col = c_gray
	
	draw_text_scale($"{i_name}", 25, 10 * (1 + (i * 2)) - scroll, 1, col, 1)
}