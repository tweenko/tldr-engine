skipped = false;
	
csState = 0;
pic = spr_intro_legend_0;
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
	
tsParent = time_source_create(time_source_game, 1, time_source_units_frames, function(){}, [], -1)

//prophecy
propSurf = -1;
propOffset = 0;
propAlpha = 1.5;

var _cs_pic_fadein = method(id, function(spd=0.02) {
	var f = round(1/spd/5);
		
	cutscene_create();
	cutscene_set_variable(id, "picAlpha", .25);
	cutscene_sleep(f)
	cutscene_set_variable(id, "picAlpha", .5);
	cutscene_sleep(f)
	cutscene_set_variable(id, "picAlpha", .75);
	cutscene_sleep(f)
	cutscene_set_variable(id, "picAlpha", 1);
	cutscene_play();
})

var _cs1neo_move_img = function() {
	var ts = time_source_create(tsParent, 4, time_source_units_frames, method(o_intro_legend_neo, function(){
		picYOff -= 2;
		picYOff = max(picYOff, -240);
		propAlpha -= 0.0166666666666;
	}), [], 125)
		
	time_source_start(ts);
}
var _cs1neo_move_depths = function() {
	var ts = time_source_create(tsParent, 3, time_source_units_frames, method(o_intro_legend_neo, function(){
		propOffset++;
	}), [], 250)
		
	time_source_start(ts);
}
var _cs1neo_fader_fadeout = function(spd=0.02) {
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

var __cs1_neo_pic_init = method(id, function(){
	pic = spr_intro_legend_0_neo;
	picIndex = 0;
	picX = 60;
	picY = 28;
	
	picW = 200;
	picH = 111;
	picAlpha = 0;
	
	picXOff = 0;
	picYOff = 0;
})

cutscene_create();
	cutscene_sleep(1);
	cutscene_set_variable(self, "active", true);

	cutscene_func(__cs1_neo_pic_init);
		
	cutscene_func(music_play, [mus_intro_legend_neo, 0, false, 1, 0.95]);
	cutscene_func(_cs_pic_fadein);
	cutscene_func(_cs1neo_move_img);
	cutscene_func(_cs1neo_move_depths);
	cutscene_sleep(6);
		
	// Once upon a time, a LEGEND was whispered among shadows.
	cutscene_func(__spawn_text, [0, 80, 320, 214]);
	cutscene_sleep(214);
		
	// It was a legend of HOPE. It was a legend of DREAMS.
	cutscene_func(__spawn_text, [1, 80, 320, 120]);
	cutscene_func(__spawn_text, [2, 440, 320, 120]);
	cutscene_sleep(120);
	
	// It was a legend of LIGHT. It was a legend of DARK.
	cutscene_func(__spawn_text, [3, 80, 320, 120]);
	cutscene_func(__spawn_text, [4, 440, 320, 120]);
	cutscene_sleep(120);
		
	// This is the legend of DELTA RUNE
	cutscene_func(__spawn_text, [5, 160, 320]);
		
	cutscene_wait_until(method(self, function() { return (picYOff <= -240) }));
	cutscene_sleep(150);
    
	cutscene_func(_cs1neo_fader_fadeout);
	cutscene_wait_until(function() { return o_fader.image_alpha == 1; });
    
	cutscene_sleep(10)
    
	cutscene_func(instance_destroy, [o_text_typer]);
	cutscene_sleep(50);
    
	cutscene_func(room_goto, [room_logo]);
cutscene_play();

// pass target_room to intro logo
cutscene_create(false);

cutscene_wait_until(instance_exists, [o_intro_logo]);
cutscene_set_variable(o_intro_logo, "target_room", target_room);

cutscene_play();