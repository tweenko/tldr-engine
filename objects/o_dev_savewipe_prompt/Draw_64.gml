draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, .9)

var __coeff = clamp(timer/20, 0, 1)
var __c = lerp_type(30, 0, __coeff, "cubic_out")

draw_set_font(loc_font("main"))
draw_set_alpha(__coeff * alpha)

draw_set_halign(fa_center)
draw_set_color(c_aqua)
draw_text_transformed(320, 120 + __c, "WARNING!", 2, 2, 0)

draw_set_color(c_white)
draw_text_transformed(320, 160 + __c, "You are about to clear your SAVE DATA.\nIf you'd like that, please proceed.\nThe game will be closed if you select yes.", 1, 1, 0)

draw_set_color(c_aqua)
draw_text_transformed(320, 250 + __c, "Would you like to clear your SAVE DATA?\n(It will be impossible to recover)", 1, 1, 0)

draw_sprite_ext(spr_ui_soul, 0, soulx, 303 + __c, 1, 1, 0, c_red, alpha)

draw_set_color(c_white)
if selection == 0
    draw_set_color(c_yellow)
draw_text_transformed(320 - 50, 300 + __c, "Yes", 1, 1, 0)

draw_set_color(c_white)
if selection == 1
    draw_set_color(c_yellow)
draw_text_transformed(320 + 60, 300 + __c, "No", 1, 1, 0)

draw_set_color(c_gray)
draw_text_transformed(320, 400 + __c, $"Local Save Version: {(struct_exists(global.settings, "VERSION_SAVED") ? global.settings.VERSION_SAVED : "???")}\nEngine Version: {ENGINE_VERSION}\nLast Compatible Version: {ENGINE_LAST_COMPATIBLE_VERSION}", 1, 1, 0)

draw_set_color(c_white)
draw_set_halign(fa_left)
draw_set_alpha(1)