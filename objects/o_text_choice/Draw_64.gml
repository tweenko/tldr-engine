if !on 
	exit

draw_set_font(loc_font("main"))

if array_length(choices) > 0 {
	if selection == 0 {
		draw_set_color(c_yellow)
		draw_sprite_ext(spr_ui_soul, 0, x + 60 - 32, y + 58, 2, 2, 0, c_red, 1)
	}
	draw_text_transformed(x + 60, y + 48, choices[0], 2, 2, 0)
}
draw_set_color(c_white)

if array_length(choices) > 1 {
	if selection == 1 {
		draw_set_color(c_yellow)
		draw_sprite_ext(spr_ui_soul, 0, x + 550 - string_width(choices[1])*2 - 32, y + 58, 2, 2, 0, c_red, 1)
	}
	
	draw_set_halign(fa_right)
	draw_text_transformed(x + 550, y + 48, choices[1], 2, 2, 0)
	draw_set_halign(fa_left)
}
draw_set_color(c_white)

if array_length(choices) > 2 {
	if selection == 2 {
		draw_set_color(c_yellow)
		draw_sprite_ext(spr_ui_soul, 0, x + xx - 32, y + 26, 2, 2, 0, c_red, 1)
	}
	draw_text_transformed(x + xx, y + 16, choices[2], 2, 2, 0)
}
draw_set_color(c_white)

if array_length(choices) > 3 {
	if selection == 3 {
		draw_set_color(c_yellow)
		draw_sprite_ext(spr_ui_soul, 0, x + xx - 32, y + 112, 2, 2, 0, c_red, 1)
	}
	draw_text_transformed(x + xx, y + 102, choices[3], 2, 2, 0)
}
draw_set_color(c_white)

if selection == -1 
	draw_sprite_ext(spr_ui_soul, 0, x + 320 - 10 - array_length(choices[1])*2 - 32, y + 58, 2, 2, 0, c_red, 1)