x = 160;
y = 120;

tick = 0;

surf = -1;
active = false;

spr = spr_dw_church_prophecy_final_icon_w;
sprW = sprite_get_width(spr);
sprH = sprite_get_height(spr);

drawSurface = true;

scrollSpeed = -1;

__wave = function(_a0, _a1, _a2, _a3) {
	return (_a0 + _a1)/2 + (_a1 - _a0)/2 * sin(2*pi * (o_world.frames/30 + _a2*_a3)/_a2);
}

cutscene_create();
	cutscene_sleep(15);
	cutscene_set_variable(id, "active", true);
	cutscene_sleep(75);
	cutscene_animate(id.scrollSpeed, 0, 52, anime_curve.linear, id, "scrollSpeed");
	cutscene_sleep(60);

	// glass crack
	cutscene_set_variable(id, "drawSurface", false);
	cutscene_audio_play(snd_break1, false, 0.95);
	cutscene_sleep(19);
	
	// stop displaying the prophecy icon + spawn glass shards
	cutscene_set_variable(id, "active", false);
	cutscene_func(method(id, method(id, function(){
		for (var i=0; i<sprite_get_number(spr_dw_church_prophecy_final_glassshards); i++) {
			var inst = instance_create(o_part_fallingsprite, x, y);
			
			with inst {
				direction = random(360)
				sprite_index = spr_dw_church_prophecy_final_glassshards
				image_speed = 0
				image_index = i
				
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
			cutscene_audio_play(snd_ch4_glassbreak1, false, 0.5, 0.5);
			cutscene_audio_play(snd_ch4_glassbreak1, false, 0.5, 0.44);
			cutscene_sleep(1);
			cutscene_audio_play(snd_glassbreak, false, 0.4, 0.6);
		cutscene_play();
	})	

	cutscene_sleep(20);
	cutscene_func(function(){
		var _num = 15;
		var _ww = 45;
		for (var i=0; i<_num; i++) {
			var _xx = 160 - _ww + 2*i*_ww/_num + random_range(-15, 15);
			var _yy = 120 + random(35);
			
			if i == 0 {
				_xx = 160 - _ww;
			}
			if i == _num-1 {
				_xx = 160 + _ww
			}
			
			instance_create(o_part_groundshards, _xx, _yy);
		}
	})

	
	
	cutscene_sleep(150);
	cutscene_func(room_goto, target_room);
cutscene_play();