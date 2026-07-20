__intro_seq = function() {
	active = false;
	
	texBubble = sprite_get_texture(spr_bubl, 0);
	texGradient = sprite_get_texture(spr_shoujogradient, 0);
	texStars = sprite_get_texture(spr_stars_2, 0);
	
	uTime = shader_get_uniform(shd_shoujo, "time");
	uAppSurfWidth = shader_get_uniform(shd_shoujo, "appSurfWidth");
	uTexGradient = shader_get_sampler_index(shd_shoujo, "texGradient");
	uTexBubble = shader_get_sampler_index(shd_shoujo, "texBubble");
	uTexStars = shader_get_sampler_index(shd_shoujo, "texStars");
	
	
}
