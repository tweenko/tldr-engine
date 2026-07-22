// variables
sprite_index = spr_intro_ch3_tv_time
image_speed = 0;
	
x = 160;
y = 120;
	
fadeWhiteAlpha = 0;
tvSound = snd_its_tv_time;
	
// cutscene
cutscene_create();

cutscene_audio_play(tvSound);
cutscene_animate(0, sprite_get_number(spr_intro_ch3_tv_time)-1, 30*audio_sound_length(tvSound), anime_curve.linear, id, "image_index");
cutscene_wait_until(method(id, function(){return !audio_is_playing(tvSound)}));

cutscene_set_variable(id, "sprite_index", spr_intro_ch3_tv_time_loop);
cutscene_set_variable(id, "image_speed", 1);

cutscene_animate(0, 1, 90, anime_curve.linear, id, "fadeWhiteAlpha");
cutscene_sleep(105);

cutscene_func(room_goto, target_room);

cutscene_play();
