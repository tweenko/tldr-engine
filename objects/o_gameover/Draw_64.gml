draw_set_font(loc_font("main"))

if state == 0 { //still show the freezeframe
	draw_sprite_ext(freezeframe, 0, 0, 0, 1, 1, 0, c_white, 1)
	draw_sprite_ext(freezeframe_gui, 0, 0, 0, 1, 1, 0, c_white, 1)
}
if state == 1{
	draw_sprite_ext(sprite_index, 0, x*2, y*2, 1, 1, image_angle, image_blend, 1)
}
if state >= 2{
	draw_sprite_ext(spr_ui_gameover, 0, 0, 40, 2, 2, image_angle, c_white, image_alpha)
}
if state >= 4{
	draw_sprite_ext(spr_ui_soul_blur, 0, soulx, souly, 2, 2, 0, c_white, ui_alpha/2)
	
	draw_set_alpha(ui_alpha)
	
	if selection == 0 draw_set_color(c_yellow)
	draw_text_transformed(160, 360, choice[0], 2, 2, 0)
	draw_set_color(c_white)
	
	if selection == 1 draw_set_color(c_yellow)
	draw_text_transformed(380, 360, choice[1], 2, 2, 0)
	draw_set_color(c_white)
	
	draw_set_alpha(1)
}

draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_white, fader_alpha)