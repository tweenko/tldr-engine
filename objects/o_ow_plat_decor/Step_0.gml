image_blend = merge_colour(image_blend_start, image_blend_plat, global.platforming_perspective);

if global.platforming_perspective > .5 {
    if sprite_exists(sprite_index_plat)
        sprite_index = sprite_index_plat;
    visible = visible_plat;
    depth = depth_plat;
}
else {
    if sprite_exists(sprite_index_start)
        sprite_index = sprite_index_start;
    visible = visible_start;
    depth = depth_start;
}