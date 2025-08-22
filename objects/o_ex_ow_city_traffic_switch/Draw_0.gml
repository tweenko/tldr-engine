var xx = sine(1,shake)
x += xx

image_index = (active && label != "walk" ? 1 : 0)

draw_self()


//draw the screen
var col = c_gray
if label == "stop" && active 
    col = c_red
if label == "walk" && active 
    col = c_lime

//draw the top screen content
draw_set_color(col)
draw_set_font(global.font_numbers_w)
draw_text_transformed(x - 4, y - sprite_yoffset+7, $"{(active ? timer_sec : time)}", .5, .5, 0)
draw_set_color(c_white)

//draw the bottom screen content
draw_sprite_ext(asset_get_index($"spr_ex_ow_city_traffic_switch_{label}"), 0, x, y, image_xscale, image_yscale, image_angle, col, image_alpha)

x -= xx
dodge_darken_self()