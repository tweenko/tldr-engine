// -- Backgrounds --
function ex_enc_background_none() { // Example: No background
	enc_background()//Inherit
	bg_clear_alpha = 0;
	bg_draw = function(){}
}
function ex_enc_background_black() { // Example: Black background
	enc_background()//Inherit
	bg_draw = function(){draw_clear(c_black)}
}
function ex_enc_background_colorable_grid(_color = #420042, _sprite = spr_enc_bg, _scalex=1, _scaley=1) { // Example: Colorable grid using _color var
	enc_background()//Inherit
	bg_arrayvars = [_color, _sprite, _scalex, _scaley];
	bg_draw = function(){
		draw_clear(c_black)
		var siner = o_world.frames / 2;
		var siner2 = o_world.frames;
		draw_sprite_tiled_ext(bg_arrayvars[1], 0, round_p((-50 + siner), .25), round_p((-50 + siner), .25), bg_arrayvars[2], bg_arrayvars[3], merge_color(c_black, bg_arrayvars[0], 0.5), 1);
		draw_sprite_tiled_ext(bg_arrayvars[1], 0, round_p((-100 - siner2), .25), round_p((-105 - siner2), .25), bg_arrayvars[2], bg_arrayvars[3], bg_arrayvars[0], 1);
	}
}

// -- Bulletdarks --
function ex_enc_bulletdark_none() { // Example: No bullet darkness
	enc_bulletdark()//Inherit
	bg_bulletdark_clear_alpha = 0;
}
function ex_enc_bulletdark_fullalpha() { // Example: Full alpha bullet darkness
	enc_bulletdark()//Inherit
	bg_bulletdark_clear_alpha = 1;
}
function ex_enc_bulletdark_drawtiled(_sprite = spr_bkris_nurse, _color = c_white, _alpha = 0.8) { // Example: Draw tiled
	enc_bulletdark()//Inherit
	bg_bulletdark_clear_alpha = _alpha;
	bg_bulletdark_arrayvars = [_color, _sprite];
	bg_bulletdark_draw = function(){
		var siner = o_world.frames / 2;
		var siner2 = o_world.frames;
		draw_sprite_tiled_ext(bg_bulletdark_arrayvars[1], 0, round_p((-50 + siner), .25), round_p((-50 + siner), .25), 1, 1, merge_color(c_black, bg_bulletdark_arrayvars[0], 0.5), 1);
		draw_sprite_tiled_ext(bg_bulletdark_arrayvars[1], 0, round_p((-100 - siner2), .25), round_p((-105 - siner2), .25), 1, 1, bg_bulletdark_arrayvars[0], 1);
	}
}
