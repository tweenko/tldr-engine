if active {
	var propBlue = #42D0FF;
	
	draw_set_alpha(picAlpha*propAlpha);
	draw_sprite_part(pic, picIndex, -picXOff, -picYOff, picW, picH, picX, picY);
	draw_set_alpha(1);
	
	if sprite_exists(ov) {
		draw_set_alpha(ovAlpha);
		draw_sprite_part(ov, ovIndex, 0, -ovYOff, sprite_get_width(ov), ovH, ovX, ovY);
		draw_set_alpha(1);
	}
	
	if global.chapter >= 4 {
		
		if !surface_exists(propSurf) {
			propSurf = surface_create(picW, picH);
		}
		
		surface_set_target(propSurf);
	
			draw_sprite_looped_xy(propOffset, -propOffset, 1, spr_depth_loop, 0, -picX, -picY, 1, 1, 0, propBlue, 1);
			draw_set_alpha(0.2/3);
			draw_rectangle(0,0,picW,picH, false);
			
			gpu_set_blendmode(bm_subtract);
			
			draw_set_alpha(1 - picAlpha*(1-propAlpha));
			draw_sprite_part(pic, 1, -picXOff, -picYOff, picW, picH, 0, 0);
			draw_set_alpha(1);
			
			gpu_set_blendmode(bm_normal);
		
		surface_reset_target();
		
		draw_surface(propSurf, picX, picY);
		gpu_set_blendmode(bm_add);
		draw_surface(propSurf, picX, picY);
		draw_surface(propSurf, picX, picY);
		gpu_set_blendmode(bm_normal);
	}
	
	draw_sprite_ext(spr_pixel, 0, 0, 0, GAME_W, GAME_H, 0, c_white, fadeWhiteAlpha);
	
	
	if !skipped && InputCheck(INPUT_VERB.SELECT) {
		skipped = true;
		
		cutscene_stop();
		
		cutscene_create();
		cutscene_func(fader_fade, [0, 1, 30, DEPTH_UI.CONSOLE]);
		cutscene_func(music_fade, [0, 0, 30]);
		cutscene_sleep(40);
		
		cutscene_func(room_goto, [room_logo]);
		cutscene_play();
	}
}