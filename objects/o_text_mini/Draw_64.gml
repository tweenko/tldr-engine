draw_set_font(loc_font("main"))
draw_set_alpha(image_alpha)

draw_text_transformed(x + 58 * xscale + 10, y, text, xscale, yscale, image_angle)

draw_set_alpha(1)