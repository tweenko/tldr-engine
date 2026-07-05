if !visible 
    exit
if sprite_index == spr_block 
    exit

// (0.8+global.platforming_perspective*0.2)
// clamp(global.platforming_perspective*4, 0, 1)

// Stuff
if global.platforming_perspective == 1 
    floorbackclamping = increment_towards(floorbackclamping, 2, 0.5);
else
    floorbackclamping = increment_towards(floorbackclamping, lerp(floor_tilesback_amount, 2, clamp(-0.7 + global.platforming_perspective, 0, 1)), 1);

var floor_width = sprite_get_width(sprite_index) * image_xscale;
var pers = (1 - global.platforming_perspective);
var blend = merge_color(image_blend, blend_while_plat, global.platforming_perspective);

// start plat palette
with o_ow_plat_palette_controller start();
    
// Draw wall
matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, 0, 1, 1, 1));
draw_sprite_ext(sprite_index, image_index, 0, 0, image_xscale, image_yscale, 0, blend, image_alpha*plathidden);

// Draw floor
if floor_tilesback_amount > 0 {
	matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, 0, 1, clamp(1*pers, 0, 1), 1));
    if !is_undefined(floor_drawer) && is_callable(floor_drawer) {
        var floor_height = (floorbackclamping*tile_height);
        floor_drawer(0, -floor_height, floor_width, floor_height, blend, image_alpha*plathidden);
    }
    else if sprite_exists(floor_sprite) {
        var floor_height = (floorbackclamping*tile_height) + sprite_get_yoffset(floor_sprite);
	   draw_sprite_stretched_ext(floor_sprite, draw_get_subimg(floor_sprite), 0, -floor_height, floor_width, floor_height, blend, image_alpha*plathidden);
    }
}

// Reset
matrix_reset();

var shadow_blend = merge_colour(blend, c_black, pers);
if sprite_exists(floor_sprite)
    draw_sprite_stretched_ext(floor_sprite, draw_get_subimg(floor_sprite), x, y - 4, floor_width, 8, shadow_blend, image_alpha*plathidden * global.platforming_perspective);

// end plat palette
with o_ow_plat_palette_controller stop();