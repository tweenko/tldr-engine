function ex_misc_draw_grass(_x, _y, _w, _h, _blend, _alpha) {
    var last_i = floor(_w/20);
    var last_j = floor(_h/20);
    
    for (var i = 0; i < _w/20; i += 1) {
        for (var j = 0; j < _h/20; j += 1) {
            var ww = min(i*20 + 20, _w) % 20;
            var hh = min(j*20 + 20, _h) % 20;
            
            if ww == 0 
                ww = 20;
            if hh == 0 
                hh = 20;
            
            var _sprite = spr_ex_ow_garden_grass_center;
            
            if j == 0
                _sprite = spr_ex_ow_garden_grass_top;
            else if j == last_j
                _sprite = spr_ex_ow_garden_grass_bottom;
            
            if i == 0 && _sprite == spr_ex_ow_garden_grass_center
                _sprite = spr_ex_ow_garden_grass_left;
            if i == 0 && _sprite == spr_ex_ow_garden_grass_top
                _sprite = spr_ex_ow_garden_grass_top_left;
            if i == 0 && _sprite == spr_ex_ow_garden_grass_bottom
                _sprite = spr_ex_ow_garden_grass_bottom_left;
            
            if i == last_i && _sprite == spr_ex_ow_garden_grass_center
                _sprite = spr_ex_ow_garden_grass_right;
            if i == last_i && _sprite == spr_ex_ow_garden_grass_top
                _sprite = spr_ex_ow_garden_grass_top_right;
            if i == last_i && _sprite == spr_ex_ow_garden_grass_bottom
                _sprite = spr_ex_ow_garden_grass_bottom_right;
            
            
            draw_sprite_stretched(_sprite, draw_get_subimg(_sprite) + (_x / 320) + (i * 0.125) + (j * 0.125) + (_y / 320), _x + (20 * i), _y + (20 * j), ww, hh);
        }
    }
}
function ex_misc_draw_grass_lining(_x, _y, _w, _h, _blend, _alpha) {
    for (var i = 0; i < _w/20; i += 1) {
        var ww = min(i*20 + 20, _w) % 20;
        if ww == 0 
            ww = 20;
        
        draw_sprite_ext(spr_ex_ow_garden_grass_lining, draw_get_subimg(spr_ex_ow_garden_grass_lining) + (_x / 320) + (i * 0.125) + (_y / 320), _x + (20 * i), _y - 1, ww/20, 1, 0, _blend, _alpha);
        draw_sprite_ext(spr_ex_ow_garden_grass_lining, draw_get_subimg(spr_ex_ow_garden_grass_lining) + (_x / 320) + (i * 0.125) + (_y / 320), _x + (20 * i), _y, ww/20, 1, 0, _blend, _alpha);
    }
}