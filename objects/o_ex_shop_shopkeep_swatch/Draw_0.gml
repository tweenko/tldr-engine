if !surface_exists(surf)
    surf = surface_create(640, 240)

surface_set_target(surf)

draw_sprite_ext(spr_ex_shop_cafe_background, 0, 0, 0, 2, 2, 0, c_white, 1)
draw_sprite_tiled_ext(spr_ex_shop_cafe_guys, 0, -timer * 3, sine(30, 2), 2, 2, c_white, 1)
draw_sprite_ext(spr_ex_shop_cafe_curtains, 0, 0, 0, 2, 2, 0, c_white, 1)

surface_reset_target()

draw_surface_ext(surf, 0, 0, .5, .5, 0, c_white, 1)

s_drawer(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)