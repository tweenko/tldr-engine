// -- Backgrounds --
function enc_background() { // Default background
	bg_clear_color = c_black;
	bg_clear_alpha = 1;
	bg_arrayvars = [];
	bg_draw = function(){
		draw_clear(c_black);
		var siner = o_world.frames / 2;
		var siner2 = o_world.frames;
		draw_sprite_tiled_ext(spr_enc_bg, 0, round_p((-50 + siner), .25), round_p((-50 + siner), .25), 1, 1, merge_color(c_black, #420042, 0.5), 1);
		draw_sprite_tiled_ext(spr_enc_bg, 0, round_p((-100 - siner2), .25), round_p((-105 - siner2), .25), 1, 1, #420042, 1);
	}
	bg_surface_draw = function(){
		draw_surface_stretched_ext(bg_surface, o_camera.x, o_camera.y, 320, 240, image_blend, image_alpha);
	}
}

// -- Bulletdarks --
function enc_bulletdark() { // Default bulletdark
	bg_bulletdark_clear_color = c_black;
	bg_bulletdark_clear_alpha = 0.6;
	bg_bulletdark_arrayvars = [];
	bg_bulletdark_draw = function() {}
	bg_bulletdark_surface_draw = function(){
		draw_surface_stretched_ext(bg_bulletdark_surface, o_camera.x, o_camera.y, 320, 240, image_blend, image_alpha * (fade * 1.333334));
	}
}


