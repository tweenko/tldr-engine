if white
	gpu_set_fog(true, c_white, 0, 0)

gpu_set_blendmode(blend)
drawer(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
gpu_set_blendmode(bm_normal)

if white
	gpu_set_fog(false, c_white, 0, 0)