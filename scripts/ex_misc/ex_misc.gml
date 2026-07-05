function ex_misc_draw_grass(_x, _y, _w, _h, _blend, _alpha){
    for (var i = 0; i < _w/20; i += 1) {
        for (var j = 0; j < _h/20; j += 1) {
            var ww = 20 - min(i * 20, _w) % 20;
            var hh = 20 - min(j * 20, _h) % 20;
            
            draw_sprite_stretched(spr_ch5_ow_m_grass, draw_get_subimg(spr_ch5_ow_m_grass) + (_x / 320) + (i * 0.125) + (j * 0.125) + (_y / 320), _x + (20 * i), _y + (20 * j), ww, hh);
        }
    }
    
    draw_sprite_stretched_ext(spr_ch5_ow_m_grass_mask, 0, _x, _y, _w, _h, c_black, 1);
}