room_goto(target_room);
if audio_exists(exit_sound)
    audio_play(exit_sound);

call_later(2, time_source_units_frames, function() {
    party_leader_warp(MARKER_LAND, target_marker, exit_direction ?? savedir);
    
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