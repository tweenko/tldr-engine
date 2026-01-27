if timer == 0 {
    var truew = sprite_get_width(sprite_index)
    var trueh = sprite_get_width(sprite_index)
	
    if truew >= 25 || trueh >= 25
        chunk_size = 8
    if truew >= 50 || truew >= 50
        chunk_size = 16
	
	xs = ceil(truew / chunk_size)
	ys = ceil(trueh / chunk_size)
	
    for (var i = 0; i <= xs; i += 1) {
        for (var j = 0; j <= ys; j += 1) {
            bl[i][j] = i * chunk_size
            bh[i][j] = j * chunk_size
            bx[i][j] = x + i * chunk_size * image_xscale
            bspeed[i][j] = 0
            bsin[i][j] = 4 + j * 3 - i
        }
    }
}

if timer >= 3 {
    if redup < 10
        redup += 1
		
    image_blend = merge_color(c_white, c_red, (redup / 10))
    for (var i = 0; i <= xs; i += 1){
        for (var j = 0; j <= ys; j += 1){
            if (bsin[i][j] <= 0)
                bspeed[i][j] += .5
			
            bx[i][j] += bspeed[i][j]
            bsin[i][j] --
        }
    }
}

timer ++
if shake > 0
	shake --