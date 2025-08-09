for (var i = 0; i < image_xscale; i++){
    for (var j = 0; j < image_yscale; j++){
        draw_sprite_ext(sprite_index, image_index, x + i*40, y + j*40, 1, 1, 0, c_white, sin(i+j + siner/8)*0.5 + 0.5)
	}
}