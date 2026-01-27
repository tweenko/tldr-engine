if timer == 0
    draw_self()

var _xx = sine(1, shake)

if timer >= 1 {
    for (var i = 0; i <= xs; i += 1) {
        for (var j = 0; j <= ys; j += 1)
            draw_sprite_part_ext(sprite_index, image_index, 
				bl[i][j], bh[i][j], chunk_size, chunk_size, 
				bx[i][j] - sprite_xoffset + _xx, (y + j * chunk_size * image_yscale) - sprite_yoffset, 
				image_xscale, image_yscale, 
				image_blend, (1 - bspeed[i][j] / 12)
			)
    }
    if bspeed[0][ys] >= 12
        instance_destroy()
}