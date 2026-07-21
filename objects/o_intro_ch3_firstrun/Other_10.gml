// variables
x = 160;
y = 120;
	
active = false;
	
logoYOffset = -10;
chYOffset = 15;
	
logoSprIndex = 0;
	
drawStatic = true;
staticSurf = -1;
	
staticMaskSprIndex = 0;
staticSprIndex = 0;
staticAnimSpd = 0.4;
	
drawChText = false;
	
//cutscene
cutscene_create();
	
cutscene_sleep(15);
cutscene_set_variable(id, "active", true);
cutscene_func(music_play, [snd_tv_static, 0]);
	
cutscene_animate(0, 8, 135, anime_curve.linear, id, "staticMaskSprIndex");
cutscene_animate(0, 8, 135, anime_curve.linear, id, "logoSprIndex");
cutscene_sleep(150);
cutscene_set_variable(id, "drawStatic", false);
cutscene_func(music_stop, 0);
cutscene_sleep(52);
cutscene_set_variable(id, "drawChText", true);
cutscene_func(function(){
	music_play(snd_crowd_cheer_single, 0, true, 0.8, 0.7);
	music_play(snd_crowd_cheer_single, 1, true, 0.8, 0.8);
	music_play(snd_crowd_cheer_single, 2, true, 0.8, 0.9);
})
cutscene_sleep(90);
cutscene_func(music_fade_all, [0, 90]);
cutscene_func(fader_fade, [0, 1, 90, DEPTH_UI.CONSOLE]);
cutscene_sleep(105);
cutscene_func(room_goto, target_room);
cutscene_play();

