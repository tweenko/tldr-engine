draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, .75)
draw_set_font(loc_getfont("main"))

for (var i = 0; i <= room_last; i++) {
	var room_name = room_get_name(i)
	if selection == i {
		selected_room = i
		draw_sprite_ext(spr_ui_soul, 0, 10, 10 * (1 + (i * 2)) + 5, 1, 1, 0, c_red, 1)
	}
	
	var col = c_white
	if array_contains(inaccessible, i) 
		col = c_gray
	
	draw_text_scale($"{room_name}", 25, 10 * (1 + (i * 2)), 1, col, 1)
}