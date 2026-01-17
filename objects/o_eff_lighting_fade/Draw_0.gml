var mode = o_eff_lighting_controller.fade_mode
var tint = o_eff_lighting_controller.fade_color

if is_array(mode)
    gpu_set_blendmode_ext(mode[0], mode[1])
else 
    gpu_set_blendmode(mode)

draw_set_color(merge_color(c_white, tint, image_alpha))
draw_rectangle(0, 0, room_width, room_height, false)
draw_set_color(c_white)

gpu_set_blendmode(bm_normal)