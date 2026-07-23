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
	
#region cutscene methods

var _cs_pic_fadein = function(spd=0.02) {
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
var _cs_pic_fadeout = function(spd=0.02) {
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
var _cs_ov_fadein = function(spd=0.02) {
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
var _cs_ov_fadeout = function(spd=0.02) {
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
var _cs_pic_ov_fadein = function(spd=0.02) {
	var f = round(1/spd/5);
		
	cutscene_create();
	cutscene_set_variable(o_intro_legend, "picAlpha", .25);
	cutscene_set_variable(o_intro_legend, "ovAlpha", 0);
	cutscene_sleep(f)
	cutscene_set_variable(o_intro_legend, "picAlpha", .5);
	cutscene_sleep(f)
	cutscene_set_variable(o_intro_legend, "picAlpha", .75);
	cutscene_sleep(f)
	cutscene_set_variable(o_intro_legend, "picAlpha", 1);
	
	cutscene_play();
}
var _cs_pic_ov_fadeout = function(spd=0.02) {
	var f = round(1/spd/5);
		
	cutscene_create();
	cutscene_set_variable(o_intro_legend, "picAlpha", 0);
	cutscene_set_variable(o_intro_legend, "ovAlpha", .75);
	cutscene_sleep(f)
	cutscene_set_variable(o_intro_legend, "ovAlpha", .5);
	cutscene_sleep(f)
	cutscene_set_variable(o_intro_legend, "ovAlpha", .25);
	cutscene_sleep(f)
	cutscene_set_variable(o_intro_legend, "ovAlpha", 0);
		
	cutscene_play();
}
var _cs_fadein_white = function(spd=0.03) {
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
var _cs_fadeout_white = function(spd=0.03) {
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
	
var _cs1_move_img = function() {
	var ts = time_source_create(tsParent, 4, time_source_units_frames, method(o_intro_legend, function(){
		picYOff -= 2;
		picYOff = max(picYOff, -240);
	}), [], 125)
		
	time_source_start(ts);
}
	
var __cs1_pic_init = method(o_intro_legend, function(){
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
})
var __cs2_pic_init = method(o_intro_legend, function(){
	csState++;
		
	pic = spr_intro_legend_1;
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
var __cs3_pic_init = method(o_intro_legend, function(){
	csState++;
		
	pic = spr_intro_legend_2;
	picIndex = 0;
		
	picX = 0;
	picY = 0;
		
	picW = sprite_get_width(pic);
	picH = sprite_get_height(pic);
	
	picYOff = 0;
		
	ov = undefined;
})
var __cs4_pic_init = method(o_intro_legend, function(){
	csState++;
		
	picIndex = 0;
	ovIndex = 1;
		
	pic = spr_intro_legend_3;
	ov = pic;
		
	ovX = picX;
	ovY = picY;
	ovH = picH;
	ovYOff = picYOff;
})
var __cs5_pic_init = method(o_intro_legend, function(){
	csState++;
		
	picIndex = 0;
	ovIndex = 1;
		
	pic = spr_intro_legend_4;
	ov = pic;
		
	ovX = picX;
	ovY = picY;
	ovH = picH;
	ovYOff = picYOff;
})
var __cs6_pic_init = method(o_intro_legend, function(){
	csState++;
		
	picIndex = 0;
	ovIndex = 1;
		
	pic = spr_intro_legend_5;
	ov = undefined;
})
var __cs7_pic_init = method(o_intro_legend, function(){
	csState++;
		
	pic = spr_intro_legend_6;
		
	picX = 60;
	picY = 28;
	picXOff = 0;
	picYOff = 0;
		
	picW = 200;
	picH = 111;
		
	picIndex = 0;
})

#endregion
	
#region the legend

cutscene_create();
	cutscene_sleep(1);
	cutscene_set_variable(self, "active", true);

	cutscene_func(music_play, [mus_intro_legend, 0, false, 1, 0.95]);
	cutscene_func(__cs1_pic_init);
	cutscene_func(_cs_pic_fadein);
	cutscene_func(_cs1_move_img);
    
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
    cutscene_sleep(140);
    cutscene_func(music_pause, 0);
	cutscene_wait_until(method(self, function() { return picYOff <= -240; }));
    
	cutscene_func(_cs_pic_fadeout);
	cutscene_sleep(60);
    
	cutscene_func(instance_destroy, [o_text_typer]);
	cutscene_sleep(11);
	
	cutscene_func(music_resume, [0]);
	cutscene_sleep(14);
    
	cutscene_func(__cs2_pic_init);
	cutscene_func(_cs_pic_fadein);
		
	// For millenia, LIGHT and DARK have lived in balance, Bringing peace to the WORLD.
	cutscene_func(__spawn_text, [6, 80, 320, 270]);
	cutscene_sleep(270);
		
	// But if this harmony were to shatter...
	cutscene_func(_cs_ov_fadein);
	cutscene_func(__spawn_text, [7, 140, 320, 140]);
	cutscene_sleep(130);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// A terrible calamity would occur.
	cutscene_set_variable(id, "picAlpha", 0);
	cutscene_func(_cs_ov_fadeout);
	cutscene_func(__spawn_text, [8, 80, 160]);
	cutscene_sleep(120);
    
	cutscene_func(_cs_fadein_white);
	cutscene_sleep(10);
    
	cutscene_wait_until(method(self, function() { return fadeWhiteAlpha; }));
		
	cutscene_func(instance_destroy, [o_text_typer]);
	cutscene_func(__cs3_pic_init);
	cutscene_sleep(10);
		
	cutscene_func(_cs_fadeout_white, [0.05]);
	cutscene_set_variable(o_intro_legend, "picAlpha", 1);
		
	// The sky will run black with terror
	cutscene_func(__spawn_text, [9, 160, 370]);
	cutscene_sleep(128);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// And the land will crack with fear.
	cutscene_func(__spawn_text, [10, 160, 370]);
	cutscene_sleep(138);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// Then, her heart pounding...
	cutscene_func(__spawn_text, [11, 120, 370]);
	cutscene_sleep(128);
    
	cutscene_func(instance_destroy, [o_text_typer]);
	
	// The EARTH will draw her final breath.
	cutscene_func(__spawn_text, [12, 160, 370]);
	cutscene_sleep(106);
    
	cutscene_func(_cs_pic_fadeout, [0.04]);
	cutscene_sleep(31);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	cutscene_func(__cs4_pic_init);
	cutscene_func(_cs_pic_fadein, [0.04]);
		
	// Only then, shining with hope...
	cutscene_func(__spawn_text, [13, 80, 370]);
	cutscene_sleep(138);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// Three HEROES appear at WORLDS' edge.
	cutscene_func(_cs_ov_fadein, [0.04]);
	cutscene_func(__spawn_text, [14, 160, 370]);
	cutscene_sleep(108);
    
	cutscene_func(_cs_pic_ov_fadeout, [0.05]);
	cutscene_sleep(31);
    
	cutscene_func(instance_destroy, [o_text_typer]);
	cutscene_func(__cs5_pic_init);
	cutscene_func(_cs_pic_fadein, [0.05]);
	cutscene_sleep(4);
		
	// A HUMAN,
	cutscene_func(__spawn_text, [15, 40, 370]);
	cutscene_sleep(65);
		
	// A MONSTER,
	cutscene_func(_cs_ov_fadein, [0.04]);
	cutscene_func(__spawn_text, [16, 220, 370]);
	cutscene_sleep(69);
		
	// And a PRINCE FROM THE DARK
    cutscene_set_variable(id, "picIndex", 1);
    cutscene_set_variable(id, "ovIndex", 2);
    cutscene_set_variable(id, "ovAlpha", 0);
    
	cutscene_func(_cs_ov_fadein, [0.04]);
	cutscene_func(__spawn_text, [17, 400, 370]);
	cutscene_sleep(108);
		
    cutscene_set_variable(id, "picAlpha", 0);
	cutscene_func(_cs_ov_fadeout, [0.05]);
	cutscene_sleep(31);
    
	cutscene_func(instance_destroy, [o_text_typer]);
	cutscene_func(__cs6_pic_init);
	cutscene_func(_cs_pic_fadein, [0.04]);
		
	// Only they can seal the fountains
	cutscene_func(__spawn_text, [18, 80, 370]);
	cutscene_sleep(138);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// And banish the ANGEL'S HEAVEN.
	cutscene_func(__spawn_text, [19, 80, 370]);
	cutscene_sleep(138);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// Only then will balance be restored.
	cutscene_func(__spawn_text, [20, 160, 370]);
	cutscene_sleep(138);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// And the WORLD saved from destruction.
	cutscene_func(__spawn_text, [21, 160, 370]);
	cutscene_func(_cs_pic_fadeout, [0.05]);
	cutscene_sleep(128);
    
	cutscene_func(instance_destroy, [o_text_typer]);
	cutscene_func(__cs7_pic_init);
	cutscene_func(_cs_pic_fadein);
	cutscene_func(method(self, function() {
		cutscene_create();
		repeat(54) {
			cutscene_func(method(self, function() {picYOff -= 2}));
			cutscene_sleep(4);
		}
		cutscene_play();
	}));
		
	// Today, the FOUNTAIN OF DARKNESS-
	cutscene_func(__spawn_text, [22, 80, 320]);
	cutscene_sleep(138);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// The geyser that gives this land form-
	cutscene_func(__spawn_text, [23, 160, 320]);
	cutscene_sleep(138);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// Stands tall at the center of the kingdom.
	cutscene_func(__spawn_text, [24, 160, 320]);
	cutscene_sleep(168);
    
	cutscene_func(instance_destroy, [o_text_typer]);
	cutscene_func(method(self, function() {
		cutscene_create();
		repeat(39) {
			cutscene_func(method(self, function() {picXOff -= 2}));
			cutscene_sleep(3);
		}
		cutscene_play();
	}));
		
	// But recently, another fountain has appeared on the horizon...
	cutscene_func(__spawn_text, [25, 80, 320]);
	cutscene_sleep(240);
    
	cutscene_func(instance_destroy, [o_text_typer]);
		
	// And with it, the balance of LIGHT and DARK begins to shift...
	cutscene_func(__spawn_text, [26, 80, 320]);
	cutscene_sleep(120);
	cutscene_func(_cs_pic_fadeout);	
	cutscene_sleep(120);
	cutscene_func(music_fade, [0, 0, 30]);
	cutscene_func(fader_fade, [0, 1, 30, DEPTH_UI.CONSOLE]);
		
	cutscene_sleep(80);
	cutscene_func(room_goto, [room_logo]);

cutscene_play();

#endregion
	
// pass target_room to intro logo
cutscene_create(false);

cutscene_wait_until(instance_exists, [o_intro_logo]);
cutscene_set_variable(o_intro_logo, "target_room", target_room);

cutscene_play();