// variables
x = 160;
y = 120;

__wave = function(_a0, _a1, _a2, _a3) {
	return (_a0 + _a1)/2 + (_a1 - _a0)/2 * sin(2*pi * (o_world.frames/30 + _a2*_a3)/_a2);
}

tick = 0;
afterimageOffset = 0;

surf = -1;
active = false;

sprLogo = spr_intro_logo_noheart;
sprW = sprite_get_width(sprLogo);
sprH = sprite_get_height(sprLogo);

cracked = false;

heartAlpha = 0;
logoAlpha = 0;
surfaceAlpha = 0;
chTextAlpha = 0;

logoYOffset = 0;
chYOffset = 33;

scrollSpeed = -2;

// cutscene
cutscene_create();

cutscene_sleep(15);
cutscene_set_variable(id, "active", true);
cutscene_func(music_play, [mus_intro_ch4, 0, false]);

cutscene_animate(0, 1, 120, anime_curve.linear, id, "heartAlpha");
cutscene_sleep(120);

cutscene_animate(0, 1, 90, anime_curve.linear, id, "logoAlpha");
cutscene_sleep(105);

cutscene_animate(0, 1, 70, anime_curve.linear, id, "surfaceAlpha");
cutscene_sleep(15);

cutscene_animate(0, 1, 90, anime_curve.linear, id, "chTextAlpha");
cutscene_sleep(210);

cutscene_animate(scrollSpeed, 0, 60, anime_curve.linear, id, "scrollSpeed");

cutscene_wait_until(function(){return !audio_is_playing(mus_intro_ch4)});
cutscene_debug_message("to do: crack")

cutscene_set_variable(id, "cracked", true);
cutscene_audio_play(snd_break1, false, 0.95);
cutscene_sleep(19);

// stop displaying the prophecy icon + spawn glass shards
cutscene_set_variable(id, "logoAlpha", 0);
cutscene_func(method(id, method(id, function(){
	for (var i=0; i<sprite_get_number(spr_intro_logo_shatter); i++) {
		var inst = instance_create(o_part_fallingsprite, x, y);
		
		with inst {
			direction = random(360)
			sprite_index = spr_intro_logo_shatter
			image_speed = 0
			image_index = i
			depth = other.depth+1;
			
			spriteIsCentered = true;
			
			call_later(20, time_source_units_frames, method(self, function(){
				gravity = 0.4 + random(0.12);
				friction = 0;
				speed = 4;
			}))
		}
	}
})))

//sounds
cutscene_func(function(){
	cutscene_create();
		cutscene_sleep(10);
		cutscene_audio_play(snd_punchmed, false, 0.95, 0.7);
		cutscene_sleep(1);
		cutscene_audio_play(snd_ch4_glassbreak1, false, 0.5, 1);
		cutscene_audio_play(snd_ch4_glassbreak1, false, 0.5, 0.94);
		cutscene_sleep(1);
		cutscene_audio_play(snd_glassbreak, false, 0.4, 0.6);
	cutscene_play();
})	
cutscene_sleep(20);

//summon ground shards
cutscene_func(method(id, function(){
	var _num = 15;
	var _ww = 45;
	for (var i=0; i<_num; i++) {
		var _xx = 160 - 100 + i*199/_num + random_range(-15, 15);
		var _yy = 120 + random(30);
		
		instance_create(o_part_groundshards, _xx, _yy, depth+1);
	}
}))
cutscene_sleep(45);

cutscene_animate(1, 0, 120, anime_curve.linear, id, "heartAlpha");
cutscene_sleep(135);

cutscene_func(room_goto, target_room);
cutscene_play();

