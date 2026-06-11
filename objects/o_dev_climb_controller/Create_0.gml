climbing = false;
leader_in_trans = false;
leader_climbing = false;
leader_grounded = true;
leader_attached = true;

leader_spd_y = 0;
leader_terminal_velocity = 6;
leader_gravity = .2;
leader_grab_when_falling = true;
leader_inv = 0;
leader_inv_max = 30;

move_buffer = 0;
current_direction = 90;
last_horizontal_direction = 0;
last_direction = 0;

move_reach = 23;

jump_reach = 5;
jump_reach_max = 50;
jump_buffer = 0;
jump_target_tile = noone;
jump_timer = 0;
jump_trail_timer = 0;
jump_canceled = false;

bump_timer = 0;
bump_off_time = 10;
bump_buffered_movement = undefined;

queued_calls = [];
buffered_movement = undefined;

sfx_charge = noone;

// dash boost addition
speed_boost_timer = 0;
speed_boost_max = 30;

enum CLIMB_JUMP_MODE {
    NEAREST,
    FURTHEREST
}
__find_tile = function(_reach, _direction, _mode = CLIMB_JUMP_MODE.NEAREST) {
    var target_tile = noone; 
    var current_tile = noone;
    
    with get_leader()
        current_tile = instance_place(get_leader().x, get_leader().y, o_dev_climb_tile);
    
    var target_tiles = ds_list_create();
    collision_rectangle_list(
        get_leader().x + lengthdir_x(8, _direction) + lengthdir_x(8, _direction + 90),
        get_leader().y + lengthdir_y(8, _direction) + lengthdir_y(8, _direction + 90),
        get_leader().x + lengthdir_x(_reach + 4, _direction) + lengthdir_x(8, _direction - 90), 
        get_leader().y + lengthdir_y(_reach + 4, _direction) + lengthdir_y(8, _direction - 90), 
        o_dev_climb_tile, false, false, target_tiles, false
    );
    
    var record_dist = (_mode == CLIMB_JUMP_MODE.NEAREST ? infinity : 0);
    for (var i = 0; i < ds_list_size(target_tiles); i ++) {
        if !instance_exists(target_tiles[| i]) || target_tiles[| i] == current_tile || (variable_instance_exists(target_tiles[| i], "can_climb") && !target_tiles[| i].can_climb)
            continue;
        
        var new_dist = point_distance(get_leader().x, get_leader().y, target_tiles[| i].x, target_tiles[| i].y + 2);
        if (new_dist - record_dist) * (_mode == CLIMB_JUMP_MODE.NEAREST ? 1 : -1) < 0 {
            record_dist = new_dist;
            target_tile = target_tiles[| i];
        };
    };
    
    ds_list_destroy(target_tiles);
    return target_tile;
}

__climb_start = function() {
    climbing = true;
    
    get_leader().s_dynamic = false;
    get_leader().sprite_index = get_leader().s_climb;
    get_leader().image_index = 0;
    get_leader().image_speed = 0;
    
    __reset_variables();
    party_fade_out(0);
    
}
__climb_stop = function() {
    climbing = false;
    
    for (var i = 1; i < party_length(true); ++i) {
        if instance_exists(party_get_inst(global.party_names[i])) {
            var inst = party_get_inst(global.party_names[i]);
            
            with inst { // set position, initialize the followers
                x = get_leader().x;
                y = get_leader().y;
                dir = get_leader().dir;
                
                event_user(1);
                event_user(2);
                
                init = true;
            }
        }
    }
    
    party_fade_in();
}

__queue_call = function(time, callback) {
    queued_calls = array_filter(queued_calls, function(n) {
        return time_source_exists(n) && time_source_get_time_remaining(n) > 0;
    });
	
	// This prevents the integer issue with frame-based time sources :3
	// I just had the URGE to fix this.
	// FIXME: floor if needed
	time |= 0;
    
    var __call = time_source_create(time_source_game, time, time_source_units_frames, callback);
    time_source_start(__call);
    array_push(queued_calls, __call);
    
    return __call;
}
__unqueue_calls = function() {
    for (var i = 0; i < array_length(queued_calls); i ++) {
        if time_source_exists(queued_calls[i])
            time_source_destroy(queued_calls[i]);
    };
    queued_calls = array_filter(queued_calls, function(n) {
        return time_source_exists(n);
    });
}

__reset_variables = function() {
    buffered_movement = undefined;
    jump_canceled = false;
    current_direction = 90;
    last_horizontal_direction = 0;
    
    leader_inv = 0;
    leader_spd_y = 0;
        
    leader_in_trans = false;
    leader_climbing = false;
    leader_grounded = true;
    leader_attached = true;
    
    jump_buffer = 0;
    bump_timer = 0;
    jump_timer = 0;
    jump_target_tile = noone;
    jump_trail_timer = 0;
    speed_boost_timer = 0;
    speed_boost_max = 30;
}