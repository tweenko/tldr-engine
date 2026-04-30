climbing = false;
leader_in_trans = false;
leader_climbing = false;
leader_grounded = true;

move_buffer = 0;
current_direction = 90;
last_horizontal_direction = 0;

move_reach = 23;

jump_reach = 5;
jump_reach_max = 50;
jump_buffer = 0;
jump_target_tile = noone;
jump_timer = 0;
jump_trail_timer = 0;

bump_timer = 0;
bump_off_time = 10;
bump_buffered_movement = undefined;

call_sprite_set = undefined;
buffered_movement = undefined;

sfx_charge = noone;

enum CLIMB_JUMP_MODE {
    NEAREST,
    FURTHEREST
}
__find_tile = function(_reach, _direction, _mode = CLIMB_JUMP_MODE.NEAREST) {
    var target_tile = noone; 
    var current_tile = noone;
    
    with get_leader()
        current_tile = instance_place(get_leader().x, get_leader().y, o_dev_climb_tile)
    
    with current_tile {
        var target_tiles = ds_list_create();
        collision_rectangle_list(
            get_leader().x + lengthdir_x(10, _direction) + lengthdir_x(10, _direction + 90),
            get_leader().y + lengthdir_y(10, _direction) + lengthdir_y(10, _direction + 90),
            get_leader().x + lengthdir_x(_reach + 4, _direction) + lengthdir_x(10, _direction - 90), 
            get_leader().y + lengthdir_y(_reach + 4, _direction) + lengthdir_y(10, _direction - 90), 
            o_dev_climb_tile, false, true, target_tiles, false
        );
        
        var record_dist = (_mode == CLIMB_JUMP_MODE.NEAREST ? infinity : 0);
        for (var i = 0; i < ds_list_size(target_tiles); i ++) {
            if !instance_exists(target_tiles[| i])
                continue;
            
            var new_dist = point_distance(get_leader().x, get_leader().y, target_tiles[| i].x, target_tiles[| i].y + 2);
            if (new_dist - record_dist) * (_mode == CLIMB_JUMP_MODE.NEAREST ? 1 : -1) < 0 {
                record_dist = new_dist;
                target_tile = target_tiles[| i];
            };
        };
        
        ds_list_destroy(target_tiles);
    }
    
    return target_tile;
}

__climb_stop = function() {
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