var w = 200

draw_sprite_ext(spr_pixel, 0, 320-w/2 + 21, 293, w * timer/timermax, 12, 0, c_aqua, uialpha)
draw_sprite_ext(spr_ui_timer_on, 1, 320-w/2 - 13, 280, 2, 2, 0, c_white, uialpha)


var s_x = x
var s_y = y

x -= guipos_x(); y -= guipos_y()
x *= 2; y *= 2

draw_sprite_ext(sprite_index, 0, x, y, 1, 1, (1-uialpha) * 10, c_white, uialpha / 4)
draw_sprite_ext(sprite_index, 0, x, y, .66, .66, (1-uialpha) * -10, c_white, uialpha / 2)
draw_sprite_ext(sprite_index, 0, x, y, .33, .33, 0, c_white, uialpha)

x = s_x
y = s_y

draw_set_font(loc_font("main"))
draw_set_color(c_yellow)
draw_text_transformed(290, 10, "AMMO", 2, 2, 0)
draw_set_halign(fa_right)
draw_text_transformed(330, 42, $"{ammo} x", 2, 2, 0)
draw_set_halign(fa_left)
draw_set_color(c_white)

draw_sprite_ext(spr_soul, 0, 346, 62, 1, 1, 0, c_red, 1)