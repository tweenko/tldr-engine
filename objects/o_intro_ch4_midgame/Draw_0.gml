var propBlue = #42D0FF;

if active {
	if !surface_exists(surf) {
		surf = surface_create(sprW, sprH);
	}

	tick += scrollSpeed/15;
	afterimageOffset = sin(2*tick/15 * 2*pi) * scrollSpeed * 6;
	
	surface_set_target(surf);
		draw_clear_alpha(0,0);
		draw_sprite_tiled_ext(spr_depth_loop, 0, 15*tick/2, 15*tick/2, 1, 1, propBlue, 1)
		gpu_set_blendmode(bm_add);
		draw_sprite_tiled_ext(spr_noise_perlin, 0, 15*tick/2, 15*tick/2, 1, 1, propBlue, __wave(0, 0.4, 4, 0))
		gpu_set_blendmode(bm_subtract);
		draw_sprite(spr, 0, 0, 0);
		gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	if drawSurface {
		gpu_set_blendmode(bm_normal);
		draw_set_alpha(0.4);
		draw_surface(surf, x-sprW/2+afterimageOffset, y-sprH/2+afterimageOffset);
		draw_surface(surf, x-sprW/2-afterimageOffset, y-sprH/2-afterimageOffset);
		draw_set_alpha(1);
		
		draw_surface(surf, x-sprW/2, y-sprH/2);
		gpu_set_blendmode(bm_add);
		draw_surface(surf, x-sprW/2, y-sprH/2);
		draw_surface(surf, x-sprW/2, y-sprH/2);
		gpu_set_blendmode(bm_normal);
	}
	else {
		draw_sprite(spr_intro_ch4_prophecy_cracked, 0, x-sprW/2, y-sprH/2);
	}
}
