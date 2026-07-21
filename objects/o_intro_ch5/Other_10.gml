__intro_seq = function() {
	active = false;
	
	t = 0;
	dt = 0;
	
	x=160;
	y=120;
	
	// shader prep
	shd = shd_shoujo;
	
	texBubble = sprite_get_texture(spr_bubl, 0);
	texGradient = sprite_get_texture(spr_shoujogradient, 0);
	texStars = sprite_get_texture(spr_stars_2, 0);
	
	uTime = shader_get_uniform(shd, "time");
	uAppSurfWidth = shader_get_uniform(shd, "appSurfWidth");
	uTexGradient = shader_get_sampler_index(shd, "texGradient");
	uTexBubble = shader_get_sampler_index(shd, "texBubble");
	uTexStars = shader_get_sampler_index(shd, "texStars");
	
	//variables
	logoSprGlow = spr_logo_sep_glow;
	logoSpr = spr_intro_logo_emptyheart;
	logoHeart = spr_intro_logo;
	
	logoAlphaDEL = 0;
	logoAlphaTA = 0;
	logoAlphaRUNE = 0;
	logoAlphaAll = 0;
	logoAlphaHeart = 0;
	
	enableSparkleStep = false;
	
	introSnd = mus_intro_ch5;
	
	_sparkle = function(_img_index, _x, _y, _xscale=1, _yscale=1, _angle=0, _alpha=1) constructor {
		spr = spr_bigshoujosparkle;
		image_index = _img_index;
		
		x = _x;
		y = _y;
		
		speed = 0;
		direction = point_direction(160, 120, x/2, y/2);
		
		x_scale = _xscale;
		y_scale = _yscale;
		
		angle = _angle;
		alpha_base = 0;
		alpha = 0;
		
		fade_speed = random(0.5);
		fade_offset = random(30);
		
		__wave = function(_a0, _a1, _a2, _a3) {
			return (_a0 + _a1)/2 + (_a1 - _a0)/2 * sin(2*pi * (o_world.frames/30 + _a2*_a3)/_a2);
		}
		
		__step = method(self, function(_caller=o_intro_ch5) {
			if _caller.enableSparkleStep {
				
				alpha_base = _caller.logoAlphaAll;
				speed = alpha_base/8;
				
				alpha = alpha_base * __wave(0.2, 1, 1+fade_speed, fade_offset);
				
				x += lengthdir_x(speed, direction);
				y += lengthdir_y(speed, direction);
			}
		})
	}
	
	sparkles = [
		new _sparkle(1, 125, 212),
		new _sparkle(0, 103, 283),
		new _sparkle(1, 189, 283),
		new _sparkle(0, 237, 217),
		new _sparkle(0, 308, 283),
		new _sparkle(1, 350, 230),
		new _sparkle(0, 431, 258),
		new _sparkle(0, 512, 224),
		new _sparkle(1, 548, 294),
	];
	

	// cutscene
	cutscene_create();
		cutscene_sleep(1);
		cutscene_set_variable(id, "active", true);
		cutscene_audio_play(mus_intro_ch5);
		cutscene_animate(0, 1, 5, anime_curve.quad_out, self, "logoAlphaDEL");
		cutscene_sleep(20);
		cutscene_animate(0, 1, 5, anime_curve.quad_out, self, "logoAlphaTA");
		cutscene_sleep(20);
		cutscene_animate(0, 1, 5, anime_curve.quad_out, self, "logoAlphaRUNE");
		cutscene_sleep(21);
		cutscene_set_variable(id, "enableSparkleStep", true);
		cutscene_animate(1, 0, 25, anime_curve.quad_out, self, "logoAlphaDEL");
		cutscene_animate(1, 0, 25, anime_curve.quad_out, self, "logoAlphaTA");
		cutscene_animate(1, 0, 25, anime_curve.quad_out, self, "logoAlphaRUNE");
		cutscene_animate(0, 1, 25, anime_curve.quad_out, self, "logoAlphaAll");
		cutscene_animate(0.035, 0, 120, anime_curve.quad_out, self, "dt");
		cutscene_sleep(120);
		cutscene_func(fader_fade, [0, 1, 90, DEPTH_UI.CONSOLE]);
		cutscene_sleep(105);
		cutscene_func(room_goto, target_room);
	cutscene_play();
}
