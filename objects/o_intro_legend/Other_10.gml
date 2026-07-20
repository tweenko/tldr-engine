__intro_seq = method(self, function(){
	spawn_text = function(idx, tx, ty, duration=undefined) {
		var typer = text_typer_create(loc("legend_lb")[idx],tx,ty,DEPTH_UI.DIALOGUE_UI,"{can_skip(false)}{shadow(false)}{speed(2)}{voice(nil)}{auto_breaks(false)}","{stop}",{
				gui: true,
				caller: o_intro_legend,
				destroy_caller: false
			}
		)
		
		if !is_undefined(duration) {
			var ts = time_source_create(o_intro_legend.tsParent, duration, time_source_units_frames, instance_destroy, [typer]);
			time_source_start(ts);
		}
	}
	
	function rem(i, j)
	{
		var n = 0;
		if i > 0 {n = i mod j}
		else if i < 0{n = j + i mod j};
		while (n >= j){n -= j}
		return n;
	}
	
	draw_sprite_looped_xy = function(offsetx, offsety, amp, sprite, image, xx, yy, xscale = 1, yscale = 1, angle = 0, color = c_white, alpha = 1, move_x = true, move_y = true, xamt = 2, yamt = 2) {
		var __sw = sprite_get_width(sprite)  * xscale
		var __sh = sprite_get_height(sprite) * yscale
	    
		// pixel–space offsets (smooth, always positive)
		var __ox = (move_x ? rem(offsetx * amp, __sw) : 0)
		var __oy = (move_y ? rem(offsety * amp, __sh) : 0)
	
		for (var i = 0; abs(i) < xamt; i += sign(amp) ) {
		    for (var j = 0; abs(j) < yamt; j += sign(amp)) {
		        draw_sprite_ext(
		            sprite, image,
			        xx - __ox + i * __sw,
		            yy - __oy + j * __sh,
		            xscale, yscale, angle, color, alpha
		        )
		    }
		}
	}
	
	
	// insert variables here
	skipped = false;
	
	csState = 0;
	pic = spr_legend0;
	picIndex = 0;
	picX = 60;
	picY = 28;
	
	picW = 200;
	picH = 111;
	picAlpha = 0;
	
	picXOff = 0;
	picYOff = 0;
	
	ov = undefined;
	ovIndex = 1;
	ovX = picX;
	ovY = picY;
	ovXOff = picXOff;
	ovYOff = picYOff;
	ovW = 200;
	ovH = picH;
	ovAlpha = 0;
	
	fadeWhiteAlpha = 0;
	
	//prophecy
	propSurf = -1;
	propOffset = 0;
	propAlpha = 1.5;
	
	tsParent = time_source_create(time_source_game, 1, time_source_units_frames, function(){}, [], -1)
	
	// cutscene methods
	#region functions
	_cs_pic_fadein = function(spd=0.02) {
		var f = round(1/spd/5);
		
		cutscene_create();
		cutscene_set_variable(o_intro_legend, "picAlpha", .25);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", .5);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", .75);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", 1);
		cutscene_play();
	}
	_cs_pic_fadeout = function(spd=0.02) {
		var f = round(1/spd/5);
		
		cutscene_create();
		cutscene_set_variable(o_intro_legend, "picAlpha", .75);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", .5);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", .25);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", 0);
	
		cutscene_play();
	}
	_cs_ov_fadein = function(spd=0.02) {
		var f = round(1/spd/5);
		
		cutscene_create();
		cutscene_set_variable(o_intro_legend, "ovAlpha", .25);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "ovAlpha", .5);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "ovAlpha", .75);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "ovAlpha", 1);
		
		cutscene_play();
	}
	_cs_ov_fadeout = function(spd=0.02) {
		var f = round(1/spd/5);
		
		cutscene_create();
		cutscene_set_variable(o_intro_legend, "ovAlpha", .75);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "ovAlpha", .5);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "ovAlpha", .25);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "ovAlpha", 0);
	
		cutscene_play();
	}
	_cs_pic_ov_fadein = function(spd=0.02) {
		var f = round(1/spd/5);
		
		cutscene_create();
		cutscene_set_variable(o_intro_legend, "picAlpha", .25);
		cutscene_set_variable(o_intro_legend, "ovAlpha", .25);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", .5);
		cutscene_set_variable(o_intro_legend, "ovAlpha", .5);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", .75);
		cutscene_set_variable(o_intro_legend, "ovAlpha", .75);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", 1);
		cutscene_set_variable(o_intro_legend, "ovAlpha", 1);
	
		cutscene_play();
	}
	_cs_pic_ov_fadeout = function(spd=0.02) {
		var f = round(1/spd/5);
		
		cutscene_create();
		cutscene_set_variable(o_intro_legend, "picAlpha", .75);
		cutscene_set_variable(o_intro_legend, "ovAlpha", .75);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", .5);
		cutscene_set_variable(o_intro_legend, "ovAlpha", .5);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", .25);
		cutscene_set_variable(o_intro_legend, "ovAlpha", .25);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "picAlpha", 0);
		cutscene_set_variable(o_intro_legend, "ovAlpha", 0);
		
		cutscene_play();
	}
	_cs_fadein_white = function(spd=0.03) {
		var f = round(1/spd/5);
		
		cutscene_create();
		cutscene_set_variable(o_intro_legend, "fadeWhiteAlpha", .25);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "fadeWhiteAlpha", .5);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "fadeWhiteAlpha", .75);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "fadeWhiteAlpha", 1);
		cutscene_play();
	}
	_cs_fadeout_white = function(spd=0.03) {
		var f = round(1/spd/5);
		
		cutscene_create();
		cutscene_set_variable(o_intro_legend, "fadeWhiteAlpha", .75);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "fadeWhiteAlpha", .5);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "fadeWhiteAlpha", .25);
		cutscene_sleep(f)
		cutscene_set_variable(o_intro_legend, "fadeWhiteAlpha", 0);
		cutscene_play();
	}
	
	_cs1_move_img = function() {
		var ts = time_source_create(tsParent, 4, time_source_units_frames, method(o_intro_legend, function(){
			picYOff -= 2;
			picYOff = max(picYOff, -240);
		}), [], 125)
		
		time_source_start(ts);
	}
	
	_cs1neo_move_img = function() {
		var ts = time_source_create(tsParent, 4, time_source_units_frames, method(o_intro_legend, function(){
			picYOff -= 2;
			picYOff = max(picYOff, -240);
			propAlpha -= 0.0166666666666;
		}), [], 125)
		
		time_source_start(ts);
	}
	_cs1neo_move_depths = function() {
		var ts = time_source_create(tsParent, 3, time_source_units_frames, method(o_intro_legend, function(){
			propOffset++;
		}), [], 250)
		
		time_source_start(ts);
	}
	_cs1neo_fader_fadeout = function(spd=0.02) {
		var f = round(1/spd/5);
	
		cutscene_create();
		cutscene_sleep(f)
		cutscene_func(fader_fade, [0,0.25,0, DEPTH_UI.CONSOLE]);
		cutscene_sleep(f)
		cutscene_func(fader_fade, [0,0.5,0, DEPTH_UI.CONSOLE]);
		cutscene_sleep(f)
		cutscene_func(fader_fade, [0,0.75,0, DEPTH_UI.CONSOLE]);
		cutscene_sleep(f)
		cutscene_func(fader_fade, [0,1,0, DEPTH_UI.CONSOLE]);
	
		cutscene_play();
	}
	
	__cs1_pic_init = method(o_intro_legend, function(){
		csState = 0;
		pic = spr_legend0;
		picIndex = 0;
		picX = 60;
		picY = 28;
	
		picW = 200;
		picH = 111;
		picAlpha = 0;
	
		picXOff = 0;
		picYOff = 0;
	
		ov = undefined;
		ovIndex = 1;
		ovX = picX;
		ovY = picY;
		ovXOff = picXOff;
		ovYOff = picYOff;
		ovW = 200;
		ovH = picH;
		ovAlpha = 0;
	
		fadeWhiteAlpha = 0;
	})
	__cs2_pic_init = method(o_intro_legend, function(){
		csState++;
		
		pic = spr_legend1;
		picIndex = 0;
		
		picX = 60;
		picY = 28;
		
		picW = sprite_get_width(pic);
		picH = sprite_get_height(pic);
	
		picYOff = 0;
		
		ov = pic;
		ovIndex = 1;
		ovX = picX;
		ovY = picY;
		ovYOff = picYOff;
		ovH = picH;
		ovAlpha = 0;
	})
	__cs3_pic_init = method(o_intro_legend, function(){
		csState++;
		
		pic = spr_legend2;
		picIndex = 0;
		
		picX = 0;
		picY = 0;
		
		picW = sprite_get_width(pic);
		picH = sprite_get_height(pic);
	
		picYOff = 0;
		
		ov = undefined;
	})
	__cs4_pic_init = method(o_intro_legend, function(){
		csState++;
		
		picIndex = 0;
		ovIndex = 1;
		
		pic = spr_legend3;
		ov = pic;
		
		ovX = picX;
		ovY = picY;
		ovH = picH;
		ovYOff = picYOff;
	})
	__cs5_pic_init = method(o_intro_legend, function(){
		csState++;
		
		picIndex = 0;
		ovIndex = 1;
		
		pic = spr_legend4;
		ov = pic;
		
		ovX = picX;
		ovY = picY;
		ovH = picH;
		ovYOff = picYOff;
	})
	__cs6_pic_init = method(o_intro_legend, function(){
		csState++;
		
		picIndex = 0;
		ovIndex = 1;
		
		pic = spr_legend5;
		ov = undefined;
	})
	__cs7_pic_init = method(o_intro_legend, function(){
		csState++;
		
		pic = spr_legend6;
		
		picX = 60;
		picY = 28;
		picXOff = 0;
		picYOff = 0;
		
		picW = 200;
		picH = 111;
		
		picIndex = 0;
	})
	
	__cs1_neo_pic_init = method(o_intro_legend, function(){
		pic = spr_legend0_neo;
		picIndex = 0;
		picX = 60;
		picY = 28;
	
		picW = 200;
		picH = 111;
		picAlpha = 0;
	
		picXOff = 0;
		picYOff = 0;
	})
	#endregion
	
	#region the leg end
	cutscene_create();
	cutscene_sleep(1);
	cutscene_set_variable(self, "active", true);
		
	if global.chapter < 4 {
		cutscene_func(__cs1_pic_init);
		cutscene_func(music_play, [mus_legend, 0, false]);
		cutscene_lb_music_pitch(0, 0.95, 0.95, 1)
		cutscene_func(_cs_pic_fadein);
		cutscene_func(_cs1_move_img);
		
		// pause music
		cutscene_func(function() {
			cutscene_create();
			cutscene_sleep(600);
			cutscene_func(music_pause, [0]);
			cutscene_play();
			
			//call_later(600, time_source_units_frames, method(o_intro_legend, function(){music_pause(0)}), false);
			
		});
		cutscene_sleep(6);
		
		// Once upon a time, a LEGEND was whispered among shadows.
		cutscene_func(spawn_text, [0, 80, 320]);
		cutscene_sleep(214);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// It was a legend of HOPE. It was a legend of DREAMS.
		cutscene_func(spawn_text, [1, 80, 320]);
		cutscene_func(spawn_text, [2, 440, 320]);
		cutscene_sleep(120);
		cutscene_func(instance_destroy, [o_text_typer]);
	
		// It was a legend of LIGHT. It was a legend of DARK.
		cutscene_func(spawn_text, [3, 80, 320]);
		cutscene_func(spawn_text, [4, 440, 320]);
		cutscene_sleep(120);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// This is the legend of DELTA RUNE
		cutscene_func(spawn_text, [5, 160, 320]);
		
		cutscene_wait_until(function(i){return (i.picYOff <= -240)}, [o_intro_legend]);
		cutscene_sleep(90);
		cutscene_func(_cs_pic_fadeout);
		cutscene_sleep(41);
		cutscene_func(instance_destroy, [o_text_typer]);
		cutscene_func(__cs2_pic_init);
	
		cutscene_func(music_resume, [0]);
		cutscene_func(_cs_pic_fadein);
		
		// For millenia, LIGHT and DARK have lived in balance, Bringing peace to the WORLD.
		cutscene_func(spawn_text, [6, 80, 320]);
		cutscene_sleep(270);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// But if this harmony were to shatter...
		cutscene_func(_cs_ov_fadein);
		cutscene_func(spawn_text, [7, 140, 320]);
		cutscene_sleep(130);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// A terrible calamity would occur.
		cutscene_func(function(i=o_intro_legend) {i.picAlpha=0});
		cutscene_func(_cs_ov_fadeout);
		cutscene_func(spawn_text, [8, 80, 160]);
		cutscene_sleep(120);
		cutscene_func(_cs_fadein_white);
		cutscene_sleep(10);
		cutscene_wait_until(function(i=o_intro_legend) {return i.fadeWhiteAlpha});
		
		cutscene_func(instance_destroy, [o_text_typer]);
		cutscene_func(__cs3_pic_init);
		cutscene_sleep(10);
		
		cutscene_func(_cs_fadeout_white, [0.05]);
		cutscene_set_variable(o_intro_legend, "picAlpha", 1);
		
		// The sky will run black with terror
		cutscene_func(spawn_text, [9, 160, 370]);
		cutscene_sleep(138);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// And the land will crack with fear.
		cutscene_func(spawn_text, [10, 160, 370]);
		cutscene_sleep(138);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// Then, her heart pounding...
		cutscene_func(spawn_text, [11, 120, 370]);
		cutscene_sleep(138);
		cutscene_func(instance_destroy, [o_text_typer]);
	
		// The EARTH will draw her final breath.
		cutscene_func(spawn_text, [12, 160, 370]);
		cutscene_sleep(106);
		cutscene_func(_cs_pic_fadeout, [0.04]);
		cutscene_sleep(31);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		cutscene_func(__cs4_pic_init);
		
		cutscene_func(_cs_pic_fadein, [0.04]);
		
		// Only then, shining with hope...
		cutscene_func(spawn_text, [13, 80, 370]);
		cutscene_sleep(138);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// Three HEROES appear at WORLDS' edge.
		cutscene_func(_cs_ov_fadein, [0.04]);
		cutscene_func(spawn_text, [14, 160, 370]);
		cutscene_sleep(108);
		cutscene_func(_cs_pic_ov_fadeout, [0.05]);
		cutscene_sleep(31);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		cutscene_func(__cs5_pic_init);
		
		cutscene_func(_cs_pic_fadein, [0.05]);
		cutscene_sleep(4);
		
		// A HUMAN,
		cutscene_func(spawn_text, [15, 40, 370]);
		cutscene_sleep(65);
		
		// A MONSTER,
		cutscene_func(_cs_ov_fadein, [0.04]);
		cutscene_func(spawn_text, [16, 220, 370]);
		cutscene_sleep(69);
		
		// And a PRINCE FROM THE DARK.
		cutscene_func(function(i=o_intro_legend) {
			picIndex = 1;
			ovIndex = 2;
			ovAlpha = 0;
		})
		cutscene_func(_cs_ov_fadein, [0.04]);
		cutscene_func(spawn_text, [17, 400, 370]);
		cutscene_sleep(108);
		
		cutscene_func(function(i=o_intro_legend){i.picAlpha=0});
		cutscene_func(_cs_ov_fadeout, [0.05]);
		cutscene_sleep(31);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		cutscene_func(__cs6_pic_init);
		
		cutscene_func(_cs_pic_fadein, [0.04]);
		
		// Only they can seal the fountains
		cutscene_func(spawn_text, [18, 80, 370]);
		cutscene_sleep(138);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// And banish the ANGEL'S HEAVEN.
		cutscene_func(spawn_text, [19, 80, 370]);
		cutscene_sleep(138);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// Only then will balance be restored.
		cutscene_func(spawn_text, [20, 160, 370]);
		cutscene_sleep(138);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// And the WORLD saved from destruction.
		cutscene_func(spawn_text, [21, 160, 370]);
		cutscene_func(_cs_pic_fadeout, [0.05]);
		cutscene_sleep(108);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		cutscene_func(__cs7_pic_init);
		
		cutscene_func(_cs_pic_fadein);
		
		cutscene_func(function() {
			cutscene_create();
			repeat(55){
				cutscene_func(function() {o_intro_legend.picYOff -= 2});
				cutscene_sleep(4);
			}
			cutscene_play();
		})
		
		// Today, the FOUNTAIN OF DARKNESS-
		cutscene_func(spawn_text, [22, 80, 320]);
		cutscene_sleep(138);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// The geyser that gives this land form-
		cutscene_func(spawn_text, [23, 160, 320]);
		cutscene_sleep(138);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// Stands tall at the center of the kingdom.
		cutscene_func(spawn_text, [24, 160, 320]);
		cutscene_sleep(168);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		cutscene_func(function() {
			cutscene_create();
			repeat(39){
				cutscene_func(function() {o_intro_legend.picXOff -= 2});
				cutscene_sleep(3);
			}
			cutscene_play();
		})
		
		// But recently, another fountain has appeared on the horizon...
		cutscene_func(spawn_text, [25, 80, 320]);
		cutscene_sleep(240);
		cutscene_func(instance_destroy, [o_text_typer]);
		
		// And with it, the balance of LIGHT and DARK begins to shift...
		cutscene_func(_cs_pic_fadeout);
		cutscene_func(spawn_text, [26, 80, 320]);
		cutscene_sleep(240);
		
		cutscene_func(music_fade, [0, 0, 30]);
		cutscene_func(function() {
			fader_fade(0, 1, 30);
			o_fader.depth = DEPTH_UI.CONSOLE;
		});
		
		cutscene_sleep(80);
		cutscene_func(room_goto, [room_logo]);
	}
	else {
		cutscene_func(__cs1_neo_pic_init);
		
		cutscene_sleep(30);
		
		cutscene_func(music_play, [mus_legend_neo, 0, false]);
		cutscene_lb_music_pitch(0, 0.95, 0.95, 1)
		cutscene_func(_cs_pic_fadein);
		cutscene_func(_cs1neo_move_img);
		cutscene_func(_cs1neo_move_depths);
		cutscene_sleep(6);
		
		// Once upon a time, a LEGEND was whispered among shadows.
		cutscene_func(spawn_text, [0, 80, 320, 214]);
		cutscene_sleep(214);
		
		// It was a legend of HOPE. It was a legend of DREAMS.
		cutscene_func(spawn_text, [1, 80, 320, 120]);
		cutscene_func(spawn_text, [2, 440, 320, 120]);
		cutscene_sleep(120);
	
		// It was a legend of LIGHT. It was a legend of DARK.
		cutscene_func(spawn_text, [3, 80, 320, 120]);
		cutscene_func(spawn_text, [4, 440, 320, 120]);
		cutscene_sleep(120);
		
		// This is the legend of DELTA RUNE
		cutscene_func(spawn_text, [5, 160, 320]);
		
		cutscene_wait_until(function(i){return (i.picYOff <= -240)}, [o_intro_legend]);
		cutscene_sleep(150);
		cutscene_func(_cs1neo_fader_fadeout);
		cutscene_wait_until(function(){return o_fader.image_alpha == 1});
		cutscene_sleep(10)
		cutscene_func(instance_destroy, [o_text_typer]);
		
		cutscene_sleep(50);
		cutscene_func(room_goto, [room_logo]);
	}
			
	cutscene_play();
	#endregion
	
	// pass target_room to intro logo
	cutscene_create(false);
	cutscene_wait_until(instance_exists, [o_intro_logo]);
	cutscene_set_variable(o_intro_logo, "target_room", target_room);
	cutscene_play();
})