function ex_border_castle() : border() constructor {
    _name = "Castle"
    _sprite = spr_ex_border_castle
}
function ex_border_city() : border() constructor {
    _name = "City"
    _sprite = spr_ex_border_city
}
function ex_border_church() : border() constructor {
    _name = "Church"
    _sprite = spr_ex_border_church
}

global.border_titan_glow = false
function ex_border_titan() : border() constructor {
    _name = "Titan"
    
    _eyes_glow = 0
    _eyes_anim = undefined
    _step = method(self, function() {
        if global.border_titan_glow {
            anime_stop(_eyes_anim)
            
            _eyes_anim = animate(_eyes_glow, 1, 5, anime_curve.linear, self, "_eyes_glow")
            _eyes_anim._add(0, 30, anime_curve.linear)
        }
        global.border_titan_glow = false
    })
    _drawer = method(self, function(_width, _height, _alpha) {
        var blend = gpu_get_blendmode()
        
        draw_sprite_stretched_ext(spr_ex_border_titan, 0, 0, 0, _width, _height, c_white, _alpha)
        
        draw_sprite_stretched_ext(spr_ex_border_titan_eyes, 0, 0, 0, _width, _height, c_white, sine(40, .4) + .5)
        draw_sprite_stretched_ext(spr_ex_border_titan_eyes, 1, 0, 0, _width, _height, c_white, _eyes_glow * _alpha)
    })
}