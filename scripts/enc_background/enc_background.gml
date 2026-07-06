function enc_background() constructor {
    bg_clear_color = c_black;
    bg_clear_alpha = 1;
    
    bg_surf = -1;
    bg_surf_create = function() { return surface_create(640, 480); }
    
    bg_draw_content = function() {
        surface_set_target(bg_surf);
            draw_clear_alpha(0, 0);
            
    		var siner = o_world.frames / 2;
    		var siner2 = o_world.frames;
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -50 + siner, -50 + siner, 1, 1, merge_color(c_black, #420042, 0.5), 1);
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -100 - siner2, -105 - siner2, 1, 1, #420042, 1);
        surface_reset_target();
    }
    bg_draw = function(_alpha) {
        if !surface_exists(bg_surf)
            bg_surf = bg_surf_create();
        
        // clear color
        draw_set_color(bg_clear_color);
        draw_set_alpha(_alpha * bg_clear_alpha);
        
        draw_rectangle(guipos_x(), guipos_y(), 640, 480, false);
        
        draw_set_color(c_white);
        draw_set_alpha(1);
        
        bg_draw_content();
		draw_surface_stretched_ext(bg_surf, guipos_x(), guipos_y(), 320, 240, c_white, _alpha);
    }
}
function enc_background_black() : enc_background() constructor {
    bg_draw_content = function() {}; // remove all draw content
}
function enc_background_none() : enc_background() constructor {
    bg_draw_content = function() {}; // remove all draw content
    bg_clear_alpha = 0;
}

function enc_bulletdark() constructor {
    bulletdark_clear_color = c_black;
    bulletdark_clear_alpha = 0.75;
    
    bulletdark_surf = -1;
    bulletdark_surf_create = function() { return surface_create(640, 480); }
    
    bulletdark_draw_content = function() {};
    bulletdark_draw = function(_alpha) {
        if !surface_exists(bulletdark_surf)
            bulletdark_surf = bulletdark_surf_create();
        
        // clear color
        draw_set_color(bulletdark_clear_color);
        draw_set_alpha(_alpha * bulletdark_clear_alpha);
        
        draw_rectangle(guipos_x(), guipos_y(), 640, 480, false);
        
        draw_set_color(c_white);
        draw_set_alpha(1);
        
        bulletdark_draw_content();
		draw_surface_stretched_ext(bulletdark_surf, guipos_x(), guipos_y(), 320, 240, c_white, _alpha);
    }
}
function enc_bulletdark_none() : enc_bulletdark() constructor {
	bulletdark_clear_alpha = 0;
}
function enc_bulletdark_fullalpha() : enc_bulletdark() constructor {
	bulletdark_clear_alpha = 1;
}