var transtime_1 = 1
var transtime_2 = 20
var transtime_3 = 20

//if !variable_instance_exists(self, "plat_parent") plat_parent = 

if global.platforming_perspective == 0 {
	cutscene_create();
    
    cutscene_player_canmove(false);
    cutscene_party_follow(false);
    
	cutscene_func(function(){
        audio_stop_sound(snd_grab); 
        audio_play_sound(snd_grab, 0, false, 1, 0, 1.25)
    });
	cutscene_sleep(transtime_1);
    
	cutscene_audio_play(snd_platswap_2);
	cutscene_animate(0, 1, 14, "sine_in_out", global, "platforming_perspective");
    
	for (var i = 0; i < party_length(true); ++i) {
		var inst = party_get_inst(global.party_names[i]);
        var offset_x = ((i + 1) div 2) * cos(i * pi) * 20;
		cutscene_animate(inst.x, x + offset_x, 14, "sine_in_out", inst, "x");
        
		var plat_parent = noone; //temp
        var ground_find_range = 240;
        
        with inst {
            for (var j = 0; j < ground_find_range; j += 2) {
                with instance_place(x, y + j, o_plat_ground) {
                    plat_parent = id;
                }
                if instance_exists(plat_parent)
                    break;
            }
            if !instance_exists(plat_parent)
                plat_parent = instance_nearest(x, y, o_plat_ground);
        };
        
		if instance_exists(plat_parent) 
            cutscene_animate(inst.y, plat_parent.initial_y - (-(plat_parent.tile_height * plat_parent.wall_distance)), 14, "sine_in_out", inst, "y");
		
		cutscene_animate(0, -10, 8, "sine_out", inst, "yoff")
	}
	cutscene_sleep(12)
    
	for (var i = 0; i < party_length(true); ++i) {
		cutscene_sleep(4 - i);
		var inst = party_get_inst(global.party_names[i]);
		cutscene_animate(-10, -2, 8, "sine_in", inst, "yoff");
	}
	cutscene_sleep(8)
	cutscene_audio_play(snd_dtrans_flip, , , 1.3)
	cutscene_player_canmove(true)
    
	cutscene_set_variable(get_leader(), "pf_enabled", true);
	cutscene_func(function(){
		with get_leader() 
            event_user(1)
	})
    
    cutscene_func(function() {
        for (var i = 0; i < party_length(true); i ++) {
            party_get_inst(global.party_names[i]).pos = 5 * i;
        }
    })
    cutscene_party_interpolate();
    cutscene_party_follow(true);
    
	cutscene_play()
}
else if global.platforming_perspective == 1 {
	cutscene_create();
    
    cutscene_player_canmove(false);
    cutscene_party_follow(false);
    
	cutscene_audio_play(snd_platswap_1);
	cutscene_animate(1, 0, transtime_2, "sine_in_out", global, "platforming_perspective");
    
	for (var i = 0; i < party_length(true); ++i) {
		var inst = party_get_inst(global.party_names[i]);
        var offset_x = ((i + 1) div 2) * cos(i * pi) * 20;
        
		cutscene_animate(inst.x, x + offset_x, transtime_2, "sine_in_out", inst, "x");
		cutscene_animate(inst.y, initial_y + 15, transtime_2, "sine_in_out", inst, "y");
		cutscene_animate(inst.yoff, -2, transtime_2, "linear", inst, "yoff");
	}
	cutscene_sleep(transtime_2);
    
    cutscene_audio_play(snd_impact);
	cutscene_set_variable(get_leader(), "pf_enabled", false);
	cutscene_set_variable(get_leader(), "image_xscale", 1);
	cutscene_player_canmove(true);
    
    cutscene_func(function() {
        for (var i = 0; i < party_length(true); i ++) {
            party_get_inst(global.party_names[i]).pos = 12 * i;
            party_get_inst(global.party_names[i]).dir = DIR.DOWN;
        }
    })
    cutscene_party_interpolate();
    cutscene_party_follow(true);
    
	cutscene_play();
}