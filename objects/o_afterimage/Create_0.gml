drawer = function(_sprite, _index, _xx, _yy, _xscale, _yscale, _angle, _blend, _alpha) {
    draw_sprite_ext(_sprite, _index, 
        _xx, _yy, 
        _xscale, _yscale, 
        _angle, _blend, _alpha
    )
}

image_alpha = 0.6

gui = false
decay_speed = 0.05
white = false
blend = bm_normal