enter_x = get_leader().x
enter_y = get_leader().y
if plat_yretain_ylevel_now != -1 and instance_exists(plat_yretain_ylevel_now)
	plat_yretain_ylevel_now = plat_yretain_ylevel_now.y;

room_goto(target_room);
warped = true;
if audio_exists(exit_sound)
    audio_play(exit_sound);

call_later(2, time_source_units_frames, function() {
	var x_override = -1, y_override = -1;
	
	if (plat_yretain_ylevel_next != -1 and instance_exists(plat_yretain_ylevel_next))
		plat_yretain_ylevel_next = plat_yretain_ylevel_next.initial_y + (plat_yretain_ylevel_next.tile_height * plat_yretain_ylevel_next.wall_distance) - (plat_yretain_ylevel_now - enter_y);
	
	if (plat_yretain_enabled and is_numeric(plat_yretain_ylevel_next) and global.platforming_perspective > 0) {
		y_override = plat_yretain_ylevel_next;
		y_override = clamp(y_override, 0, room_height);
		var l = get_leader()
		l.pf_airtime = 60;
	}
	
    party_leader_warp(MARKER_LAND, target_marker, exit_direction ?? savedir, x_override, y_override);
    
    if was_climbing {
        o_dev_climb_controller.__climb_start();
        if o_camera.target == get_leader() {
            o_camera.x = camera_confine_x(get_leader().x);
            o_camera.y = camera_confine_y(get_leader().y);
            o_camera.x_real = get_leader().x;
            o_camera.y_real = get_leader().y; 
        }
    }
    
    call_later(1, time_source_units_frames, function() {
        fader_fade(1, 0, 10);
    });
});