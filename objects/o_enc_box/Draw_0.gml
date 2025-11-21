if !sprite_exists(trans_sprite) {
    if !surface_exists(trans_surf) 
        trans_surf = surface_create(width, height)
    
    surface_set_target(trans_surf)
        draw_clear_alpha(0,0)
        drawer(sprite_index, image_index, width/2, height/2, width, height, image_angle, c_white, image_alpha)
    surface_reset_target()
    
    trans_sprite = sprite_create_from_surface(trans_surf, 0, 0, width, height, false, false, width/2 , height/2)
}

if is_transitioning
    drawer(trans_sprite, image_index, x - 1/2, y - 1/2, sprite_w * temp_scale, sprite_h * temp_scale, temp_angle, c_white, image_alpha)
else 
    drawer(sprite_index, image_index, x, y, width * temp_scale, height * temp_scale, image_angle + temp_angle, c_white, image_alpha)