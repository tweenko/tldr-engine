loc_font("main")
if active {
	draw_set_font(loc_font("main"))
	
	var curkey = chr(keyboard_key)
	if keyboard_key == vk_tab
		curkey = ""
	
	var text = $"tab+{curkey}"
	if struct_exists(registred_commands, string_lower(curkey)) {
		text += $"\n{struct_get(struct_get(registred_commands, string_lower(curkey)), "name")}"
	}
	
	draw_set_color(c_black)
	draw_set_alpha(.5)
	draw_rectangle(0, 0, string_width(text), string_height(text), 0)
	draw_set_alpha(1)
	draw_set_color(c_white)
	
	draw_text_transformed(0, 0, text, 1, 1, 0)
	if keyhold > 0 
		draw_rectangle(0, string_height(text), string_width(text) * keyhold, string_height(text) + 4, 0)
}