if place_meeting(x, y, get_leader()) && o_dev_climb_controller.jump_buffer <= 0 && !triggered {
	triggered = true;
	shake = 3;
	image_blend = c_gray;
	can_climb = false;
	
	cutscene_create();
	cutscene_player_canmove(false);
	
	cutscene_audio_play(snd_break1, false, .5, 1.2);
	cutscene_audio_play(snd_break1, false, .2, .75, false,, 3);
	cutscene_sleep(5);
	
	cutscene_audio_play(snd_climb_slip);
	cutscene_audio_play(snd_climb_slip, false, .6, .75, false,, 1);
	
	cutscene_func(function() {
		o_dev_climb_controller.leader_attached = false;
	});
	cutscene_animate(0, 15, 10, anime_curve.sine_in, id, "y_off");
	cutscene_animate(1, 0, 10, anime_curve.linear, id, "image_alpha");
	
	cutscene_player_canmove(true);
	cutscene_play();
}
