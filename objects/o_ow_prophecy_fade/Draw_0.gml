gpu_set_blendmode_ext(bm_zero, bm_src_color)

draw_set_color(merge_color(c_white, tint, image_alpha))
draw_rectangle(0, 0, room_width, room_height, false)
draw_set_color(c_white)

gpu_set_blendmode(bm_normal)