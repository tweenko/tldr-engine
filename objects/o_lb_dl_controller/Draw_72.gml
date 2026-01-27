if !surface_exists(surf_light)
    surf_light = surface_create(640, 480)

surface_set_target(surf_light)
    draw_clear_alpha(0,0)
surface_reset_target()