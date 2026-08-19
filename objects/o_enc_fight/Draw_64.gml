for (var i = 0; i < array_length(fighting); ++i) {
	var yy = ui_fightbar_height * party_get_index(fighting[i])
	
	// fight bar
	
	
	
	draw_sprite_stretched_ext(spr_pixel, 0, ui_fightarea_x, ui_fightarea_y + yy, ui_fightbar_width, ui_fightbar_height, merge_color(party_getdata(fighting[i], "darkcolor"), c_white, lightup), image_alpha)
	draw_sprite_stretched_ext(spr_pixel, 0, ui_fightarea_x + 2, ui_fightarea_y + yy+2, ui_fightbar_width-4, ui_fightbar_height-4, c_black, image_alpha)
	
	//crit zone
	draw_sprite_stretched_ext(spr_pixel, 0, ui_crit_x, ui_fightarea_y + yy, ui_crit_widths[i], ui_fightbar_height, party_getdata(fighting[i], "color"), image_alpha)
	draw_sprite_stretched_ext(spr_pixel, 0, ui_crit_x + 2, ui_fightarea_y + yy+2, ui_crit_widths[i]-4, ui_fightbar_height-4, c_black, image_alpha)
	
	draw_set_color(c_white)
	draw_sprite_ext(loc_sprite("enc_fight_press_spr"), 0, 46, 371 + yy, 1, 1, 0, c_white, image_alpha)
	draw_sprite_ext(party_get_icon(fighting[i]), 0, 8, 375 + yy, 1, 1, 0, c_white, image_alpha)
}