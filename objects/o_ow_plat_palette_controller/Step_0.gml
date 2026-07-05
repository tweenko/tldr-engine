var dx = global.platforming_perspective - perspective_prev;

if dx != 0 {
    if !surface_exists(surf_pal)
        surf_pal = surface_create(2, sprite_get_height(palette_sprite));
    
    surface_set_target(surf_pal);
        draw_sprite_part_ext(palette_sprite, 0, 0, 0, 1, sprite_get_height(palette_sprite), 0, 0, 1, 1, c_white, 1);
    
        draw_sprite_part_ext(palette_sprite, 0, 0, 0, 1, sprite_get_height(palette_sprite), 1, 0, 1, 1, c_white, 1);
        draw_sprite_part_ext(palette_sprite, 0, palette_index, 0, 1, sprite_get_height(palette_sprite), 1, 0, 1, 1, c_white, global.platforming_perspective);
    surface_reset_target();
    
    pal_swap_layer_init();
    
    for (var i = 0; i < array_length(layers_to_swap); i ++) {
        pal_swap_enable_layer(layers_to_swap[i]);
        pal_swap_set_layer(surf_pal, 1, layers_to_swap[i], true);
    }
    
    pal_swap_reset();
}
else {
    if !surface_exists(surf_pal) { // make sure we never run into not having a surface to use
        surf_pal = surface_create(2, sprite_get_height(palette_sprite));
        surface_set_target(surf_pal);
            draw_sprite_part_ext(palette_sprite, 0, 0, 0, 1, sprite_get_height(palette_sprite), 0, 0, 1, 1, c_white, 1);
        
            draw_sprite_part_ext(palette_sprite, 0, 0, 0, 1, sprite_get_height(palette_sprite), 1, 0, 1, 1, c_white, 1);
            draw_sprite_part_ext(palette_sprite, 0, palette_index, 0, 1, sprite_get_height(palette_sprite), 1, 0, 1, 1, c_white, global.platforming_perspective);
        surface_reset_target();
    }
}

perspective_prev = global.platforming_perspective;