var _scale = round_p(image_xscale * scale, .1)

draw_sprite_ext(sprite_index, image_index, 
    x, y, _scale, _scale, 
    image_angle, image_blend, image_alpha
)

gpu_set_fog(true, c_white, 0, 1)
draw_sprite_ext(sprite_index, image_index, 
    x, y, _scale, _scale, 
    image_angle, image_blend, glow
)
gpu_set_fog(false, 0, 0, 0)