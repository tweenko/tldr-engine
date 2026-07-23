var propBlue = #42D0FF;
if active {
	if !surface_exists(surf) {
		surf = surface_create(sprW, sprH);
	}
	
	tick += scrollSpeed/15;
	afterimageOffset = sin(tick/15 * 2*pi) * scrollSpeed * 3;
	
	surface_set_target(surf);
		draw_clear_alpha(0,0);
		draw_sprite_tiled_ext(spr_depth_loop, 0, 15*tick/2, 15*tick/2, 1, 1, propBlue, 1)
		gpu_set_blendmode(bm_add);
		draw_sprite_tiled_ext(spr_noise_perlin, 0, 15*tick/2, 15*tick/2, 1, 1, propBlue, __wave(0, 0.4, 4, 0))
		gpu_set_blendmode(bm_subtract);
		draw_sprite(sprLogo, 2, sprW/2, sprH/2);
		gpu_set_blendmode(bm_normal);
	surface_reset_target();

	if !cracked {
		draw_surface_ext(surf, x-sprW/2+afterimageOffset, y-sprH/2+afterimageOffset,1,1,0,c_white, surfaceAlpha*0.4);
		draw_surface_ext(surf, x-sprW/2-afterimageOffset, y-sprH/2-afterimageOffset,1,1,0,c_white, surfaceAlpha*0.4);
		
		draw_sprite_ext(sprLogo, 0, x, y+logoYOffset, 1, 1, 0, c_white, logoAlpha);
		
		draw_set_alpha(surfaceAlpha);
		draw_surface(surf, x-sprW/2, y-sprH/2);
		gpu_set_blendmode(bm_add);
		draw_surface(surf, x-sprW/2, y-sprH/2);
		draw_surface(surf, x-sprW/2, y-sprH/2);
		gpu_set_blendmode(bm_normal);
		draw_set_alpha(1);
		
		draw_sprite_ext(spr_intro_chapter_number, 4, x, y+chYOffset, .5, .5, 0, c_white, chTextAlpha);
	}
	else {
		draw_sprite_ext(spr_intro_ch4_logo_cracked, 0, x, y+logoYOffset, 1, 1, 0, c_white, logoAlpha);	
	}
	
	draw_sprite_ext(sprLogo, 1, x, y+logoYOffset, 1, 1, 0, c_white, heartAlpha);
}