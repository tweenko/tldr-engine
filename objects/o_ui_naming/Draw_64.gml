draw_sprite_ext(spr_ui_soul_blur, 0, soulx_display, souly_display, 2, 2, 0, c_white, .5*keyboard_alpha)

draw_set_alpha(keyboard_alpha)
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
draw_set_alpha(1)

// ------------------- CONFIRM --------------------

var __name_scale = lerp(2, 4, name_trans)

draw_set_halign(fa_center)
draw_text_transformed(320, lerp(85, 185, name_trans), name, __name_scale, __name_scale, name_angle)


draw_set_alpha(confirm_alpha)
draw_sprite_ext(spr_ui_soul_blur, 0, confirm_soulx_display, 378, 2, 2, 0, c_white, .5*confirm_alpha)

if confirm_selection == 0
    draw_set_colour(c_yellow)
draw_text_transformed(232, 360, loc("naming_menu_no"), 2, 2, 0)

draw_set_colour(c_white)
if confirm_selection == 1
    draw_set_colour(c_yellow)
draw_text_transformed(400, 360, loc("naming_menu_yes"), 2, 2, 0)

draw_set_colour(c_white)
draw_set_alpha(1)

draw_set_halign(fa_left)