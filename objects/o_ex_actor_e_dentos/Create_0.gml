event_inherited();

s_drawer = function(_sprite, _index, _xx, _yy, _xscale, _yscale, _angle, _blend, _alpha) {
    draw_sprite_ext(_sprite, _index, 
        _xx + sine(5, 1), _yy + round(cosine(3, 1, o_world.frames + 12.2)), 
        _xscale, _yscale, 
        _angle, _blend, _alpha
    )
}