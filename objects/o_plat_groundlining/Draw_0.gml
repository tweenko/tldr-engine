if maker == noone 
    exit;

var blend = merge_color(maker.image_blend, maker.blend_while_plat, global.platforming_perspective);
image_xscale = (sprite_get_width(maker.sprite_index)*maker.image_xscale) / sprite_get_width(sprite_index);
x = maker.x;
y = maker.y;

if sprite_index != spr_plat_default_lining_mask 
    draw_sprite_ext(sprite_index, draw_get_subimg(sprite_index), maker.x, maker.y, image_xscale, 1, 0, blend, maker.image_alpha*global.platforming_perspective);