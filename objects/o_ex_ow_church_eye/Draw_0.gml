draw_self()

// copy pasted from deltarune
gpu_set_blendmode(bm_add)

var xoff = lengthdir_x(1, siner)
var yoff = lengthdir_y(1, siner)
var dist = 4 * image_xscale
var scale = 0.05 * image_xscale

for (var i = 0; i < 3; i += 1)
    draw_sprite_ext(sprite_index, image_index, 
        x + (xoff * i * dist), y + yoff + (i * dist), 
        image_xscale + (scale * i), image_yscale + (scale * i), 
        0, c_white, (0.4 + sine(10, .4) - 0.1*i) * image_alpha
    )

gpu_set_blendmode(bm_normal)