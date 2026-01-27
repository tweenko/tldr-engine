event_inherited()
s_drawer = function(_sprite, _index, _xx, _yy, _xscale, _yscale, _angle, _blend, _alpha) {
    draw_sprite_ext(_sprite, _index, 
        _xx + siner_xoff, _yy + siner_yoff, 
        _xscale, _yscale, 
        _angle, _blend, _alpha
    )
}

siner_xoff = 0
siner_yoff = 0