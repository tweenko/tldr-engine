draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, .75)

draw_set_font(loc_font("main"))

for (var i = 0; i < array_length(encounters); i++) {
	var enc_name = enc_names[i]
	if selection == i {
		draw_sprite_ext(spr_ui_soul, 0, 10, 10 * (1 + (i * 2)) + 5, 1, 1, 0, c_red, 1)
	}
	
	var col = c_white
	draw_text_scale($"{enc_name}", 25, 10 * (1 + (i * 2)), 1, col, 1)
}