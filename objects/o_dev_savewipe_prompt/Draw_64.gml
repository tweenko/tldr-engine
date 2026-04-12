draw_sprite_ext(spr_pixel, 0, 0, 0, GAME_W_GUI, GAME_H_GUI, 0, c_black, .9)

var __coeff = clamp(timer/20, 0, 1)
var __c = anime_curve_lerp(30, 0, __coeff, anime_curve.cubic_out)
var __center_x = GAME_W_GUI/2
var __center_y = GAME_H_GUI/2

draw_set_font(loc_font("main"))
draw_set_alpha(__coeff * alpha)

draw_set_halign(fa_center)
draw_set_color(c_aqua)
draw_text_transformed(__center_x, __center_y - 120 + __c, "WARNING!", 2, 2, 0)

draw_set_color(c_white)
draw_text_transformed(__center_x, __center_y - 80 + __c, message, 1, 1, 0)

draw_set_color(c_aqua)
draw_text_transformed(__center_x, __center_y + 10 + __c, "Would you like to clear your SAVE DATA?\n(It will be impossible to recover)", 1, 1, 0)

draw_set_color(c_white)
if selection == 0
    draw_set_color(c_yellow)
draw_text_highlighted("Yes", __center_x - 50, __center_y + 60 + __c, (selection == 0), 1, 1)

draw_set_color(c_white)
if selection == 1
    draw_set_color(c_yellow)
draw_text_highlighted("No", __center_x + 60, __center_y + 60 + __c, (selection == 1), 1, 1)

draw_set_color(c_gray)
draw_text_transformed(__center_x, __center_y + 160 + __c, $"Local Save Version: {struct_get(global.settings, "VERSION_SAVED") ?? "???"}\nEngine Version: {GAME_VERSION}\nLast Compatible Version: {GAME_LAST_COMPATIBLE_VERSION}", 1, 1, 0)

draw_set_color(c_white)
draw_set_halign(fa_left)
draw_set_alpha(1)