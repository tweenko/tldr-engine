draw_sprite_ext(spr_ui_soul_blur, 0, soulx_display, souly_display, 2, 2, 0, c_white, .5)

draw_set_font(loc_font("main"))
for (var i = 0; i < array_length(keyboard); i ++) {
    var __cur_xoff = 0
    for (var j = 0; j < array_length(keyboard[i]); j ++) {
        if selection[0] == i && selection[1] == j
            draw_set_color(c_yellow)
        
        draw_text_transformed(keyboard_origin_x + __cur_xoff, keyboard_origin_y + i*40, keyboard[i][j], 2, 2, 0)
        __cur_xoff += string_width(keyboard[i][j])*2 + keyboard_spacing
        
        draw_set_color(c_white)
    }
}


draw_sprite_ext(naming_ref, 0, 0, 0, 1, 1, 0, c_white, .2)