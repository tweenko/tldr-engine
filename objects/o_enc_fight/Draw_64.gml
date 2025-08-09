for (var i = 0; i < array_length(fighting); ++i) {
	var yy = 38 * array_get_index(global.party_names, fighting[i])
	
	draw_sprite_stretched_ext(spr_pixel, 0, 79, 365 + yy, 125, 38, merge_color(party_getdata(fighting[i], "darkcolor"), c_white, lightup), image_alpha)
	draw_sprite_stretched_ext(spr_pixel, 0, 79 + 2, 365 + yy+2, 125-4, 38-4, c_black, image_alpha)
	draw_sprite_stretched_ext(spr_pixel, 0, 82, 365 + yy, 10, 38, party_getdata(fighting[i], "color"), image_alpha)
	draw_sprite_stretched_ext(spr_pixel, 0, 82 + 2, 365 + yy+2, 10-4, 38-4, c_black, image_alpha)
	
	draw_set_color(c_white)
	draw_sprite_ext(spr_ui_enc_press, 0, 46, 371 + yy, 1, 1, 0, c_white, image_alpha)
	draw_sprite_ext(party_geticon(fighting[i]), 0, 8, 375 + yy, 1, 1, 0, c_white, image_alpha)
}