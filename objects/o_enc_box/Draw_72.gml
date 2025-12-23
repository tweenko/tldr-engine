if !surface_exists(bullet_surf)
    bullet_surf = surface_create(640 + bullet_surf_safe*2, 480 + bullet_surf_safe*2)

surface_set_target(bullet_surf) 
    draw_clear_alpha(0,0)
    drawer(mask_index, 1,
        (x - guipos_x() + bullet_surf_safe) * 2, 
        (y - guipos_y() + bullet_surf_safe) * 2, 
        width * temp_scale * 2, height * temp_scale * 2, 
        image_angle + temp_angle, c_white, 1
    )
surface_reset_target()