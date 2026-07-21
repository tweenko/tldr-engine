x = 160;
y = 120;

surf = -1;
active = false;

drawSurface = true;

depthOff = 0;
depthOffSpd = -1;

spr = spr_dw_church_prophecy_final_icon_w;
sprW = sprite_get_width(spr);
sprH = sprite_get_height(spr);

siner = 0;
auraAmplitude = 8;

cutscene_create();
	cutscene_sleep(1);
	cutscene_set_variable(id, "active", true);
	cutscene_animate(0, 180, 60, anime_curve.linear, id, "siner");
	cutscene_animate(-1, 0, 135, anime_curve.linear, id, "depthOffSpd");
	cutscene_sleep(60);
	cutscene_animate(180, 360, 75, anime_curve.sine_out, id, "siner");
	cutscene_sleep(90);
	cutscene_set_variable(id, "drawSurface", false);
	cutscene_audio_play(snd_break1);
	cutscene_sleep(20);
	cutscene_set_variable(id, "active", false);
	
	

cutscene_play();