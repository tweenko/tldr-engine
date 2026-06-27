var vert_xpos = 320 - 26;
if !modern_choicer {
    // determine the widest choice on the vertical axis
    var longest = 0;
    for (var i = 2; i < array_length(choices); ++i) {
    	var a = string_width(variable_callable_to_value(choices[i].text))*2;
    	if a > longest
    		longest = a;
    }
    vert_xpos = 320 - longest/2 - 32;
}

draw_set_font(loc_font("main"))
if array_length(choices) > 0
    choices[0]._draw(x + 60, y + box_height/2 - 28, 0, self);
if array_length(choices) > 1
    choices[1]._draw(x + 550, y + box_height/2 - 28, 1, self, fa_right);
if array_length(choices) > 2
    choices[2]._draw(x + vert_xpos, y + 26/151 * box_height - 10, 2, self, (modern_choicer ? fa_center : fa_left));
if array_length(choices) > 3
    choices[3]._draw(x + vert_xpos, y + 112/151 * box_height - 10, 3, self, (modern_choicer ? fa_center : fa_left));

draw_sprite_ext(spr_ui_soul, 0, soul_x, soul_y, 2, 2, 0, c_red, 1);