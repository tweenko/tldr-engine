event_inherited()

timer = 0
surf = -1

s_talking = false
s_drawer = method(self, function(_sprite, _index, _xx, _yy, _xscale, _yscale, _angle, _blend, _alpha) {
    draw_sprite_ext(_sprite, (s_talking ? draw_get_index_looped(,, 4, 0, image_number) : _index), 
        _xx, _yy, 
        _xscale, _yscale, 
        _angle, _blend, _alpha
    )
})