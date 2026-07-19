loc_font("main")
if active {
	draw_set_font(loc_font("main"))
	
    var target_command = command_find(held_keys);
	
	var text = $"tab+"
    for (var i = 0; i < array_length(held_keys); i ++) {
        text += chr(held_keys[i]);
        if i < array_length(held_keys) - 1
            text += "+";
    }
    
	if !is_undefined(target_command) {
		text += $"\n{target_command.name}"
	}
	
	draw_set_color(c_black)
	draw_set_alpha(.5)
	draw_rectangle(0, 0, string_width(text), string_height(text), 0)
	draw_set_alpha(1)
	draw_set_color(c_white)
	
	draw_text_transformed(0, 0, text, 1, 1, 0)
	if keyhold > 0 
		draw_rectangle(0, string_height(text), string_width(text) * keyhold/keyhold_max, string_height(text) + 4, 0)
}