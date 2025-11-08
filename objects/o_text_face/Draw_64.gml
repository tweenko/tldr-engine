var spr = f_sprite
var img = f_index

draw_sprite_ext(spr, img, 
    x + 26 * image_xscale, y + (instance_exists(o_enc) ? 26 : 30) * image_yscale, 
    image_xscale, image_xscale, 
    0, c_white, image_alpha
)