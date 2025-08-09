if !surface_exists(surface_board)
    surface_board = surface_create(width, height);

if !surface_exists(bullet_surf)
    bullet_surf = surface_create(room_width, room_height);
surface_set_target(bullet_surf) 
    draw_clear_alpha(0, 0)

surface_reset_target();