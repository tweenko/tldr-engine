/// @desc starts a climb with the nearest block
function climb_start_nearest() {
    var target_block = instance_nearest(get_leader().x, get_leader().y, o_dev_climb_tile);
    var target_x = target_block.x;
    var target_y = target_block.y + 2;
    
    cutscene_create();
    cutscene_player_canmove(false);
    
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", true);
    cutscene_audio_play(snd_wing);
    cutscene_actor_move(get_leader(), new actor_movement_jump_into(target_x, target_y, true, 16, false));
    
    cutscene_set_variable(get_leader(), "s_dynamic", false);
    cutscene_set_variable(get_leader(), "sprite_index", get_leader().s_climb);
    cutscene_set_variable(get_leader(), "image_index", 0);
    cutscene_set_variable(get_leader(), "image_speed", 0);
    cutscene_audio_play(snd_noise);
    
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", false);
    cutscene_set_variable(o_dev_climb_controller, "climbing", true);
    
    cutscene_player_canmove(true);
    cutscene_play();
    
    party_fade_out();
}

/// @desc stops a climb and makes the leader jump to the nearest climb end marker
function climb_stop_nearest() {
    if time_source_exists(o_dev_climb_controller.call_sprite_set)
        call_cancel(o_dev_climb_controller.call_sprite_set);
    
    var target_marker = marker_find_closest(get_leader().x, get_leader().y, "climb");
    
    cutscene_create();
    cutscene_player_canmove(false);
    
    cutscene_set_variable(get_leader(), "s_dynamic", true);
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", true);
    cutscene_set_variable(o_dev_climb_controller, "climbing", false);
    cutscene_audio_play(snd_wing);
    cutscene_actor_move(get_leader(), new actor_movement_jump_into(target_marker.x, target_marker.y, true, 20, false));
    
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