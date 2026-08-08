if active {
	draw_sprite_ext(logoSprGlow, 0, x, y, .5, .5, 0, c_white, logoAlphaDEL);
	draw_sprite_ext(logoSprGlow, 1, x, y, .5, .5, 0, c_white, logoAlphaTA);
	draw_sprite_ext(logoSprGlow, 2, x, y, .5, .5, 0, c_white, logoAlphaRUNE);

	shader_set(shd);
		shader_set_uniform_f(uTime, t);
		shader_set_uniform_f(uAppSurfWidth, surface_get_width(application_surface));	
		texture_set_stage(uTexGradient, texGradient);
		texture_set_stage(uTexBubble, texBubble);
		texture_set_stage(uTexStars, texStars);
		draw_sprite_ext(logoSpr, 0, x, y, 1, 1, 0, c_white, logoAlphaAll);
	shader_reset();
	
	draw_sprite_ext(logoHeart, 1, x, y, 1, 1, 0, c_white, logoAlphaAll);
	
	for (var i = 0; i < array_length(sparkles); i ++) {
		var _sp = sparkles[i];
		method_call(_sp.__step);
		
		draw_sprite_ext(_sp.spr, _sp.image_index, _sp.x/2, _sp.y/2, _sp.x_scale/2, _sp.y_scale/2, _sp.angle, c_white, _sp.alpha);
	}
	t += dt;
}