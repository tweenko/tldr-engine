if active {
	if !surface_exists(staticSurf)
		staticSurf = surface_create(sprite_get_width(spr_intro_ch2_logo), sprite_get_height(spr_intro_ch2_logo))
	
	staticSprIndex += staticAnimSpd; 
	
	draw_sprite(spr_intro_ch2_logo, logoSprIndex, x, y+logoYOffset);
	
	surface_set_target(staticSurf);
		draw_clear_alpha(0, 0);
		draw_sprite_tiled(spr_noise_static, staticSprIndex, 0, 0);
		gpu_set_blendmode(bm_subtract);
		draw_sprite_tiled(spr_intro_ch3_logo_mask, staticMaskSprIndex, 0, 0);
		gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	if drawStatic
		draw_surface(staticSurf, x - surface_get_width(staticSurf)/2, y - surface_get_height(staticSurf)/2 + logoYOffset);
	
	if drawChText
		draw_sprite(spr_intro_chapter_number, 3, x, y + chYOffset);
}