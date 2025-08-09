draw_set_color(c_white)
draw_set_alpha(1)

surface_set_target(surface_board) {
	draw_pixel(0, 0, width, height, c_white, 1);
	
	gpu_set_blendmode(bm_subtract);
	draw_pixel(2, 2, width-4, height-4, c_black,1 );
	gpu_set_blendmode(bm_normal);
} 
surface_reset_target();

if is_sprite == true {
	sprite = sprite_create_from_surface(surface_board, 0, 0, width, height, false, false, width/2, height/2);
	is_sprite = false;
}

if sprite != -1 {
	var xpos = x - (width-1) * temp_scale / 2
	var ypos = y - (height-1) * temp_scale / 2
	
	gpu_set_blendmode(bm_normal)
	draw_pixel_center(x, y, (width-1) * temp_scale * 2, (height-1) * temp_scale * 2, c_black, 1, temp_angle);
	
	draw_surface_part(bullet_surf, xpos, ypos, (width-1) * temp_scale, (height-1) * temp_scale, xpos, ypos)
	draw_sprite_ext(sprite, 0, x, y, temp_scale, temp_scale, temp_angle, color, 1);
	
	var fflash = flash
	if instance_exists(o_enc.mysoul)
		if flash != 0 
			with o_enc.mysoul
				outline = fflash
	
	rem_scale[trans_frame] = temp_scale;
	rem_angle[trans_frame] = temp_angle;
	rem_alpha[trans_frame] = 0.75;
	
	for(var i=0; i<15; i++) {
		if rem_alpha[i] > 0
			rem_alpha[i] -= 0.1;
		draw_sprite_ext(sprite, 0, x, y, rem_scale[i], rem_scale[i], rem_angle[i], color, rem_alpha[i]);
	}
	
	if is_transitioning
		trans_frame++;
}