var transtime_1 = 1
var transtime_2 = 20
var transtime_3 = 20

//if !variable_instance_exists(self, "plat_parent") plat_parent = 

if global.platforming_perspective==0{
	cutscene_create()
    cutscene_player_canmove(false)
	cutscene_func(function(){audio_stop_sound(snd_grab); audio_play_sound(snd_grab, 0, false, 1, 0, 1.25)})
	cutscene_sleep(transtime_1)
	cutscene_audio_play(snd_platswap_2)
	cutscene_animate(0, 1, 14, "sine_in_out", global, "platforming_perspective")
	for (var i = 0; i < party_length(true); ++i) {
		var inst = party_get_inst(global.party_names[i])
		cutscene_animate(inst.x, x, 14, "sine_in_out", inst, "x")
		var plat_parent = instance_find(obj_plat_ground, 1) //temp
		if instance_exists(plat_parent) cutscene_animate(inst.y, plat_parent.initial_y-(-(plat_parent.tile_height*plat_parent.wall_distance)), 14, "sine_in_out", inst, "y")
		
		cutscene_animate(0, -10, 8, "sine_out", inst, "yoff")
	}
	cutscene_sleep(12)
	for (var i = 0; i < party_length(true); ++i) {
		cutscene_sleep(4-i)
		var inst = party_get_inst(global.party_names[i])
		cutscene_animate(-10, 0, 8, "sine_in", inst, "yoff")
	}
	cutscene_sleep(8)
	cutscene_audio_play(snd_dtrans_flip, , , 1.3)
	cutscene_player_canmove(true)
	cutscene_func(function(){
		get_leader().pf_enabled=1
		with get_leader() {event_user(1)}
		for (var i = 0; i < party_length(true); ++i) {
			var pinst = party_get_inst(global.party_names[i])
			if pinst.follow and pinst.is_follower{ with pinst{ repeat(50){
				array_insert_cycle(record[0], 0, get_leader().x)
				array_insert_cycle(record[1], 0, get_leader().y)
			}}}
		}
		
	})
	cutscene_play()
}
else if global.platforming_perspective==1{
	cutscene_create()
    cutscene_player_canmove(false)
	cutscene_audio_play(snd_platswap_1)
	cutscene_animate(1, 0, transtime_2, "sine_in_out", global, "platforming_perspective")
	for (var i = 0; i < party_length(true); ++i) {
		var inst = party_get_inst(global.party_names[i])
		cutscene_animate(inst.x, x, transtime_2, "sine_in_out", inst, "x")
		cutscene_animate(inst.y, initial_y+15, transtime_2, "sine_in_out", inst, "y")
	}
	cutscene_sleep(transtime_2+1)
	//cutscene_audio_play(snd_break2)
	cutscene_player_canmove(true)
	cutscene_func(function(){get_leader().pf_enabled=0})
	cutscene_play()
}