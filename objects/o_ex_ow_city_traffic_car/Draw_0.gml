var extend = 6

draw_sprite_ext(spr_ex_ow_city_traffic_car_legs, o_world.frames % 100 / 8, 
    x, y + legsgrow * extend,
    image_xscale, image_yscale,
    image_angle, image_blend, image_alpha
)
draw_sprite_ext(sprite_index, image_index,
    x + sine(4, legsgrow/2), y - legsgrow * extend, 
    image_xscale, image_yscale,
    image_angle, image_blend, image_alpha
)