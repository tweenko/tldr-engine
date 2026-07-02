draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

image_angle -= 90;
draw_sprite_ext(spr_eff_scythemare_z_split, 0, x + z_offset, y, 1.5, 1.5, image_angle, image_blend, z_alpha);
draw_sprite_ext(spr_eff_scythemare_z_split, 0, x + z_offset*2, y, 1.5, 1.5, image_angle, image_blend, z_alpha);
draw_sprite_ext(spr_eff_scythemare_z_split, 1, x - z_offset, y, 1.5, 1.5, image_angle, image_blend, z_alpha);
draw_sprite_ext(spr_eff_scythemare_z_split, 1, x - z_offset*2, y, 1.5, 1.5, image_angle, image_blend, z_alpha);
image_angle += 90;

if slash_image > 0 && slash_image < 3
    draw_sprite_ext(spr_eff_scythemare_slash, slash_image, x, y, 1, .5, 0, image_blend, 1);