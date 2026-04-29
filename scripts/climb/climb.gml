/// @desc starts a climb with the nearest block
function climb_start_nearest() {
    var target_block = instance_nearest(get_leader().x, get_leader().y, o_dev_climb_tile);
    var target_x = target_block.x + 10;
    var target_y = target_block.y + 12;
    
    cutscene_create();
    cutscene_player_canmove(false);
    
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", true);
    cutscene_actor_move(get_leader(), new actor_movement_jump(target_x, target_y), false);
    cutscene_sleep(16);
    cutscene_set_variable(get_leader(), "s_dynamic", false);
    cutscene_set_variable(get_leader(), "sprite_index", get_leader().s_climb);
    cutscene_set_variable(get_leader(), "image_index", 0);
    cutscene_set_variable(get_leader(), "image_speed", 0);
    
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", false);
    cutscene_set_variable(o_dev_climb_controller, "climbing", true);
    
    cutscene_player_canmove(true);
    cutscene_play();
    
    party_fade_out();
}

/// @desc stops a climb and makes the leader jump to the nearest climb end marker
function climb_stop_nearest() {
    var target_marker = marker_find_closest(get_leader().x, get_leader().y, "climb");
    
    cutscene_create();
    cutscene_player_canmove(false);
    
    cutscene_set_variable(get_leader(), "s_dynamic", true);
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", true);
    cutscene_set_variable(o_dev_climb_controller, "climbing", false);
    cutscene_actor_move(get_leader(), new actor_movement_jump(target_marker.x, target_marker.y));
    
    cutscene_set_variable(o_dev_climb_controller, "leader_in_trans", false);
    cutscene_func(function() {
        for (var i = 1; i < party_length(true); ++i) {
            if instance_exists(party_get_inst(global.party_names[i])) {
                var inst = party_get_inst(global.party_names[i]);
                
                with inst { // set position, initialize the followers
                    x = get_leader().x
                    y = get_leader().y
                    dir = get_leader().dir;
                    
                    event_user(1);
                    event_user(2);
                    
                    init = true;
                }
            }
        }
        
        party_fade_in();
    });
    
    cutscene_player_canmove(true);
    cutscene_play();
}

/// @desc returns whether the player is currently climbing
/// @returns {bool}
function climb_check() {
    return (instance_exists(o_dev_climb_controller) && o_dev_climb_controller.climbing)
}