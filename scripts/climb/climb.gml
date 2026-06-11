/// @desc starts a climb with the nearest block
function climb_start_nearest() {
    party_fade_out();
    
    var target_block = instance_nearest(get_leader().x, get_leader().y, o_dev_climb_tile);
    var target_x = target_block.x;
    var target_y = target_block.y + 2;
    
    cutscene_create();
    cutscene_player_canmove(false);
    
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", true);
    cutscene_audio_play(snd_wing);
    cutscene_actor_move(get_leader(), new actor_movement_jump_into(target_x, target_y, true, 15, false));
    cutscene_set_variable(o_camera, "target", noone);
    cutscene_camera_pan(target_x, target_y, 15, false);
    
    cutscene_audio_play(snd_noise);
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", false);
    cutscene_set_variable(o_camera, "target", get_leader());
    cutscene_func(o_dev_climb_controller.__climb_start);
    
    cutscene_player_canmove(true);
    cutscene_play();
}

/// @desc stops a climb and makes the leader jump to the nearest climb end marker
function climb_stop_nearest() {
    o_dev_climb_controller.__unqueue_calls();
    
    var target_marker = marker_find_closest(get_leader().x, get_leader().y, MARKER_CLIMB);
    if !instance_exists(target_marker)
        show_error("climb_stop_nearest error: couldn't find a climb end marker in the current room, aborting", true);
    
    cutscene_create();
    cutscene_player_canmove(false);
    
    cutscene_set_variable(get_leader(), "s_dynamic", true);
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", true);
    cutscene_set_variable(o_dev_climb_controller, "climbing", false);
    cutscene_audio_play(snd_wing);
    cutscene_set_variable(o_camera, "target", noone);
    cutscene_camera_pan(target_marker.x, target_marker.y, 15, false);
    cutscene_actor_move(get_leader(), new actor_movement_jump_into(target_marker.x, target_marker.y, true, 15, false));
    
    cutscene_set_variable(o_camera, "target", get_leader());
    cutscene_set_variable(get_leader(), "dir", DIR.DOWN);
    
    cutscene_audio_play(snd_noise);
    
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", false);
    cutscene_func(o_dev_climb_controller.__climb_stop);
    
    cutscene_player_canmove(true);
    cutscene_play();
}

/// @desc returns whether the player is currently climbing
/// @returns {bool}
function climb_check() {
    return (instance_exists(o_dev_climb_controller) && o_dev_climb_controller.climbing)
}

/// @desc returns whether climbing is enabled
function climb_get_enabled() {
    if is_bool(global.climbing_enabled) 
        return global.climbing_enabled;
    else if is_callable(global.climbing_enabled)
        return global.climbing_enabled();
    
    return global.climbing_enabled;
}