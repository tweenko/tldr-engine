if !surface_exists(bullet_surf)
    bullet_surf = surface_create(320 + bullet_surf_safe*2, 240 + bullet_surf_safe*2)

surface_set_target(bullet_surf) 
    draw_clear_alpha(0,0)
    drawer(mask_index, 1, 
        x - guipos_x() + bullet_surf_safe, y - guipos_y() + bullet_surf_safe, 
        width * temp_scale, height * temp_scale, 
        image_angle + temp_angle, c_black, 1
    )
surface_reset_target()