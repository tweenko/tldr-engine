if climbing {
    leader_grounded = false;
    
    if !leader_climbing {
        get_leader().moveable_climbing = false;
        get_leader().sprite_index = get_leader().s_climb;
        
        leader_climbing = true;
    }
    else if !leader_in_trans {
        if move_buffer <= 0 && jump_buffer <= 0 && bump_timer <= 0 {
            var x_move = InputX(INPUT_CLUSTER.NAVIGATION);
            var y_move = InputY(INPUT_CLUSTER.NAVIGATION);
            
            if x_move != 0 || y_move != 0
                current_direction = snap(InputDirection(90, INPUT_CLUSTER.NAVIGATION), 90);
            
            // charge
            if (InputCheck(INPUT_VERB.SELECT) && jump_buffer <= 0) || jump_timer > 0 {
                var target_tile = __find_tile(jump_reach + 10, current_direction, CLIMB_JUMP_MODE.FURTHEREST);
                jump_target_tile = target_tile;
                
                if jump_timer == 0 { // init
                    jump_timer = 0;
                    sfx_charge = audio_play(snd_chargeshot_charge, true, .3, .4);
                }
                
                // cap the jump reach
                if jump_reach < jump_reach_max
                    jump_reach += 2;
                else 
                    jump_reach = jump_reach_max;
                
                // charge sprites
                var charge_sprite = get_leader().s_climb_charge;
                switch current_direction {
                    case 0:
                        charge_sprite = get_leader().s_climb_charge_right;
                        break;
                    case 180:
                        charge_sprite = get_leader().s_climb_charge_left;
                        break;
                }
                // animate them
                get_leader().sprite_index = charge_sprite;
                get_leader().image_index = lerp(0, sprite_get_number(get_leader().sprite_index)-1, jump_reach/jump_reach_max);
                
                // player charge indicator
                if jump_reach/jump_reach_max > 2/3 {
                    get_leader().override_blend = merge_color(get_leader().image_blend, c_teal, 0.4 + floor(sin(jump_timer)) * .4);
                    audio_sound_pitch(sfx_charge, .7);
                    
                    if jump_timer % 5 == 0 {
                        with get_leader() {
                            var inst = afterimage(.2);
                            inst.scale_mod = .05;
                        }
                    }
                }
                else if jump_reach/jump_reach_max > 1/3 {
                    get_leader().override_blend = merge_color(get_leader().image_blend, c_teal, 0.2 + floor(sin(jump_timer)) * .2);
                    audio_sound_pitch(sfx_charge, .5);
                }
                else 
                    get_leader().override_blend = undefined;
                
                jump_timer ++;
                
                 // select is let go
                if !InputCheck(INPUT_VERB.SELECT) {
                    if instance_exists(target_tile) {
                        move_buffer = 10;
                        jump_buffer = 15;
                        jump_target_tile = noone;
                        jump_trail_timer = 10;
                        
                        // spawn particles
                        repeat(5) {
                            instance_create(o_eff_generic, get_leader().x + random_range(-7, 7), get_leader().y + random_range(-7, 7), get_leader().depth + 20, {
                                sprite_index: spr_eff_climb_dust,
                                image_speed: 1,
                                end_alpha: 1,
                                life: 8,
                                vspeed: -.25,
                            })
                        }
                        
                        var jump_sprite = get_leader().s_climb_jump_up;
                        switch current_direction {
                            case 0:
                                jump_sprite = get_leader().s_climb_jump_right;
                                break;
                            case 180:
                                jump_sprite = get_leader().s_climb_jump_left;
                                break;
                        }
                        get_leader().sprite_index = jump_sprite;
                        get_leader().image_index = 0;
                        get_leader().image_speed = 1;
                        
                        audio_play(snd_wing)
                        animate(get_leader().x, target_tile.x, 10, anime_curve.sine_out, get_leader(), "x");
                        animate(get_leader().y, target_tile.y + 2, 10, anime_curve.sine_out, get_leader(), "y");
                        
                        // change to land sprite
                        call_later(4, time_source_units_frames, method(self, function() {
                            switch current_direction {
                                case 0:
                                    get_leader().sprite_index = get_leader().s_climb_land_right;
                                    break;
                                case 180:
                                    get_leader().sprite_index = get_leader().s_climb_land_left;
                                    break;
                            }
                        }));
                        // change to climb sprite upon fully landing
                        call_sprite_set = call_later(10, time_source_units_frames, method(get_leader(), function() {
                            get_leader().sprite_index = get_leader().s_climb;
                            get_leader().image_index = 0;
                            get_leader().image_speed = 0;
                        }));
                    }
                    else {
                        bump_timer = bump_off_time;
                        bump_buffered_movement = undefined;
                        
                        if current_direction % 180 == 0
                            last_horizontal_direction = current_direction;
                        
                        get_leader().sprite_index = get_leader().s_climb_charge_left;
                        if last_horizontal_direction == 0
                            get_leader().sprite_index = get_leader().s_climb_charge_right;
                        
                        audio_play(snd_bump);
                    }
                    
                    get_leader().override_blend = undefined;
                    if audio_is_playing(sfx_charge)
                        audio_stop_sound(sfx_charge);
                    
                    jump_reach = 5;
                    jump_timer = 0;
                    jump_target_tile = noone;
                }
            }
            // move
            else if (x_move != 0 || y_move != 0) || !is_undefined(bump_buffered_movement) {
                // unbuffer the bump movement
                if x_move == 0 && y_move == 0 && !is_undefined(bump_buffered_movement) {
                    current_direction = bump_buffered_movement;
                    bump_buffered_movement = undefined;
                }
                
                var target_tile = __find_tile(move_reach, current_direction);
                if instance_exists(target_tile) {
                    move_buffer = 10;
                    jump_buffer = 0;
                    
                    if current_direction % 180 == 0
                        last_horizontal_direction = current_direction;
                    
                    animate(get_leader().x, target_tile.x, 8, anime_curve.sine_out, get_leader(), "x");
                    animate(get_leader().y, target_tile.y + 2, 8, anime_curve.sine_out, get_leader(), "y");
                    
                    audio_play(snd_wing, false, 0.6, 1.1 + random(.1));
                    
                    get_leader().sprite_index = get_leader().s_climb;
                    get_leader().image_speed = 0;
                    get_leader().image_index = cap_wraparound(get_leader().image_index + 1, get_leader().image_number);
                    call_sprite_set = call_later(8, time_source_units_frames, method(get_leader(), function() {
                        image_index = cap_wraparound(image_index + 1, image_number);
                    }));
                }
                else {
                    bump_timer = bump_off_time;
                    bump_buffered_movement = undefined;
                    
                    if current_direction % 180 == 0
                        last_horizontal_direction = current_direction;
                    
                    get_leader().sprite_index = get_leader().s_climb_charge_left;
                    if last_horizontal_direction == 0
                        get_leader().sprite_index = get_leader().s_climb_charge_right;
                    
                    var inst_return = noone;
                    with get_leader()
                        inst_return = instance_place(x, y, o_dev_climb_auto);
                    
                    if instance_exists(inst_return) 
                        inst_return.trigger_exit_code();
                    else 
                        audio_play(snd_bump);
                }
                
                jump_reach = 0;
                jump_target_tile = noone;
                jump_timer = 0;
            }
            else {
                jump_reach = 0;
                jump_target_tile = noone;
                jump_timer = 0;
            }
        }
        
        // account for inputs during bump buffer
        if bump_timer > 0 {
            var x_move = InputX(INPUT_CLUSTER.NAVIGATION);
            var y_move = InputY(INPUT_CLUSTER.NAVIGATION);
            if x_move != 0 || y_move != 0
                bump_buffered_movement = snap(InputDirection(90, INPUT_CLUSTER.NAVIGATION), 90);
            
            // don't buffer same direction
            if bump_buffered_movement == current_direction
                bump_buffered_movement = undefined;
            
            bump_timer --;
            
            // return to default climbing sprite
            if bump_timer == 0 
                get_leader().sprite_index = get_leader().s_climb;
        }
        
        if move_buffer > 0 
            move_buffer --;
        if jump_buffer > 0
            jump_buffer --;
        if jump_trail_timer > 0 {
            if jump_trail_timer % 2 == 0
                with get_leader() {
                    var inst = afterimage(.05);
                    inst.image_alpha = .5;
                    inst.depth = depth + 40;
                }
            jump_trail_timer -- 
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

depth = get_leader().depth - 100;