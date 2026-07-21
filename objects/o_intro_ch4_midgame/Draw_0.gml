var propBlue = #42D0FF;

if active {
	if !surface_exists(surf) {
		surf = surface_create(sprW, sprH);
	}
	
	afterimageOffset = dsin(2*o_world.frames) * 6; 
	depthOff += depthOffSpd;
	depthOff = depthOff mod sprite_get_width(spr_depth_legend);
	
	surface_set_target(surf);
		draw_clear_alpha(0,0);
		draw_sprite_looped(depthOff, -.5, spr_depth_loop, 0, 0, 0,,,, propBlue, 1)
		gpu_set_blendmode(bm_subtract);
		draw_sprite(spr, 0, 0, 0);
		gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	if drawSurface {
		//draw_set_alpha(0.33);
		//draw_surface(surf, x-sprW/2+afterimageOffset, y-sprH/2+afterimageOffset);
		//draw_surface(surf, x-sprW/2-afterimageOffset, y-sprH/2-afterimageOffset);
		//draw_set_alpha(1);
		gpu_set_blendmode(bm_add);
		draw_surface(surf, x-sprW/2, y-sprH/2);
		draw_surface(surf, x-sprW/2, y-sprH/2);
		draw_surface(surf, x-sprW/2, y-sprH/2);
		gpu_set_blendmode(bm_normal);
	}
}
