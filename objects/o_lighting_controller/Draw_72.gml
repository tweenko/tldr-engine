if !surface_exists(surf)
    surf = surface_create(640 + surf_border*2, 480 + surf_border*2)

surface_set_target(surf)
    draw_clear_alpha(0, 0)
surface_reset_target()