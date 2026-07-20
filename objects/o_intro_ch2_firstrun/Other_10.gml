__intro_seq = function() {
	active = false;
	
	sprite_index = spr_intro_logo_ch2_firstrun;
	image_index = 0;
	image_speed = 0;
		
	x = 160;
	y = 120;
	logoYOff = -10;
	chYOff = 15;
	
	showChapter = false;
	
	cutscene_create();
	cutscene_sleep(15);
	cutscene_set_variable(self, "active", true);
	cutscene_audio_play(snd_noise, false, 0.8, random_range(0.5, 1.5));
	
	repeat(8) {
		cutscene_sleep(8);
		cutscene_func(method(id, function(){image_index++}));
		cutscene_audio_play(snd_noise, false, 0.8, random_range(0.5, 1.5));
	}
	
	cutscene_sleep(48);
	cutscene_set_variable(self, "showChapter", true);
	cutscene_audio_play(snd_queen_laugh_title);
	
	cutscene_sleep(120);	
	cutscene_set_variable(self, "active", false);
	cutscene_sleep(30);
	
	cutscene_func(room_goto, target_room);
	
	cutscene_play();
}