function ex_enc_background_colorable_grid(_color = #420042, _sprite = spr_enc_bg, _scale_x = .5, _scale_y = .5) : enc_background() constructor {
    color = _color;
    sprite = _sprite;
    scale_x = _scale_x;
    scale_y = _scale_y;
    
	bg_draw_content = function() {
        surface_set_target(bg_surf);
            draw_clear_alpha(0, 0);
            
    		var siner = o_world.frames / 2;
    		var siner2 = o_world.frames;
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -50 + siner, -50 + siner, 1, 1, merge_color(c_black, color, 0.5), 1);
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -100 - siner2, -105 - siner2, 1, 1, color, 1);
        surface_reset_target();
	}
}
function ex_enc_background_spawnlings() : enc_background() constructor {
    color = merge_colour(c_red, c_black, 160/255);
    
	bg_draw_content = function() {
        surface_set_target(bg_surf);
            draw_clear_alpha(0, 0);
            
    		var siner = o_world.frames / 2;
    		var siner2 = o_world.frames;
            
            draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, color, 1);
            
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -50 + siner + sine(16, 10, o_world.frames + 16), -50 + siner + cosine(16, 10, o_world.frames + 16), 1, 1, color, 1);
    		draw_sprite_tiled_ext(spr_ex_enc_bg_spawnlings, 0, -100 - siner2 + sine(20, 12), -105 - siner2 + cosine(20, 12), 1, 1, color, .5);
        
            draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, .7);
        
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -60 + siner + sine(16, 40, o_world.frames + 8), -60 + siner + cosine(16, 40, o_world.frames + 8), 1, 1, color, .75);
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -50 + siner + sine(16, 20, o_world.frames + 16), -50 + siner + cosine(16, 20, o_world.frames + 16), 1, 1, color, 1);
        surface_reset_target();
	}
}

function ex_enc_bulletdark_drawtiled(_sprite = spr_default_alt_4, _color = c_white, _alpha, _clear_alpha = 0.8) : enc_bulletdark() constructor {
	bg_bulletdark_clear_alpha = _clear_alpha;
    
    sprite = _sprite;
    color = _color;
    alpha = _alpha;
    
	bulletdark_draw_content = function() {
		var siner = o_world.frames / 2;
		var siner2 = o_world.frames;
        
		draw_sprite_tiled_ext(sprite, 0, -50 + siner, -50 + siner, 1, 1, merge_color(c_black, color, 0.5), alpha);
		draw_sprite_tiled_ext(sprite, 0, -100 - siner2, -105 - siner2, 1, 1, color, alpha);
	}
}
