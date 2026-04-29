if climbing {
    leader_grounded = false;
    
    if !leader_climbing {
        get_leader().moveable_climbing = false;
        get_leader().sprite_index = get_leader().s_climb;
        
        leader_climbing = true;
    }
    else if !leader_in_trans {
        if move_buffer <= 0 {
            var x_move = InputX(INPUT_CLUSTER.NAVIGATION);
            var y_move = InputY(INPUT_CLUSTER.NAVIGATION);
            current_direction = snap(InputDirection(0, INPUT_CLUSTER.NAVIGATION), 90);
            
            if x_move != 0 || y_move != 0 {
                var target_tile = noone; 
                var current_tile = noone;
                
                with get_leader()
                    current_tile = instance_place(get_leader().x, get_leader().y, o_dev_climb_tile)
                
                with current_tile 
                    target_tile = collision_line(get_leader().x, get_leader().y,
                        get_leader().x + lengthdir_x(other.grid_size, other.current_direction), 
                        get_leader().y + lengthdir_y(other.grid_size, other.current_direction), 
                        o_dev_climb_tile, false, true
                    );
                
                if instance_exists(target_tile) {
                    move_buffer = 10;
                    
                    animate(get_leader().x, target_tile.x + 10, 8, anime_curve.sine_out, get_leader(), "x");
                    animate(get_leader().y, target_tile.y + 12, 8, anime_curve.sine_out, get_leader(), "y");
                    
                    get_leader().image_index = cap_wraparound(get_leader().image_index + 1, get_leader().image_number);
                    call_later(8, time_source_units_frames, method(get_leader(), function() {
                        image_index = cap_wraparound(image_index + 1, image_number);
                    }))
                }
            }
        }
        else {
            move_buffer --
        }
    }
}
else {
    leader_climbing = false;
    if !leader_in_trans && !leader_grounded {
        get_leader().moveable_climbing = true;
        leader_grounded = true;
    }
}