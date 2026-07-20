__intro_seq = method(self, function() {
	// variables
x = 160;
y = 120;
image_speed = 0;
image_index = 0;

heartAlpha = 0;

//cutscene
	
	cutscene_create();
	
	cutscene_sleep(30);
	cutscene_set_variable(id, "image_index", 1);
	cutscene_audio_play(snd_noise, false, 1, random_range(0.8, 1.2));
	cutscene_sleep(7);
	cutscene_set_variable(id, "image_index", 2);
	cutscene_audio_play(snd_noise, false, 1, random_range(0.8, 1.2));
	cutscene_sleep(7);
	cutscene_set_variable(id, "image_index", 3);
	cutscene_audio_play(snd_noise, false, 1, random_range(0.8, 1.2));
	cutscene_sleep(7);
	cutscene_set_variable(id, "image_index", 4);
	cutscene_audio_play(snd_noise, false, 1, random_range(0.8, 1.2));
	cutscene_sleep(7);
	cutscene_set_variable(id, "image_index", 5);
	cutscene_audio_play(snd_noise, false, 1, random_range(0.8, 1.2));
	cutscene_sleep(45);
	
	cutscene_audio_play(snd_splat);
	cutscene_audio_play(snd_mercyadd);
	repeat(8) {
		cutscene_instance_create(o_eff_magicstar, id.x + random_range(-30, 30), id.y + random_range(-15, 15), id.depth - 10, {image_blend: c_white})
	}
	cutscene_animate(0, 1, 30, anime_curve.linear, id, "heartAlpha");
	cutscene_sleep(60);
	
	cutscene_func(fader_fade, [0, 1, 30]);
	cutscene_sleep(50);
	cutscene_func(room_goto, target_room);
	
	cutscene_play();
})